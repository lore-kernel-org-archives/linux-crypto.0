From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Counter Size in CTR mode for AES Driver
Date: Fri, 10 Apr 2015 22:51:11 +0200
Message-ID: <3837185.yfoG22Ljkb@tachyon.chronox.de>
References: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34115 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbbDJUvQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 16:51:16 -0400
In-Reply-To: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 11. April 2015, 00:30:30 schrieb sri sowj:

Hi sri,

> Hi All,
> 
> I have seen multiple open source drivers for AES(CTR) mode for
> different Crypto Hardware Engines, I was not really sure on
> countersize,nonce etc.
> Please can any one provide some info on the following
> 
> #1:How does AES driver identifies the counter size during the CTR mode
> of operation?

I am not sure about the question, but the block chaining mode is orthogonal to 
the block cipher.

Thus, the block cipher does not need to know of the counter size of CTR. That 
applies to any block chaining mode.
> 
> looks like AES in CTR mode supports "countersize" of multiple lengths as 
below:
> >>1: First is a counter which is made up of a nonce and counter. The nonce
> >>is random, and the remaining bytes are counter bytes (which are
> >>incremented).
>  For example, a 16 byte block cipher might use the high 8 bytes as a
> nonce, and the low 8 bytes as a counter.
> 
> >>2: Second is a counter block, where all bytes are counter bytes and can be
> >>incremented as carries are generated.
>  For example, in a 16 byte block cipher, all 16 bytes are counter bytes
> 
> #2: Does Linux Kernel Crypto subsystem increments the counter value
> for every block of input or is it needs tp be taken care by Kernel
> Driver for the respective Crypto H/W ?

This depends on your choice -- the kernel crypto API provides crypto_inc() for 
the increment, it provides the ctr template to wrap a block chaining mode. The 
kernel crypto API does not restrict, it enables you.
> 
> 
> #3:counters and nonces are something which will be extracted from the
> IV i.e., IV = nonce + counter
> Note if "l" is length of IV then first "l/2" is length of nonce and
> next "l/2" is length of counter.

What you describe may be on e convention. But the ctr.c template initializes 
the counter value to 0 during init time. So, you see that there is no hard 
fact. The counter is in fact just an IV.
> 
> Any information regarding the above is really appreciable.
> 
> BR,
> SriSowj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
