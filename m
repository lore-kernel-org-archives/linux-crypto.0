Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED4AC5DF60
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67F04214D8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Du/Pkluu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389715AbfKEPOV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39369 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389766AbfKEPOD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:03 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so2897524plk.6;
        Tue, 05 Nov 2019 07:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cD8QSUIgtSt3hWOH7J14z6PosOVnptVgj941oita3aA=;
        b=Du/Pkluuj+rJHqc/Lc5etCEkuKR6HXKyZwudSyaULAYJP1G9X5EAPkKWh1SQnuGq7v
         sLXX7xu+MuKhT/CP7B+vVHYVc9vs7Z7OTNSpx+4jmb0SeHXvm3CvZy0T8O4zgUrLR9oO
         7QhK4XgldCyi/m+YK43uT2CqULE0FqpywJgL0/LAYg3tZ+hn6QQTANf+hfmaa4uSBIFY
         qJSC7MaBK5nULS7wygyHnRJ5CnORJAUjhf9MQK+96J1WU6zJbfIahKLYqY0+cVqpWjDR
         HeThp04ZzVoWAL2H0EJoKNsNL+V6TkChTIniVQwBumMRZCD7zt+GQdjfyzECP8xynijz
         jQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cD8QSUIgtSt3hWOH7J14z6PosOVnptVgj941oita3aA=;
        b=rR1bRSQiAxK4phJzIWbzNxh5veaS7mzzUt83ZpA18/SneaHPgl48rUxDxs9g3FbXWp
         crXdzLZl9xKCXUQbOUoNELZILXf40LNIsZlkj4/WimSfEvKKg7TZzFHkIPzGJ0ty6Qav
         J9MOluI5ECj/Y9yUZiMipl08lr9ygTniNkfzvc1Vu201YXU5Scc/zBy8cfrTwrOlUVf9
         /MfOztCqIgt5kIhWF1NEd8jtO5dMyk5gRbmRz1XpLo9uKx8Q6D8v4zzyumErhRh5RlTJ
         CtiR4QQY8y1LufYx7ga5vSd0GDguZqmCYXIZzmJVeMJKUexosFrEzg/X15cCbV5buhWp
         BCvQ==
X-Gm-Message-State: APjAAAU1Ym7ISG5eWw7EjC+oHnD638yGVzx7Jy5k8ViUNNY7GwO6PhpT
        GhgY/gIWhA2vnCzv6qjWUcinZzB8
X-Google-Smtp-Source: APXvYqy4OrftXbNogh5G8CwuTnDqLkLNCLEQqB3ycXFLBuN1wSMZFp4vnXTbz7B7iySJua0eWvZ3UQ==
X-Received: by 2002:a17:902:aa8a:: with SMTP id d10mr12729955plr.273.1572966841264;
        Tue, 05 Nov 2019 07:14:01 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:14:00 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] crypto: caam - introduce caam_jr_cbk
Date:   Tue,  5 Nov 2019 07:13:50 -0800
Message-Id: <20191105151353.6522-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Coalesce multiple ad-hoc definitions of the same function pointer into
a dedicated type to avoid repetition.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/intern.h | 3 ++-
 drivers/crypto/caam/jr.c     | 9 +++------
 drivers/crypto/caam/jr.h     | 7 ++++---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c90464b..fe2ca2ad6ff0 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -11,6 +11,7 @@
 #define INTERN_H
 
 #include "ctrl.h"
+#include "jr.h"
 
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
@@ -31,7 +32,7 @@
  * Each entry on an output ring needs one of these
  */
 struct caam_jrentry_info {
-	void (*callbk)(struct device *dev, u32 *desc, u32 status, void *arg);
+	caam_jr_cbk callbk;
 	void *cbkarg;	/* Argument per ring entry */
 	u32 *desc_addr_virt;	/* Stored virt addr for postprocessing */
 	dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 49c98a7f6723..3e78fedeea30 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -197,7 +197,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 	int hw_idx, sw_idx, i, head, tail;
 	struct device *dev = (struct device *)devarg;
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
+	caam_jr_cbk usercall;
 	u32 *userdesc, userstatus;
 	void *userarg;
 	u32 outring_used = 0;
@@ -354,10 +354,7 @@ EXPORT_SYMBOL(caam_jr_free);
  * @areq: optional pointer to a user argument for use at callback
  *        time.
  **/
-int caam_jr_enqueue(struct device *dev, u32 *desc,
-		    void (*cbk)(struct device *dev, u32 *desc,
-				u32 status, void *areq),
-		    void *areq)
+int caam_jr_enqueue(struct device *dev, u32 *desc, caam_jr_cbk cbk, void *areq)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	struct caam_jrentry_info *head_entry;
@@ -386,7 +383,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry = &jrp->entinfo[head];
 	head_entry->desc_addr_virt = desc;
 	head_entry->desc_size = desc_size;
-	head_entry->callbk = (void *)cbk;
+	head_entry->callbk = cbk;
 	head_entry->cbkarg = areq;
 	head_entry->desc_addr_dma = desc_dma;
 
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index eab611530f36..81acc6a6909f 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -9,11 +9,12 @@
 #define JR_H
 
 /* Prototypes for backend-level services exposed to APIs */
+typedef void (*caam_jr_cbk)(struct device *dev, u32 *desc, u32 status,
+			    void *areq);
+
 struct device *caam_jr_alloc(void);
 void caam_jr_free(struct device *rdev);
-int caam_jr_enqueue(struct device *dev, u32 *desc,
-		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
-				void *areq),
+int caam_jr_enqueue(struct device *dev, u32 *desc, caam_jr_cbk cbk,
 		    void *areq);
 
 #endif /* JR_H */
-- 
2.21.0

