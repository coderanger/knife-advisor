#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'tk'


module KnifeAdvisor
  class UI
    class Window
      def initialize(image)
        @image = image
        center!

        # Create a widget to show the image.
        TkLabel.new(root, background: 'systemTransparent', image: image) do
          place(x: 150, y: 200-(image.height/2))
        end
      end

      def root
        @root ||= TkRoot.new(background: 'systemTransparent', width: @image.width+150, height: (@image.height/2)+200).tap do |window|
          # Disable the WM decoration (title bar).
          Tk::Wm.overrideredirect(window, 1)
          # Start in front of other windows.
          Tk::Wm.attributes(window, 'topmost', true)
          # Activate transparency mode.
          Tk::Wm.attributes(window, 'transparent', true)
        end
      end

      def center!
        # Center the window.
        screen_width = TkWinfo.screenwidth(root)
        screen_height = TkWinfo.screenheight(root)
        x = (screen_width/2) - (@image.width/2) - 150
        y = (screen_height/2) - 200
        root.geometry("#{root.width}x#{root.height}+#{x}+#{y}")
      end

      def say(msg)
        msg = msg.strip
        @msg = msg
        unless @message_canvas
          @message_canvas = TkCanvas.new(root, background: 'systemTransparent', highlightthickness: 0) do
            place(x: 0, y: 0, width: 200, height: 200)
          end
          rounded_rect(@message_canvas, 0, 0, 200, 200, 10, '#FFFFC7')
        end
        if @text
          @text.text = msg
        else
          @text = TkcText.new(@message_canvas, 10, 10, anchor: 'nw', width: 180, text: msg)
        end
      end

      def append(msg)
        say("#{@msg} #{msg}")
      end

      def unsay!
        if @message_canvas && @text
          @text.destroy
          @text = nil
        end
      end

      def clear!
        if @message_canvas
          @message_canvas.destroy
          @message_canvas = nil
          @text = nil
        end
      end

      def draw_buttons!
        @yes_button = rounded_rect(@message_canvas, 10, 170, 16, 85, 2, '#FFFFC7', 1)
        @yes_button << TkcText.new(@message_canvas, 48, 178, text: 'Yes')
        @no_button = rounded_rect(@message_canvas, 105, 170, 16, 85, 2, '#FFFFC7', 1)
        @no_button << TkcText.new(@message_canvas, 147, 178, text: 'No')
      end

      def on_yes(&block)
        @yes_button.each do |obj|
          obj.bind('1', &block)
        end
      end

      def on_no(&block)
        @no_button.each do |obj|
          obj.bind('1', &block)
        end
      end

      def clear_buttons!
        (@yes_button + @no_button).each(&:destroy)
        @yes_button = @no_button = nil
      end

      def rounded_rect(canvas, x, y, height, width, radius, color, border=0, border_color='black')
        [].tap do |objs|
          diameter = radius * 2
          # Top left corner.
          objs << TkcOval.new(canvas, x, y, x+diameter, y+diameter, fill: color, width: border, outline: border_color)
          # Top right corner.
          objs << TkcOval.new(canvas, x+width-diameter, y, x+width, y+diameter, fill: color, width: border, outline: border_color)
          # Bottom left corner.
          objs << TkcOval.new(canvas, x, y+height-diameter, x+diameter, y+height, fill: color, width: border, outline: border_color)
          # Bottom right corner.
          objs << TkcOval.new(canvas, x+width-diameter, y+height-diameter, x+width, y+height, fill: color, width: border, outline: border_color)
          objs << TkcRectangle.new(canvas, x+radius, y, x+width-radius, y+height, fill: color, width: 0)
          objs << TkcRectangle.new(canvas, x, y+radius, x+width, y+height-radius, fill: color, width: 0)
          if border > 0
            # Top border.
            objs << TkcLine.new(canvas, x+radius, y, x+width-radius, y, fill: border_color, width: border)
            # Bottom border.
            objs << TkcLine.new(canvas, x+radius, y+height, x+width-radius, y+height, fill: border_color, width: border)
            # Left border.
            objs << TkcLine.new(canvas, x, y+radius, x, y+height-radius, fill: border_color, width: border)
            # Right border
            objs << TkcLine.new(canvas, x+width, y+radius, x+width, y+height-radius, fill: border_color, width: border)
          end
        end
      end

    end
  end
end
