Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28858C48BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 23:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8A760FF0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 23:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhFRXvt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 19:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbhFRXvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 19:51:48 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80807C061767
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v7so9152162pgl.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1LjPznQ/uIsBDTfnzklraJ3U4KjBtmygs7CsvfkuOpE=;
        b=DOvQjNeS+IMvZE3V2rm/bsTOIE2+ElVWYpXBZFcbc3+qR4DzP1GrEt9yKpj0PRQqM5
         QK21+zJTSoN1Btb1LpXsZEUBLD482NwV90tCJzDecrk9yRXIR7/iS40hHtUX6HWl3Caq
         KqA7e5DTfGdu/IRPBaotih4QTz2Uw9/rrROpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LjPznQ/uIsBDTfnzklraJ3U4KjBtmygs7CsvfkuOpE=;
        b=tKVZDvinOuxQBhXmhgi19glmKwGkgpaW2RkniSR4t2/VpNbIii+YMJDMVWLsa5mJSR
         PU2kAztb3ZvE7V/DLZrxcBFaFoLkbVs6UZQbDAu6Hd3D3zctSbFfh5LBm7Y78FcAyQu2
         K+ztMIwv36n/DG7drkAY6HwY7+i4r9ANyUMBZjuyBdQE8UtTsOooYtVDMs75+83Ier7B
         SXf3UZbi+41RN+oKnYXwLxuYrf86ETF2hXQeTuWQphcr9WzK1wczCQlmgXZg/pwhw1aA
         jmG0eIqZt+IxHR/bruQXqEaMw8z1K+0VN2un3aUPkJghnvZz1DAFIo4w2WUQ9ayukduh
         S7kg==
X-Gm-Message-State: AOAM531ew6Ibd19XDGPjT1iWfboLxwZiwmdXkYMhUDh3vC9jgzSb88xz
        ilDNqYOTMjny4gl1Hhno9/7aY1SeePAFRg==
X-Google-Smtp-Source: ABdhPJwZim075DfvinUYZnIyBpgJHTRdBHlySZ9Lv5z4lp07rXwavP5/Oq5awRv5qpMc/S7ulDSg/Q==
X-Received: by 2002:a63:d47:: with SMTP id 7mr12346532pgn.339.1624060177005;
        Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b1sm472127pjk.51.2021.06.18.16.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:49:36 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:49:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx: Fix memcpy() over-reading in nonce
Message-ID: <202106181648.0C5FA93@keescook>
References: <20210616203459.1248036-1-keescook@chromium.org>
 <87zgvpqb00.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgvpqb00.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 17, 2021 at 04:08:15PM +1000, Michael Ellerman wrote:
> Kees Cook <keescook@chromium.org> writes:
> > Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.
> >
> > Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Thanks.
> 
> > ---
> >  drivers/crypto/nx/nx-aes-ctr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
> > index 13f518802343..6120e350ff71 100644
> > --- a/drivers/crypto/nx/nx-aes-ctr.c
> > +++ b/drivers/crypto/nx/nx-aes-ctr.c
> > @@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
> >  	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
> >  	u8 iv[16];
> >  
> > -	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
> > +	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
> >  	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
> >  	iv[12] = iv[13] = iv[14] = 0;
> >  	iv[15] = 1;
> 
> Where IV_SIZE is 8 and NONCE_SIZE is 4.
> 
> And iv is 16 bytes, so it's not a buffer overflow.
> 
> But priv.ctr.nonce is 4 bytes, and at the end of the struct, so it reads
> 4 bytes past the end of the nx_crypto_ctx, which is not good.
> 
> But then immediately overwrites whatever it read with req->iv.
> 
> So seems pretty harmless in practice?

Right -- there's no damage done, but future memcpy() FORTIFY work alerts
on this, so I'm going through cleaning all of these up. :)

-- 
Kees Cook
