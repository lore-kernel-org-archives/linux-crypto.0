Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB29C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 17:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 194DD206F6
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 17:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/6h65z6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXRsH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:48:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57082 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726593AbgGXRsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 13:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595612886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+T+pO1IiTBcshaBx7K7XDtzKCU9wZxsL20cvuI+vdD4=;
        b=T/6h65z6rxv+1lsK/xwXZLScfhb4CJPKpc51UEdFVhWZmZG4+HgtDtR561kASJLRE2zhH5
        bfs4vKK8orsNofU3RlNfW2Mg5pQnJDRQ3VJ6tz5Iru23goyMB0Xnwi5DObwlfXQHh413p8
        tZ9d02MzowOFjOhln4uIs+cKFKjaOVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-zUnlP70DMaetJ8bg__5xPw-1; Fri, 24 Jul 2020 13:48:02 -0400
X-MC-Unique: zUnlP70DMaetJ8bg__5xPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4A46800685;
        Fri, 24 Jul 2020 17:48:00 +0000 (UTC)
Received: from desktop-in5iihd.lan (ovpn-115-213.rdu2.redhat.com [10.10.115.213])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1A345D9D3;
        Fri, 24 Jul 2020 17:47:56 +0000 (UTC)
Date:   Fri, 24 Jul 2020 13:47:51 -0400
From:   Neil Horman <nhorman@redhat.com>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, simo@redhat.com
Subject: Re: [PATCH v3 1/5] crypto: ECDH - check validity of Z before export
Message-ID: <20200724173233.GA62975@desktop-in5iihd.lan>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2544426.mvXUDI8C0e@positron.chronox.de>
 <1759349.tdWV9SEqCh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1759349.tdWV9SEqCh@positron.chronox.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 20, 2020 at 07:07:48PM +0200, Stephan Müller wrote:
> SP800-56A rev3 section 5.7.1.2 step 2 mandates that the validity of the
> calculated shared secret is verified before the data is returned to the
> caller. Thus, the export function and the validity check functions are
> reversed. In addition, the sensitive variables of priv and rand_z are
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
> 
Acked-by: Neil Horman <nhorman@redhat.com>

