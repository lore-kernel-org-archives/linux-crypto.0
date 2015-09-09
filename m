From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: USB HID devices not linked to RNG
Date: Tue, 8 Sep 2015 22:40:07 -0700
Message-ID: <CAKdAkRRYKi+P9NTaKuDm+OeXh6YoP4Atf3V1NR3miioFHAchhQ@mail.gmail.com>
References: <1735492.1FWVU9y0M8@myon.chronox.de>
	<1461912.H1d3XDk5sm@myon.chronox.de>
	<CAF8px55WFMO54uJT2kME4OauXAUCfsv2K2W1EA0ufuaVjFtXfg@mail.gmail.com>
	<2343086.CRIplH0oLU@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mike Mestnik <cheako@mikemestnik.net>,
	linux-crypto@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <2343086.CRIplH0oLU@tauon.atsec.com>
Sender: linux-input-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 7, 2015 at 2:09 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 7. September 2015, 15:07:47 schrieb Mike Mestnik:
>
> Hi Mike,
>
>>This is just an off the wall guess.  Wouldn't such entropy already be
>>collected at a lower level, like raw usb traffic?
>
> The RNG collects data from interrupts (that also covers normal PS/2 mice and
> keyboards), block devices and HID (it hooks itself into the input layer).
>
> So, raw USB traffic is not a source of entropy other than for the interrupts
> the base PCI traffic would generate.
>
> What I am wondering: isn't the USB mouse/keyboard support hooking into the
> kernel's input layer?

All input devices add randomness, however I think for mouse
add_input_randomness() will drop majority of events since they are
likely have the same value (well, depends on which direction you are
moving the mouse)...

-- 
Dmitry
