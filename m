Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363B9C33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 23:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEDC2072B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 23:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dNP82Xt3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgAPXqb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:46:31 -0500
Received: from linux.microsoft.com ([13.77.154.182]:57364 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbgAPXq2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 18:46:28 -0500
Received: from nramas-ThinkStation-P520.corp.microsoft.com (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id 39C3120B4798;
        Thu, 16 Jan 2020 15:46:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 39C3120B4798
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1579218387;
        bh=nQJSr6RPBnyKTrsutV6KOIA9o9XsfPqJs74csjph0zY=;
        h=From:To:Cc:Subject:Date:From;
        b=dNP82Xt3tJIuRcfYBkPaJOEgMu9iK3hC51XgjYZV6d6U9qYdhu8WURpgw5CVdGpWX
         L/AUa1B03RHNyHCBCDbcmBUsquyZFPF+2dvlhNl3dtx1r/ZfRVxTtNHS8Zjn8qYwZY
         hvqsbGnC8cQbU/iubuimwDJn2FQIwC7R5ULdODpY=
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
To:     zohar@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        linux-integrity@vger.kernel.org
Cc:     dhowells@redhat.com, sashal@kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1] IMA: pre-allocate buffer to hold keyrings string
Date:   Thu, 16 Jan 2020 15:46:23 -0800
Message-Id: <20200116234623.2959-1-nramas@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ima_match_keyring() is called while holding rcu read lock. Since this
function executes in atmomic context, it should not call any function
that can sleep (such as kstrdup()).

This patch pre-allocates a buffer to hold the keyrings string read from
the IMA policy and uses that to match the given keyring.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Fixes: e9085e0ad38a ("IMA: Add support to limit measuring keys")
---
 security/integrity/ima/ima_policy.c | 50 ++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9963863d6c92..180e2069e075 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -208,6 +208,10 @@ static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
 static struct list_head *ima_rules;
 
+/* Pre-allocated buffer used for matching keyrings. */
+static char *ima_keyrings;
+static size_t ima_keyrings_len;
+
 static int ima_policy __initdata;
 
 static int __init default_measure_policy_setup(char *str)
@@ -369,7 +373,7 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
 static bool ima_match_keyring(struct ima_rule_entry *rule,
 			      const char *keyring, const struct cred *cred)
 {
-	char *keyrings, *next_keyring, *keyrings_ptr;
+	char *next_keyring, *keyrings_ptr;
 	bool matched = false;
 
 	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
@@ -381,15 +385,13 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
 	if (!keyring)
 		return false;
 
-	keyrings = kstrdup(rule->keyrings, GFP_KERNEL);
-	if (!keyrings)
-		return false;
+	strcpy(ima_keyrings, rule->keyrings);
 
 	/*
 	 * "keyrings=" is specified in the policy in the format below:
 	 * keyrings=.builtin_trusted_keys|.ima|.evm
 	 */
-	keyrings_ptr = keyrings;
+	keyrings_ptr = ima_keyrings;
 	while ((next_keyring = strsep(&keyrings_ptr, "|")) != NULL) {
 		if (!strcmp(next_keyring, keyring)) {
 			matched = true;
@@ -397,8 +399,6 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
 		}
 	}
 
-	kfree(keyrings);
-
 	return matched;
 }
 
@@ -949,6 +949,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	bool uid_token;
 	struct ima_template_desc *template_desc;
 	int result = 0;
+	size_t keyrings_len;
 
 	ab = integrity_audit_log_start(audit_context(), GFP_KERNEL,
 				       AUDIT_INTEGRITY_POLICY_RULE);
@@ -1114,14 +1115,47 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		case Opt_keyrings:
 			ima_log_string(ab, "keyrings", args[0].from);
 
+			keyrings_len = strlen(args[0].from) + 1;
+
 			if ((entry->keyrings) ||
 			    (entry->action != MEASURE) ||
-			    (entry->func != KEY_CHECK)) {
+			    (entry->func != KEY_CHECK) ||
+			    (keyrings_len < 2)) {
 				result = -EINVAL;
 				break;
 			}
+
+			if (ima_keyrings) {
+				if (keyrings_len > ima_keyrings_len) {
+					char *tmpbuf;
+
+					tmpbuf = krealloc(ima_keyrings,
+							  keyrings_len,
+							  GFP_KERNEL);
+					if (!tmpbuf) {
+						result = -ENOMEM;
+						break;
+					}
+
+					ima_keyrings = tmpbuf;
+					ima_keyrings_len = keyrings_len;
+				}
+			} else {
+				ima_keyrings = kzalloc(keyrings_len,
+						       GFP_KERNEL);
+				if (!ima_keyrings) {
+					result = -ENOMEM;
+					break;
+				}
+
+				ima_keyrings_len = keyrings_len;
+			}
+
 			entry->keyrings = kstrdup(args[0].from, GFP_KERNEL);
 			if (!entry->keyrings) {
+				kfree(ima_keyrings);
+				ima_keyrings = NULL;
+				ima_keyrings_len = 0;
 				result = -ENOMEM;
 				break;
 			}
-- 
2.17.1

