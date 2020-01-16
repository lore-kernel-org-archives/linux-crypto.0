Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85A9C33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 03:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE1A6222C3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 03:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qD2RbvB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAPDNr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:13:47 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39480 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAPDNr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 22:13:47 -0500
Received: from nramas-ThinkStation-P520.corp.microsoft.com (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9AB842008710;
        Wed, 15 Jan 2020 19:13:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9AB842008710
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1579144426;
        bh=V3Ds4RpgBxSwsUsJpJvIRuEhKzlSSaeueHPFqpvVuyQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qD2RbvB8PrVXz8ZIup03tpVcqZ62lIeoP3YA0CMdl0d9DH2DnPWS0bBCUb2UJf/og
         Rjg68tIQ5D7iriC25H5esuK0XaJqqpnexBjF9STs/C23xVPy2NrWGui6KxvftZNT5O
         HnWCdb6vRAfxxivGnlGemmfBxQ/sD3YCyzq3habU=
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
To:     zohar@linux.ibm.com, dvyukov@google.com,
        James.Bottomley@HansenPartnership.com, arnd@arndb.de,
        linux-integrity@vger.kernel.org
Cc:     dhowells@redhat.com, sashal@kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] IMA: inconsistent lock state in ima_process_queued_keys
Date:   Wed, 15 Jan 2020 19:13:42 -0800
Message-Id: <20200116031342.3418-1-nramas@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ima_queued_keys() is called from a non-interrupt context, but
ima_process_queued_keys() may be called from both an interrupt
context (ima_timer_handler) and non-interrupt context
(ima_update_policy). Since the spinlock named ima_keys_lock is used
in both ima_queued_keys() and ima_process_queued_keys(),
irq version of the spinlock macros, spin_lock_irqsave() and
spin_unlock_irqrestore(), should be used[1].

This patch fixes the "inconsistent lock state" issue caused by
using the non-irq version of the spinlock macros in ima_queue_key()
and ima_process_queued_keys().

[1] Documentation/locking/spinlocks.rst

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Reported-by: syzbot <syzbot+a4a503d7f37292ae1664@syzkaller.appspotmail.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 8f5d2d06f217 ("IMA: Defined timer to free queued keys")
Fixes: 9fb38e76b5f1 ("IMA: Define workqueue for early boot key measurements")
---
 security/integrity/ima/ima_asymmetric_keys.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_asymmetric_keys.c b/security/integrity/ima/ima_asymmetric_keys.c
index 61e478f9e819..381f51708e7b 100644
--- a/security/integrity/ima/ima_asymmetric_keys.c
+++ b/security/integrity/ima/ima_asymmetric_keys.c
@@ -103,17 +103,18 @@ static bool ima_queue_key(struct key *keyring, const void *payload,
 {
 	bool queued = false;
 	struct ima_key_entry *entry;
+	unsigned long flags;
 
 	entry = ima_alloc_key_entry(keyring, payload, payload_len);
 	if (!entry)
 		return false;
 
-	spin_lock(&ima_keys_lock);
+	spin_lock_irqsave(&ima_keys_lock, flags);
 	if (!ima_process_keys) {
 		list_add_tail(&entry->list, &ima_keys);
 		queued = true;
 	}
-	spin_unlock(&ima_keys_lock);
+	spin_unlock_irqrestore(&ima_keys_lock, flags);
 
 	if (!queued)
 		ima_free_key_entry(entry);
@@ -131,6 +132,7 @@ void ima_process_queued_keys(void)
 {
 	struct ima_key_entry *entry, *tmp;
 	bool process = false;
+	unsigned long flags;
 
 	if (ima_process_keys)
 		return;
@@ -141,12 +143,12 @@ void ima_process_queued_keys(void)
 	 * First one setting the ima_process_keys flag to true will
 	 * process the queued keys.
 	 */
-	spin_lock(&ima_keys_lock);
+	spin_lock_irqsave(&ima_keys_lock, flags);
 	if (!ima_process_keys) {
 		ima_process_keys = true;
 		process = true;
 	}
-	spin_unlock(&ima_keys_lock);
+	spin_unlock_irqrestore(&ima_keys_lock, flags);
 
 	if (!process)
 		return;
-- 
2.17.1

