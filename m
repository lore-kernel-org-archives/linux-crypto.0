From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Wed, 06 Nov 2013 12:42:47 +0100
Message-ID: <6186307.PQMXWdkvke@tauon>
References: <2579337.FPgJGgHYdz@tauon> <4763730.CsXSbevC1J@tauon> <7447932.fADKoNoZRI@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7447932.fADKoNoZRI@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 5. November 2013, 14:45:58 schrieb Stephan Mueller:

Hi Pavel,

>Am Dienstag, 5. November 2013, 13:25:40 schrieb Stephan Mueller:
>
>Hi Pavel,
>
>>Am Montag, 4. November 2013, 00:32:07 schrieb Pavel Machek:
>>>But they usually _do_ have RTC or other clock, not driven by CPU
>>>oscilator. Good.
>>>
>>>What about just
>>>
>>>while (!enough_entropy) {
>>>
>>>      cur_time = read_rtc();
>>>      simulated_tsc = 0;
>>>      while (cur_time == read_rtc())
>>>      
>>>      	    simulated_tsc++;
>>>      
>>>      gain_entropy_from(simulated_tsc)
>>>
>>>}
>>
>>That is an interesting piece of code -- what would you do in the
>>gain_entropy_from function?
>
>Please disregard my question.
>
>I plugged that idea into my current Jitter RNG processing and disabled
>the other jitter measurements to get a clear, isolated picture.
>
>The result is also a white noise! And it is even quite fast.

After doing some more research on this approach, I have to admit that 
the output not good (i.e. white noise) in all situations. Therefore, I 
dropped that (for now).

But thank you very much for your suggestion.

Ciao
Stephan
