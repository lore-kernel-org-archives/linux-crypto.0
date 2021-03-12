Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA32C4332E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF0664F85
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCLHo5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhCLHoj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 02:44:39 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFABC061574;
        Thu, 11 Mar 2021 23:44:38 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id f124so23402602qkj.5;
        Thu, 11 Mar 2021 23:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7I42ZZBIp3nuMygUFN643ARCYmtNwE1bdxY8TBbPX0w=;
        b=UQWrZvgLvSLGk6eUzmnGbm+X9Ma9IZodXlEYuAT988lzqxCmdcPDwCRv+N3uJwCmXH
         1FNqEtV51vz8oBfXS3s9IaYH65rTghyCsyM3U7jbfX/AT4W+xus5BhZwQmJYoxVsqJur
         m2ZtxW3nANIwa81ihbAHdpf7EXsrT0agL8AQSDGWu/LJ/9KNpalzq+R01eJbCqFyit70
         BqFRpw4M20OODrrAy6dAetVhbjpjDecrhdjHaS2Y67/GGo+gjBEwcnrUz54cq5jD5ZBA
         qskqpWUpBu65cVcoYaWNxvgHX8RJvQMfGSotq3ECMZTil217TDoVh+C5Qxnt44zvX/QS
         JswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7I42ZZBIp3nuMygUFN643ARCYmtNwE1bdxY8TBbPX0w=;
        b=K3EzTlLN/1Y6mjAa47eCSB1E0xfrofSvLadf+Edvl0hXetdzBvaJm8IYQfPXl2DVzy
         cOZ28Pj/QysRydw/mzOovJles9haIPjwX07fKNIP4vcuiBduHGq1Qj2TuM3QvqKzxIMy
         3HYhEAWIZ4sC5La+sfbovfrF6MFNBmYpzq7DYy9PhXHzLRhuZcP6jwcVKs2FDkHOv5Tq
         d35y0tiM1WPoE7rYngwJL/gg/Ykm99TWey01gEgJflZDVFW3ZYwPd0EBsRUJYLynljBQ
         9ciAPf748W+y2aGlKgMDKB7gGx3lckKuv35HsvT/AHmxsOnhJjC+X6aaCwxS8eEaCffA
         CNnw==
X-Gm-Message-State: AOAM532x0zohBGQDzJQhrVX/Zkt95JPeP9GJgRpKtttHIOplQUsad8zg
        G/40NTj2D9t5htO4QkAJ/+4=
X-Google-Smtp-Source: ABdhPJyFk2AswEogHAMglGkOBg5FHQgdmC3oD9zIipEEcuQXikWGc9ugO/MAbEqIyni46A/9+dqCPw==
X-Received: by 2002:a05:620a:c0d:: with SMTP id l13mr11185410qki.234.1615535078055;
        Thu, 11 Mar 2021 23:44:38 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id e2sm3434089qto.50.2021.03.11.23.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 23:44:37 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tong Zhang <ztong0001@gmail.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: qat - dont release uninitialized resources
Date:   Fri, 12 Mar 2021 02:43:57 -0500
Message-Id: <20210312074357.2384087-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210312074357.2384087-1-ztong0001@gmail.com>
References: <20210312074357.2384087-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

adf_vf_isr_resource_alloc() is not unwinding correctly when error
happens and it trys to release uninitialized resources.
To fix this, only release initialized resources.

[    1.792594] ------------[ cut here ]------------
[    1.792845] Trying to free already-free IRQ 11
[    1.793091] WARNING: CPU: 0 PID: 182 at kernel/irq/manage.c:1821 free_irq+0x202/0x380
[    1.793518] Modules linked in: qat_c3xxxvf(+) drm snd_pcm intel_qat snd_timer snd joydev psmouse 4
[    1.794998] CPU: 0 PID: 182 Comm: systemd-udevd Not tainted 5.12.0-rc2+ #78
[    1.795379] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
[    1.795986] RIP: 0010:free_irq+0x202/0x380
[    1.796211] Code: e8 23 6a 1b 00 48 83 c4 10 4c 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 8b 75 d0 40
[    1.797215] RSP: 0018:ffffc90000ce3970 EFLAGS: 00010082
[    1.797500] RAX: 0000000000000000 RBX: ffff888104b75200 RCX: 0000000000000027
[    1.797886] RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff88817bc18448
[    1.798270] RBP: ffffc90000ce39a8 R08: ffff88817bc18440 R09: ffffc90000ce3730
[    1.798655] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881001c2200
[    1.799040] R13: ffff8881001c2360 R14: ffff8881001c22a4 R15: ffff8881008b30c8
[    1.799434] FS:  00007f2313cd38c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
[    1.799871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.800183] CR2: 00007ffc6f4b4080 CR3: 0000000104a3c000 CR4: 00000000000006f0
[    1.800569] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.800954] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.801340] Call Trace:
[    1.801477]  adf_vf_isr_resource_free+0x32/0xb0 [intel_qat]
[    1.801785]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
[    1.802105]  adf_dev_init+0xba/0x140 [intel_qat]
[    1.802365]  adf_probe+0x32f/0x370 [qat_c3xxxvf]
[    1.802620]  local_pci_probe+0x48/0x80
[    1.802827]  pci_device_probe+0x10f/0x1c0
[    1.803048]  really_probe+0xfb/0x420
[    1.803249]  driver_probe_device+0xe9/0x160
[    1.803479]  device_driver_attach+0x5d/0x70
[    1.803709]  __driver_attach+0x8f/0x150
[    1.803920]  ? device_driver_attach+0x70/0x70
[    1.804159]  bus_for_each_dev+0x7e/0xc0
[    1.804370]  driver_attach+0x1e/0x20
[    1.804568]  bus_add_driver+0x152/0x1f0
[    1.804779]  driver_register+0x74/0xd0
[    1.804986]  ? 0xffffffffc009b000
[    1.805169]  __pci_register_driver+0x54/0x60
[    1.805404]  adfdrv_init+0x34/0x1000 [qat_c3xxxvf]
[    1.805667]  do_one_initcall+0x48/0x1d0
[    1.805879]  ? __slab_alloc+0x20/0x40
[    1.806081]  ? kmem_cache_alloc_trace+0x390/0x440
[    1.806338]  ? do_init_module+0x28/0x250
[    1.806555]  do_init_module+0x62/0x250
[    1.806762]  load_module+0x23ee/0x26a0
[    1.806970]  __do_sys_finit_module+0xc2/0x120
[    1.807211]  ? __do_sys_finit_module+0xc2/0x120
[    1.807460]  __x64_sys_finit_module+0x1a/0x20
[    1.807693]  do_syscall_64+0x38/0x90
[    1.807892]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    1.808167] RIP: 0033:0x7f2312b50469
[    1.808365] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48
[    1.809368] RSP: 002b:00007ffeae1d29e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    1.809775] RAX: ffffffffffffffda RBX: 000055909ee6aee0 RCX: 00007f2312b50469
[    1.810159] RDX: 0000000000000000 RSI: 00007f2313469265 RDI: 0000000000000010
[    1.810543] RBP: 00007f2313469265 R08: 0000000000000000 R09: 00007ffeae1d2f60
[    1.810927] R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000000
[    1.811312] R13: 000055909ee6afe0 R14: 0000000000020000 R15: 000055909dd2fefc
[    1.811697] ---[ end trace ff698e93b7952e56 ]---
[    1.811962] BUG: unable to handle page fault for address: ffffebde000003c8
[    1.812341] #PF: supervisor read access in kernel mode
[    1.812621] #PF: error_code(0x0000) - not-present page
[    1.812902] PGD 0 P4D 0
[    1.813044] Oops: 0000 [#1] SMP NOPTI
[    1.813246] CPU: 0 PID: 182 Comm: systemd-udevd Tainted: G        W         5.12.0-rc2+ #78
[    1.813697] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
[    1.814302] RIP: 0010:kfree+0x5d/0x420
[    1.814508] Code: db 4d 01 fd 0f 82 c8 03 00 00 49 c7 c4 00 00 00 80 4c 2b 25 e5 f1 1c 01 4d 01 ed
[    1.815518] RSP: 0018:ffffc90000ce3970 EFLAGS: 00010286
[    1.815803] RAX: 1000000000000401 RBX: 0000000000000000 RCX: 0000000000000000
[    1.816189] RDX: ffff8881047291b0 RSI: ffffffffc01a72cf RDI: 000000000000f000
[    1.816575] RBP: ffffc90000ce39a8 R08: ffff88817bc18440 R09: 0000000000000246
[    1.816961] R10: 0000000000000001 R11: 0000000000000001 R12: ffffebde000003c0
[    1.817348] R13: 000000008000f000 R14: 0000000000000000 R15: 000000000000f000
[    1.817734] FS:  00007f2313cd38c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
[    1.818170] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.818483] CR2: ffffebde000003c8 CR3: 0000000104a3c000 CR4: 00000000000006f0
[    1.818871] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.819259] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.819645] Call Trace:
[    1.819781]  adf_vf_isr_resource_free+0x9f/0xb0 [intel_qat]
[    1.820088]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
[    1.820408]  adf_dev_init+0xba/0x140 [intel_qat]
[    1.820664]  adf_probe+0x32f/0x370 [qat_c3xxxvf]
[    1.820918]  local_pci_probe+0x48/0x80
[    1.821126]  pci_device_probe+0x10f/0x1c0
[    1.821347]  really_probe+0xfb/0x420
[    1.821544]  driver_probe_device+0xe9/0x160
[    1.821774]  device_driver_attach+0x5d/0x70
[    1.822004]  __driver_attach+0x8f/0x150
[    1.822228]  ? device_driver_attach+0x70/0x70
[    1.822471]  bus_for_each_dev+0x7e/0xc0
[    1.822684]  driver_attach+0x1e/0x20
[    1.822883]  bus_add_driver+0x152/0x1f0
[    1.823098]  driver_register+0x74/0xd0
[    1.823305]  ? 0xffffffffc009b000
[    1.823490]  __pci_register_driver+0x54/0x60
[    1.823725]  adfdrv_init+0x34/0x1000 [qat_c3xxxvf]
[    1.823988]  do_one_initcall+0x48/0x1d0
[    1.824200]  ? __slab_alloc+0x20/0x40
[    1.824403]  ? kmem_cache_alloc_trace+0x390/0x440
[    1.824662]  ? do_init_module+0x28/0x250
[    1.824879]  do_init_module+0x62/0x250
[    1.825087]  load_module+0x23ee/0x26a0
[    1.825296]  __do_sys_finit_module+0xc2/0x120
[    1.825535]  ? __do_sys_finit_module+0xc2/0x120
[    1.825785]  __x64_sys_finit_module+0x1a/0x20
[    1.826025]  do_syscall_64+0x38/0x90
[    1.826223]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    1.826500] RIP: 0033:0x7f2312b50469
[    1.826697] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48
[    1.827708] RSP: 002b:00007ffeae1d29e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    1.828118] RAX: ffffffffffffffda RBX: 000055909ee6aee0 RCX: 00007f2312b50469
[    1.828504] RDX: 0000000000000000 RSI: 00007f2313469265 RDI: 0000000000000010
[    1.828890] RBP: 00007f2313469265 R08: 0000000000000000 R09: 00007ffeae1d2f60
[    1.829276] R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000000
[    1.829662] R13: 000055909ee6afe0 R14: 0000000000020000 R15: 000055909dd2fefc
[    1.830049] Modules linked in: qat_c3xxxvf(+) drm snd_pcm intel_qat snd_timer snd joydev psmouse 4
[    1.831540] CR2: ffffebde000003c8
[    1.831724] ---[ end trace ff698e93b7952e57 ]---
[    1.831976] RIP: 0010:kfree+0x5d/0x420
[    1.832184] Code: db 4d 01 fd 0f 82 c8 03 00 00 49 c7 c4 00 00 00 80 4c 2b 25 e5 f1 1c 01 4d 01 ed
[    1.833214] RSP: 0018:ffffc90000ce3970 EFLAGS: 00010286
[    1.833503] RAX: 1000000000000401 RBX: 0000000000000000 RCX: 0000000000000000
[    1.833894] RDX: ffff8881047291b0 RSI: ffffffffc01a72cf RDI: 000000000000f000
[    1.834286] RBP: ffffc90000ce39a8 R08: ffff88817bc18440 R09: 0000000000000246
[    1.834677] R10: 0000000000000001 R11: 0000000000000001 R12: ffffebde000003c0
[    1.835068] R13: 000000008000f000 R14: 0000000000000000 R15: 000000000000f000
[    1.835462] FS:  00007f2313cd38c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
[    1.835906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.836222] CR2: ffffebde000003c8 CR3: 0000000104a3c000 CR4: 00000000000006f0
[    1.836614] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.837003] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 38d316a42ba6..888388acb6bd 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -261,17 +261,26 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 		goto err_out;
 
 	if (adf_setup_pf2vf_bh(accel_dev))
-		goto err_out;
+		goto err_disable_msi;
 
 	if (adf_setup_bh(accel_dev))
-		goto err_out;
+		goto err_cleanup_pf2vf_bh;
 
 	if (adf_request_msi_irq(accel_dev))
-		goto err_out;
+		goto err_cleanup_bh;
 
 	return 0;
+
+err_cleanup_bh:
+	adf_cleanup_bh(accel_dev);
+
+err_cleanup_pf2vf_bh:
+	adf_cleanup_pf2vf_bh(accel_dev);
+
+err_disable_msi:
+	adf_disable_msi(accel_dev);
+
 err_out:
-	adf_vf_isr_resource_free(accel_dev);
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
-- 
2.25.1

