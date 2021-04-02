Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CF6C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 23:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544BE6117A
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 23:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhDBXhl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 19:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbhDBXh1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 19:37:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23249C0617A9
        for <linux-crypto@vger.kernel.org>; Fri,  2 Apr 2021 16:37:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y13so10740695ybk.20
        for <linux-crypto@vger.kernel.org>; Fri, 02 Apr 2021 16:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JMPyfRrNTJEnxRsRF0NXGibkdIDx6g72IvDD8DBLBAc=;
        b=BsssdWa8zKBgRLN2ZFQnJjPi+nli3qXmA85WjJtirgXqGhT6hleG5Hlh3Oo96+AEW5
         kiOxRhErqG1FnGD8zZUoR4DZa4wk9+VGHSfx75GDTgBn19sTraD51NEJBVaa4kUiBYCE
         KgqTDnz5F+UEwEhzlD+YjPwaXYEXQ+Y8A8KEJYFHh5bCBPg4k5pibqokGtCONm8TXBiI
         BSff4ovCqEVMJYRDR8RSNBRBCG3pIM6+we6FEczBHxRBLOcXAIEB5B0MLyE3dsge/lzu
         vWBk+8byT/f9a/3TWpxBqw+HQiwWFE8+Tkv+vxcBRzH9sj5FuL4O26bVn6z87lImSWDY
         tT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JMPyfRrNTJEnxRsRF0NXGibkdIDx6g72IvDD8DBLBAc=;
        b=GVJFYMf9p2oyBQfdvUEpNtGVqcfLyT1ARKjGu39408zUmdrhFE7Ca5NjKVKAOpT5yC
         KpXHf/iN82XGGgu7yqQGLilT5m0fIkOiXGuL9K/iIhvKdR2G84MqfoYwaTAaneQ9qGOn
         iEfe3pmGtO6kH3sBEZsa1EkFQisL0EnSdExH8IcH00TKDXqm1C+ajv/hC56JXb2cpNcO
         i8tOzQZB1LBm6zHiRXDjU4VK1xGi8CIqtxrMDYeUScWoLNFXU/7sRwtsl1E8bea3vDIh
         rjDp82Pklan8YxsbP9KDd8twysAt4uSAvGhHN7LT0S536lq4sy4W9XHTFgKpsMFBkZ2s
         rTGw==
X-Gm-Message-State: AOAM532xJ8+YBCb0IA9rXOWMlZDz68qAbJCincCldaCpedNmxX4WM3id
        F41HgfU64caScgf95ow7hsaMfN/P6ac=
X-Google-Smtp-Source: ABdhPJzB76SN2pruVxE6ceq8jWS4gfeTFoN+pMwWWvM2TvEx1kPzsXm9gtZbZKYwTDuUyXxj27z4Y1x0yyU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a7:3342:da61:f6aa])
 (user=seanjc job=sendgmr) by 2002:a25:cf81:: with SMTP id f123mr21040804ybg.379.1617406643355;
 Fri, 02 Apr 2021 16:37:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Apr 2021 16:37:01 -0700
In-Reply-To: <20210402233702.3291792-1-seanjc@google.com>
Message-Id: <20210402233702.3291792-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210402233702.3291792-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 4/5] crypto: ccp: Use the stack for small SEV command buffers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For commands with small input/output buffers, use the local stack to
"allocate" the structures used to communicate with the PSP.   Now that
__sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 122 ++++++++++++++---------------------
 1 file changed, 47 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6d5882290cfc..6a380d483fce 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -402,7 +402,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
-	struct sev_data_pek_csr *data;
+	struct sev_data_pek_csr data;
 	void __user *input_address;
 	void *blob = NULL;
 	int ret;
@@ -413,29 +413,24 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	/* userspace wants to query CSR length */
-	if (!input.address || !input.length)
+	if (!input.address || !input.length) {
+		data.address = 0;
+		data.len = 0;
 		goto cmd;
+	}
 
 	/* allocate a physically contiguous buffer to store the CSR blob */
 	input_address = (void __user *)input.address;
-	if (input.length > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.length > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	blob = kmalloc(input.length, GFP_KERNEL);
-	if (!blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	if (!blob)
+		return -ENOMEM;
 
-	data->address = __psp_pa(blob);
-	data->len = input.length;
+	data.address = __psp_pa(blob);
+	data.len = input.length;
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
@@ -444,10 +439,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_blob;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -461,8 +456,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -594,7 +587,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
-	struct sev_data_pek_cert_import *data;
+	struct sev_data_pek_cert_import data;
 	void *pek_blob, *oca_blob;
 	int ret;
 
@@ -604,19 +597,14 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	/* copy PEK certificate blobs from userspace */
 	pek_blob = psp_copy_user_blob(input.pek_cert_address, input.pek_cert_len);
-	if (IS_ERR(pek_blob)) {
-		ret = PTR_ERR(pek_blob);
-		goto e_free;
-	}
+	if (IS_ERR(pek_blob))
+		return PTR_ERR(pek_blob);
 
-	data->pek_cert_address = __psp_pa(pek_blob);
-	data->pek_cert_len = input.pek_cert_len;
+	data.reserved = 0;
+	data.pek_cert_address = __psp_pa(pek_blob);
+	data.pek_cert_len = input.pek_cert_len;
 
 	/* copy PEK certificate blobs from userspace */
 	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
@@ -625,8 +613,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pek;
 	}
 
-	data->oca_cert_address = __psp_pa(oca_blob);
-	data->oca_cert_len = input.oca_cert_len;
+	data.oca_cert_address = __psp_pa(oca_blob);
+	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
@@ -635,21 +623,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_oca;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
 static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 {
 	struct sev_user_data_get_id2 input;
-	struct sev_data_get_id *data;
+	struct sev_data_get_id data;
 	void __user *input_address;
 	void *id_blob = NULL;
 	int ret;
@@ -663,28 +649,25 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 	input_address = (void __user *)input.address;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	if (input.address && input.length) {
 		id_blob = kmalloc(input.length, GFP_KERNEL);
-		if (!id_blob) {
-			kfree(data);
+		if (!id_blob)
 			return -ENOMEM;
-		}
 
-		data->address = __psp_pa(id_blob);
-		data->len = input.length;
+		data.address = __psp_pa(id_blob);
+		data.len = input.length;
+	} else {
+		data.address = 0;
+		data.len = 0;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
 	 * required length or the actual length written), return it to the user.
 	 */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -692,7 +675,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	}
 
 	if (id_blob) {
-		if (copy_to_user(input_address, id_blob, data->len)) {
+		if (copy_to_user(input_address, id_blob, data.len)) {
 			ret = -EFAULT;
 			goto e_free;
 		}
@@ -700,7 +683,6 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 e_free:
 	kfree(id_blob);
-	kfree(data);
 
 	return ret;
 }
@@ -750,7 +732,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob = NULL, *cert_blob = NULL;
-	struct sev_data_pdh_cert_export *data;
+	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
 	int ret;
@@ -768,9 +750,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
@@ -782,25 +762,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	input_cert_chain_address = (void __user *)input.cert_chain_address;
 
 	/* Allocate a physically contiguous buffer to store the PDH blob. */
-	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	/* Allocate a physically contiguous buffer to store the cert chain blob. */
-	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
-	if (!pdh_blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	if (!pdh_blob)
+		return -ENOMEM;
 
-	data->pdh_cert_address = __psp_pa(pdh_blob);
-	data->pdh_cert_len = input.pdh_cert_len;
+	data.pdh_cert_address = __psp_pa(pdh_blob);
+	data.pdh_cert_len = input.pdh_cert_len;
 
 	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
@@ -808,15 +782,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pdh;
 	}
 
-	data->cert_chain_address = __psp_pa(cert_blob);
-	data->cert_chain_len = input.cert_chain_len;
+	data.cert_chain_address = __psp_pa(cert_blob);
+	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
-	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
-	input.cert_chain_len = data->cert_chain_len;
-	input.pdh_cert_len = data->pdh_cert_len;
+	input.cert_chain_len = data.cert_chain_len;
+	input.pdh_cert_len = data.pdh_cert_len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -841,8 +815,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
-- 
2.31.0.208.g409f899ff0-goog

