Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F4DC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0372C21479
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbfDROiA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:38:00 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55342 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731317AbfDROiA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:38:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7aB-0004ZG-KX; Thu, 18 Apr 2019 22:00:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7aA-0008J3-Nh; Thu, 18 Apr 2019 22:00:06 +0800
Date:   Thu, 18 Apr 2019 22:00:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 5/7] crypto: gcm - fix incompatibility between "gcm"
 and "gcm_base"
Message-ID: <20190418140006.x3aaja7vvntu6p5p@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410064635.11813-6-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
>
> @@ -638,7 +637,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
>                goto err_free_inst;
> 
>        err = -EINVAL;
> -       if (ghash->digestsize != 16)
> +       if (strcmp(ghash->base.cra_name, "ghash") != 0)
>                goto err_drop_ghash;

We should keep both tests because the self-tests can be compiled
out so there is no guarantee that something claiming to be ghash
actually is ghash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
