Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141ACC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 08:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC66264FEE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 08:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhCLI4W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhCLI4F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 03:56:05 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E45AC061574;
        Fri, 12 Mar 2021 00:56:05 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id v14so8505667pgq.2;
        Fri, 12 Mar 2021 00:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uu+gybMD/XVJPkbZMHT7oLlfILaCA4WqbIpcSotrUJg=;
        b=cym5jYpkFto9sqEa97CRuQYXKSio1H313W32jPPFjGNEg2CFGa8gpWwhH0WbZrz8Xl
         rr6fpOC22/io3zqbitsgGdI9jCKvWA7pfyclGtF3OyDlnnSPwAh4yg4bg7Q7/jh3o6p+
         q4CxT3AE2I4xXAzv1KRtjfM9yKigP5RfvPYlgLrW7pHsMsOuh4TLuU+xHZdbEvEsxe89
         llVBr+7bvdUW8VxeyrFSUo7lMqs4n8+T98m1UL/+AQ1ho5p4Rz+RnzA4444zQLB+DIwc
         KHhe/W8AkQJJlGgSvtDjYTSuMB/8SraVLF9hrW9K+crLv3FGv0GE5czH/cYr4ZQx6nNe
         LMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uu+gybMD/XVJPkbZMHT7oLlfILaCA4WqbIpcSotrUJg=;
        b=Z0O8lYe0oW1WGoNDYzuK7YFI/JOzwR5iW5ZuHQqkQQbkQmF5YcOrkYsi7sZGEKljiz
         LW8I7L9O3/8bM/bgAqysL5KpDDpRNJjFGzxbxG5j68u0V9sNex+EBWOgwYCtlatvfhJ+
         27Dh1W7Rb2WfceKtV8duy5WIn9pC5piMPurwzreo1ylvvoWv9MtiLUnEYdK5hVTxX072
         ecCHyth9y7sRhkF9Et7z+1GFjYhHPXWZXMxW7rP9U7kLCQYb7TH6bW429BZzIbNRvYye
         mw2EMKLN0wUiYBxe5nG4kixG3+Uy1IVoNiofcVF4OrlyiRA5HGWQrdgEKA4RIKRH2b2W
         Kf5w==
X-Gm-Message-State: AOAM531QXxWzqs7C+qNe919T4OOg9d7VA7MYL2xop28t6zBR6gfciSIx
        p+XvREAsgzgg+vkeAiGih3U3yPXj2HtTbZHxMgs=
X-Google-Smtp-Source: ABdhPJyocBvy+MltN5FTIbg5ZRmqHfy5QX/WdF33EXbZfhqN5gxT9odmwqNeSc5JRaq8OG14xpv/lSVhOJNFamK9S3A=
X-Received: by 2002:a63:ce15:: with SMTP id y21mr10941733pgf.4.1615539364693;
 Fri, 12 Mar 2021 00:56:04 -0800 (PST)
MIME-Version: 1.0
References: <20210312074357.2384087-1-ztong0001@gmail.com> <20210312074357.2384087-3-ztong0001@gmail.com>
In-Reply-To: <20210312074357.2384087-3-ztong0001@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 12 Mar 2021 10:55:48 +0200
Message-ID: <CAHp75Vc=Y5aS8hbynHu9WxF6uy9Na+icaUunbhqGzV_FF-0R5g@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>, qat-linux@intel.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 12, 2021 at 9:50 AM Tong Zhang <ztong0001@gmail.com> wrote:
>
> ADF_STATUS_PF_RUNNING is (only) used and checked  by adf_vf2pf_shutdown()
> before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> use of vf2pf_lock will cause issue.
> To fix this issue, only set this flag if adf_dev_init() returns 0.

Makes sense, but please leave only ~2-3 (significant) lines from the
below noisy dump
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
(after making commit message neat)

> [    7.178008] ==================================================================
> [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> [    7.178800] Read of size 4 at addr 000000000000f434 by task modprobe/96
> [    7.179169]
> [    7.179257] CPU: 0 PID: 96 Comm: modprobe Not tainted 5.12.0-rc2-00338-gf78d76e72a46-dirty #86
> [    7.179730] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
> [    7.180345] Call Trace:
> [    7.180485]  dump_stack+0x8a/0xb5
> [    7.180676]  kasan_report.cold+0x10f/0x111
> [    7.180907]  ? __mutex_lock.isra.0+0x1ac/0x7c0
> [    7.181156]  __mutex_lock.isra.0+0x1ac/0x7c0
> [    7.181394]  ? finish_task_switch+0x12f/0x360
> [    7.181640]  ? __switch_to+0x339/0x6b0
> [    7.181852]  ? ww_mutex_lock_interruptible+0x150/0x150
> [    7.182138]  ? __sched_text_start+0x8/0x8
> [    7.182363]  ? vprintk_emit+0x91/0x170
> [    7.182576]  mutex_lock+0xc9/0xd0
> [    7.182765]  ? __mutex_lock_slowpath+0x10/0x10
> [    7.183016]  ? swsusp_write.cold+0x208/0x208
> [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]
> [    7.184403]  ? adf_remove+0x70/0x70 [qat_dh895xccvf]
> [    7.184681]  ? _raw_spin_lock_irqsave+0x7b/0xd0
> [    7.184936]  ? _raw_spin_unlock_irqrestore+0xd/0x20
> [    7.185209]  ? adf_remove+0x70/0x70 [qat_dh895xccvf]
> [    7.185489]  local_pci_probe+0x6f/0xb0
> [    7.185702]  pci_device_probe+0x1e9/0x2f0
> [    7.185928]  ? pci_device_remove+0xf0/0xf0
> [    7.186159]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
> [    7.186458]  really_probe+0x161/0x420
> [    7.186665]  driver_probe_device+0x6d/0xd0
> [    7.186894]  device_driver_attach+0x82/0x90
> [    7.187131]  ? device_driver_attach+0x90/0x90
> [    7.187375]  __driver_attach+0x60/0x100
> [    7.187591]  ? device_driver_attach+0x90/0x90
> [    7.187835]  bus_for_each_dev+0xe1/0x140
> [    7.188057]  ? subsys_dev_iter_exit+0x10/0x10
> [    7.188302]  ? klist_node_init+0x61/0x80
> [    7.188524]  bus_add_driver+0x254/0x2a0
> [    7.188740]  driver_register+0xd3/0x150
> [    7.188956]  ? 0xffffffffc0050000
> [    7.189143]  adfdrv_init+0x2b/0x1000 [qat_dh895xccvf]
> [    7.189427]  do_one_initcall+0x84/0x250
> [    7.189644]  ? trace_event_raw_event_initcall_finish+0x150/0x150
> [    7.189977]  ? _raw_spin_unlock_irqrestore+0xd/0x20
> [    7.190250]  ? create_object+0x395/0x510
> [    7.190472]  ? kasan_unpoison+0x21/0x50
> [    7.190689]  do_init_module+0xf8/0x350
> [    7.190901]  load_module+0x40c5/0x4410
> [    7.191121]  ? module_frob_arch_sections+0x20/0x20
> [    7.191390]  ? kernel_read_file+0x1cd/0x3e0
> [    7.191626]  ? __do_sys_finit_module+0x108/0x170
> [    7.191885]  __do_sys_finit_module+0x108/0x170
> [    7.192134]  ? __ia32_sys_init_module+0x40/0x40
> [    7.192389]  ? file_open_root+0x200/0x200
> [    7.192615]  ? do_sys_open+0x85/0xe0
> [    7.192817]  ? filp_open+0x50/0x50
> [    7.193010]  ? exit_to_user_mode_prepare+0xfc/0x130
> [    7.193283]  do_syscall_64+0x33/0x40
> [    7.193486]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [    7.193770] RIP: 0033:0x7f6ad21b4cf7
> [    7.193971] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d6 41
> [    7.194991] RSP: 002b:00007ffe2a5d9028 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [    7.195408] RAX: ffffffffffffffda RBX: 0000000000882a70 RCX: 00007f6ad21b4cf7
> [    7.195801] RDX: 0000000000000000 RSI: 00000000008819e0 RDI: 0000000000000003
> [    7.196193] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
> [    7.196588] R10: 00007f6ad2218300 R11: 0000000000000246 R12: 00000000008819e0
> [    7.196979] R13: 0000000000000000 R14: 0000000000881dd0 R15: 0000000000000001
> [    7.197372] ==================================================================
>
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 4 ++--
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 4 ++--
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> index 1d1532e8fb6d..067ca5e17d38 100644
> --- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         if (ret)
>                 goto out_err_free_reg;
>
> -       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>         ret = adf_dev_init(accel_dev);
>         if (ret)
>                 goto out_err_dev_shutdown;
>
> +       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>         ret = adf_dev_start(accel_dev);
>         if (ret)
>                 goto out_err_dev_stop;
> diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> index 04742a6d91ca..51ea88c0b17d 100644
> --- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         if (ret)
>                 goto out_err_free_reg;
>
> -       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>         ret = adf_dev_init(accel_dev);
>         if (ret)
>                 goto out_err_dev_shutdown;
>
> +       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>         ret = adf_dev_start(accel_dev);
>         if (ret)
>                 goto out_err_dev_stop;
> diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> index c972554a755e..29999da716cc 100644
> --- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         if (ret)
>                 goto out_err_free_reg;
>
> -       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>         ret = adf_dev_init(accel_dev);
>         if (ret)
>                 goto out_err_dev_shutdown;
>
> +       set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>         ret = adf_dev_start(accel_dev);
>         if (ret)
>                 goto out_err_dev_stop;
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
