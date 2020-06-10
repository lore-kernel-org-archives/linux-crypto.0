Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8F1C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C96C2074B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591771301;
	bh=XBro1BdlKVtRYQ14k2Du4lUHyRFgnbd/U0Vngfqhlmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FaQwUICHbvIo9bp5xC4+dJ6TKk4ZAh0EiWwXv1cFjIGZqu134w9xVjSzGMTNW30Ed
	 hXLmBBmlmYSjDrLQPCVrl3vQG8wR+GCFW74xY9ELGVrIyqHqNppHAPZqDtD1pXTkti
	 1RXDTz8fbYt/+HQevPMWVMiSU8iooZ/7eCwrCu5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgFJGll (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgFJGli (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 02:41:38 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F44520801;
        Wed, 10 Jun 2020 06:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591771297;
        bh=XBro1BdlKVtRYQ14k2Du4lUHyRFgnbd/U0Vngfqhlmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whM5d22uH9TKOCIjY//5/xA8coZirvZ+A3N/bfi7lsqWKShzxtiHAjk9ts6EXK84G
         OOnWS6AygV6kvGm+rKogcJHSVqJeuuQWKY9M+gQY3A9XNuUMkEiFG/1oc3gpN0rpDL
         KBtHhuphg3b7HGHd5ADGrQEuyzgXUqp2Iv8aNJTQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] crc-t10dif: clean up some more things
Date:   Tue,  9 Jun 2020 23:39:43 -0700
Message-Id: <20200610063943.378796-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610063943.378796-1-ebiggers@kernel.org>
References: <20200610063943.378796-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

- Correctly compare the algorithm name in crc_t10dif_notify().

- Use proper NOTIFY_* status codes instead of 0.

- Consistently use CRC_T10DIF_STRING instead of "crct10dif" directly.

- Use a proper type for the shash_desc context.

- Use crypto_shash_driver_name() instead of open-coding it.

- Make crc_t10dif_transform_show() use snprintf() rather than sprintf().
  This isn't actually necessary since the buffer has size PAGE_SIZE
  and CRYPTO_MAX_ALG_NAME < PAGE_SIZE, but it's good practice.

- Give the "transform" sysfs file mode 0444 rather than 0644,
  since it doesn't implement a setter method.

- Adjust the module description to not be the same as crct10dif-generic.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crc-t10dif.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index af3613367ef944..1ed2ed4870971e 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -26,11 +26,11 @@ static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, voi
 	struct crypto_alg *alg = data;
 
 	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
-		return 0;
+	    strcmp(alg->cra_name, CRC_T10DIF_STRING))
+		return NOTIFY_DONE;
 
 	schedule_work(&crct10dif_rehash_work);
-	return 0;
+	return NOTIFY_OK;
 }
 
 static void crc_t10dif_rehash(struct work_struct *work)
@@ -40,7 +40,7 @@ static void crc_t10dif_rehash(struct work_struct *work)
 	mutex_lock(&crc_t10dif_mutex);
 	old = rcu_dereference_protected(crct10dif_tfm,
 					lockdep_is_held(&crc_t10dif_mutex));
-	new = crypto_alloc_shash("crct10dif", 0, 0);
+	new = crypto_alloc_shash(CRC_T10DIF_STRING, 0, 0);
 	if (IS_ERR(new)) {
 		mutex_unlock(&crc_t10dif_mutex);
 		return;
@@ -64,7 +64,7 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[2];
+		__u16 crc;
 	} desc;
 	int err;
 
@@ -73,14 +73,13 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 
 	rcu_read_lock();
 	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
-	*(__u16 *)desc.ctx = crc;
-
+	desc.crc = crc;
 	err = crypto_shash_update(&desc.shash, buffer, len);
 	rcu_read_unlock();
 
 	BUG_ON(err);
 
-	return *(__u16 *)desc.ctx;
+	return desc.crc;
 }
 EXPORT_SYMBOL(crc_t10dif_update);
 
@@ -111,7 +110,6 @@ module_exit(crc_t10dif_mod_fini);
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
 	struct crypto_shash *tfm;
-	const char *name;
 	int len;
 
 	if (static_branch_unlikely(&crct10dif_fallback))
@@ -119,15 +117,15 @@ static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp
 
 	rcu_read_lock();
 	tfm = rcu_dereference(crct10dif_tfm);
-	name = crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
-	len = sprintf(buffer, "%s\n", name);
+	len = snprintf(buffer, PAGE_SIZE, "%s\n",
+		       crypto_shash_driver_name(tfm));
 	rcu_read_unlock();
 
 	return len;
 }
 
-module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
+module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0444);
 
-MODULE_DESCRIPTION("T10 DIF CRC calculation");
+MODULE_DESCRIPTION("T10 DIF CRC calculation (library API)");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: crct10dif");
-- 
2.26.2

