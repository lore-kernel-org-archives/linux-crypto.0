Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E063C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Dec 2021 11:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhLaLfj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Dec 2021 06:35:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58800 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhLaLfi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Dec 2021 06:35:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GC5-0004xp-9u; Fri, 31 Dec 2021 22:35:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:35:33 +1100
Date:   Fri, 31 Dec 2021 22:35:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: Re: [PATCH] crypto: qat - fix definition of ring reset results
Message-ID: <Yc7rBZpzo8GbARsW@gondor.apana.org.au>
References: <20211224110532.247754-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224110532.247754-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 24, 2021 at 11:05:32AM +0000, Giovanni Cabiddu wrote:
> The ring reset result values are defined starting from 0x1 instead of 0.
> This causes out-of-tree drivers that support this message to understand
> that a ring reset failed even if the operation was successful.
> 
> Fix by starting the definition of ring reset result values from 0.
> 
> Fixes: 0bba03ce9739 ("crypto: qat - add PFVF support to enable the reset of ring pairs")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reported-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_pfvf_msg.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
