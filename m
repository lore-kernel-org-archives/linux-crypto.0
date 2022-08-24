Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F596C00140
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 08:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiHXIiK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 04:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiHXIiI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 04:38:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E8869F4A
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 01:38:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso821441pjr.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 01:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=+N+UE2X7qHP/k3D28KNJuWxXPnW1fj++zF37MMUkZvs=;
        b=l2mLLuW96AUMrOkw1NO9NyPlFA+5vidq2XHQ1XGYHXAt58pkEkSdmTrVB0bq+Ij/Dd
         NFPq5Cq03M7jUOl1bFfiHiNld5AxAk4ZmpQne5kyZRDzmeoODLxiYLskI1xUM3NFwrpC
         LvtoN33HZeFUOKjFrOmeNvlTVuG0HLWbjBnip//tNSPxhZWyC7fYydTJ2bfH1WCXRii4
         dz/xsMiJr7y/pEWxjKOuNiFVwOtVe7tyS+HkhpGhwzvj57iP6pT7n68x5VmhGp+EZvDn
         bk2xuQN/peZCsxoaMfNN/MChuqiB6M+yXj+4NGzNnLTWFIVoQHOpHTY3HVyQ4X+jecC5
         om1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=+N+UE2X7qHP/k3D28KNJuWxXPnW1fj++zF37MMUkZvs=;
        b=w0JGwQrAbPPb53O5RXrWfKSwZifNnruJ40DAceGi4w3fggq0TsZmkDwvovxruk6bLH
         yxQqGBMWD/JaJ8IB/seTfSRnNd7buSPDoTgAWCOVW0SGn4jE54kaBhPx0f2dvDSwUMV7
         2cFjQM8ueM7XLzwYpUzFrnbk/FP/YxMnLA3V0F40nvYqcMCf6Ln1ALmEEQmWqjx4mkhW
         hncPE5TeynuL1qxQ+EAsJoKJ2TYKRSuPCSk6Yhw9hATR8WqNdN2vl+2qtvS5dK8DlZxC
         VkzXadk67xHOnYZ5RoexvyH10d01XViz8dvJU+XKWi+DmDh0GOirwZ1ijWN6i/aJRvWn
         /4+g==
X-Gm-Message-State: ACgBeo25QGrxpUMrSuNztXeko8m/bTdzK5NEVJHakKnMLIJFLRykUHoc
        nxmOV4oDw3INz2uHDZChplsntw==
X-Google-Smtp-Source: AA6agR792mm220wXVOY8iINInSkP7OO47CDQTqD6ox3ALgicSewvh8sQM/dCrRGc3T1Cpg9MYRL/XA==
X-Received: by 2002:a17:902:aa03:b0:172:9b18:ebb1 with SMTP id be3-20020a170902aa0300b001729b18ebb1mr26730429plb.24.1661330286451;
        Wed, 24 Aug 2022 01:38:06 -0700 (PDT)
Received: from [10.76.43.148] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id lp12-20020a17090b4a8c00b001fa8b909ef0sm843210pjb.7.2022.08.24.01.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 01:38:06 -0700 (PDT)
Message-ID: <95f6eec3-62f7-46d8-9bb1-664fb9e36534@bytedance.com>
Date:   Wed, 24 Aug 2022 16:38:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Cc:     helei.sig11@bytedance.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com
Subject: PING: [PATCH v2] virtio-crypto: fix memory-leak
To:     mst@redhat.com, herbert@gondor.apana.org.au,
        arei.gonglei@huawei.com
References: <20220816094336.27806-1-helei.sig11@bytedance.com>
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <20220816094336.27806-1-helei.sig11@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/8/16 下午5:43, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> Fix memory-leak for virtio-crypto akcipher request, this problem is
> introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
> The leak can be reproduced and tested with the following script
> inside virtual machine:
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gonglei <arei.gonglei@huawei.com>
> ---
>   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 2a60d0525cde..168195672e2e 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -56,6 +56,10 @@ static void virtio_crypto_akcipher_finalize_req(
>   	struct virtio_crypto_akcipher_request *vc_akcipher_req,
>   	struct akcipher_request *req, int err)
>   {
> +	kfree(vc_akcipher_req->src_buf);
> +	kfree(vc_akcipher_req->dst_buf);
> +	vc_akcipher_req->src_buf = NULL;
> +	vc_akcipher_req->dst_buf = NULL;
>   	virtcrypto_clear_request(&vc_akcipher_req->base);
>   
>   	crypto_finalize_akcipher_request(vc_akcipher_req->base.dataq->engine, req, err);
> 
> base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868

PING.

Best regards,
Lei He
--
helei.sig11@bytedance.com

