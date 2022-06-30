Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005A0CCA47B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiF3IiT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiF3IiP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:38:15 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 020F6DFF0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 01:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eIU//
        gX/xVkvZIkLqKn/qZ7ss2gGbSLGNms96/xuylo=; b=aP28UP/A8gNCyhxgGObun
        Er09FbY099Pvucqpy0wnbdaNVblwtMWhFcKW/uULAij0TlgFYbmg6IqWskxQycvg
        a8DV+har3IoZyutqePV5SpuoxSBQeL4xCmkG/Hasnq5pe+CdPSkPjLvvlcOpCJhk
        I4ytytaMZk1TRUR0PyIs0s=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp3 (Coremail) with SMTP id DcmowADXb5GpYL1iB4f_EA--.25761S3;
        Thu, 30 Jun 2022 16:37:01 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        windhl@126.com, linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: nx: Hold the reference returned by of_find_compatible_node
Date:   Thu, 30 Jun 2022 16:36:57 +0800
Message-Id: <20220630083657.206122-2-windhl@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630083657.206122-1-windhl@126.com>
References: <20220630083657.206122-1-windhl@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowADXb5GpYL1iB4f_EA--.25761S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Xr1UAry5AFykZF4UXFWUurg_yoW8Jry8pF
        4akay5AFyfJay09Fy0vFy8ZFy5Xas5uFW8GF1jkas8uwn3AFy8ArWIvr17uFn8CFW5Kr1S
        vFWvq3W8AF48ZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRwmiiUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi2g0wF1uwMUQ19QAAsu
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In nx842_pseries_init(), we should hold the reference returned by
of_find_compatible_node() and use it to call of_node_put to keep
refcount balance.

Signed-off-by: Liang He <windhl@126.com>
---
 changelog:

 v2: split v1 into two commits
 v1: fix bugs in two directories (amcc,nx) of crypto

 v1-link: https://lore.kernel.org/all/20220621073742.4081013-1-windhl@126.com/


 drivers/crypto/nx/nx-common-pseries.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 7584a34ba88c..3ea334b7f820 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1208,10 +1208,13 @@ static struct vio_driver nx842_vio_driver = {
 static int __init nx842_pseries_init(void)
 {
 	struct nx842_devdata *new_devdata;
+	struct device_node *np;
 	int ret;
 
-	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
+	np = of_find_compatible_node(NULL, NULL, "ibm,compression");
+	if (!np)
 		return -ENODEV;
+	of_node_put(np);
 
 	RCU_INIT_POINTER(devdata, NULL);
 	new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
-- 
2.25.1

