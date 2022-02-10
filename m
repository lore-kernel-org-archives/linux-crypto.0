Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FA6C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 07:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbiBJHW3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:22:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBJHW2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 02:22:28 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A970C56;
        Wed,  9 Feb 2022 23:22:28 -0800 (PST)
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JvSl73RbrzZfRY;
        Thu, 10 Feb 2022 15:18:11 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:22:25 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2308.021;
 Thu, 10 Feb 2022 15:22:25 +0800
From:   "Gonglei (Arei)" <arei.gonglei@huawei.com>
To:     zhenwei pi <pizhenwei@bytedance.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>
Subject: RE: [PATCH 1/3] virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
Thread-Topic: [PATCH 1/3] virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
Thread-Index: AQHYDm44Bq+fl173Z0edEmaWVexeY6yMgIDQ
Date:   Thu, 10 Feb 2022 07:22:24 +0000
Message-ID: <fac2cfd89f3f4fff9e5c5d29c8c4ed8a@huawei.com>
References: <20220121022438.1042547-1-pizhenwei@bytedance.com>
 <20220121022438.1042547-2-pizhenwei@bytedance.com>
In-Reply-To: <20220121022438.1042547-2-pizhenwei@bytedance.com>
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
> Sent: Friday, January 21, 2022 10:25 AM
> To: mst@redhat.com; Gonglei (Arei) <arei.gonglei@huawei.com>
> Cc: jasowang@redhat.com; virtualization@lists.linux-foundation.org;
> linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> helei.sig11@bytedance.com; zhenwei pi <pizhenwei@bytedance.com>
> Subject: [PATCH 1/3] virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
> 
> Base on the lastest virtio crypto spec, define VIRTIO_CRYPTO_NOSPC.
> 
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  include/uapi/linux/virtio_crypto.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/virtio_crypto.h
> b/include/uapi/linux/virtio_crypto.h
> index a03932f10565..1166a49084b0 100644
> --- a/include/uapi/linux/virtio_crypto.h
> +++ b/include/uapi/linux/virtio_crypto.h
> @@ -408,6 +408,7 @@ struct virtio_crypto_op_data_req {
>  #define VIRTIO_CRYPTO_BADMSG    2
>  #define VIRTIO_CRYPTO_NOTSUPP   3
>  #define VIRTIO_CRYPTO_INVSESS   4 /* Invalid session id */
> +#define VIRTIO_CRYPTO_NOSPC     5 /* no free session ID */
> 
>  /* The accelerator hardware is ready */  #define
> VIRTIO_CRYPTO_S_HW_READY  (1 << 0)
> --
> 2.25.1

Reviewed-by: Gonglei <arei.gonglei@huawei.com>
