Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A0ACCA47F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jul 2022 08:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiGVIof (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jul 2022 04:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiGVIoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jul 2022 04:44:32 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FD49FE05
        for <linux-crypto@vger.kernel.org>; Fri, 22 Jul 2022 01:44:30 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oEoGd-003HMD-01; Fri, 22 Jul 2022 18:44:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jul 2022 16:44:15 +0800
Date:   Fri, 22 Jul 2022 16:44:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] crypto: keembay-ocs-ecc: Drop if with an always false
 condition
Message-ID: <YtpjX9WoXgoq9ru+@gondor.apana.org.au>
References: <20220714212820.59237-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220714212820.59237-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 14, 2022 at 11:28:20PM +0200, Uwe Kleine-König wrote:
> The remove callback is only called after probe completed successfully.
> In this case platform_set_drvdata() was called with a non-NULL argument
> and so ecc_dev is never NULL.
> 
> This is a preparation for making platform remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/keembay/keembay-ocs-ecc.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
