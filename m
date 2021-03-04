Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57426C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 05:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D79664EF4
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 05:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhCDF31 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 00:29:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48220 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234113AbhCDF3K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 00:29:10 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHgWw-0006UG-3x; Thu, 04 Mar 2021 16:28:11 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 16:28:09 +1100
Date:   Thu, 4 Mar 2021 16:28:09 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, dhowells@redhat.com, zohar@linux.ibm.com,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        linux-integrity@vger.kernel.org,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: Re: [PATCH v9 6/9] crypto: Add NIST P384 curve parameters
Message-ID: <20210304052809.GB25972@gondor.apana.org.au>
References: <20210225160802.2478700-1-stefanb@linux.vnet.ibm.com>
 <20210225160802.2478700-7-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225160802.2478700-7-stefanb@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 25, 2021 at 11:07:59AM -0500, Stefan Berger wrote:
> From: Saulo Alessandre <saulo.alessandre@tse.jus.br>
> 
> * crypto/ecc_curve_defs.h
>   - add nist_p384 params
> 
> * include/crypto/ecdh.h
>   - add ECC_CURVE_NIST_P384
> 
> Signed-off-by: Saulo Alessandre <saulo.alessandre@tse.jus.br>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> ---
>  crypto/ecc_curve_defs.h | 32 ++++++++++++++++++++++++++++++++
>  include/crypto/ecdh.h   |  1 +
>  2 files changed, 33 insertions(+)

Can you reorder the patches so that the crypto patches come first
and then I can apply them?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
