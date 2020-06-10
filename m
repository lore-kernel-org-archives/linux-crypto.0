Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B48C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB022081A
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591771299;
	bh=1hpfaBML1OOWVYV6GGLZ2RGNotNScSZu4UBYbMv9bvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V/FIMscbDT+EgQYdicMou6YkBlCpuwHrbBlGiXfHxgjTT5RgMpT7YB6G7iESegPjl
	 wuJbu0d5C2VM8MYRXrrhPPY2J84ervUetEvAVdqkOelqdwGjis8/awBUDBDS8/EMM+
	 9fdn65/GxIFzCPyB7tBc4M1WQU00x8niFQlSN6+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgFJGli (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgFJGli (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 02:41:38 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4600D207ED;
        Wed, 10 Jun 2020 06:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591771297;
        bh=1hpfaBML1OOWVYV6GGLZ2RGNotNScSZu4UBYbMv9bvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeXVlfIKHONmbrFvDPP2Yj5tDMSnhNbbkyzAOPd8FiEt1OL+vNH6cntvGzT8jIGKz
         A00FIuUtlYCqBoGqG13Xew3nPHjrPNkVwufYhg37p/eNzZrpn+S+KriiMB9c7q+ToD
         rXN9YTkM6fkBZ2vCwk+hQZ3O9Bbj3vtxJqXCXqU8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] crc-t10dif: use fallback in initial state
Date:   Tue,  9 Jun 2020 23:39:42 -0700
Message-Id: <20200610063943.378796-2-ebiggers@kernel.org>
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

Currently the crc-t10dif module starts out with the fallback disabled
and crct10dif_tfm == NULL.  crc_t10dif_mod_init() tries to allocate
crct10dif_tfm, and if it fails it enables the fallback.

This is backwards because it means that any call to crc_t10dif() prior
to module_init (which could theoretically happen from built-in code)
will crash rather than use the fallback as expected.  Also, it means
that if the initial tfm allocation fails, then the fallback stays
permanently enabled even if a crct10dif implementation is loaded later.

Change it to use the more logical solution of starting with the fallback
enabled, and disabling the fallback when a tfm gets allocated for the
first time.  This change also ends up simplifying the code.

Also take the opportunity to convert the code to use the new static_key
API, which is much less confusing than the old and deprecated one.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crc-t10dif.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index c9acf1c12cfcb4..af3613367ef944 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -17,7 +17,7 @@
 #include <linux/notifier.h>
 
 static struct crypto_shash __rcu *crct10dif_tfm;
-static struct static_key crct10dif_fallback __read_mostly;
+static DEFINE_STATIC_KEY_TRUE(crct10dif_fallback);
 static DEFINE_MUTEX(crc_t10dif_mutex);
 static struct work_struct crct10dif_rehash_work;
 
@@ -26,7 +26,6 @@ static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, voi
 	struct crypto_alg *alg = data;
 
 	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    static_key_false(&crct10dif_fallback) ||
 	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
 		return 0;
 
@@ -41,10 +40,6 @@ static void crc_t10dif_rehash(struct work_struct *work)
 	mutex_lock(&crc_t10dif_mutex);
 	old = rcu_dereference_protected(crct10dif_tfm,
 					lockdep_is_held(&crc_t10dif_mutex));
-	if (!old) {
-		mutex_unlock(&crc_t10dif_mutex);
-		return;
-	}
 	new = crypto_alloc_shash("crct10dif", 0, 0);
 	if (IS_ERR(new)) {
 		mutex_unlock(&crc_t10dif_mutex);
@@ -53,8 +48,12 @@ static void crc_t10dif_rehash(struct work_struct *work)
 	rcu_assign_pointer(crct10dif_tfm, new);
 	mutex_unlock(&crc_t10dif_mutex);
 
-	synchronize_rcu();
-	crypto_free_shash(old);
+	if (old) {
+		synchronize_rcu();
+		crypto_free_shash(old);
+	} else {
+		static_branch_disable(&crct10dif_fallback);
+	}
 }
 
 static struct notifier_block crc_t10dif_nb = {
@@ -69,7 +68,7 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 	} desc;
 	int err;
 
-	if (static_key_false(&crct10dif_fallback))
+	if (static_branch_unlikely(&crct10dif_fallback))
 		return crc_t10dif_generic(crc, buffer, len);
 
 	rcu_read_lock();
@@ -93,18 +92,9 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
-	struct crypto_shash *tfm;
-
 	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
 	crypto_register_notifier(&crc_t10dif_nb);
-	mutex_lock(&crc_t10dif_mutex);
-	tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(tfm)) {
-		static_key_slow_inc(&crct10dif_fallback);
-		tfm = NULL;
-	}
-	RCU_INIT_POINTER(crct10dif_tfm, tfm);
-	mutex_unlock(&crc_t10dif_mutex);
+	crc_t10dif_rehash(&crct10dif_rehash_work);
 	return 0;
 }
 
@@ -124,20 +114,13 @@ static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp
 	const char *name;
 	int len;
 
-	if (static_key_false(&crct10dif_fallback))
+	if (static_branch_unlikely(&crct10dif_fallback))
 		return sprintf(buffer, "fallback\n");
 
 	rcu_read_lock();
 	tfm = rcu_dereference(crct10dif_tfm);
-	if (!tfm) {
-		len = sprintf(buffer, "init\n");
-		goto unlock;
-	}
-
 	name = crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
 	len = sprintf(buffer, "%s\n", name);
-
-unlock:
 	rcu_read_unlock();
 
 	return len;
-- 
2.26.2

