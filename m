Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB7BC28CC2
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5220A26875
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaLzL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51371 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfEaLzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from orion.localdomain ([77.7.63.28]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MPosX-1hB0Ov0nZL-00MqI5; Fri, 31 May 2019 13:54:58 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] mod_devicetable: helper macro for declaring oftree module device table
Date:   Fri, 31 May 2019 13:54:48 +0200
Message-Id: <1559303690-8108-2-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559303690-8108-1-git-send-email-info@metux.net>
References: <1559303690-8108-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:V288v4ALIWuWNg9HRg79E6LpE7dzHj4EBz4l93oqRsKCBr/QUSy
 I0NLW8gl8Nb+SO5o3chDtqIXJOYGcC8EpFMX8bDouP9ej7aBQ6g9TdBGvF7GdSHRTdr/mZV
 3qlXzmS7Tb/VFQC9St3koLYPmiYTsyDDMy/FCQNqMQdpj1zyJhcu4iMW+n8Dtgkuw2UwQFN
 Cl6mS9uOxWsnw5E5SMeFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bINdRz6o6vM=:1m4uF5uYooJCKxCZ+OV6Du
 /Qbc6OffjQZj1+BTQ2yZecPNqHNmYaG/tN2zvllwRvuY/7tOiEfF3FIBK05HdEe39GlyWuqyY
 s9p0mT+LlKd1goyBxz5SaUXm0AAyzieQ2bYwluLqb8wkKz5Z1UOEbCzlFa3mKwLN/D6Q5jQgo
 aswyh6GSxJH3YZkgHFQ7X0ZQoztCTR2UnY5zMM4oIzZsBH6CeZy8Ym5bNKqa4A+bYOkNJGpaT
 MQWxKWn2dYbDv4WnvVD2iRFCL1u2WjmJ5RZ5lEhcuTR9XNHIVJ61XWMMa4BBc3sMJaPNxx0ti
 AvOSD2b3IrqhOEUjWXGHrJnxoBQcrd2zKUSjopULhHpTMU+WSOwdi9Lqa1BAG0ypskfZ0TzuI
 uuhTviDsgefclU4Aa8lW/9Zvl/9dVDnNYDv8muOVDNn6TPGcL5XpmAEXkw5ir60wo3TrxVzEg
 4IrUNvHLk/GDn8kuycQIW5tYW6O2QSd5qKDzM4oJeqjTuDvGncxF7oXkLAiTrNjt+I9+faOq2
 nxRlCV9DLkqaEX3dix9eL1Tlx+P87GeQoVoq7f6zpB2mXOqF6dPdGLvOag1Yck0tc+vK/6GnF
 w33ZjcDKLtQt8daMOUa98K6RQ5SgwnjmwlbzQD90cxUmGQYJ49tOIFIqj70udQ5eVayj72Aka
 PS6g8fcffAqTtk3BSFt/1sFgE4ITlUExgjnLs1HEnZVkmQUu629B/bGEvp2BSll9wILdvIcZX
 eTZR0/N4YV365T7B7R3O2kDI1DUXP47gkzHDyw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Little helper macro that declares an oftree module device table,
if CONFIG_OF is enabled. Otherwise it's just noop. Helpful for
reducing the number of #ifdef's.

Instead of:
    MODULE_DEVICE_TABLE(of, foo)
now use:
    MODULE_OF_TABLE(foo)

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 include/linux/mod_devicetable.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 448621c..0551b53 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -245,6 +245,15 @@ struct of_device_id {
 	const void *data;
 };
 
+/*
+ * macro for adding the of module device table only if CONFIG_OF enabled
+ */
+#ifdef CONFIG_OF
+#define MODULE_OF_TABLE(name)	MODULE_DEVICE_TABLE(of,name)
+#else
+#define MODULE_OF_TABLE(name)
+#endif /* CONFIG_OF */
+
 /* VIO */
 struct vio_device_id {
 	char type[32];
-- 
1.9.1

