From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Thu, 16 Apr 2015 17:07:20 +0200
Message-ID: <1505308.pr7rreheuo@tauon>
References: <20150416143617.GA17178@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34139 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbbDPPRn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 11:17:43 -0400
In-Reply-To: <20150416143617.GA17178@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. April 2015, 22:36:17 schrieb Herbert Xu:

Hi Herbert,

>Hi Stephan:
>
>Currently DRBG is seeded with entropy from get_random_bytes.
>However, get_random_bytes is basically the kernel version of
>/dev/urandom.  So there is no guarantee that you're actually
>getting the amount of entropy required.
>
>Are you sure this is compliant with the DRBG specification?

I do not see a specific requirement in SP800-90A about the quality of the 
noise source.

But SP800-90B specifies tests and assessments about the quality. When applying 
that specification, I applied some initial assessments: /dev/urandom complies 
with SP800-90B when disregarding the very early boot stage (i.e. when assuming 
that the input_pool received sufficient entropy).

The only shaky time is the boot time until the nonblocking_pool/input_pool has 
been sufficiently seeded.

That said, I already developed an in-kernel version of /dev/random. I sent the 
patch to LKML some half year ago. If I understood Ted Tso right, there is no 
general objection against adding that in-kernel interface. See [1] for the 
thread.

Furthermore, I already started working on updating the DRBG to use that in-
kernel /dev/random interface.

Shall I pursue that work in earnest now?

[1] https://lkml.org/lkml/2014/5/11/276


Ciao
Stephan
