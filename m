From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 17:01:13 +0100
Message-ID: <1604413.m50iU9qQPD@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <19793111.SdtrLVTG75@tauon.atsec.com> <20170112155344.GB19252@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55494 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdALQBT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:01:19 -0500
In-Reply-To: <20170112155344.GB19252@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 23:53:44 CET schrieb Herbert Xu:

Hi Herbert,

> 
> > If we only want to solve that for algif_aead, wouldn't it make more sense
> > if the user space caller takes care of that (such as libkcapi)? By
> > tinkering with the SGLs and copying the data to the dst buffer before the
> > cipher operation takes place, I guess we will add performance degradation
> > and more complexity in the kernel.
> > 
> > Having such logic in user space would keep the algif_aead cleaner IMHO.
> 
> We need to have a sane kernel API that respects POSIX.

I fully agree. Therefore, I was under the impression that disregarding the AAD 
in recvmsg entirely would be most appropriate as offered with the patch 
"crypto: AF_ALG - disregard AAD buffer space for output". In this case we 
would be fully POSIX compliant, the kernel would not copy the AAD (and thus 
perform multiple memcpy operations due to copy_from_user and copy_to_user 
round trips) and leave the AAD copy operation entirely to user space.

Ciao
Stephan
