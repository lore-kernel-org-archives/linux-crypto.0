Received: from mail187-17.suw11.mandrillapp.com (mail187-17.suw11.mandrillapp.com [198.2.187.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550733A6FB
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.187.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808071; cv=none; b=gU95SGtxcRYM+V68p1TW/IY5V70wdOd9sFs7XqUv7bQ05b6oCk/Xm9DWQW+qJSIbjU3JFsJbCgfPMvrdUYuRO7VW7Tk7v6dzo8GxTvOe5bR1cAjDmAjMBvSkcgkJ5UOZxhj85NkW7LFXtzAbSClWU5FqJEh6zyc5CnfKptF8Eko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808071; c=relaxed/simple;
	bh=r4pR/WZWgxpWH4YZ0HxKYJaXnqglOE1l6sGyaVhvDZQ=;
	h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type; b=Pl2U/cQHxysVYaIY/lgvG1odoQnDCC+46Ew8GfYUuHd4u8YWpCZxv1If3U69YiqOn82xzaFZ50j3KzaGlgjnTgR36gjUwWgYlee8I1yH6/uoQwzkjE0heiTtgnCLk44/f3tu9a20sql/ved9q5/KEei3Z5Pikpth5OrRI6k4vnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=jGllSDAK; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=Q/iO2aXO; arc=none smtp.client-ip=198.2.187.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="jGllSDAK";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="Q/iO2aXO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1765808069; x=1766078069;
	bh=MQWFgBdoUX1kknCFzw0JsezB1mvx5zyVSGtfO5OP/iE=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=jGllSDAKrGdCf6k1BpPnf3wIEyOGlVtDkO2Z9lbRLagXAIw+klaTxf2P5wPhFu+wv
	 x3GARbACpkXuRaWNSppa7dNpu0TuMn5bduhOb28yWSvbTFoSJttwR1dOEcQEgVeAhx
	 hkq9vigei0iDDXuAnEpr+hV3q6HY0VaYftacN4ThuYD22tYyoxxL6F+AuqHIJW91pA
	 QgmX95cJKOA7VHyS/gXUFupYM+R2Ysd2YtmNCVl0YUctB1WvO3Tgvyqxo3LV04I+3A
	 4ffUM3FcOu4mbI+g98YsGXULP2m8GRLBatr6pxaXyr97WhZmPjWCHRWSbeGJBiwkRH
	 EP8wZxKPX1C3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1765808069; x=1766068569; i=thomas.courrege@vates.tech;
	bh=MQWFgBdoUX1kknCFzw0JsezB1mvx5zyVSGtfO5OP/iE=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=Q/iO2aXOcIVt+PnazbkMiKw54+AJrk8A2Qo6ckKlK3dmfOE++lpXVx8j8lQnV/Iyp
	 1i0A3MX7mYh7tinNLgQXWZRoX2ZvZL+gdCg9o5TEGn8VcXEaQn0xAjc2PJRXOxk2dS
	 CVTdupxLtkOi5dDN2XG0gJAQrnuP25gRlvZs7l01hGkThtt9cpC1Q73tF5N4x7vhqb
	 ipYEsBDKk7fs8ZTzSJKYMU/l7BDHMSHhjuVrTOoV0nDO44L9LKwem7uhni+3Ch7YV7
	 OUm92inCuWc9N5m0v+fgDMSt12Q7r+XRb320WPtxdmasGzefv2tLWeP3eKDzQqfrn0
	 rUwdnWORxKkgA==
Received: from pmta09.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail187-17.suw11.mandrillapp.com (Mailchimp) with ESMTP id 4dVMWT0crtzRKVFXv
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 14:14:29 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?[PATCH=20v3]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 5ae4059d44794185ba00ec745c629ef8; Mon, 15 Dec 2025 14:14:29 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1765808068580
To: ashish.kalra@amd.com, corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com, nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com, thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, "Thomas Courrege" <thomas.courrege@vates.tech>
Message-Id: <20251215141417.2821412-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.5ae4059d44794185ba00ec745c629ef8?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251215:md
Date: Mon, 15 Dec 2025 14:14:29 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Add support for retrieving the SEV-SNP attestation report via the
SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
ioctl for SNP guests.

Signed-off-by: Thomas Courrege <thomas.courrege@vates.tech>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 128 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..083ed487764e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,33 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
 
+21. KVM_SEV_SNP_HV_REPORT_REQ
+-----------------------------
+
+The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated
+SNP attestation report. This report is produced by the PSP using the
+HV-SIGNED key selected by the caller.
+
+The ``key_sel`` field indicates which key the platform will use to sign the
+report:
+  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
+  * ``1``: Sign with VCEK.
+  * ``2``: Sign with VLEK.
+  * Other values are reserved.
+
+Parameters (in): struct kvm_sev_snp_hv_report_req
+
+Returns:  0 on success, -negative on error
+
+::
+        struct kvm_sev_snp_hv_report_req {
+                __u64 report_uaddr;
+                __u64 report_len;
+                __u8 key_sel;
+                __u8 pad0[7];
+                __u64 pad1[4];
+        };
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..464146bed784 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -743,6 +743,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_HV_REPORT_REQ,
 
 	KVM_SEV_NR_MAX,
 };
@@ -871,6 +872,14 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_hv_report_req {
+	__u64 report_uaddr;
+	__u64 report_len;
+	__u8 key_sel;
+	__u8 pad0[7];
+	__u64 pad1[4];
+};
+
 struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..ba7a07d132ff 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2261,6 +2261,63 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
+	struct sev_data_snp_hv_report_req data;
+	struct kvm_sev_snp_hv_report_req params;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	void __user *u_report;
+	void __user *u_params = u64_to_user_ptr(argp->data);
+	size_t rsp_size = sizeof(*report_rsp);
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+	if (copy_from_user(&params, u_params, sizeof(params)))
+		return -EFAULT;
+
+	if (params.report_len < rsp_size)
+		return -ENOSPC;
+
+	u_report = u64_to_user_ptr(params.report_uaddr);
+	if (!u_report)
+		return -EINVAL;
+
+	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!report_rsp)
+		return -ENOMEM;
+
+	data.len = sizeof(data);
+	data.key_sel = params.key_sel;
+	data.gctx_addr = __psp_pa(sev->snp_context);
+	data.hv_report_paddr = __psp_pa(report_rsp);
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
+				&argp->error);
+	if (ret)
+		goto e_free_rsp;
+
+	if (!report_rsp->status)
+		rsp_size += report_rsp->report_size;
+
+	if (params.report_len < rsp_size) {
+		rsp_size = sizeof(*report_rsp);
+		ret = -ENOSPC;
+	}
+
+	if (copy_to_user(u_report, report_rsp, rsp_size))
+		ret = -EFAULT;
+
+	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
+	if (copy_to_user(u_params, &params, sizeof(params)))
+		ret = -EFAULT;
+
+e_free_rsp:
+	snp_free_firmware_page(report_rsp);
+	return ret;
+}
+
 struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
@@ -2672,6 +2729,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_HV_REPORT_REQ:
+		r = sev_snp_hv_report_request(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 956ea609d0cc..5dd7c3f0d50d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -259,6 +259,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
+	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
 	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..c651a400d124 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -124,6 +124,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
 	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
 	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
 	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
 	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
@@ -594,6 +595,36 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
+ *
+ * @len: length of the command buffer in bytes
+ * @key_sel: Selects which key to use for generating the signature.
+ * @gctx_addr: System physical address of guest context page
+ * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
+ */
+struct sev_data_snp_hv_report_req {
+	u32 len;		/* In */
+	u32 key_sel	:2,	/* In */
+	    rsvd	:30;
+	u64 gctx_addr;		/* In */
+	u64 hv_report_paddr;	/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_msg_export_rsp
+ *
+ * @status: Status : 0h: Success. 16h: Invalid parameters.
+ * @report_size: Size in bytes of the attestation report
+ * @report: attestation report
+ */
+struct sev_data_snp_msg_report_rsp {
+	u32 status;			/* Out */
+	u32 report_size;		/* Out */
+	u8 rsvd[24];
+	u8 report[];
+} __packed;
+
 /**
  * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
  *
-- 
2.52.0
