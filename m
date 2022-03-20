Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A04C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Mar 2022 12:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245029AbiCTMG1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Mar 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiCTMG0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Mar 2022 08:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 226EB37A9E
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647777901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dluyFNWHj0wdqGZD9WiZi8hb8qI80pWjkbX+xynrT7U=;
        b=Qj3nUJCKv0aRAzzU185bNxKaIr55ILXROrj5ddr/QbgaKYC9fKHx82LbU7lbF2tkTvU8ch
        /xKW9/+Y77BTuzY5aH4nf2/hJ6y5XpNEwFCov6OTOmhxrTWl1NWWiAMujstRc3UHkl7LJP
        ZJZJAlr4QI6Uanv00o/Srf5tM624064=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-ybrT6qHKO7mML1HOAmi_aw-1; Sun, 20 Mar 2022 08:04:59 -0400
X-MC-Unique: ybrT6qHKO7mML1HOAmi_aw-1
Received: by mail-ej1-f72.google.com with SMTP id og28-20020a1709071ddc00b006dfb92d8e3fso2268529ejc.14
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 05:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dluyFNWHj0wdqGZD9WiZi8hb8qI80pWjkbX+xynrT7U=;
        b=XVr+jfDsE7iiJJQVvJ04Tm/XcIttR1gvJf7N4KrPNA7O6uddsvgLzGQW5ASAlka+q2
         RWjV+2Fg4tvlb+6tJaMr/6+alB+UAoStJVQYu99NOIcZsdmw0wky44gEMLJP0cH2zPgR
         LVuC/+PATY0u+NY0Py+Joyd8VZogoJeRkHQCNLcOWmWUHYCba+iUaJEJQc3U5XiJanmR
         mYeeu8svnU7gnIWaEL5AwrEuNJgRaVnwdeo4D8Jad9LfNVY9k3T3b5OLITX3XS/ckzic
         P+toBZigwTNdZ9TMwY0BNDrzkGre5h7EUCUOK8aguK+kU7iBdX3nPhSYaJRclzh0liZx
         paFw==
X-Gm-Message-State: AOAM531Pp1KKZaVPpyQkfajcUb/FLqrmFb75/ktMxB67xtBAXGNpyh6U
        koQPsIuoxgvUKEYTtN5icm/ZBd5Ab1C6W6ml4/AYXl/ufRjmfmlF/rmP9I5zsokm0DQNxgeRSHK
        s+2oN2dCJpX7elQQVmJgiQSxG
X-Received: by 2002:a05:6402:40c5:b0:418:e73c:a1ab with SMTP id z5-20020a05640240c500b00418e73ca1abmr18517076edb.52.1647777898149;
        Sun, 20 Mar 2022 05:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfAQhzmlNy6q9yY+EnFX+2g1gYETe+axmQh3kzhVOc32at9/0TqUx+j50nzMAK4FS++1BWlA==
X-Received: by 2002:a05:6402:40c5:b0:418:e73c:a1ab with SMTP id z5-20020a05640240c500b00418e73ca1abmr18517008edb.52.1647777897820;
        Sun, 20 Mar 2022 05:04:57 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090600db00b006df6b34d9b8sm5854831eji.211.2022.03.20.05.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 05:04:57 -0700 (PDT)
Date:   Sun, 20 Mar 2022 08:04:48 -0400
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
Subject: Re: [PATCH 2/9] virtio_console: eliminate anonymous module_init &
 module_exit
Message-ID: <20220320080438-mutt-send-email-mst@kernel.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-3-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316192010.19001-3-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 16, 2022 at 12:20:03PM -0700, Randy Dunlap wrote:
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
> Fixes: 31610434bc35 ("Virtio console driver")
> Fixes: 7177876fea83 ("virtio: console: Add ability to remove module")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Amit Shah <amit@kernel.org>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


If this is done tree-wide, it's ok to do it for virtio too.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

No real opinion on whether it's a good idea.


> ---
>  drivers/char/virtio_console.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-517-rc8.orig/drivers/char/virtio_console.c
> +++ lnx-517-rc8/drivers/char/virtio_console.c
> @@ -2245,7 +2245,7 @@ static struct virtio_driver virtio_rproc
>  	.remove =	virtcons_remove,
>  };
>  
> -static int __init init(void)
> +static int __init virtio_console_init(void)
>  {
>  	int err;
>  
> @@ -2280,7 +2280,7 @@ free:
>  	return err;
>  }
>  
> -static void __exit fini(void)
> +static void __exit virtio_console_fini(void)
>  {
>  	reclaim_dma_bufs();
>  
> @@ -2290,8 +2290,8 @@ static void __exit fini(void)
>  	class_destroy(pdrvdata.class);
>  	debugfs_remove_recursive(pdrvdata.debugfs_dir);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_console_init);
> +module_exit(virtio_console_fini);
>  
>  MODULE_DESCRIPTION("Virtio console driver");
>  MODULE_LICENSE("GPL");

