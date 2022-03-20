Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F1FC4321E
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Mar 2022 12:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245017AbiCTMGC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Mar 2022 08:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245004AbiCTMF7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Mar 2022 08:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 217FE377F0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 05:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647777876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pfT/FhM65DQKRvRUzD2KeWz3oDwCgvpb4tTTJtJbjgQ=;
        b=hxYH+u0Y95bu6gGKTNOxNL/fSfmFM7hcefZ5NxV2AO1sZLCSjq5yAlyrFlaDYsU0jX9u0g
        qvP9Q6qLW1Y/IXXj1WaJMoQyQl0NY60eU8E4rSENeMd12VTiWzPTNQj8IB50CuW/4ZlvJj
        F6EezC97dipL3/+c14kNr+Q9xmfpWTo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-HLI4LEJhN7GTpnOqE50h6g-1; Sun, 20 Mar 2022 08:04:35 -0400
X-MC-Unique: HLI4LEJhN7GTpnOqE50h6g-1
Received: by mail-ej1-f71.google.com with SMTP id de52-20020a1709069bf400b006dffb966922so396464ejc.2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 05:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pfT/FhM65DQKRvRUzD2KeWz3oDwCgvpb4tTTJtJbjgQ=;
        b=mHYkcMqRflNZ5gaPdFWI5smnrsmZCSNhL3d5lmJBFqVIz457dji3PQBMiZl9txfDCk
         Vn2Ov/h/1z7faCtBnu3oAUub2L2uP9vG4+hOyrvmLH8dyqFxjPeTObOKvBtlxp/dBgfz
         adaya7JOO5ulmyMdajrRx0qtV+b7toxEwCdMudW/OIV0VloqHprGawKYuJYT/mJKp0e2
         4LlAyUFeXh4XGeZXPgZfk+8pq8HcAr/D4fGDZFdoMiq61SNAvOONVXT4WjvBzHeNaGaq
         m9TucvTBGt3/sFwzJV/aEL6G12STxkWDgBON54v8LkaQS1GE1vrtHXJVY0GQ5a3lGpkP
         u/1w==
X-Gm-Message-State: AOAM532D5OAodOCBAuwZpEsnzel5iH5sx9iekivSfgk6bgiktRYwW6U9
        6daXVF/wKk1uw1GWX7Kiztydq2Cqe6Wr/GrPoctSOcMntrijxpinBbNzKY4zj/WDG7Mq27jmmnt
        UACRovXqtmCHAZF7B5bf5CRPy
X-Received: by 2002:a17:907:9706:b0:6db:566a:4408 with SMTP id jg6-20020a170907970600b006db566a4408mr16470493ejc.374.1647777873724;
        Sun, 20 Mar 2022 05:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx89ppvPKr6BvvjBnbbPf3CkRgoqozB02ZyScIP5D34LakZNdud2DzXyDuKhCsgHIy5z//Zgg==
X-Received: by 2002:a17:907:9706:b0:6db:566a:4408 with SMTP id jg6-20020a170907970600b006db566a4408mr16470444ejc.374.1647777873440;
        Sun, 20 Mar 2022 05:04:33 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id gb3-20020a170907960300b006dfafbb4ba4sm3340411ejc.83.2022.03.20.05.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 05:04:32 -0700 (PDT)
Date:   Sun, 20 Mar 2022 08:04:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 5/9] virtio-scsi: eliminate anonymous module_init &
 module_exit
Message-ID: <20220320080414-mutt-send-email-mst@kernel.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-6-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316192010.19001-6-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 16, 2022 at 12:20:06PM -0700, Randy Dunlap wrote:
> Eliminate anonymous module_init() and module_exit(), which can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> Example 1: (System.map)
>  ffffffff832fc78c t init
>  ffffffff832fc79e t init
>  ffffffff832fc8f8 t init
> 
> Example 2: (initcall_debug log)
>  calling  init+0x0/0x12 @ 1
>  initcall init+0x0/0x12 returned 0 after 15 usecs
>  calling  init+0x0/0x60 @ 1
>  initcall init+0x0/0x60 returned 0 after 2 usecs
>  calling  init+0x0/0x9a @ 1
>  initcall init+0x0/0x9a returned 0 after 74 usecs
> 
> Fixes: 4fe74b1cb051 ("[SCSI] virtio-scsi: SCSI driver for QEMU based virtual machines")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org



If this is done tree-wide, it's ok to do it for virtio too.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

No real opinion on whether it's a good idea.


> ---
>  drivers/scsi/virtio_scsi.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-517-rc8.orig/drivers/scsi/virtio_scsi.c
> +++ lnx-517-rc8/drivers/scsi/virtio_scsi.c
> @@ -988,7 +988,7 @@ static struct virtio_driver virtio_scsi_
>  	.remove = virtscsi_remove,
>  };
>  
> -static int __init init(void)
> +static int __init virtio_scsi_init(void)
>  {
>  	int ret = -ENOMEM;
>  
> @@ -1020,14 +1020,14 @@ error:
>  	return ret;
>  }
>  
> -static void __exit fini(void)
> +static void __exit virtio_scsi_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_scsi_driver);
>  	mempool_destroy(virtscsi_cmd_pool);
>  	kmem_cache_destroy(virtscsi_cmd_cache);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_scsi_init);
> +module_exit(virtio_scsi_fini);
>  
>  MODULE_DEVICE_TABLE(virtio, id_table);
>  MODULE_DESCRIPTION("Virtio SCSI HBA driver");

