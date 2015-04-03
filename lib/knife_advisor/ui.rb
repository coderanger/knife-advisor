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
    autoload :Window, 'knife_advisor/ui/window'

    def initialize(ui)
      @ui = ui
      @responses = RingBuffer.new([
        'Do you care about networking performance?',
        'Do you need high availability?',
        'Do you want auto-scaling?',
        'Do you need to improve your IT velocity?',
        'Do you need network security?',
        'Is your business web scale?',
        'Are you using MongoDB to power your web applications?',
        'Is your current hosting too expensive?',
      ])
    end

    def run
      $stdout.write('Just a moment. We are connecting you to one of our expert advisors.')
      10.times do
        sleep(1)
        $stdout.write('.')
      end
      $stdout.write("\n")
      # Show the window.
      window
      after(4000) do
        window.say('Hi there!')
      end
      after(6000) do
        window.append('It looks like you are trying to use the cloud.')
      end
      after(8000) do
        window.append('Would you like help?')
        window.draw_buttons!
        window.on_yes do
          window.say(@responses.next)
        end
        window.on_no do
          window.clear_buttons!
          window.say("I'm sorry to hear that.")
          after(2000) { window.append('Goodbye!') }
          after(4000) { puts('Thank you for using the cloud!'); exit(0) }
        end
      end
      Tk.mainloop
    end

    private

    def image
      @image ||= TkPhotoImage.new(file: File.expand_path('../advisor.gif', __FILE__))
    end

    def window
      @window ||= Window.new(image)
    end

    def after(n, &block)
      window.root.after(n, &block)
    end



  end
end
