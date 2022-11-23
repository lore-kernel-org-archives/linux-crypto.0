Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F25C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 01:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbiKWBNa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 20:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbiKWBNA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 20:13:00 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77482E2B45
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 17:11:51 -0800 (PST)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NH33r3KPDzRpGP;
        Wed, 23 Nov 2022 09:11:20 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:11:49 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.031;
 Wed, 23 Nov 2022 09:11:49 +0800
From:   "Gonglei (Arei)" <arei.gonglei@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: virtio - Use helper to set reqsize
Thread-Topic: [PATCH] crypto: virtio - Use helper to set reqsize
Thread-Index: AQHY/lbIB4UAwZ8czkmWEcxmrx9Xl65LtBLQ
Date:   Wed, 23 Nov 2022 01:11:49 +0000
Message-ID: <7d7face1123d4b2585ad706a7bc772ee@huawei.com>
References: <Y3yZgn/ffk21bGaM@gondor.apana.org.au>
In-Reply-To: <Y3yZgn/ffk21bGaM@gondor.apana.org.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.149.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, November 22, 2022 5:42 PM
> To: Gonglei (Arei) <arei.gonglei@huawei.com>;
> virtualization@lists.linux-foundation.org; Linux Crypto Mailing List
> <linux-crypto@vger.kernel.org>
> Subject: [PATCH] crypto: virtio - Use helper to set reqsize
> 
> The value of reqsize must only be changed through the helper.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 168195672e2e..b2979be613b8 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -479,6 +479,9 @@ static int virtio_crypto_rsa_init_tfm(struct
> crypto_akcipher *tfm)
>  	ctx->enginectx.op.prepare_request = NULL;
>  	ctx->enginectx.op.unprepare_request = NULL;
> 
> +	akcipher_set_reqsize(tfm,
> +			     sizeof(struct virtio_crypto_akcipher_request));
> +
>  	return 0;
>  }
> 
> @@ -505,7 +508,6 @@ static struct virtio_crypto_akcipher_algo
> virtio_crypto_akcipher_algs[] = {
>  			.max_size = virtio_crypto_rsa_max_size,
>  			.init = virtio_crypto_rsa_init_tfm,
>  			.exit = virtio_crypto_rsa_exit_tfm,
> -			.reqsize = sizeof(struct virtio_crypto_akcipher_request),
>  			.base = {
>  				.cra_name = "rsa",
>  				.cra_driver_name = "virtio-crypto-rsa", @@ -528,7
> +530,6 @@ static struct virtio_crypto_akcipher_algo
> virtio_crypto_akcipher_algs[] = {
>  			.max_size = virtio_crypto_rsa_max_size,
>  			.init = virtio_crypto_rsa_init_tfm,
>  			.exit = virtio_crypto_rsa_exit_tfm,
> -			.reqsize = sizeof(struct virtio_crypto_akcipher_request),
>  			.base = {
>  				.cra_name = "pkcs1pad(rsa,sha1)",
>  				.cra_driver_name = "virtio-pkcs1-rsa-with-sha1",
> --

Acked-by: Gonglei <arei.gonglei@huawei.com>

Regards,
-Gonglei
