Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB96C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFFF221479
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfDROiF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:38:05 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55344 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731317AbfDROiF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:38:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7dq-0004aR-2P; Thu, 18 Apr 2019 22:03:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7do-0008Js-Lr; Thu, 18 Apr 2019 22:03:52 +0800
Date:   Thu, 18 Apr 2019 22:03:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 6/7] crypto: ccm - fix incompatibility between "ccm"
 and "ccm_base"
Message-ID: <20190418140352.2mhpzee5nfgly7ka@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410064635.11813-7-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
>
> @@ -486,7 +485,8 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
> 
>        mac = __crypto_hash_alg_common(mac_alg);
>        err = -EINVAL;
> -       if (mac->digestsize != 16)
> +       if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
> +           mac->digestsize != 16)
>                goto out_put_mac;

Keeping the digestsize check is good because names don't mean
much when self-tests are disabled.

> @@ -509,23 +509,26 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
> 
>        ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
> 
> -       /* Not a stream cipher? */
> +       /* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
>        err = -EINVAL;
> -       if (ctr->base.cra_blocksize != 1)
> +       if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
> +           crypto_skcipher_alg_ivsize(ctr) != 16)
>                goto err_drop_ctr;

So we should keep the cra_blocksize test here as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
