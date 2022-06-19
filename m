Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034B9C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jun 2022 07:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiFSHKF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jun 2022 03:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiFSHKD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jun 2022 03:10:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E356AE0D3
        for <linux-crypto@vger.kernel.org>; Sun, 19 Jun 2022 00:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655622601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3x8OsDInbETvWJowuf8truRClhNOXKtH5zOnRtLp1ps=;
        b=FLS7seFbrzHoALPKwRISBEqc1W+5tNMIu36DrWZH/9Ihj2efjvVLRhMdIupqx3SCm0dils
        QEhC6DD12Aoy/Iu0SQMU0OL+mACePxt4lAyg+a5re8ksD10F0nhAInRqFY9/ttpulL7/Zb
        IUtlfCG9KAL4+5mIPtFvxOsTzd39/AY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-pTCwTSmyMsOW6P-gyONOJA-1; Sun, 19 Jun 2022 03:09:53 -0400
X-MC-Unique: pTCwTSmyMsOW6P-gyONOJA-1
Received: by mail-ed1-f69.google.com with SMTP id s15-20020a056402520f00b004327f126170so6320567edd.7
        for <linux-crypto@vger.kernel.org>; Sun, 19 Jun 2022 00:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3x8OsDInbETvWJowuf8truRClhNOXKtH5zOnRtLp1ps=;
        b=d3YW2V7dr9ijuWJkyCC/dpnXJIp/D8qpM0guSO+WqDegxkjAZe7sfCSk+Fd4TKHjNC
         mygSAPyO+KvSoF6YXPva93VKRzCjNEfOneKnHQ3Fq/hEs/Zcz/JHYS5tZZ8oMgwY1tb3
         62YsrSe2XhUCtM/GYbYEeUrqsPHiz5UJZPd1p0AiR2IJ6MbcbRB8wTp/gf4L2NmMYQjT
         YrT2vUQvHs7fPzIWsnkXLtWU7z/znDiBW1LrQoWobgw0kZVRapwleu83Hs60/UolAxad
         23Rv63KPMj+XHJD0y570+c3DSYlPBrXEPJO/Y9E4gCCBNFpPPkTi9ZYKuzP0j4f7FFPE
         B+1Q==
X-Gm-Message-State: AJIora/+0tyNbc4Y7NU4DCyjJjPf1esCVIyxHCTdL21wmymYGwAVxtuA
        XnpZ6VE+t6ahsD2ICe1PACVbKPhbm3GWEjLnjwCq5+qQIsNN401XsYtOE4Gj7alqBwJoBhl+Sg7
        WuLOFchwSbDpb58A6XqCjB5+P
X-Received: by 2002:a50:ff04:0:b0:431:6a31:f19e with SMTP id a4-20020a50ff04000000b004316a31f19emr22156467edu.89.1655622592103;
        Sun, 19 Jun 2022 00:09:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHgTJKPW1Cl3U4Jj11eBtBszC1tyUEeWn1MpZtV9B23XUh+8+QpA4+aWLhjmnJwCXuwT+6aQ==
X-Received: by 2002:a50:ff04:0:b0:431:6a31:f19e with SMTP id a4-20020a50ff04000000b004316a31f19emr22156454edu.89.1655622591889;
        Sun, 19 Jun 2022 00:09:51 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906211200b006fea43db5c1sm4258312ejt.21.2022.06.19.00.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 00:09:51 -0700 (PDT)
Date:   Sun, 19 Jun 2022 03:09:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        dhowells@redhat.com, arei.gonglei@huawei.com, jasowang@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com, f4bug@amsat.org, berrange@redhat.com
Subject: Re: [PATCH] crypto: testmgr - fix version number of RSA tests
Message-ID: <20220619030904-mutt-send-email-mst@kernel.org>
References: <20220617070754.73667-1-helei.sig11@bytedance.com>
 <20220617070754.73667-3-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617070754.73667-3-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 17, 2022 at 03:07:51PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> According to PKCS#1 standard, the 'otherPrimeInfos' field contains
> the information for the additional primes r_3, ..., r_u, in order.
> It shall be omitted if the version is 0 and shall contain at least
> one instance of OtherPrimeInfo if the version is 1, see:
> 	https://www.rfc-editor.org/rfc/rfc3447#page-44
> 
> Replace the version number '1' with 0, otherwise, some drivers may
> not pass the run-time tests.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>

Why is this posted as part of the virtio-crypto patchset thread though?


> ---
>  crypto/testmgr.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 4d7449fc6a65..d57f24b906f1 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -186,7 +186,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
>  #ifndef CONFIG_CRYPTO_FIPS
>  	.key =
>  	"\x30\x81\x9A" /* sequence of 154 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
>  	"\x02\x41" /* modulus - integer of 65 bytes */
>  	"\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
>  	"\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
> @@ -216,7 +216,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
>  	}, {
>  	.key =
>  	"\x30\x82\x01\x1D" /* sequence of 285 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
>  	"\x02\x81\x81" /* modulus - integer of 129 bytes */
>  	"\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
>  	"\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
> @@ -260,7 +260,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
>  #endif
>  	.key =
>  	"\x30\x82\x02\x20" /* sequence of 544 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
>  	"\x02\x82\x01\x01\x00" /* modulus - integer of 256 bytes */
>  	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
>  	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
> -- 
> 2.20.1

