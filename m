Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E48C33C9E
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 00:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 497D120692
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 00:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="sa6le+kJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAHAgx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 19:36:53 -0500
Received: from linux.microsoft.com ([13.77.154.182]:54842 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgAHAgx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 19:36:53 -0500
Received: from nramas-ThinkStation-P520.corp.microsoft.com (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1854E200766E;
        Tue,  7 Jan 2020 16:36:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1854E200766E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1578443812;
        bh=uDFbL012Mn3QsfVJrcwLvdlFl64rDMvh5io3nyEQNeo=;
        h=From:To:Cc:Subject:Date:From;
        b=sa6le+kJcA1AZqAz7G7FzWIlVhQA1Y75jL8ILo67ae81XGWbeW347zan9ZBjbCtEt
         43i4cpo8jOE9OfWgDMyPqRX49sK9pr0cJiKZFn2NIjK+MgTVue6H/NwCgxOdPLu5y2
         XaTVav+j4cX+qDjxgrYY0EmKKVsX0QNn8l0kbhYk=
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
To:     zohar@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        arnd@arndb.de, linux-integrity@vger.kernel.org
Cc:     dhowells@redhat.com, sashal@kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] IMA: Defined CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS to enable IMA hook to measure keys
Date:   Tue,  7 Jan 2020 16:36:47 -0800
Message-Id: <20200108003647.2472-1-nramas@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is a tristate and not a bool.
If this config is set to "=m", ima_asymmetric_keys.c is built
as a kernel module when it is actually not.

Defined a new config CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS that is
defined when CONFIG_IMA and CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE
are defined.

Asymmetric key structure is defined only when
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is defined. Since the IMA hook
measures asymmetric keys, the IMA hook is defined in
ima_asymmetric_keys.c which is built only if
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS is defined.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reported-by: kbuild test robot <lkp@intel.com> # ima_asymmetric_keys.c
is built as a kernel module when it is actually not.
Fixes: 88e70da170e8 ("IMA: Define an IMA hook to measure keys")
Fixes: cb1aa3823c92 ("KEYS: Call the IMA hook to measure keys")
---
 include/linux/ima.h             | 4 ++--
 security/integrity/ima/Kconfig  | 6 ++++++
 security/integrity/ima/Makefile | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 3b89136bc218..f4644c54f648 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -101,7 +101,7 @@ static inline void ima_add_kexec_buffer(struct kimage *image)
 {}
 #endif
 
-#if defined(CONFIG_IMA) && defined(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE)
+#ifdef CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS
 extern void ima_post_key_create_or_update(struct key *keyring,
 					  struct key *key,
 					  const void *payload, size_t plen,
@@ -113,7 +113,7 @@ static inline void ima_post_key_create_or_update(struct key *keyring,
 						 size_t plen,
 						 unsigned long flags,
 						 bool create) {}
-#endif  /* CONFIG_IMA && CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE */
+#endif  /* CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS */
 
 #ifdef CONFIG_IMA_APPRAISE
 extern bool is_ima_appraise_enabled(void);
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 838476d780e5..355754a6b6ca 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -310,3 +310,9 @@ config IMA_APPRAISE_SIGNED_INIT
 	default n
 	help
 	   This option requires user-space init to be signed.
+
+config IMA_MEASURE_ASYMMETRIC_KEYS
+	bool
+	depends on IMA
+	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
+	default y
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 207a0a9eb72c..3e9d0ad68c7b 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -12,4 +12,4 @@ ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
 ima-$(CONFIG_IMA_APPRAISE_MODSIG) += ima_modsig.o
 ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
 obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
-obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += ima_asymmetric_keys.o
+obj-$(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) += ima_asymmetric_keys.o
-- 
2.17.1

