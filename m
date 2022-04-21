Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9C8C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 10:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388008AbiDUKDD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388005AbiDUKDC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 06:03:02 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDA0BF6B;
        Thu, 21 Apr 2022 03:00:12 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nhTbY-005D13-CP; Thu, 21 Apr 2022 20:00:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Apr 2022 18:00:04 +0800
Date:   Thu, 21 Apr 2022 18:00:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Joseph Longever <jlongever@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hwrng: cn10k - Optimize random number generator
 driver
Message-ID: <YmErJGiTYjlOus5D@gondor.apana.org.au>
References: <20220413141606.8261-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413141606.8261-1-vdronov@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 13, 2022 at 04:16:04PM +0200, Vladis Dronov wrote:
> Hi,
> 
> I'm suggesting couple of tweaks and fixes for the CN10K Random Number Generator
> driver. Main points are: fix a logic, optimize a loop and make an error message
> more informative.
> 
> Vladis Dronov (2):
>   hwrng: cn10k - Optimize cn10k_rng_read()
>   hwrng: cn10k - Make check_rng_health() return an error code
> 
>  drivers/char/hw_random/cn10k-rng.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
