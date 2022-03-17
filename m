Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BEEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 03:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiCQD2E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiCQD14 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 23:27:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83070344C0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 20:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647487599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdUR6nzOC/8O0v+PINEYQA8hLCMnHSUIAPMWwkW08rs=;
        b=Wyfm3m60PtMDs9J980olZsBlkeVIRdwuebiXZVqR/xCw2kGY60wv6+aE80qaAaiMFwEGDM
        7YRqS4nHgBrBPJ+pBHMKwcrRNiUoG52KtSnMdK0lsMRTr0fNEcoYGSXhHXgyBofffJUzFa
        tIGbVspPUaqcrKVF86iqziLojiuccKA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-KbmQmiozOc-iWy4AqivSqQ-1; Wed, 16 Mar 2022 23:26:38 -0400
X-MC-Unique: KbmQmiozOc-iWy4AqivSqQ-1
Received: by mail-lf1-f71.google.com with SMTP id x23-20020ac25dd7000000b004492a3f2ecdso738330lfq.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 20:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdUR6nzOC/8O0v+PINEYQA8hLCMnHSUIAPMWwkW08rs=;
        b=J2renV5tyLZbeT2nja15n6KwBoumkc07vg4cWg4NpbC27OQeR49xxPnL1jHMhtdG9f
         jpgon9eFrdxfta9B9v6jtfzYlRx2WXzVXX1E8vuc28lDmzTR5EaKLnLJmlZOc5g9zCAS
         BeUBrg1dOEaCgJWGUoHEllBaV+WKi1Bio/h//hFGgkO1rsb0ICqQIUXxbL94vR7uzC0R
         9+Ov2pdtJr2Jtn3/tB1m0vLn6u83AQ2xVK7OqyQI7yq931In+ui+ak/4vOPAyjtks/Yp
         wnG5kw0QngyZ8A6x9FYzJQKBiMiWFvEFkjhLI3E4KiwFrxe5qCNyenmc/ZN3JzGyV+Dj
         xEbg==
X-Gm-Message-State: AOAM533G38bW6ca/m2iElpCB2M+gRTpT7aWlfTTDmFJ5Gm68tBGvk7RM
        VXBVjo4rkvZ7kXxsHUSQXKplDG+VwVLa0EoH3Aei8gOoUFRDtJHW88vBpjx8tZcukm19szUBypp
        D+bGSsIwVKLfzlcrNIqIbBFAXPz5tykrjFxWWk+Xb
X-Received: by 2002:a2e:a490:0:b0:248:8f0:e4ee with SMTP id h16-20020a2ea490000000b0024808f0e4eemr1585875lji.97.1647487596333;
        Wed, 16 Mar 2022 20:26:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxodJS4+oPuUw6/FJlLdS1DOlRDugHlSvT6drTv1PuTs0XvDj5DTLTyLGxZOhq4kq4IHrWqpfNVV0chS1q08S4=
X-Received: by 2002:a2e:a490:0:b0:248:8f0:e4ee with SMTP id
 h16-20020a2ea490000000b0024808f0e4eemr1585821lji.97.1647487596075; Wed, 16
 Mar 2022 20:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220316192010.19001-1-rdunlap@infradead.org> <20220316192010.19001-2-rdunlap@infradead.org>
In-Reply-To: <20220316192010.19001-2-rdunlap@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Mar 2022 11:26:24 +0800
Message-ID: <CACGkMEtg6uCNfP-ncXEEWn+EeGLe1-KxbYu45g1-7vR_JHr7hg@mail.gmail.com>
Subject: Re: [PATCH 1/9] virtio_blk: eliminate anonymous module_init & module_exit
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
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
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 17, 2022 at 3:25 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
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
> Fixes: e467cde23818 ("Block driver using virtio.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

>  drivers/block/virtio_blk.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- lnx-517-rc8.orig/drivers/block/virtio_blk.c
> +++ lnx-517-rc8/drivers/block/virtio_blk.c
> @@ -1058,7 +1058,7 @@ static struct virtio_driver virtio_blk =
>  #endif
>  };
>
> -static int __init init(void)
> +static int __init virtio_blk_init(void)
>  {
>         int error;
>
> @@ -1084,14 +1084,14 @@ out_destroy_workqueue:
>         return error;
>  }
>
> -static void __exit fini(void)
> +static void __exit virtio_blk_fini(void)
>  {
>         unregister_virtio_driver(&virtio_blk);
>         unregister_blkdev(major, "virtblk");
>         destroy_workqueue(virtblk_wq);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_blk_init);
> +module_exit(virtio_blk_fini);
>
>  MODULE_DEVICE_TABLE(virtio, id_table);
>  MODULE_DESCRIPTION("Virtio block driver");
>

