Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2547AC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 07:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21D4224B1
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 07:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgLWHvr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 02:51:47 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36578 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgLWHvr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 02:51:47 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kryvI-0006eG-HD; Wed, 23 Dec 2020 18:51:05 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Dec 2020 18:51:04 +1100
Date:   Wed, 23 Dec 2020 18:51:04 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay-ocs-aes - Add dependency on HAS_IOMEM
Message-ID: <20201223075104.GB8269@gondor.apana.org.au>
References: <20201217163510.372558-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217163510.372558-1-daniele.alessandrelli@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 04:35:10PM +0000, Daniele Alessandrelli wrote:
> From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> 
> Add dependency for CRYPTO_DEV_KEEMBAY_OCS_AES_SM4 on HAS_IOMEM to
> prevent build failures.
> 
> Fixes: 88574332451380f4 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> ---
>  drivers/crypto/keembay/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
