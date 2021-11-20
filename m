Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E37AC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhKTEb5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:31:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56904 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236949AbhKTEbx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:31:53 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moHzc-0001JJ-5Q; Sat, 20 Nov 2021 12:28:48 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moHzc-0006kO-2m; Sat, 20 Nov 2021 12:28:48 +0800
Date:   Sat, 20 Nov 2021 12:28:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Declan Murphy <declan.murphy@intel.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: rectify entry for INTEL KEEM BAY OCS ECC
 CRYPTO DRIVER
Message-ID: <20211120042848.GF25752@gondor.apana.org.au>
References: <20211103094711.8844-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103094711.8844-1-lukas.bulwahn@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 03, 2021 at 10:47:11AM +0100, Lukas Bulwahn wrote:
> Commit c9f608c38009 ("crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC
> Driver") only adds drivers/crypto/keembay/keembay-ocs-ecc.c, but adds a
> file entry drivers/crypto/keembay/ocs-ecc-curve-defs.h in MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns warns:
> 
>   warning: no file matches  F:  drivers/crypto/keembay/ocs-ecc-curve-defs.h
> 
> Assuming that this header is obsolete and will not be included in the
> repository, remove the unneeded file entry from MAINTAINERS.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
