Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4AFC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35BBA2465B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EykB0ac2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgAVKqJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:46:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40701 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbgAVKpv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so6629170wmi.5;
        Wed, 22 Jan 2020 02:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXhhnXKXoxYSpa1+LXBS7VNs2uspXwnX5jIhIQmwFrM=;
        b=EykB0ac2kjYrYahu/jZIfG6FfpaSNjvW7yVd/WDy3Fs3kS6TW94qvZDp2Z9zG6y7kk
         P182nzjKGL3aJwP3fYx1VS8CqcqsglP0XtShXtt5mB83h7kB/UbCZwsbp6itjDxeZffB
         YQgI0AiY2tL/6LwGZDDHn51fT+IL2IyLOtJQbC8iWc60bEqkTi5iz8TYmdwyp2skjvuS
         J6QJlKUQwoIRUe59EjCf264gffqZjLFpzOEQ2lNaYtjUU9bkehFD0RuPP4ufl7wraoTK
         6cIcb4utrANC0cdjxDGPLZ1PkCSHMLDxt7jewacut+G9zXpgQ50ouZwP7IZT5fnbJL5k
         AUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXhhnXKXoxYSpa1+LXBS7VNs2uspXwnX5jIhIQmwFrM=;
        b=HEF+FN0Poq1tGTAAeqoMyFmrEC7dEr1QFhyDF9pwU3ATFNG/C2Hosuhz2tpry5D7IS
         ZqznwZxCn6S47AmX3qm+jSpB7+E6EMvpIvLmfynWgWl8nVXV78nR5kjSlV0euozw/Bc/
         Ey9wJwsypED8h+w7gOWjPhmTO8C0JK0dHXpuf/yNUDsKtGxS+HVS7TWDf/g9fHNoUJrr
         Oz1ENaT+UThdBC7WGPQKizMQZujE9QjcI8/PGb6us21NlvHMMEPVH83pqCmnRyJ2cQo0
         35RkFXgXqHmKeq8Ph7xRrL9hukV+Y2Nz31JrSTgKxauMAAf+M4jOwRt1d5gQpdE2zrxk
         1xSA==
X-Gm-Message-State: APjAAAWjEGCX4rrZeEZSKiVvhQdMFAm5lGM3vfaIwyVRVzgd6eE0YLxw
        unHq0k3dNX5QdNYSiv3obos=
X-Google-Smtp-Source: APXvYqxzgTFSZ6oqp6dWOuexRw6nwIAhgLOfYgEFyNAyKcSwm1Rtry4hWg/6bgd0XM2rcSVRYbPuVw==
X-Received: by 2002:a1c:5945:: with SMTP id n66mr2249307wmb.98.1579689949561;
        Wed, 22 Jan 2020 02:45:49 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:48 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 7/9] crypto: sun8i-ce: increase task list size
Date:   Wed, 22 Jan 2020 11:45:26 +0100
Message-Id: <20200122104528.30084-8-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CE can handle more than 1 task at once, so this patch increase the size of
the task list up to 8.
For the moment I did not see more gain beyong this value.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 4 ++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h      | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index f72346a44e69..e8bf7bf31061 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -321,7 +321,7 @@ static void sun8i_ce_free_chanlist(struct sun8i_ce_dev *ce, int i)
 	while (i >= 0) {
 		crypto_engine_exit(ce->chanlist[i].engine);
 		if (ce->chanlist[i].tl)
-			dma_free_coherent(ce->dev, sizeof(struct ce_task),
+			dma_free_coherent(ce->dev, sizeof(struct ce_task) * MAXTASK,
 					  ce->chanlist[i].tl,
 					  ce->chanlist[i].t_phy);
 		i--;
@@ -356,7 +356,7 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 			goto error_engine;
 		}
 		ce->chanlist[i].tl = dma_alloc_coherent(ce->dev,
-							sizeof(struct ce_task),
+							sizeof(struct ce_task) * MAXTASK,
 							&ce->chanlist[i].t_phy,
 							GFP_KERNEL);
 		if (!ce->chanlist[i].tl) {
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 49507ef2ec63..049b3175d755 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -73,6 +73,7 @@
 #define CE_MAX_CLOCKS 3
 
 #define MAXFLOW 4
+#define MAXTASK 8
 
 /*
  * struct ce_clock - Describe clocks used by sun8i-ce
-- 
2.24.1

