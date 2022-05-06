Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3236C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 09:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiEFJiZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 05:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238563AbiEFJiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 05:38:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFCB106;
        Fri,  6 May 2022 02:34:41 -0700 (PDT)
Received: from kwepemi100012.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kvlkl6FPMzhYhf;
        Fri,  6 May 2022 17:34:07 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi100012.china.huawei.com (7.221.188.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 17:34:39 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Fri, 6 May 2022 17:34:39 +0800
From:   "Gonglei (Arei)" <arei.gonglei@huawei.com>
To:     zhenwei pi <pizhenwei@bytedance.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Thread-Topic: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Thread-Index: AQHYYGfJIkLldEFis0GWr3Sle9+GwK0Rltzw
Date:   Fri, 6 May 2022 09:34:39 +0000
Message-ID: <ad61b1ae4bd145eaa18fc28696e9502a@huawei.com>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
 <20220505092408.53692-6-pizhenwei@bytedance.com>
In-Reply-To: <20220505092408.53692-6-pizhenwei@bytedance.com>
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
> From: zhenwei pi [mailto:pizhenwei@bytedance.com]
> Sent: Thursday, May 5, 2022 5:24 PM
> To: Gonglei (Arei) <arei.gonglei@huawei.com>; mst@redhat.com
> Cc: jasowang@redhat.com; herbert@gondor.apana.org.au;
> linux-kernel@vger.kernel.org; virtualization@lists.linux-foundation.org;
> linux-crypto@vger.kernel.org; helei.sig11@bytedance.com;
> pizhenwei@bytedance.com; davem@davemloft.net
> Subject: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
> 
> From: lei he <helei.sig11@bytedance.com>
> 
> Enable retry for virtio-crypto-dev, so that crypto-engine can process
> cipher-requests parallelly.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Gonglei <arei.gonglei@huawei.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
> b/drivers/crypto/virtio/virtio_crypto_core.c
> index 60490ffa3df1..f67e0d4c1b0c 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -144,7 +144,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
>  		spin_lock_init(&vi->data_vq[i].lock);
>  		vi->data_vq[i].vq = vqs[i];
>  		/* Initialize crypto engine */
> -		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
> +		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true,
> NULL, 1,
> +						virtqueue_get_vring_size(vqs[i]));

Here the '1' can be 'true' too.

Sure, you can add

Reviewed-by: Gonglei <arei.gonglei@huawei.com>

Regards,
-Gonglei

>  		if (!vi->data_vq[i].engine) {
>  			ret = -ENOMEM;
>  			goto err_engine;
> --
> 2.20.1

