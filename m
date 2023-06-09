Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D533DC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 15:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbjFIP6P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbjFIP6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 11:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4F330CD
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 08:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686326246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+y+aveIxA7jLi8Qb8e+Oc4pjTAYvwXvNOc23v+nQ9Dc=;
        b=UZj0ROgVvPHnmnyLZgigkjuKHhc+vSbNwosgy/VFasMbhf17pINkve2uCRrhp/dxiD/GxF
        aGCkz7x884iWFK4Sc0JOF1hY4hFgKFNZiZC7Rwp3PmvP3wQJc9mssZWdu2YxrypANn+sFQ
        akEqcTbEqkT2Pto/zT6i8rDkxjggXlo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-3-aZQIPVMiWgIXuElRPa0g-1; Fri, 09 Jun 2023 11:57:22 -0400
X-MC-Unique: 3-aZQIPVMiWgIXuElRPa0g-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f59c4df0f9so1411441e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 08:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686326240; x=1688918240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+y+aveIxA7jLi8Qb8e+Oc4pjTAYvwXvNOc23v+nQ9Dc=;
        b=cQ8ujLLI0iJo0sto6OPuWEAzDy69HBHpUYHm+yD7mVGIW9ZaNswtUJRvf+M+5XkajW
         4Bce8bbQtIZuamwqU1tXqMwQm35lf1ScLZcHTkkTs9StGD67x1KT9eVjZqu9kdvJjmqt
         zjLE+5WqgclmMcVHmmcy5lrbutHPMhtWW6D8AJ7VyZtWtJ/1fGO+JgINpDo3+GSdYWg6
         oYROoW7mNdtOHH6QO02Qmt1khErP++hgcVGXa1uY/bM6pQT5kSiwZZ37br+9xHvajjv/
         Uh/ncerQlNhtchk29zigUXQ8lScDQJD4kx3XV334RsyzluYprsGUXdJ1Cu8t7pcgSpld
         Zh3w==
X-Gm-Message-State: AC+VfDwZGdqfx5ju7GgHnhb8Hb4Etqp9daL3bDVTbBnKNePK8QhdkwSo
        bXMN42dLzRzLCX009JOFdg6z7vRA5N0i2GfDns/GMkZEBsahnxmW+0qVzgzG7sB/bd9HQJFtSht
        ksh/WtInUwo2q8Fj06lWcSya0LvfovZ0w
X-Received: by 2002:a19:f24f:0:b0:4f5:f736:cb9f with SMTP id d15-20020a19f24f000000b004f5f736cb9fmr989541lfk.67.1686326240277;
        Fri, 09 Jun 2023 08:57:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/T5/nSOeffmIMMxsU83CU4sVcwwjp3dmRwDnOHHwbrP+YSlBuBwmQ6CY/6oW8GCAvWshWtA==
X-Received: by 2002:a19:f24f:0:b0:4f5:f736:cb9f with SMTP id d15-20020a19f24f000000b004f5f736cb9fmr989534lfk.67.1686326239964;
        Fri, 09 Jun 2023 08:57:19 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7403:2800:22a6:7656:500:4dab])
        by smtp.gmail.com with ESMTPSA id m7-20020a7bca47000000b003f80b96097esm415596wml.31.2023.06.09.08.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:57:19 -0700 (PDT)
Date:   Fri, 9 Jun 2023 11:57:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
Message-ID: <20230609115617-mutt-send-email-mst@kernel.org>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
> From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
> 
> Cpu stall issue may happen if device is configured with multi queues
> and large queue depth, so fix it.

What does "may happen" imply exactly?
was this observed?

> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index 1198bd306365..94849fa3bd74 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -480,6 +480,7 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
>  			kfree(vc_req->req_data);
>  			kfree(vc_req->sgs);
>  		}
> +		cond_resched();
>  	}
>  }
>  
> -- 
> 2.17.1

