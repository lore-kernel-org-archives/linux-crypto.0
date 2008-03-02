From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Sun, 2 Mar 2008 14:22:02 +0100
Message-ID: <20080302132202.GB16659@Chamillionaire.breakpoint.cc>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc> <47C1CE67.70804@the2masters.de> <20080302112004.GA16659@Chamillionaire.breakpoint.cc> <47CA97D5.8090804@the2masters.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58165 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbYCBNWE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 08:22:04 -0500
Content-Disposition: inline
In-Reply-To: <47CA97D5.8090804@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-02 13:04:37 [+0100]:

>But I get much lower speed than with aes-cbc-essiv:sha256.
Yes, I expected this :)
The aes-cbc operation is supported directly in HW. So the
driver just says here is the key, source, destination, length and now do
it. So the HW fetches the key once and is going to process the whole
request (lets say 4 KiB) in one go.

The XTS blockmode on the other hand encrypts encrypts only 16 bytes in
one go and performs some GF operations in between. This is
repeated until we encrypt the whole request. So for a 4 KiB we need here
257 calls to the HW instead of one (the one extra is to encrypt the IV).
For every encryption call we have to reset the HW key. According to the
spec fetching the key from memory takes more time than the whole
encryption process as it (in case of a 16 byte block). This might still
be faster than the pure software solution.
Anyway, XTS is way more complex than CBC and part of it is done in
software what we can't change.

>With xts I get 57MB/s while reading the cryptodev with dd, and >90% sys in top, 0% wait
>With cbc-essiv I get about 75MB/s while reading it with dd, 60% sys int top, 30% wait
>without cryptodev I get 75MB/s while reading the raw lvm-volume with dd, 40% sys, 50% wait
>I do a blockdev --flushbufs beetween each read.
According to this numbers I would say in CBC mode the HD is breaking in
XTS the CPU is.
I could try to tune it a little but don't expect much.
Could you please compare xts with and without padlock?

Sebastian
