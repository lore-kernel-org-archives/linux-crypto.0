Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226C5C433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CB620799
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbhABVSN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 16:18:13 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37110 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbhABVSN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 16:18:13 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvoH2-00006e-JR; Sun, 03 Jan 2021 08:17:21 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 08:17:20 +1100
Date:   Sun, 3 Jan 2021 08:17:20 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Luca Dariz <luca.dariz@hitachi-powergrids.com>
Cc:     linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Colin Ian King <colin.king@canonical.com>,
        Holger Brunck <holger.brunck@hitachi-powergrids.com>,
        Valentin Longchamp <valentin.longchamp@hitachi-powergrids.com>
Subject: Re: [PATCH v2] hwrng: fix khwrng lifecycle
Message-ID: <20210102211720.GA1788@gondor.apana.org.au>
References: <20201216105906.6607-1-luca.dariz@hitachi-powergrids.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216105906.6607-1-luca.dariz@hitachi-powergrids.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 11:59:06AM +0100, Luca Dariz wrote:
>
> @@ -432,12 +433,15 @@ static int hwrng_fillfn(void *unused)
>  {
>  	long rc;
>  
> +	complete(&hwrng_started);
>  	while (!kthread_should_stop()) {
>  		struct hwrng *rng;
>  
>  		rng = get_current_rng();
> -		if (IS_ERR(rng) || !rng)
> -			break;
> +		if (IS_ERR(rng) || !rng) {
> +			msleep_interruptible(10);
> +			continue;

Please fix this properly with reference counting.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
