Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C02EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 11:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbjFPLEe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 07:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344830AbjFPLD7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 07:03:59 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E26144BF;
        Fri, 16 Jun 2023 03:58:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qA79X-003mfD-15; Fri, 16 Jun 2023 18:58:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 18:58:03 +0800
Date:   Fri, 16 Jun 2023 18:58:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Yang <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] crypto: hisilicon/advca - Add SHA support
Message-ID: <ZIxAOxhsR5pihWlE@gondor.apana.org.au>
References: <20230606071128.375567-1-mmyangfl@gmail.com>
 <20230606071128.375567-3-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606071128.375567-3-mmyangfl@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 03:11:12PM +0800, David Yang wrote:
.
> +/*
> + * must be called before setting SHA_START
> + * does nothing if import is not supported (SHA_TYPE_HASH)
> + */
> +static void hica_sha_import(const struct hica_sha_priv *priv, const void *state)
> +{
> +	if (priv->type != SHA_TYPE_MHASH)
> +		return;

As you may have noticed from the void return type, an import is
not allowed to fail.  If you have to fail then you're doing something
wrong.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
