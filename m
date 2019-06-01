Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0ADC46470
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633DB27729
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFANxa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:53:30 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:57031 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFANx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 09:53:29 -0400
Received: from orion.localdomain ([95.114.112.19]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MyvFC-1gbGrY29eE-00vthP; Sat, 01 Jun 2019 15:53:06 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vireshk@kernel.org, b.zolnierkie@samsung.com, axboe@kernel.dk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] mod_devicetable: helper macro for declaring oftree module device table
Date:   Sat,  1 Jun 2019 15:52:56 +0200
Message-Id: <1559397179-5833-2-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559397179-5833-1-git-send-email-info@metux.net>
References: <1559397179-5833-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:/pQ0SiB+S9YxYbrQ1XDQRcGrtuLOnVkDVszipfecYxl03iwuOl4
 nYqF4l9YRJDBlJV317mF4FCdWTOJux6+BnyF1DOVm3yoiR3red/00RFsrZhmKqIYrFVXynW
 sQyQm3T9sIpBhlmVtpgoiq+r+9LDdRGEsM0cuWRtoycGb2U3vMt0Rf8ol5EBGlGW85uLeXH
 VHrD64bfJFZA6+B0hT02Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UsEKdqu8eJQ=:yn1djYVny2lJ9uswl5IQxH
 sLk9xJQBvb48x0/GWC8ISyDjZ8465go8tSn5FEniZ8L4ZterG3xoJoF3NJb+TQMhI/Rj3TKjj
 jh0lHrIwPqTK1Wo54G3kbdjTy1PSGRZs0qg26IxbwzndjW7560milp3WbSbUXI1pDalE/WJLu
 njiRw9MdBhcqHLUvmLRi1jxUDgi+R8M2/9bSmtpMEFMmvppDZGzKiVQVIMDlS06Wm+m5IMiIx
 w6w9HQK2qwFjM25ARbWpD/KuBETbmg3lLg2ofERSqw8NiF4+UrAoYWAZb0MMLvn3fYtEO/Yi1
 +lJ/4ztM1qGIU+bYgKeYpGLW0YX8kb7g4UYrFEQh9LGnXgVCpbWVm+MbkPXkC5GXTRkQHUTcj
 pSyIzS+sZD7LlR7PZ4RCyWE/xIxc27fIRuJA3XDYrKnLJlp6vG7Blsm+CgbSKPPu1vH/7+4iE
 fAt789Ct3T0ND3BaKqyxCOoox/igriu0IIl9MwXOugQwESQ3TJ/vTLWTCW5zlSOzknnL/8imU
 Sd+dqPQgBnq0ivNe6RNv3ezAUAxHsovJM6105rtuWI2Xc9p+vzfs5mwYC/0/VpVOHFzkVg4F/
 nYcLHODNl6JBfs6go7p/3vxExXhVOnz566rH9T31dQT9fWjWxoFP2tIYcALNZIrYSZu8LfKJY
 f3Ddw/k0Pehm0DQDpUrU/wOjk/IY2Rde5SPHlK0+APA6dWGV3FbZIyYIAjBfFqncZtxqYp9Dx
 P3/uCvIh0KB/R4pXy+2mht1zZokaB/5lMJ/JgA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Little helper macros that declares an oftree module device table,
if CONFIG_OF is enabled. Otherwise it's just noop. Helpful for
reducing the number of #ifdef's.

Instead of:
    MODULE_DEVICE_TABLE(of, foo);
now use:
    MODULE_OF_TABLE(foo);

Or declare the whole table via:
    MODULE_DECLARE_OF_TABLE(foo,
        { .compatible = "foo" },
        { .compatible = "bar" });

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 include/linux/mod_devicetable.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 448621c..5f4f2dc8 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -245,6 +245,19 @@ struct of_device_id {
 	const void *data;
 };
 
+/*
+ * macro for adding the of module device table only if CONFIG_OF enabled
+ */
+#ifdef CONFIG_OF
+#define MODULE_OF_TABLE(name)	MODULE_DEVICE_TABLE(of,name)
+#define MODULE_DECLARE_OF_TABLE(name,entries...) \
+static const struct of_device_id name[] = { entries, {} };
+#else
+#define MODULE_OF_TABLE(name)
+#define MODULE_DECLARE_OF_TABLE(name,entries...) \
+static const struct of_device_id *name = NULL;
+#endif /* CONFIG_OF */
+
 /* VIO */
 struct vio_device_id {
 	char type[32];
-- 
1.9.1

