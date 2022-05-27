Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB7EC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 10:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350613AbiE0KaN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 06:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350789AbiE0K3w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 06:29:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A5F6129EE7
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653647390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwZPFqIRJiz/mjivgVRtjcs5bLzTBRhho+OpN7zzsp8=;
        b=USHyu2VNzjzRI0VSg0YZMSdr4mqsR/IhZ9QUv/bMC0wXqEq+crfLM+Wfwq/c1dp3mf5dC4
        DvmWU5egMsrBxW4HoI58UTs71Y1bQ/HomhLdSYEHLJLzXgkMvQKo3bbq7kDVxBvPmA97Xg
        VYqcRs1vhYnbUMuWST5F50pJv48aiC8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-RY5GnNj3NkiC3oz1VrmNbQ-1; Fri, 27 May 2022 06:29:48 -0400
X-MC-Unique: RY5GnNj3NkiC3oz1VrmNbQ-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so2236660wmr.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LwZPFqIRJiz/mjivgVRtjcs5bLzTBRhho+OpN7zzsp8=;
        b=P78dibj3y6Dx0qqAE+edGec1TftxzrEwtKx058liinY+zQl/XJOtqmsAo+btQXmHzM
         c9rX3xKCFf1SOO+Aoghpdu9vMGIQ2KhrfF82+tij1u7u/lO910ZNHx/6PxqmJT0Yg+T6
         Xlp3XUGY9hk76U2/ycVZ42N0DGrNyb/VyJ+6sqo75nwMm+hcTiliZ8ZMbu3F4Xc/VSGP
         D216EBiJiCOmsJRMK2i72bwTg4otq3TJfrWEaAVRtDmHoJDU2JIPmG8zAWZfFiZ88UCr
         MlFXpUoy/5WMxd+GQKZUM9TMXiyFgufs//jMONLpLvUlXKdoSwFUmHEfMD6TgBqXRloo
         VZ3g==
X-Gm-Message-State: AOAM532+kbw/A/CdZH/15Fwe6/ZVDpxx79rGqfPzuJmUqTf1QkTlBpO5
        MJnRXCwNBVhQeKxMPxNGPmsuZodAaLM7jIIuLwutIr8+duWWEfIEhnT64ES6byAU9VFOI25Ymml
        6oBn+CbXIGnr7fX1a8YXy1hUY
X-Received: by 2002:a05:600c:268a:b0:397:48d4:f6ad with SMTP id 10-20020a05600c268a00b0039748d4f6admr6433896wmt.134.1653647387632;
        Fri, 27 May 2022 03:29:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIfPwi/cxkq5NvC1Uj/iwugQqN4hK/nrAnna0hSd9oRlJyVgf6OS4vhXpx6o3Vxd5nu2q/BA==
X-Received: by 2002:a05:600c:268a:b0:397:48d4:f6ad with SMTP id 10-20020a05600c268a00b0039748d4f6admr6433879wmt.134.1653647387417;
        Fri, 27 May 2022 03:29:47 -0700 (PDT)
Received: from redhat.com ([2.55.130.213])
        by smtp.gmail.com with ESMTPSA id n1-20020adfe341000000b0020e68dd2598sm1351811wrj.97.2022.05.27.03.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:29:46 -0700 (PDT)
Date:   Fri, 27 May 2022 06:29:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     keliu <liuke94@huawei.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, minyard@acm.org,
        sudipm.mukherjee@gmail.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, lvivier@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: char: Directly use ida_alloc()/free()
Message-ID: <20220527062822-mutt-send-email-mst@kernel.org>
References: <20220527074422.2475104-1-liuke94@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527074422.2475104-1-liuke94@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 27, 2022 at 07:44:22AM +0000, keliu wrote:
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94@huawei.com>


virtio bits

Acked-by: Michael S. Tsirkin <mst@redhat.com>


pls cc people that commented on a similar patch in the past though.

Thanks!

> ---
>  drivers/char/hw_random/virtio-rng.c | 6 +++---
>  drivers/char/ipmi/ipmi_msghandler.c | 4 ++--
>  drivers/char/ppdev.c                | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index e856df7e285c..0ee602963c50 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -135,7 +135,7 @@ static int probe_common(struct virtio_device *vdev)
>  	if (!vi)
>  		return -ENOMEM;
>  
> -	vi->index = index = ida_simple_get(&rng_index_ida, 0, 0, GFP_KERNEL);
> +	vi->index = index = ida_alloc(&rng_index_ida, GFP_KERNEL);
>  	if (index < 0) {
>  		err = index;
>  		goto err_ida;
> @@ -165,7 +165,7 @@ static int probe_common(struct virtio_device *vdev)
>  	return 0;
>  
>  err_find:
> -	ida_simple_remove(&rng_index_ida, index);
> +	ida_free(&rng_index_ida, index);
>  err_ida:
>  	kfree(vi);
>  	return err;
> @@ -183,7 +183,7 @@ static void remove_common(struct virtio_device *vdev)
>  		hwrng_unregister(&vi->hwrng);
>  	virtio_reset_device(vdev);
>  	vdev->config->del_vqs(vdev);
> -	ida_simple_remove(&rng_index_ida, vi->index);
> +	ida_free(&rng_index_ida, vi->index);
>  	kfree(vi);
>  }
>  
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index f1827257ef0e..c1584ed24a6b 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -3018,7 +3018,7 @@ static void cleanup_bmc_work(struct work_struct *work)
>  	int id = bmc->pdev.id; /* Unregister overwrites id */
>  
>  	platform_device_unregister(&bmc->pdev);
> -	ida_simple_remove(&ipmi_bmc_ida, id);
> +	ida_free(&ipmi_bmc_ida, id);
>  }
>  
>  static void
> @@ -3134,7 +3134,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
>  
>  		bmc->pdev.name = "ipmi_bmc";
>  
> -		rv = ida_simple_get(&ipmi_bmc_ida, 0, 0, GFP_KERNEL);
> +		rv = ida_alloc(&ipmi_bmc_ida, GFP_KERNEL);
>  		if (rv < 0) {
>  			kfree(bmc);
>  			goto out;
> diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
> index 38b46c7d1737..f6024d97fe70 100644
> --- a/drivers/char/ppdev.c
> +++ b/drivers/char/ppdev.c
> @@ -299,7 +299,7 @@ static int register_device(int minor, struct pp_struct *pp)
>  		goto err;
>  	}
>  
> -	index = ida_simple_get(&ida_index, 0, 0, GFP_KERNEL);
> +	index = ida_alloc(&ida_index, GFP_KERNEL);
>  	memset(&ppdev_cb, 0, sizeof(ppdev_cb));
>  	ppdev_cb.irq_func = pp_irq;
>  	ppdev_cb.flags = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
> @@ -310,7 +310,7 @@ static int register_device(int minor, struct pp_struct *pp)
>  	if (!pdev) {
>  		pr_warn("%s: failed to register device!\n", name);
>  		rc = -ENXIO;
> -		ida_simple_remove(&ida_index, index);
> +		ida_free(&ida_index, index);
>  		goto err;
>  	}
>  
> @@ -750,7 +750,7 @@ static int pp_release(struct inode *inode, struct file *file)
>  
>  	if (pp->pdev) {
>  		parport_unregister_device(pp->pdev);
> -		ida_simple_remove(&ida_index, pp->index);
> +		ida_free(&ida_index, pp->index);
>  		pp->pdev = NULL;
>  		pr_debug(CHRDEV "%x: unregistered pardevice\n", minor);
>  	}
> -- 
> 2.25.1

