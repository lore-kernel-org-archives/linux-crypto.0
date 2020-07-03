Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38693C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17305208C7
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgGCEL4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:11:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40050 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgGCEL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 00:11:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jrD2p-0007fi-IQ; Fri, 03 Jul 2020 14:11:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2020 14:11:23 +1000
Date:   Fri, 3 Jul 2020 14:11:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     davem@davemloft.net, wangzhou1@hisilicon.com,
        jonathan.cameron@huawei.com, akpm@linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: Re: [PATCH v2 1/3] crypto: permit users to specify numa node of
 acomp hardware
Message-ID: <20200703041123.GA7774@gondor.apana.org.au>
References: <20200623041610.7620-1-song.bao.hua@hisilicon.com>
 <20200623041610.7620-2-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623041610.7620-2-song.bao.hua@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 23, 2020 at 04:16:08PM +1200, Barry Song wrote:
>
> -void *crypto_create_tfm(struct crypto_alg *alg,
> -			const struct crypto_type *frontend)
> +void *crypto_create_tfm_node(struct crypto_alg *alg,
> +			const struct crypto_type *frontend,
> +			int node)
>  {
>  	char *mem;
>  	struct crypto_tfm *tfm = NULL;
> @@ -451,6 +452,7 @@ void *crypto_create_tfm(struct crypto_alg *alg,
>  
>  	tfm = (struct crypto_tfm *)(mem + tfmsize);
>  	tfm->__crt_alg = alg;
> +	tfm->node = node;

Should the kzalloc also use node?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
