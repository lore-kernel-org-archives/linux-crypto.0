Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160E1C43214
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00FE461076
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbhHRFj5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237812AbhHRFjy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 01:39:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C98C061796
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f3-20020a25cf030000b029055a2303fc2dso1700772ybg.11
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2SQGO8/2iXPtIUooucD/eO6bqrLtSvtEu6E7DOOItXU=;
        b=qA8e64Kb00kp6bO4xdbyLOWEmbyjhLdMbXIQIMUJC4JjQEExf8Obg/6ulAV++cbYHe
         seaB7gnldG4wphLkQH+xS7q5kkQ8f+kMlHzycIk5m0E8ouNvPs/yXkgwr3biPSljplT0
         bjQudUC4X+lSwB9gKZvaHHCLI/GJGXF6/d2oOc1bVp0xAFOVkNCMjg0KS90NJPbjlrEC
         U0b6ZqM6I0DwJdL8gZqSxlCch/BLYwzqIkcHcmAzKM9QBZfqI4Uvn2BmL4gTqCxBQ8+B
         16u22hIrO3L6Wf04EC3h23z026/oifM9o2EwkYSM/ZgR+X3rrg6Gjm20f9AwL9FOXk8F
         XRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2SQGO8/2iXPtIUooucD/eO6bqrLtSvtEu6E7DOOItXU=;
        b=buGMc89l54Z8ZkZXpN00X0dmmgfrUCYPp4dLEQ7sYAJEWFhd0N4wdnB20DXEjJKhzp
         TlU7OVGSk7+8l+7pkbQakWdyuPncjR+b+WgnD6ba4RJGSTl0b1wUzwGjGIrSOZUcJUzE
         5BByulzkIpc+kea/urimcsCdtrYR65FOTZzpXLLf9b+Jf0V62zD3sxu5lzJ+EYAyKljf
         HtDCN/DluDWLleum6jVp1rOXL4kVHYDscS549jjRIaCKpjxQWan6I+NoDHhp8GzdZBqi
         GCf8q4M2gyOu8CJu40U8mzVPef/s+fXLdg5ZPL1TII2dXfC81zlyjjR675cQrNM/LOe/
         rvYw==
X-Gm-Message-State: AOAM533HQ50sb0wcsqzCK3fL+VQyR92PzCPJdfq+3vaTSdorX2aEG1vu
        ca8/vNhvuP1qvkH1amFxNPCKzDqt0qyf
X-Google-Smtp-Source: ABdhPJzuyxVT6NsDPLtEcULjJYm+OkMq+dnnCkkgGAB0PZvq799uOfQciWoffvNxj0tn7K6NfROYF+kF/FAb
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:7bc6:: with SMTP id
 w189mr9133182ybc.160.1629265159902; Tue, 17 Aug 2021 22:39:19 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 18 Aug 2021 05:39:07 +0000
In-Reply-To: <20210818053908.1907051-1-mizhang@google.com>
Message-Id: <20210818053908.1907051-4-mizhang@google.com>
Mime-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
From:   Mingwei Zhang <mizhang@google.com>
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
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ccp/sev-dev.c is the software layer in psp that allows KVM to manage
SEV/ES/SNP enabled VMs. Since psp API provides only primitive sev command
invocation, KVM has to do extra processing that are specific only to psp
with KVM level wrapper function.

sev_bind_asid is such a KVM function that literally wraps around
sev_guest_activate in psp with extra steps like psp data structure creation
and error processing: invoking sev_guest_decommission on activation
failure.

Since sev_bind_asid code logic is purely psp specific, putting it into psp
layer should make it more robust, since KVM does not have to worry
about error handling for all asid binding callsites.

So replace the KVM pointer in sev_bind_asid with primitive arguments: asid
and handle; slightly change the name to sev_guest_bind_asid make it
consistent with other psp APIs; add the error handling code inside
sev_guest_bind_asid and; put it into the sev-dev.c.

No functional change intended.

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c       | 26 ++++----------------------
 drivers/crypto/ccp/sev-dev.c | 15 +++++++++++++++
 include/linux/psp-sev.h      | 19 +++++++++++++++++++
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b8b26a9c5369..157962aa4aff 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -252,20 +252,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
-static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
-{
-	struct sev_data_activate activate;
-	int asid = sev_get_asid(kvm);
-	int ret;
-
-	/* activate ASID on the given handle */
-	activate.handle = handle;
-	activate.asid   = asid;
-	ret = sev_guest_activate(&activate, error);
-
-	return ret;
-}
-
 static int __sev_issue_cmd(int fd, int id, void *data, int *error)
 {
 	struct fd f;
@@ -336,11 +322,9 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_session;
 
 	/* Bind ASID to this guest */
-	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret) {
-		sev_guest_decommission(start.handle, NULL);
+	ret = sev_guest_bind_asid(sev_get_asid(kvm), start.handle, error);
+	if (ret)
 		goto e_free_session;
-	}
 
 	/* return handle to userspace */
 	params.handle = start.handle;
@@ -1385,11 +1369,9 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_session;
 
 	/* Bind ASID to this guest */
-	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret) {
-		sev_guest_decommission(start.handle, NULL);
+	ret = sev_guest_bind_asid(sev_get_asid(kvm), start.handle, error);
+	if (ret)
 		goto e_free_session;
-	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e2d49bedc0ef..325e79360d9e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -903,6 +903,21 @@ int sev_guest_activate(struct sev_data_activate *data, int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_activate);
 
+int sev_guest_bind_asid(int asid, unsigned int handle, int *error)
+{
+	struct sev_data_activate activate;
+	int ret;
+
+	/* activate ASID on the given handle */
+	activate.handle = handle;
+	activate.asid   = asid;
+	ret = sev_guest_activate(&activate, error);
+	if (ret)
+		sev_guest_decommission(handle, NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sev_guest_bind_asid);
+
 int sev_guest_decommission(unsigned int handle, int *error)
 {
 	struct sev_data_decommission decommission;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 6c0f2f451c89..be50446ff3f1 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -595,6 +595,22 @@ int sev_guest_deactivate(struct sev_data_deactivate *data, int *error);
  */
 int sev_guest_activate(struct sev_data_activate *data, int *error);
 
+/**
+ * sev_guest_bind_asid - bind an ASID with VM and does decommission on failure
+ *
+ * @asid: current ASID of the VM
+ * @handle: handle of the VM to retrieve status
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_bind_asid(int asid, unsigned int handle, int *error);
+
 /**
  * sev_guest_df_flush - perform SEV DF_FLUSH command
  *
@@ -643,6 +659,9 @@ sev_guest_decommission(unsigned int handle, int *error) { return -ENODEV; }
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_guest_bind_asid(int asid, unsigned int handle, int *error) { return -ENODEV; }
+
 static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
 
 static inline int
-- 
2.33.0.rc1.237.g0d66db33f3-goog

