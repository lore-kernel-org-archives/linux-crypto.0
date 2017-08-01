From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Tue, 01 Aug 2017 11:15:50 +0200
Message-ID: <4246082.jRinN0y4r5@tauon.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de> <88356288.VicKj4yezc@tauon.chronox.de> <20170801090833.GA674@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60922 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdHAJPw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 05:15:52 -0400
In-Reply-To: <20170801090833.GA674@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 1. August 2017, 11:08:33 CEST schrieb Herbert Xu:

Hi Herbert,
> 
> How about you separate into three patches? The first two make
> changes to algif_skcipher/algif_aead so that they can be merged,
> and the last one does the actual merging.
> 
Ok, I can do that.

How would you want to handle the following: the new af_alg_wait_for_data will 
include:

if (sk_wait_event(sk, &timeout, (ctx->used || !ctx->more)

whereas algif_aead only contains !ctx->more and algif_skcipher only contains 
ctx->used in the check? When merging both, having the common check is good for 
both, but not needed individually.

Shall I only make the change during the merger or add these changes to the 
modification of algif_skcipher/algif_aead?

Please then also disregard the recvmsg consolidation patch from this morning.

Ciao
Stephan
