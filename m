Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2EDC433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 23:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBA722583
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 23:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbhADXDh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:03:37 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:21025 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbhADXDh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 18:03:37 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-ag-iRlqQOuKeaV89XUEPMQ-1; Mon, 04 Jan 2021 18:02:42 -0500
X-MC-Unique: ag-iRlqQOuKeaV89XUEPMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAF07180A092;
        Mon,  4 Jan 2021 23:02:40 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD0B45D9C6;
        Mon,  4 Jan 2021 23:02:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-crypto@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: Rename struct device_private to bcm_device_private
Date:   Tue,  5 Jan 2021 00:02:37 +0100
Message-Id: <20210104230237.916064-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Renaming 'struct device_private' to 'struct bcm_device_private',
because it clashes with 'struct device_private' from
'drivers/base/base.h'.

While it's not a functional problem, it's causing two distinct
type hierarchies in BTF data. It also breaks build with options:
  CONFIG_DEBUG_INFO_BTF=y
  CONFIG_CRYPTO_DEV_BCM_SPU=y

as reported by Qais Yousef [1].

[1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 2 +-
 drivers/crypto/bcm/cipher.h | 4 ++--
 drivers/crypto/bcm/util.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 30390a7324b2..0e5537838ef3 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -42,7 +42,7 @@
 
 /* ================= Device Structure ================== */
 
-struct device_private iproc_priv;
+struct bcm_device_private iproc_priv;
 
 /* ==================== Parameters ===================== */
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 0ad5892b445d..71281a3bdbdc 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -420,7 +420,7 @@ struct spu_hw {
 	u32 num_chan;
 };
 
-struct device_private {
+struct bcm_device_private {
 	struct platform_device *pdev;
 
 	struct spu_hw spu;
@@ -467,6 +467,6 @@ struct device_private {
 	struct mbox_chan **mbox;
 };
 
-extern struct device_private iproc_priv;
+extern struct bcm_device_private iproc_priv;
 
 #endif
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 2b304fc78059..77aeedb84055 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -348,7 +348,7 @@ char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
 static ssize_t spu_debugfs_read(struct file *filp, char __user *ubuf,
 				size_t count, loff_t *offp)
 {
-	struct device_private *ipriv;
+	struct bcm_device_private *ipriv;
 	char *buf;
 	ssize_t ret, out_offset, out_count;
 	int i;
-- 
2.26.2

