Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D03C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Nov 2022 01:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiKOBK7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Nov 2022 20:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKOBK6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2022 20:10:58 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6279CF5BB
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 17:10:55 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so12726465pfb.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 17:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZoxcZLmzsq83+rHNWuzABJOjX7MklD2wIzx4GvWNeCY=;
        b=iyzZeB2HIwzW+rGfh2nFI825HJA5s0hyO6y42jBoY4eYD7JAzLEiLIkC3NSVG78BKc
         mQDssF8RtvFCb/94yM35OxP/RSkKEbFVbHiZ5dm12cGVH6D1/2beJ4aIRJWivDKN0UMJ
         A/ovm6OMDHgEYtFRVJ9zjFLQi5oFATo1c9dQX8fGpnRXsgfxVx2fihRBk8w3xZwCN2YD
         q2BOce+mDlq76+h6kfh4/NwAmgBcGMUFzyXQHzaljFRlH2XwDgg9BRkM4QiM5TR+Y262
         TD1V6CO87waIBRLqhxMozbhWNrV8oEG8ndSF16TyCrwcPLt11GPyftBFvLk5f52TACV1
         9OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoxcZLmzsq83+rHNWuzABJOjX7MklD2wIzx4GvWNeCY=;
        b=LHnU8n7t4aRh8QURAezO3DQHwMGNsUv6g/Hap+VRpQTL6m/wsajCkvgurT6Yg1asXx
         zlxyhayjaEEiemkOVgKlX6ONYOQWXoMj0XXeu8L/7Z0AC+B2tnQhsDiwMa2YoDsVIx8d
         WKey2Iwg3Aeh1UUGvSY4GPNmh5Mq1S8E3kzt41x2iP15rTxCWHSzY1OXYs45samtgc1d
         zHikEj7JvEWmKalIPjSvseOqgT/8isWV5y2JYQ/Yn6oKzhZd5KxHeh0LA8lj3dvIcUph
         gGZMqkl5JLOfA4QuvnSpkxVWumy2N3R9mNX197mATkhmZGZ0tMhGkrG8vhjlU/lzFp1+
         qvbw==
X-Gm-Message-State: ANoB5pl/lo0mfObKSEZDD4+GIQIZr84T+yyOsFwo3IOJSmTaMimsjdrv
        DxweEypQYHawQlTVdsVOcomGTg==
X-Google-Smtp-Source: AA0mqf6zb5XJbo4C55nIh4hVOYh8QQgkeOw7vEH2RSrP44ZAkXBsW4BJ0KfNo6XrDl9r1B+8HiqGkg==
X-Received: by 2002:a63:d457:0:b0:476:837b:7a08 with SMTP id i23-20020a63d457000000b00476837b7a08mr6159794pgj.430.1668474654884;
        Mon, 14 Nov 2022 17:10:54 -0800 (PST)
Received: from [10.3.43.196] ([63.216.146.186])
        by smtp.gmail.com with ESMTPSA id jm5-20020a17090304c500b00186b758c9fasm8201015plb.33.2022.11.14.17.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 17:10:54 -0800 (PST)
Message-ID: <0cc9f344-44ff-284f-391e-dcf756d74471@bytedance.com>
Date:   Tue, 15 Nov 2022 09:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] virtio-crypto: fix memory leak in
 virtio_crypto_alg_skcipher_close_session()
To:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
Content-Language: en-US
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks good to me, thanks!

Acked-by: zhenwei pi<pizhenwei@bytedance.com>

On 11/14/22 19:07, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> 'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
> and should be freed in the invalid ctrl_status->status error handling
> case. Otherwise there is a memory leak.
> 
> Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index e553ccadbcbc..e5876286828b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
>   		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
>   			ctrl_status->status, destroy_session->session_id);
>   
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto out;
>   	}
>   
>   	err = 0;

-- 
zhenwei pi
