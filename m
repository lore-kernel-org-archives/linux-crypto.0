From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Thu, 14 Nov 2013 19:30:22 +0100
Message-ID: <528516BE.2040204@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <27146362.bQgmetPpTV@tauon> <5284AB17.5050802@ladisch.de> <3127174.i8ueAho43m@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39483 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999Ab3KNSbT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Nov 2013 13:31:19 -0500
In-Reply-To: <3127174.i8ueAho43m@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller wrote:
> Am Donnerstag, 14. November 2013, 11:51:03 schrieb Clemens Ladisch:
>> An attacker would not try to detect patterns; he would apply knowledge
>> of the internals.
>
> I do not buy that argument, because if an attacker can detect or deduce
> the internals of the CPU, he surely can detect the state of the
> input_pool or the other entropy pools behind /dev/random.

With "internals", I do not mean the actual state of the CPU, but the
behaviour of all the CPU's execution engines.

An Intel engineer might know how to affect the CPU so that the CPU
jitter code measures a deterministic pattern, but he will not know the
contents of my memory.

>> Statistical tests are useful only for detecting the absence of entropy,
>> not for the opposite.
>
> Again, I fully agree. But it is equally important to understand that
> entropy is relative.

In cryptography, we care about absolute entropy, i.e., _nobody_ must be
able to predict the RNG output, not even any CPU engineer.


Regards,
Clemens
