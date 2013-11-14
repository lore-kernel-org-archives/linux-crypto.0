From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 14 Nov 2013 19:01:58 +0100
Message-ID: <3127174.i8ueAho43m@tauon>
References: <2579337.FPgJGgHYdz@tauon> <27146362.bQgmetPpTV@tauon> <5284AB17.5050802@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
To: Clemens Ladisch <clemens@ladisch.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51773 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab3KNSCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Nov 2013 13:02:11 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S233> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 14 Nov 2013 19:02:00 +0100
In-Reply-To: <5284AB17.5050802@ladisch.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 14. November 2013, 11:51:03 schrieb Clemens Ladisch:

Hi Clemens,

>Stephan Mueller wrote:
>> Am Mittwoch, 13. November 2013, 12:51:44 schrieb Clemens Ladisch:
>>> (And any setting that increases accesses to main memory is likey to
>>> introduce more entropy due to clock drift between the processor and
>>> the memory bus.  Or where do you assume the entropy comes from?)
>> 
>> You nailed it. When I disable the caches using the CR0 setting, I get
>> a massive increase in variations and thus entropy.
>
>Now this would be an opportunity to use the number of main memory
>accesses to estimate entropy.  (And when you're running out of the
>cache, i.e., deterministically, is there any entropy?)
>

I seem to have found the root cause with my bare metal tester, but I am 
yet unable to make sense of it.

I will report back with more analyses.


>An attacker would not try to detect patterns; he would apply knowledge
>of the internals.

I do not buy that argument, because if an attacker can detect or deduce 
the internals of the CPU, he surely can detect the state of the 
input_pool or the other entropy pools behind /dev/random. And then, 
/dev/random is not so entropic any more for that attacker.
>
>Statistical tests are useful only for detecting the absence of entropy,
>not for the opposite.

Again, I fully agree. But it is equally important to understand that 
entropy is relative. And all I want and all I care about is that an 
attacker has only the knowledge and ability to make measurements that 
are less precise than 1 bit.

Ciao
Stephan
