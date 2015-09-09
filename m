From: Stephan Mueller <smueller@chronox.de>
Subject: Re: USB HID devices not linked to RNG
Date: Wed, 09 Sep 2015 14:24:54 +0200
Message-ID: <2407745.gnJxkiQhnm@tauon.atsec.com>
References: <1735492.1FWVU9y0M8@myon.chronox.de> <2343086.CRIplH0oLU@tauon.atsec.com> <CAKdAkRRYKi+P9NTaKuDm+OeXh6YoP4Atf3V1NR3miioFHAchhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mike Mestnik <cheako@mikemestnik.net>,
	linux-crypto@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <CAKdAkRRYKi+P9NTaKuDm+OeXh6YoP4Atf3V1NR3miioFHAchhQ@mail.gmail.com>
Sender: linux-input-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 8. September 2015, 22:40:07 schrieb Dmitry Torokhov:

Hi Dmitry,

>
>All input devices add randomness, however I think for mouse
>add_input_randomness() will drop majority of events since they are
>likely have the same value (well, depends on which direction you are
>moving the mouse)...

I agree that such mechanism is present, but it is implemented by 
add_input_randomness:

        /* ignore autorepeat and the like */
        if (value == last_value)
                return;

So, when we install a probe at the entry into add_input_randomness, we should 
see invocations.

The problem now is that add_input_randomness is not called at all.

Simply use the following code as a systemtap script, load it and move a USB 
mouse or type on a USB keyboard:

probe kernel.function("add_input_randomness") {
	printf("add_input_randomness triggered\n");
}

Expected behavior: tons of printouts should be received (as it is the case 
with PS/2 mice and keyboards).

Actual behavior: no printout when moving USB HID.


Ciao
Stephan
