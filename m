Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E7CC54EBD
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 02:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjAICPL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Jan 2023 21:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjAICPK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Jan 2023 21:15:10 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BD1BA
        for <linux-crypto@vger.kernel.org>; Sun,  8 Jan 2023 18:15:09 -0800 (PST)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 64F313F5D0
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 02:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1673230507;
        bh=cesIom+i6U7EcWgqSOlJDVRbhpCjHorO+Z/WXR63GXE=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=OSTemymuVp4ry+Yg0Xls8XA6pps6tyS1yH0i6rWgVmm/7eNXrR2QROQ6Z4ZJ/w7d8
         unqhInAAQfMEilCecUIfSBVZohhBzIEntK0kxLY18FQ7BHqg0p33Nx7v7A4l1k47g1
         HXwhBc4kaPJhRUq9x6QKkMZKHcOS3ZkemXcp7qGD3ah2C6KF91FcpKLm2P813Wezv/
         jc+T6APBM7yp9zd8I0z7Q7pRzSVjy9pikMjdCzNqzbIooUyf9pQIYe5PqjnC2uEKlW
         zNuRFMn075+KwjU8zpqSCB3WPjwFs5UzQQN2wOFwFzFvctx7dofBJUtkiNYhppaKHP
         /ZkKQ67t7LIVw==
Received: by mail-pj1-f71.google.com with SMTP id k1-20020a17090a9d8100b00225af21197dso2257208pjp.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Jan 2023 18:15:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cesIom+i6U7EcWgqSOlJDVRbhpCjHorO+Z/WXR63GXE=;
        b=wRnuNuoRtrzoTGYEMsERoGPvTLnEPmGmjPJIZ3PCzxRzaKlJPXoDUOtZ36cYbBXvlv
         sAxvEXvZh3NIkxKAGTeIdSc77InGywBEjUI4Mqi9alCBTGD46C3DuFHzdxwGyKegxJr8
         f5ZrzMx1SB7NJbMAtXNp7JPZHfzGAxxd33aDbVrISJGVEu+ZtmUOlgk4Bq6xXlSzQf5u
         +SnsI4SfrnhsQDlGvgz/Ba+vVL8E+dr1rHzHYwnqvBCrsUlaOdfmvRD6R3bOg4LnMbDI
         W81yyBXwnCmvCn4fJFDJe29MJSppi4Lbti7yQOnUwDFI7IaTb9sr+By5ZzS/3rERrrkG
         sLAA==
X-Gm-Message-State: AFqh2kq2Mub0dp1+u+hb1lg80xp4jkX6jfBE18gyQrS5ZrFta5oN8YBq
        2S2+uKKnf1bg7CVxTvN2id25FovUjs2bE8mYx4jTzN+lcP30GYT7ppJxw7r8ppLYUQrmmyoAdc7
        gBP0K3OtoAR4DNZR8iqAMXhA3Ex3Mr8ubh3eWYwwqsQ==
X-Received: by 2002:a17:902:cf02:b0:191:283d:5afb with SMTP id i2-20020a170902cf0200b00191283d5afbmr65426600plg.50.1673230505949;
        Sun, 08 Jan 2023 18:15:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXukHQIZMIkhm+rsRaauuO1zn0GnSOoQcW7iOIzXk83VM3/taXgcWJST4aYMuT5GsLUGr3hJnQ==
X-Received: by 2002:a17:902:cf02:b0:191:283d:5afb with SMTP id i2-20020a170902cf0200b00191283d5afbmr65426574plg.50.1673230505474;
        Sun, 08 Jan 2023 18:15:05 -0800 (PST)
Received: from canonical.com (2001-b011-3007-dcb9-7dfb-c0ec-85d4-a958.dynamic-ip6.hinet.net. [2001:b011:3007:dcb9:7dfb:c0ec:85d4:a958])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902e54b00b0018c7a5e052asm4728743plf.225.2023.01.08.18.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 18:15:04 -0800 (PST)
From:   Koba Ko <koba.ko@canonical.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: ccp - Failure on re-initialization due to duplicate sysfs filename
Date:   Mon,  9 Jan 2023 10:15:02 +0800
Message-Id: <20230109021502.682474-1-koba.ko@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Koba Ko <koba.taiwan@gmail.com>

The following warning appears during the CCP module re-initialization:

[  140.965403] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:07.1/0000:03:00.2/dma/dma0chan0'
[  140.975736] CPU: 0 PID: 388 Comm: kworker/0:2 Kdump: loaded Not
tainted 6.2.0-0.rc2.18.eln124.x86_64 #1
[  140.985185] Hardware name: HPE ProLiant DL325 Gen10/ProLiant DL325
Gen10, BIOS A41 07/17/2020
[  140.993761] Workqueue: events work_for_cpu_fn
[  140.998151] Call Trace:
[  141.000613]  <TASK>
[  141.002726]  dump_stack_lvl+0x33/0x46
[  141.006415]  sysfs_warn_dup.cold+0x17/0x23
[  141.010542]  sysfs_create_dir_ns+0xba/0xd0
[  141.014670]  kobject_add_internal+0xba/0x260
[  141.018970]  kobject_add+0x81/0xb0
[  141.022395]  device_add+0xdc/0x7e0
[  141.025822]  ? complete_all+0x20/0x90
[  141.029510]  __dma_async_device_channel_register+0xc9/0x130
[  141.035119]  dma_async_device_register+0x19e/0x3b0
[  141.039943]  ccp_dmaengine_register+0x334/0x3f0 [ccp]
[  141.045042]  ccp5_init+0x662/0x6a0 [ccp]
[  141.049000]  ? devm_kmalloc+0x40/0xd0
[  141.052688]  ccp_dev_init+0xbb/0xf0 [ccp]
[  141.056732]  ? __pci_set_master+0x56/0xd0
[  141.060768]  sp_init+0x70/0x90 [ccp]
[  141.064377]  sp_pci_probe+0x186/0x1b0 [ccp]
[  141.068596]  local_pci_probe+0x41/0x80
[  141.072374]  work_for_cpu_fn+0x16/0x20
[  141.076145]  process_one_work+0x1c8/0x380
[  141.080181]  worker_thread+0x1ab/0x380
[  141.083953]  ? __pfx_worker_thread+0x10/0x10
[  141.088250]  kthread+0xda/0x100
[  141.091413]  ? __pfx_kthread+0x10/0x10
[  141.095185]  ret_from_fork+0x2c/0x50
[  141.098788]  </TASK>
[  141.100996] kobject_add_internal failed for dma0chan0 with -EEXIST,
don't try to register things with the same name in the same directory.
[  141.113703] ccp 0000:03:00.2: ccp initialization failed

The /dma/dma0chan0 sysfs file is not removed since dma_chan object
has been released in ccp_dma_release() before releasing dma device.
A correct procedure would be: release dma channels first => unregister
dma device => release ccp dma object.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216888
Fixes: 68dbe80f5b51 ("crypto: ccp - Release dma channels before dmaengine unrgister")
Tested-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Koba Ko <koba.ko@canonical.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 9f753cb4f5f18..b386a7063818b 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -642,14 +642,26 @@ static void ccp_dma_release(struct ccp_device *ccp)
 		chan = ccp->ccp_dma_chan + i;
 		dma_chan = &chan->dma_chan;
 
-		if (dma_chan->client_count)
-			dma_release_channel(dma_chan);
-
 		tasklet_kill(&chan->cleanup_tasklet);
 		list_del_rcu(&dma_chan->device_node);
 	}
 }
 
+static void ccp_dma_release_channels(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_chan *dma_chan;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+
+		if (dma_chan->client_count)
+			dma_release_channel(dma_chan);
+	}
+}
+
 int ccp_dmaengine_register(struct ccp_device *ccp)
 {
 	struct ccp_dma_chan *chan;
@@ -770,8 +782,9 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	ccp_dma_release(ccp);
+	ccp_dma_release_channels(ccp);
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
-- 
2.25.1

