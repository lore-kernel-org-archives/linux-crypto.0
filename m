Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCF0C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D6A420637
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKVINm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 03:13:42 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43464 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfKVINl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 03:13:41 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY44S-0007hc-MT; Fri, 22 Nov 2019 16:13:40 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY44Q-0004u8-Ip; Fri, 22 Nov 2019 16:13:38 +0800
Date:   Fri, 22 Nov 2019 16:13:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH 2/3] s390/crypto: Rework on paes implementation
Message-ID: <20191122081338.6bdjevtyttpdzzwl@gondor.apana.org.au>
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-3-freude@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113105523.8007-3-freude@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 11:55:22AM +0100, Harald Freudenberger wrote:
>
> @@ -129,6 +128,7 @@ static int ecb_paes_init(struct crypto_skcipher *tfm)
>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>  
>  	ctx->kb.key = NULL;
> +	spin_lock_init(&ctx->pk_lock);

This makes no sense.  The context is per-tfm, and each tfm should
have a single key at any time.  The synchronisation of setkey vs.
crypto operations is left to the user of the tfm, not the
implementor.

So why do you need this spin lock at all?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
