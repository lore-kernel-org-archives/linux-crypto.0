Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EDBC43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC76221EE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgIKG6D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 02:58:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58962 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgIKG6C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 02:58:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kGd06-0007tW-VT; Fri, 11 Sep 2020 16:57:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2020 16:57:38 +1000
Date:   Fri, 11 Sep 2020 16:57:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     martin@kaiser.cx, prasannatsmkumar@gmail.com, linux-imx@nxp.com,
        festevam@gmail.com, mpm@selenic.com, Anson.Huang@nxp.com,
        horia.geanta@nxp.com, arnd@arndb.de, ceggers@arri.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] hwrng: imx-rngc - add quality to use it as kernel
 entropy pool
Message-ID: <20200911065738.GE32150@gondor.apana.org.au>
References: <20200831140042.2049-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831140042.2049-1-m.felsch@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 31, 2020 at 04:00:42PM +0200, Marco Felsch wrote:
> The RM describes the RNGB as follow:
> 8<----------------------------------------------------------------
> The RNGB uses the True Random Number Generator (TRNG) and a
> Pseudo-Random Number Generator (PRNG) to achieve a true randomness and
> cryptographic strength.
> 8<----------------------------------------------------------------
> 
> The RNGB has 3 operation modes: self-test, seed-generation and the final
> 'random number generation' mode. Before we can retrieve random numbers
> from the RNGB we need to generate the seed pool:
> 8<----------------------------------------------------------------
> During the seed generation, the RNGB adds the entropy generated in the
> TRNG to the 256-bit XKEY register. The PRNG algorithm executes 20.000
> entropy samples from the TRNG to create an initial seed for the random
> number generation.
> 8<----------------------------------------------------------------
> 
> The RNGB can generate 2^20 words (1 word == 4 byte) of 'random' data
> after the seed pool was initialized. The pool needs to be reseeded if
> more words are required. The reseeding is done automatically since
> commit 3acd9ea9331c ("hwrng: imx-rngc - use automatic seeding").
> 
> We can't retrieve the TRNG values directly so we need a other way to get
> the quality level. We know that the PRNG uses 20.000 entropy samples
> from the TRNG to generate 2^20 words (1MiB) and the quality level is
> defined as (in bits of entropy per 1024 bits of input). So the quality
> level can be calculated by:
> 
>    20.000 * 1024
>    ------------- = ~ 19.5
>         2^20
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  drivers/char/hw_random/imx-rngc.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
