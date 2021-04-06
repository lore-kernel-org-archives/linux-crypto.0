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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC15C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE85613D3
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbhDFWud (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbhDFWuZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F46C06175F
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so21946737ybw.7
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KV8GfpQpTpZiH9kgk6yjg0OW0xYFz416RtlhJj6iD3k=;
        b=KliXWp2g9Qy94K28mZN3A9edJ79cTeJZGPIT/dvVPG3nEZODDUlMty1dxIQkzPZVEq
         IejkcTASBjb+WMZeH44zaRuAjFaZVIMuGhu7on2VJJYY+bNLF/Apuq4bRuOmBVL67atQ
         YLot98CuvP2rYMp9cm0RdHAP4ekEqLDiG13Rni4yaK13/yGSLQyUNAO/fTg4THwyFmXX
         uSKH1OLuEKSA7QfoAimnzYpqjRYNnrysg0AzGoEpGIpGHHGBQLj00qNs8Vb/K1J7bqA1
         3krOcnpp3o9zHUEdQTjLrSPJdaELEDLB6iTLoVRaDsZ+UiYg35XzBr7LA5bx23Oia9Ex
         WCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KV8GfpQpTpZiH9kgk6yjg0OW0xYFz416RtlhJj6iD3k=;
        b=NnFTA3XRXNyBAaD60qDRpRi4IO+cMZiMrga7MAgCu4mKuQdBQJxgj5YJDirAeQRUCf
         Ql5OJTXlgR3hZDvONHtm9iWdbnIyDcDPyIFeaGMJ0RJSzgBjTsLoItFY9fQHP95pLpcA
         /estpGAf6+BHfRRlnkCYYAPO+sozknp/d3YkpqlnYrJp3JEPVOUH60kdb9uoy/8AXl7N
         gHuUUvAbnGJRxwNrOutG//bLSXZ8iH5QBdroazFAyDhn9nd4SNeh7yueOwFD/r2BGLm+
         GGNioltu9Vtk1S+aSRA5MwRBqonrFq6BOis/7as+cKn0faaZ5Ip2nQhuGyi+4m1VJmIN
         hC2w==
X-Gm-Message-State: AOAM530OKBAU5dej4WZ/AVtqErk8GLWfz5XQH8E476EvH8UfHEd0J6ca
        dTrcnK7HsV4SGtXJJnu0iyb21TlLg6U=
X-Google-Smtp-Source: ABdhPJy9XGKAT95aAkCt7uMojqdd8CgerWE4Lz4pLzTBfTrY8EHhpYRnvnE0j16oGynVgrxBClvlecyjA0w=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:da44:: with SMTP id n65mr545254ybf.68.1617749416164;
 Tue, 06 Apr 2021 15:50:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:49 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 5/8] crypto: ccp: Use the stack for small SEV command buffers
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
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
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
index 4aedbdaffe90..bb0d6de071e6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -396,7 +396,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
-	struct sev_data_pek_csr *data;
+	struct sev_data_pek_csr data;
 	void __user *input_address;
 	void *blob = NULL;
 	int ret;
@@ -407,29 +407,24 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
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
@@ -438,10 +433,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_blob;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -455,8 +450,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -588,7 +581,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
-	struct sev_data_pek_cert_import *data;
+	struct sev_data_pek_cert_import data;
 	void *pek_blob, *oca_blob;
 	int ret;
 
@@ -598,19 +591,14 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
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
@@ -619,8 +607,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pek;
 	}
 
-	data->oca_cert_address = __psp_pa(oca_blob);
-	data->oca_cert_len = input.oca_cert_len;
+	data.oca_cert_address = __psp_pa(oca_blob);
+	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
@@ -629,21 +617,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
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
@@ -657,28 +643,25 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
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
@@ -686,7 +669,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	}
 
 	if (id_blob) {
-		if (copy_to_user(input_address, id_blob, data->len)) {
+		if (copy_to_user(input_address, id_blob, data.len)) {
 			ret = -EFAULT;
 			goto e_free;
 		}
@@ -694,7 +677,6 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 e_free:
 	kfree(id_blob);
-	kfree(data);
 
 	return ret;
 }
@@ -744,7 +726,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob = NULL, *cert_blob = NULL;
-	struct sev_data_pdh_cert_export *data;
+	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
 	int ret;
@@ -762,9 +744,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
@@ -776,25 +756,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -802,15 +776,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -835,8 +809,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
-- 
2.31.0.208.g409f899ff0-goog

