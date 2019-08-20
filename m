Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BDEC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 09:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 365A422DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 09:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AMvlqI8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfHTJvw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 05:51:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39162 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbfHTJvw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 05:51:52 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190820095150euoutp01223cbdcb84c61c2c3e5122861f864ec1~8mL2wUlG-2257822578euoutp01f
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 09:51:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190820095150euoutp01223cbdcb84c61c2c3e5122861f864ec1~8mL2wUlG-2257822578euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566294710;
        bh=fXKvTtNMUisuSWsDVpocSk3OUD2IZfGyPFsFtoY+UOw=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=AMvlqI8y7SWZrvUbkXkN9PsEUiCBLflhNNDHnqPxq6/Rfl5DNrXKJaCa2QGDNE1qF
         g0xIGcwSBKA0O8nnyVmS0C5gprc6QhwZNX0RAGuO9CoCsC2VY1WjrQJFSA/fpw61+g
         +2iz358/+jaU7cmqCsTrekecdEzPjGzKOH0X6nZg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190820095150eucas1p1bba7ef0a30eee773713bc58b43b3dcfc~8mL2KpI660812108121eucas1p1E;
        Tue, 20 Aug 2019 09:51:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id D8.B2.04469.5B2CB5D5; Tue, 20
        Aug 2019 10:51:49 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190820095149eucas1p25e74d4b541bf9f8d612bbaa4ac4faf05~8mL1NiMGI3272032720eucas1p2Q;
        Tue, 20 Aug 2019 09:51:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190820095149eusmtrp15dfb8fc9b31bc0ad8fe700c4b6e4fa59~8mL1M03UJ2787427874eusmtrp1d;
        Tue, 20 Aug 2019 09:51:49 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-e3-5d5bc2b59a56
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FF.B9.04117.5B2CB5D5; Tue, 20
        Aug 2019 10:51:49 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190820095148eusmtip2497c8a2bb51eaef38c76d2d43255a73c~8mL00_gkW2777127771eusmtip2L;
        Tue, 20 Aug 2019 09:51:48 +0000 (GMT)
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for
 ctr(aes)
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <f42c9a9f-b9a1-1858-e79f-e844b2d56bc5@partner.samsung.com>
Date:   Tue, 20 Aug 2019 11:51:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819142226.1703-3-ard.biesheuvel@linaro.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsWy7djPc7pbD0XHGvz8pmPx/8NuRovuVzIW
        589vYLe4f+8nk8WM8/uYLP7/amZ2YPPYdkDVY9OqTjaPO9f2sHn8WziFxePzJrkA1igum5TU
        nMyy1CJ9uwSujKmXljMWfGevODbrGlMD40a2LkZODgkBE4n/fxaxdDFycQgJrGCU6L3QxQTh
        fGGUOD6nhxGkSkjgM6PErGW1MB09B1azQRQtZ5RYc/EBVPtbRokr55aCzRUWCJTomLWYtYuR
        g0NEwEfi0klxkBpmgT5Gie0LN7OC1LAJmEs82n6GCcTmFXCTmN/3jQWknkVAVeJlJ9hiUYEI
        iU8PDrNClAhKnJz5hAXE5hSwk1j0YTPYKmYBcYlbT+YzQdjyEtvfzmGGOHQVu8TBX/EQtovE
        60t/WSFsYYlXx7ewQ9gyEqcn97BA2OUSTxf2sYPcKSHQwijxoP0jVMJa4vDxi2C/MAtoSqzf
        pQ8RdpTov76WDSQsIcAnceOtIMQJfBKTtk1nhgjzSnS0CUFUq0o8P9XDBGFLS3T9X8c6gVFp
        FpLHZiF5ZhaSZ2Yh7F3AyLKKUTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/dxMjMOGc/nf80w7G
        r5eSDjEKcDAq8fB6TIuKFWJNLCuuzD3EKMHBrCTCWzEHKMSbklhZlVqUH19UmpNafIhRmoNF
        SZy3muFBtJBAemJJanZqakFqEUyWiYNTqoExzkPQ3UwiUupWxtxJoQYHbQJ2yp45yL3tgd8j
        6eZ7z+VK1sqVf5dN317ItdnMJ9pt5xn5w/afhXTZfoqr2iZs+L+uOcvzz+eXdcEfZ6xXmvnv
        j1P6ixaXBMW/4TvepL6fs2PPCe+jIrrLnp5/3z9DYVvcvSW8k23Nd7yftKRh6eyDm1Xk1c4t
        VGIpzkg01GIuKk4EANmk89Q0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xe7pbD0XHGkz9wWHx/8NuRovuVzIW
        589vYLe4f+8nk8WM8/uYLP7/amZ2YPPYdkDVY9OqTjaPO9f2sHn8WziFxePzJrkA1ig9m6L8
        0pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jKmXljMWfGev
        ODbrGlMD40a2LkZODgkBE4meA6uBbC4OIYGljBKvZx5lh0hISzSeXs0EYQtL/LnWBVX0mlGi
        deIKVpCEsECgRMesxUA2B4eIgI/EpZPiIDXMAn2MEg1zZ7JDNBxllJj3vIUFpIFNwFzi0fYz
        YFN5Bdwk5vd9YwFpZhFQlXjZyQgSFhWIkDi8YxYjRImgxMmZT8BaOQXsJBZ92Ax2NbOAusSf
        eZeYIWxxiVtP5jNB2PIS29/OYZ7AKDQLSfssJC2zkLTMQtKygJFlFaNIamlxbnpusZFecWJu
        cWleul5yfu4mRmCcbTv2c8sOxq53wYcYBTgYlXh4PaZFxQqxJpYVV+YeYpTgYFYS4a2YAxTi
        TUmsrEotyo8vKs1JLT7EaAr020RmKdHkfGAKyCuJNzQ1NLewNDQ3Njc2s1AS5+0QOBgjJJCe
        WJKanZpakFoE08fEwSnVwCjusLzh1OK508R6z2zcKDBpo9aUEy2ZLcsu9nud6d6imcEVM0n7
        ioRSUfs9lle2kp7POhfFT3fmfnFOnmNng+ftLRG7Zl0JbXn/6qDNDyURuVDlH7P/ruZ2+X+l
        5d8r129TizdGl1+3r5i9t+m1K39Ml9As7ys5X90nJF3YWTtv98Rczx11TUZKLMUZiYZazEXF
        iQCSQFW8yQIAAA==
X-CMS-MailID: 20190820095149eucas1p25e74d4b541bf9f8d612bbaa4ac4faf05
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190819142413epcas2p379e5fa48cd9c2f437b041d5a1fdd1a50
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190819142413epcas2p379e5fa48cd9c2f437b041d5a1fdd1a50
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
        <CGME20190819142413epcas2p379e5fa48cd9c2f437b041d5a1fdd1a50@epcas2p3.samsung.com>
        <20190819142226.1703-3-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19.08.2019 16:22, Ard Biesheuvel wrote:
> Align the s5p ctr(aes) implementation with other implementations
> of the same mode, by setting the block size to 1.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index ef90c58edb1f..010f1bb20dad 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
>  		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
>  					  CRYPTO_ALG_ASYNC |
>  					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -		.cra_blocksize		= AES_BLOCK_SIZE,
> +		.cra_blocksize		= 1,
>  		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
>  		.cra_alignmask		= 0x0f,
>  		.cra_type		= &crypto_ablkcipher_type,
> 

Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

