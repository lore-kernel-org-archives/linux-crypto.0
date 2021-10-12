Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8401C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 21:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C099360F38
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 21:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhJLVTl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhJLVTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Oct 2021 17:19:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705BBC061570
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 14:17:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i3-20020aa79083000000b003efb4fd360dso311457pfa.8
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 14:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SjtjUn7Dh89Glad70w9JbhCcm7JkioEHX9vtiCQNsAU=;
        b=oDGorw9A7leJyVXWRO9YZLEV/Q+zBqoSbqpgbA2DFoh73N+NfTbBXQcfcboB/8m4lE
         /SVQcU2ax9RCjgVnGM/z1G2j1pe21wriWuDm0BEB+cOuiWZUEy3+LC8DqK3Evr46gCD6
         m6XSb9M4RoT8Hd56Ve7XnqIFSoN1m4FNI/vaxZlMqtoNGq0ReyNb5OU1Zn7abbmBZvt6
         WlmscQXE03wsCsQ1xMTOPFDhAJGn8ITkCaNF+d3RjWZW54kXakxbBDiR9sWlOsKokpk8
         gf07MqnDBrEypvRbZ/AvbvXbpKjt/IX+q/BuINxVABs0d/cgh4N+4aIK6zgj3Asqv6xu
         7prQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SjtjUn7Dh89Glad70w9JbhCcm7JkioEHX9vtiCQNsAU=;
        b=D4qYji6btzfEB1pE7seYeODqwLz30PFADivTpEQgLRUC8nlzaj2aqHP7okziUIj4vb
         2OBAa/kz5awLpt+x3QL6ARfE/wkYwn1SivcUH7CIwm4dFMOnF0DpJxb5CFoZbfoO+e3T
         MH5hPreGND0cECqdyIrVQCxfHr2peko/Bs94g5/YwCNmbM62LdduDbknleYK6BvDTyBS
         y1U1YLi8gvBxS8uORLnyjEFcCeABaAVPaG/26qZ+PlU/d7l/NIXj2fpafaqSA1s26Cyq
         GhHGDg7ugNCOyPr/NPakYHLN2vmNoDbuomgZgjL/ueVpcuTqv0no8IjlR9Qj4QVSmaC9
         hNgA==
X-Gm-Message-State: AOAM533K1AjTkCWCyFxNgL8CVTP9vHBp3CrZnyeADeYSH7T0bDGUj5Fn
        q960cVWMttcMEub9AnKc0E/HZN66DcQ=
X-Google-Smtp-Source: ABdhPJzi5fDaRaOrJgIlxOfL+igJ7z/pbJweO3PW9kzGYRdlTChfPm6U0fzC5jOYabad0ZIZ+gcE8P5z9Ls=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:bab5:e2c:2623:d2f8])
 (user=pgonda job=sendgmr) by 2002:a62:1d46:0:b0:44d:1a4d:5d03 with SMTP id
 d67-20020a621d46000000b0044d1a4d5d03mr14637056pfd.55.1634073457873; Tue, 12
 Oct 2021 14:17:37 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:17:34 -0700
Message-Id: <20211012211734.3859621-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH V2] crypto: ccp - Consolidate sev INIT logic
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds new helper function sev_init_if_required() for use in sev_ioctl().
The function calls __sev_platform_init_locked() if the command requires
the PSP's internal state be at least SEV_STATE_INIT. This consolidates
many checks scattered through out the ioctl delegation functions.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

V2
 * Move calls of sev_init_if_required() into command specific functions
   to remove tedious command_id if statement.

 drivers/crypto/ccp/sev-dev.c | 62 +++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e09925d86bf3..3f40cc73459c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -384,26 +384,37 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
-static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
+static int sev_init_if_required(bool writable, int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (sev->state != SEV_STATE_UNINIT)
+		return 0;
+
+	if (!writable)
+		return -EPERM;
+
+	return __sev_platform_init_locked(error);
+}
+
+static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
+{
 	int rc;
 
 	if (!writable)
 		return -EPERM;
 
-	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
-		if (rc)
-			return rc;
-	}
+	rc = sev_init_if_required(writable, &argp->error);
+	if (rc)
+		return rc;
 
 	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
 }
 
 static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
-	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
 	struct sev_data_pek_csr data;
 	void __user *input_address;
@@ -413,6 +424,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	ret = sev_init_if_required(writable, &argp->error);
+	if (ret)
+		return ret;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -435,12 +450,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
-	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_blob;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
@@ -586,7 +595,6 @@ static int sev_update_firmware(struct device *dev)
 
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
-	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
 	void *pek_blob, *oca_blob;
@@ -595,6 +603,10 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	ret = sev_init_if_required(writable, &argp->error);
+	if (ret)
+		return ret;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -617,17 +629,10 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
-	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_oca;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
-e_free_oca:
 	kfree(oca_blob);
+
 e_free_pek:
 	kfree(pek_blob);
 	return ret;
@@ -730,7 +735,6 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 
 static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 {
-	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob = NULL, *cert_blob = NULL;
 	struct sev_data_pdh_cert_export data;
@@ -738,15 +742,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	void __user *input_pdh_cert_address;
 	int ret;
 
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
-		if (!writable)
-			return -EPERM;
-
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			return ret;
-	}
+	ret = sev_init_if_required(writable, &argp->error);
+	if (ret)
+		return ret;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
-- 
2.33.0.882.g93a45727a2-goog

