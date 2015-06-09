From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: drbg - initialize in subsys_initcall
Date: Tue, 09 Jun 2015 16:18:57 +0200
Message-ID: <2832652.83U08vW1Tz@tauon.atsec.com>
References: <7507652.XDRqQzIvs8@tachyon.chronox.de> <3033189.WTiU3v3QJk@tachyon.chronox.de> <20150609141743.GA14223@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46174 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbbFIOUI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:20:08 -0400
In-Reply-To: <20150609141743.GA14223@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Tuesday 09 June 2015, 22:17:43 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Jun 08, 2015 at 02:42:50PM +0200, Stephan Mueller wrote:
>> When compiling the DRBG statically into the kernel, the testmgr
>> allocation of the DRBG may be done at a time the Jitter RNG is
>> not available as it is registered later. The patch changes the
>> initialization to be invoked in subsys_initcall.
>> 
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
>Actually I think we won't need this patch after all because after
>my callback patches we will never allocate jent in the testmgr
>path.

Agreed. Let us drop the patch.
>
>Cheers,


Ciao
Stephan
