Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFA3C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 03:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BCE20855
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 03:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHUDrC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 23:47:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49734 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgHUDrC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 23:47:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8y0x-0008OY-JO; Fri, 21 Aug 2020 13:46:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 13:46:51 +1000
Date:   Fri, 21 Aug 2020 13:46:51 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
Message-ID: <20200821034651.GA25442@gondor.apana.org.au>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806163551.14395-2-andrei.botila@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 06, 2020 at 07:35:43PM +0300, Andrei Botila wrote:
>
> +static bool xts_skcipher_ivsize(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
> +	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
> +	u64 size = 0;
> +
> +	if (IS_ALIGNED((unsigned long)req->iv, __alignof__(u64)))
> +		size = *(u64 *)(req->iv + (ivsize / 2));
> +	else
> +		size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
> +
> +	return !!size;
> +}

Just go with the get_unaligned unconditionally.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
