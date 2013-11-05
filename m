From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 05 Nov 2013 14:45:58 +0100
Message-ID: <7447932.fADKoNoZRI@tauon>
References: <2579337.FPgJGgHYdz@tauon> <20131103233207.GA5105@amd.pavel.ucw.cz> <4763730.CsXSbevC1J@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47410 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3KEPAe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Nov 2013 10:00:34 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1E5> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 5 Nov 2013 16:00:25 +0100
In-Reply-To: <4763730.CsXSbevC1J@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 5. November 2013, 13:25:40 schrieb Stephan Mueller:

Hi Pavel,

>Am Montag, 4. November 2013, 00:32:07 schrieb Pavel Machek:

>>But they usually _do_ have RTC or other clock, not driven by CPU
>>oscilator. Good.
>>
>>What about just
>>
>>while (!enough_entropy) {
>>
>>      cur_time = read_rtc();
>>      simulated_tsc = 0;
>>      while (cur_time == read_rtc())
>>      
>>      	    simulated_tsc++;
>>      
>>      gain_entropy_from(simulated_tsc)
>>
>>}
>
>That is an interesting piece of code -- what would you do in the
>gain_entropy_from function?

Please disregard my question.

I plugged that idea into my current Jitter RNG processing and disabled 
the other jitter measurements to get a clear, isolated picture.

The result is also a white noise! And it is even quite fast.

That means with this approach, even another noise source is available 
that I could combine with the jitter measurements. 

I will have to perform more tests on that noise source. But the smoke 
test is already quite interesting.


Ciao
Stephan
