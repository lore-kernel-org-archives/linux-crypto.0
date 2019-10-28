Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AD4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 08:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 753F8208C0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 08:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbfJ1IYh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 04:24:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51094 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbfJ1IYh (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Mon, 28 Oct 2019 04:24:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iP0KK-0001Em-2p; Mon, 28 Oct 2019 16:24:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iP0KH-0002w1-Ep; Mon, 28 Oct 2019 16:24:33 +0800
Date:   Mon, 28 Oct 2019 16:24:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, ifranzki@linux.ibm.com,
        ebiggers@kernel.org, freude@linux.ibm.com
Subject: Re: [PATCH] s390/crypto: Rework on paes implementation
Message-ID: <20191028082433.qdaabj2imf34ikam@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028073731.11778-1-freude@linux.ibm.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Harald Freudenberger <freude@linux.ibm.com> wrote:
>
> @@ -165,18 +183,31 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
>        struct skcipher_walk walk;
>        unsigned int nbytes, n, k;
>        int ret;
> +       struct {
> +               u8 key[MAXPROTKEYSIZE];
> +       } param;
> 
>        ret = skcipher_walk_virt(&walk, req, false);
> +       if (ret)
> +               return ret;
> +
> +       spin_lock(&ctx->pk_lock);
> +       memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
> +       spin_unlock(&ctx->pk_lock);

I think using a plain spin lock is unsafe as you may have callers
from both kernel thread context and BH context.  So you need to
have at least a spin_lock_bh here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
