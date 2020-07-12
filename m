Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C95C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 18:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598762063A
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 18:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgGLSCf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:02:35 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:55302 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbgGLSCf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 14:02:35 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 05D1E72CCF5;
        Sun, 12 Jul 2020 21:02:33 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id E3E4B4A4AEE;
        Sun, 12 Jul 2020 21:02:32 +0300 (MSK)
Date:   Sun, 12 Jul 2020 21:02:32 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 1/5] crypto: ECDH - check validity of Z before export
Message-ID: <20200712180232.jnvkz6xtx63hisvg@altlinux.org>
Mail-Followup-To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4348752.LvFx2qVVIh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4348752.LvFx2qVVIh@positron.chronox.de>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jul 12, 2020 at 06:39:26PM +0200, Stephan Müller wrote:
> SP800-56A rev3 section 5.7.1.2 step 2 mandates that the validity of the
> calculated shared secret is verified before the data is returned to the
> caller. Thus, the export function and the validity check functions are
> reversed. In addition, the sensitive variables of priv and rand_z are

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

> zeroized.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/ecc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 02d35be7702b..52e2d49262f2 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1495,11 +1495,16 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>  
>  	ecc_point_mult(product, pk, priv, rand_z, curve, ndigits);
>  
> -	ecc_swap_digits(product->x, secret, ndigits);
> -
> -	if (ecc_point_is_zero(product))
> +	if (ecc_point_is_zero(product)) {
>  		ret = -EFAULT;
> +		goto err_validity;
> +	}
> +
> +	ecc_swap_digits(product->x, secret, ndigits);
>  
> +err_validity:
> +	memzero_explicit(priv, sizeof(priv));
> +	memzero_explicit(rand_z, sizeof(rand_z));
>  	ecc_free_point(product);
>  err_alloc_product:
>  	ecc_free_point(pk);
> -- 
> 2.26.2
> 
> 
> 
