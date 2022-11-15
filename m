Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2E3C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Nov 2022 06:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiKOG3A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Nov 2022 01:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiKOG25 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2022 01:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85671EED8
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 22:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668493684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gaUjUy0cAk82v0uahWp+GaCbWFfU6R/rouT9IrYbegg=;
        b=AWsY4qtL8Op6/8DVQGPOzBzF/v1ASHZ0hNCxgdMensuBlrbyE1Hkt3hagIvyqOo2s0gRP1
        cIcZVnhbgcZwuOV+SXcPqHIfcUxpku0HjQDUdbeMB8DKQLSrSRHYpBhwck3h7zEvCsWmD7
        weFA3p485aKHe0ExqjytK4dJXKKdAU0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-30-NejiPD-6NZONaUiOxeZJ0Q-1; Tue, 15 Nov 2022 01:28:03 -0500
X-MC-Unique: NejiPD-6NZONaUiOxeZJ0Q-1
Received: by mail-oi1-f198.google.com with SMTP id be25-20020a056808219900b0035ad466a313so2793268oib.17
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 22:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gaUjUy0cAk82v0uahWp+GaCbWFfU6R/rouT9IrYbegg=;
        b=jH5bYRmZvL8HTP4DmNclAxJWxyRbBYgPHPRNZ9px4EhpQA69OfOCG5byIIGkTQ0Asz
         XvdHUnG8akTdSAQN6ave7HfhSEYdTmHdQRvI4heSUGRGMjpU+25fvVOr6QEm1WW0QbUZ
         VMut10hjG0ZOB1OoCgK0FTNdZU27/oWb1T/VUqX8aWtOAmUUi/alG9oJdbqaEoij36gB
         TqbqXUiq+5xg7A2dH8xv5DElHDWXXXVBIAHkhKpLYNf9ND+3SnTmOM3bnWM3DvmRAhQX
         BMnyVGcj6tlxlGSs6VsvBPUNX6CS55ESsT0NXf2Y5fn4bmYSa8FZbsZ7qzmU/Wt/R3KK
         qheA==
X-Gm-Message-State: ANoB5pk3JEGx6gvAOTwwO2VHKznWfbZliwhhDoqjtYWRqa1ORXlmVqqd
        67J1FMwU21Va4k52/FSA6mEJ0oSzok72hdcDooL3m/kQQdQojJPzfUoPErw2fCYCWP/ZSG7whYK
        MxviB/tUNvWLC3zGrefCB59V7wGCSX1dis4+wpD72
X-Received: by 2002:a05:6870:638b:b0:132:7b3:29ac with SMTP id t11-20020a056870638b00b0013207b329acmr20143oap.35.1668493681906;
        Mon, 14 Nov 2022 22:28:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5tUUvRnolsxfw39pTuYChdskbYVUQhRqzQkqzCLPFMem0cs5JPJwzFU6g3NP1ms1xyZbrMZ2DrwHkNEwFVECw=
X-Received: by 2002:a05:6870:638b:b0:132:7b3:29ac with SMTP id
 t11-20020a056870638b00b0013207b329acmr20136oap.35.1668493681696; Mon, 14 Nov
 2022 22:28:01 -0800 (PST)
MIME-Version: 1.0
References: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 15 Nov 2022 14:27:50 +0800
Message-ID: <CACGkMEvTnjO7eunS42WeAs4hG=zLWVmHmaRXaAvzhCy4QnCc=g@mail.gmail.com>
Subject: Re: [PATCH] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 14, 2022 at 7:26 PM Wei Yongjun <weiyongjun@huaweicloud.com> wrote:
>
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> 'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
> and should be freed in the invalid ctrl_status->status error handling
> case. Otherwise there is a memory leak.
>
> Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index e553ccadbcbc..e5876286828b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
>                 pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
>                         ctrl_status->status, destroy_session->session_id);
>
> -               return -EINVAL;
> +               err = -EINVAL;
> +               goto out;
>         }
>
>         err = 0;
> --
> 2.34.1
>

