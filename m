Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855E5C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 09:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390497AbiEFJbr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 05:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390489AbiEFJbr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 05:31:47 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5CD64BC4;
        Fri,  6 May 2022 02:28:04 -0700 (PDT)
Received: from kwepemi500011.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KvlZS3bvfz1JBmX;
        Fri,  6 May 2022 17:26:56 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi500011.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 17:28:01 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Fri, 6 May 2022 17:28:01 +0800
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
Subject: RE: [PATCH v5 4/5] virtio-crypto: adjust dst_len at ops callback
Thread-Topic: [PATCH v5 4/5] virtio-crypto: adjust dst_len at ops callback
Thread-Index: AQHYYGJ6/Z4WULmv0kCZX8LJqZ7zXa0Rlkkg
Date:   Fri, 6 May 2022 09:28:01 +0000
Message-ID: <f2addf5602254e2c81b52c30cb2c8180@huawei.com>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
 <20220505092408.53692-5-pizhenwei@bytedance.com>
In-Reply-To: <20220505092408.53692-5-pizhenwei@bytedance.com>
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
> Subject: [PATCH v5 4/5] virtio-crypto: adjust dst_len at ops callback
> 
> From: lei he <helei.sig11@bytedance.com>
> 
> For some akcipher operations(eg, decryption of pkcs1pad(rsa)), the length of
> returned result maybe less than akcipher_req->dst_len, we need to recalculate
> the actual dst_len through the virt-queue protocol.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Gonglei <arei.gonglei@huawei.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gonglei <arei.gonglei@huawei.com>

Regards,
-Gonglei


> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 382ccec9ab12..2a60d0525cde 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -90,9 +90,12 @@ static void
> virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>  	}
> 
>  	akcipher_req = vc_akcipher_req->akcipher_req;
> -	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY)
> +	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
> +		/* actuall length maybe less than dst buffer */
> +		akcipher_req->dst_len = len - sizeof(vc_req->status);
>  		sg_copy_from_buffer(akcipher_req->dst,
> sg_nents(akcipher_req->dst),
>  				    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
> +	}
>  	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req,
> error);  }
> 
> --
> 2.20.1

