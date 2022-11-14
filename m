Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4D1C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 11:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiKNLWa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbiKNLWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2022 06:22:06 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AFD115E
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 03:18:37 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N9myJ6GFTz15Mc6;
        Mon, 14 Nov 2022 19:18:16 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 19:18:35 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.031;
 Mon, 14 Nov 2022 19:18:35 +0800
From:   "Gonglei (Arei)" <arei.gonglei@huawei.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        zhenwei pi <pizhenwei@bytedance.com>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] virtio-crypto: fix memory leak in
 virtio_crypto_alg_skcipher_close_session()
Thread-Topic: [PATCH] virtio-crypto: fix memory leak in
 virtio_crypto_alg_skcipher_close_session()
Thread-Index: AQHY+Bk7XRuE0LikA0eoAQIv/q8hvK4+RQHw
Date:   Mon, 14 Nov 2022 11:18:35 +0000
Message-ID: <06d31ec507ef441abc4dc56f2c9be8ac@huawei.com>
References: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
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
> From: Wei Yongjun [mailto:weiyongjun@huaweicloud.com]
> Sent: Monday, November 14, 2022 7:08 PM
> To: Michael S. Tsirkin <mst@redhat.com>; Jason Wang
> <jasowang@redhat.com>; Gonglei (Arei) <arei.gonglei@huawei.com>;
> Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller
> <davem@davemloft.net>; zhenwei pi <pizhenwei@bytedance.com>
> Cc: weiyongjun (A) <weiyongjun1@huawei.com>;
> virtualization@lists.linux-foundation.org; linux-crypto@vger.kernel.org
> Subject: [PATCH] virtio-crypto: fix memory leak in
> virtio_crypto_alg_skcipher_close_session()
> 
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> 'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
> and should be freed in the invalid ctrl_status->status error handling case.
> Otherwise there is a memory leak.
> 
> Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index e553ccadbcbc..e5876286828b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
>  		pr_err("virtio_crypto: Close session failed status: %u, session_id:
> 0x%llx\n",
>  			ctrl_status->status, destroy_session->session_id);
> 
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto out;
>  	}
> 
Good catch.

Reviewed-by: Gonglei <arei.gonglei@huawei.com>

Regards,
-Gonglei

>  	err = 0;
> --
> 2.34.1

