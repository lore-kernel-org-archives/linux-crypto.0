Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64113C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 19:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35460207FC
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575055492;
	bh=PiWQMksBfOFU77+Sa7gt5Uz57Cj0o+N3a0RruMCZB2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qBipWCuDExwEHbSvnfbw6CvJie2SiWHEjZnYLYHnNAtKcMIF+gtSdxIjHHEsp433u
	 Pli1VH1bUoQQjHbAsUsZt7H47c/ShFNsVHILQv5dDbX1RyMlxTdxRhVuhCXIg8OPeJ
	 ao24Ol2/oFxKBki0rYSpME7Ht7MLAAVY5nP8DnjQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfK2TYv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 14:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfK2TYv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 14:24:51 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2B1207FA;
        Fri, 29 Nov 2019 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575055490;
        bh=PiWQMksBfOFU77+Sa7gt5Uz57Cj0o+N3a0RruMCZB2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qc8UVPEhmnD1KkQiIwI3CH6sy7mCfvqdS+AJ5N27KYN8bFXbIcE3OpCwXm5SK2PEo
         xKKVELtZ31P8tPBGAt4IXMhbC5X359gRSxbtnAAj60vQwtXmLyPmqsmhMx8wEtTNI9
         UU+XhpGrPfHvCUJj4xXz3vzcHzKlaj4mEG9nyQfg=
Date:   Fri, 29 Nov 2019 11:24:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: pcrypt - Do not clear MAY_SLEEP flag in original
 request
Message-ID: <20191129192449.GA706@sol.localdomain>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
 <20191119173732.GB819@sol.localdomain>
 <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
 <20191126053238.yxhtfbt5okcjycuy@ca-dmjordan1.us.oracle.com>
 <20191126075845.2v3woc3xqx2fxzqh@gondor.apana.org.au>
 <20191127191452.GC49214@sol.localdomain>
 <20191129084024.arwefx7bpvvxpyjk@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129084024.arwefx7bpvvxpyjk@gondor.apana.org.au>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 29, 2019 at 04:40:24PM +0800, Herbert Xu wrote:
> On Wed, Nov 27, 2019 at 11:14:52AM -0800, Eric Biggers wrote:
> >
> > I tried applying the following patches and running syzkaller again:
> > 
> > 	padata: Remove unused padata_remove_cpu
> > 	padata: Remove broken queue flushing
> > 	crypto: pcrypt - Fix user-after-free on module unload
> > 	[v3] crypto: pcrypt - Avoid deadlock by using per-instance padata queues
> > 
> > This time I got a crypto self-test failure when
> > "pcrypt(pcrypt(rfc4106-gcm-aesni))" was instantiated:
> > 
> > [ 2220.165113] alg: aead: pcrypt(pcrypt(rfc4106-gcm-aesni)) encryption corrupted request struct on test vector 0, cfg="uneven misaligned splits, may sleep"
> > [ 2220.170295] alg: aead: changed 'req->base.flags'
> > [ 2220.171799] Kernel panic - not syncing: alg: self-tests for pcrypt(pcrypt(rfc4106-gcm-aesni)) (rfc4106(gcm(aes))) failed in panic_on_fail mode!
> > 
> > So the algorithm is not preserving aead_request::base.flags.
> 
> Thanks for the report.  This is a preexisting bug in pcrypt.  Here
> is a patch for it.
> 
> ---8<---
> We should not be modifying the original request's MAY_SLEEP flag
> upon completion.  It makes no sense to do so anyway.
> 
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 543792e0ebf0..2f6f81183e45 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -63,7 +63,6 @@ static void pcrypt_aead_done(struct crypto_async_request *areq, int err)
>  	struct padata_priv *padata = pcrypt_request_padata(preq);
>  
>  	padata->info = err;
> -	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>  
>  	padata_do_serial(padata);
>  }

Tested-by: Eric Biggers <ebiggers@kernel.org>
