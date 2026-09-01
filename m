Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406421D514E;
	Tue,  1 Sep 2026 00:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221687; cv=none; b=kZddvDEdDkhC98bQGumZFaYledUl7zJv0/1VEGxQ5tl/vJEG87l3HLwMiPO1MBUcpXD0i824Klr1RPmU2hf44sGKjf/usvfdeVDHNeKbnORYoCXV8kTYRsqgIcEbVo6uZCIwcxotuRdf9WoJ3Cwvb8L6c0ag5NfG1NvMyrRMa0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221687; c=relaxed/simple;
	bh=2phUVcFadREuLRgY15OGGAA7HvvTBfoL0fe4gQ2k/mo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JdorZTPvHRQHoBOhLUf/m0JMdKCufg7mJpKHVFrklAxlFBs50bI3Kl89DTOHS1ygMylHH1FeZBlAN3YXtBXJCxMGwYqEuogMPRyfZyZ96rJqh2hNpMFcF8qqlXKYWlWqlKtL72+/loKBmWwV8P/H0MT2pEuZy6Rf85nlznwgSJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r5tA/TtD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r5tA/TtD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=QkErFzxdP4xR3lEZ5Xvl7uXKIeEFLx5j5WZFM9iT0Mc=; b=r5tA/TtDCHPV4eo5R6pEvEmcHx
	U9v3EbUqW1tx7HVfxjXP1xOZlX39CTWnv8Q65yXr+9QJM7VDQ3w5Nsy7BY2ywBoE6MixjzGHXexq5
	Q9TKyLAmIMhsMXFecRkU7d5TGNzofZxT2aqiUjShAp2CSqv/c7MWaOED2scKfo/Tnejl3zzUwdppk
	VA31KR3CVLZUGa1emKAU+MgntleKPb/DFtQReewaosyj19t9yHKI3jksNeUaOCgBaAJhO1ZqcJIc9
	9UEqGWxh+o/p2CZeKNAx3aWJh4hLderXnrkSgZa93R0eh10lredaJ0vdaMbJvTk2q+P+dlKnsajHz
	WjUPn6PQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1C9A-0000000Ahvq-0Rew;
	Tue, 01 Sep 2026 00:14:40 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
Date: Mon, 31 Aug 2026 17:14:38 -0700
Message-ID: <20260901001438.3917854-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean up kernel-doc comments to prevent warnings in both
<linux/psp-sev.h> and <uapi/linux/psp-sev.h>.

Binary files are the same before and after this patch.

include/linux/psp-sev.h: (62 lines; edited for brevity)
Warning: include/linux/psp-sev.h:52 This comment starts with '/**', but isn't a kernel-doc comment.
 * SEV platform state
Warning: include/linux/psp-sev.h:63 This comment starts with '/**', but isn't a kernel-doc comment.
 * SEV platform and guest management commands
Warning: include/linux/psp-sev.h:167 struct member 'reserved' not described in 'sev_data_init'
Warning: include/linux/psp-sev.h:187 struct member 'reserved' not described in 'sev_data_init_ex'
Warning: include/linux/psp-sev.h:216 expecting prototype for struct sev_data_cert_import. Prototype was for struct sev_data_pek_cert_import instead
Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_address' not described in 'sev_data_pdh_cert_export'
Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_len' not described in 'sev_data_pdh_cert_export'
Warning: include/linux/psp-sev.h:253 struct member 'reserved' not described in 'sev_data_pdh_cert_export'
Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_address' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_len' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
Warning: include/linux/psp-sev.h:446 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_data instead
Warning: include/linux/psp-sev.h:469 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_vmsa instead
Warning: include/linux/psp-sev.h:506 struct member 'policy' not described in 'sev_data_receive_start'
Warning: include/linux/psp-sev.h:799 struct member 'rapl_dis' not described in 'sev_data_snp_init_ex'
Warning: include/linux/psp-sev.h:799 struct member 'ciphertext_hiding_en' not described in 'sev_data_snp_init_ex'
Warning: include/linux/psp-sev.h:799 struct member 'tio_en' not described in 'sev_data_snp_init_ex'
Warning: include/linux/psp-sev.h:799 struct member 'max_snp_asid' not described in 'sev_data_snp_init_ex'
Warning: include/linux/psp-sev.h:843 missing initial short description on line:
 * struct sev_platform_init_args
Warning: include/linux/psp-sev.h:893 expecting prototype for struct feature_info. Prototype was for struct snp_feature_info instead
Warning: include/linux/psp-sev.h:956 missing initial short description on line:
 * struct sev_snp_tcb_version_genoa_milan
Warning: include/linux/psp-sev.h:973 missing initial short description on line:
 * struct sev_snp_tcb_version_turin
Warning: include/linux/psp-sev.h:1053 function parameter 'filep' not described in 'sev_issue_cmd_external_user'
Warning: include/linux/psp-sev.h:1053 function parameter 'id' not described in 'sev_issue_cmd_external_user'
Warning: include/linux/psp-sev.h:1112 function parameter 'data' not described in 'sev_guest_decommission'
Warning: include/linux/psp-sev.h:1112 function parameter 'error' not described in 'sev_guest_decommission'
Warning: include/linux/psp-sev.h:1112 Excess function parameter 'decommission' description in 'sev_guest_decommission'
Warning: include/linux/psp-sev.h:1112 Excess function parameter 'sev_ret' description in 'sev_guest_decommission'

include/uapi/linux/psp-sev.h:
Warning: include/uapi/linux/psp-sev.h:18 This comment starts with '/**', but isn't a kernel-doc comment.
 * SEV platform commands
Warning: include/uapi/linux/psp-sev.h:39 This comment starts with '/**', but isn't a kernel-doc comment.
 * SEV Firmware status code
Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_major' not described in 'sev_user_data_status'
Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_minor' not described in 'sev_user_data_status'
Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'major' description in 'sev_user_data_status' (did you mean one of: 'api_major')
Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'minor' description in 'sev_user_data_status' (did you mean one of: 'api_minor')
Warning: include/uapi/linux/psp-sev.h:153 expecting prototype for struct sev_user_data_cert_import. Prototype was for struct sev_user_data_pek_cert_import instead
Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_address' not described in 'sev_user_data_pdh_cert_export'
Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_len' not described in 'sev_user_data_pdh_cert_export'
Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_address' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_len' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
Warning: include/uapi/linux/psp-sev.h:263 expecting prototype for struct sev_data_snp_vlek_load. Prototype was for struct sev_user_data_snp_vlek_load instead
Warning: include/uapi/linux/psp-sev.h:273 expecting prototype for struct sev_user_data_snp_vlek_wrapped_vlek_hashstick. Prototype was for struct sev_user_data_snp_wrapped_vlek_hashstick instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>

 include/linux/psp-sev.h      |  114 +++++++++++++++++++++++++--------
 include/uapi/linux/psp-sev.h |   26 +++----
 2 files changed, 101 insertions(+), 39 deletions(-)

--- linux-next-20260828.orig/include/linux/psp-sev.h
+++ linux-next-20260828/include/linux/psp-sev.h
@@ -49,7 +49,7 @@
 
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
-/**
+/*
  * SEV platform state
  */
 enum sev_state {
@@ -60,7 +60,7 @@ enum sev_state {
 	SEV_STATE_MAX
 };
 
-/**
+/*
  * SEV platform and guest management commands
  */
 enum sev_cmd {
@@ -162,7 +162,9 @@ enum sev_cmd {
  */
 struct sev_data_init {
 	u32 flags;			/* In */
+	/* private: */
 	u32 reserved;			/* In */
+	/* public: */
 	u64 tmr_address;		/* In */
 	u32 tmr_len;			/* In */
 } __packed;
@@ -182,7 +184,9 @@ struct sev_data_init_ex {
 	u32 flags;                      /* In */
 	u64 tmr_address;                /* In */
 	u32 tmr_len;                    /* In */
+	/* private: */
 	u32 reserved;                   /* In */
+	/* public: */
 	u64 nv_address;                 /* In/Out */
 	u32 nv_len;                     /* In */
 } __packed;
@@ -201,17 +205,19 @@ struct sev_data_pek_csr {
 } __packed;
 
 /**
- * struct sev_data_cert_import - PEK_CERT_IMPORT command parameters
+ * struct sev_data_pek_cert_import - PEK_CERT_IMPORT command parameters
  *
- * @pek_address: PEK certificate chain
- * @pek_len: len of PEK certificate
- * @oca_address: OCA certificate chain
- * @oca_len: len of OCA certificate
+ * @pek_cert_address: PEK certificate chain
+ * @pek_cert_len: len of PEK certificate
+ * @oca_cert_address: OCA certificate chain
+ * @oca_cert_len: len of OCA certificate
  */
 struct sev_data_pek_cert_import {
 	u64 pek_cert_address;			/* In */
 	u32 pek_cert_len;			/* In */
+	/* private: */
 	u32 reserved;				/* In */
+	/* public: */
 	u64 oca_cert_address;			/* In */
 	u32 oca_cert_len;			/* In */
 } __packed;
@@ -240,15 +246,17 @@ struct sev_data_get_id {
 /**
  * struct sev_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
  *
- * @pdh_address: PDH certificate address
- * @pdh_len: len of PDH certificate
+ * @pdh_cert_address: PDH certificate address
+ * @pdh_cert_len: len of PDH certificate
  * @cert_chain_address: PDH certificate chain
  * @cert_chain_len: len of PDH certificate chain
  */
 struct sev_data_pdh_cert_export {
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In/Out */
+	/* private: */
 	u32 reserved;				/* In */
+	/* public: */
 	u64 cert_chain_address;			/* In */
 	u32 cert_chain_len;			/* In/Out */
 } __packed;
@@ -312,7 +320,9 @@ struct sev_data_launch_start {
 	u32 policy;				/* In */
 	u64 dh_cert_address;			/* In */
 	u32 dh_cert_len;			/* In */
+	/* private: */
 	u32 reserved;				/* In */
+	/* public: */
 	u64 session_address;			/* In */
 	u32 session_len;			/* In */
 } __packed;
@@ -326,7 +336,9 @@ struct sev_data_launch_start {
  */
 struct sev_data_launch_update_data {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved;
+	/* public: */
 	u64 address;				/* In */
 	u32 len;				/* In */
 } __packed;
@@ -340,7 +352,9 @@ struct sev_data_launch_update_data {
  */
 struct sev_data_launch_update_vmsa {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved;
+	/* public: */
 	u64 address;				/* In */
 	u32 len;				/* In */
 } __packed;
@@ -354,7 +368,9 @@ struct sev_data_launch_update_vmsa {
  */
 struct sev_data_launch_measure {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved;
+	/* public: */
 	u64 address;				/* In */
 	u32 len;				/* In/Out */
 } __packed;
@@ -372,13 +388,19 @@ struct sev_data_launch_measure {
  */
 struct sev_data_launch_secret {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 guest_address;			/* In */
 	u32 guest_len;				/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
 } __packed;
@@ -411,19 +433,25 @@ struct sev_data_send_start {
 	u32 policy;				/* Out */
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 plat_certs_address;			/* In */
 	u32 plat_certs_len;			/* In */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 amd_certs_address;			/* In */
 	u32 amd_certs_len;			/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 session_address;			/* In */
 	u32 session_len;			/* In/Out */
 } __packed;
 
 /**
- * struct sev_data_send_update - SEND_UPDATE_DATA command
+ * struct sev_data_send_update_data - SEND_UPDATE_DATA command
  *
  * @handle: handle of the VM to process
  * @hdr_address: physical address containing packet header
@@ -435,19 +463,25 @@ struct sev_data_send_start {
  */
 struct sev_data_send_update_data {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In/Out */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 guest_address;			/* In */
 	u32 guest_len;				/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
 } __packed;
 
 /**
- * struct sev_data_send_update - SEND_UPDATE_VMSA command
+ * struct sev_data_send_update_vmsa - SEND_UPDATE_VMSA command
  *
  * @handle: handle of the VM to process
  * @hdr_address: physical address containing packet header
@@ -461,10 +495,14 @@ struct sev_data_send_update_vmsa {
 	u32 handle;				/* In */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In/Out */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 guest_address;			/* In */
 	u32 guest_len;				/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
 } __packed;
@@ -491,6 +529,7 @@ struct sev_data_send_cancel {
  * struct sev_data_receive_start - RECEIVE_START command parameters
  *
  * @handle: handle of the VM to perform receive operation
+ * @policy: policy information for the VM
  * @pdh_cert_address: system physical address containing PDH certificate blob
  * @pdh_cert_len: len of PDH certificate blob
  * @session_address: system physical address containing session blob
@@ -501,7 +540,9 @@ struct sev_data_receive_start {
 	u32 policy;				/* In */
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 session_address;			/* In */
 	u32 session_len;			/* In */
 } __packed;
@@ -519,13 +560,19 @@ struct sev_data_receive_start {
  */
 struct sev_data_receive_update_data {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 guest_address;			/* In */
 	u32 guest_len;				/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
 } __packed;
@@ -543,13 +590,19 @@ struct sev_data_receive_update_data {
  */
 struct sev_data_receive_update_vmsa {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved1;
+	/* public: */
 	u64 hdr_address;			/* In */
 	u32 hdr_len;				/* In */
+	/* private: */
 	u32 reserved2;
+	/* public: */
 	u64 guest_address;			/* In */
 	u32 guest_len;				/* In */
+	/* private: */
 	u32 reserved3;
+	/* public: */
 	u64 trans_address;			/* In */
 	u32 trans_len;				/* In */
 } __packed;
@@ -573,7 +626,9 @@ struct sev_data_receive_finish {
  */
 struct sev_data_dbg {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved;
+	/* public: */
 	u64 src_addr;				/* In */
 	u64 dst_addr;				/* In */
 	u32 len;				/* In */
@@ -589,7 +644,9 @@ struct sev_data_dbg {
  */
 struct sev_data_attestation_report {
 	u32 handle;				/* In */
+	/* private: */
 	u32 reserved;
+	/* public: */
 	u64 address;				/* In */
 	u8 mnonce[16];				/* In */
 	u32 len;				/* In/Out */
@@ -781,9 +838,14 @@ struct sev_data_snp_guest_request {
  *
  * @init_rmp: indicate that the RMP should be initialized.
  * @list_paddr_en: indicate that list_paddr is valid
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
+ * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
  * @rsvd: reserved
  * @rsvd1: reserved
  * @list_paddr: system physical address of range list
+ * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
+ *  maximum ASID that can be used for an SEV-SNP guest.
  * @rsvd2: reserved
  */
 struct sev_data_snp_init_ex {
@@ -841,7 +903,7 @@ struct sev_data_snp_shutdown_ex {
 } __packed;
 
 /**
- * struct sev_platform_init_args
+ * struct sev_platform_init_args - parameters for sev_platform_init()
  *
  * @error: SEV firmware error code
  * @probe: True if this is being called as part of CCP module probe, which
@@ -879,12 +941,12 @@ struct sev_data_snp_feature_info {
 } __packed;
 
 /**
- * struct feature_info - FEATURE_INFO structure
+ * struct snp_feature_info - FEATURE_INFO structure
  *
  * @eax: output of SNP_FEATURE_INFO command
  * @ebx: output of SNP_FEATURE_INFO command
  * @ecx: output of SNP_FEATURE_INFO command
- * #edx: output of SNP_FEATURE_INFO command
+ * @edx: output of SNP_FEATURE_INFO command
  */
 struct snp_feature_info {
 	u32 eax;
@@ -954,7 +1016,7 @@ struct sev_data_snp_verify_mitigation_ds
 } __packed;
 
 /**
- * struct sev_snp_tcb_version_genoa_milan
+ * struct sev_snp_tcb_version_genoa_milan - v1 SVN payload
  *
  * @boot_loader: SVN of PSP bootloader
  * @tee: SVN of PSP operating system
@@ -971,7 +1033,7 @@ struct sev_snp_tcb_version_genoa_milan {
 };
 
 /**
- * struct sev_snp_tcb_version_turin
+ * struct sev_snp_tcb_version_turin - v2 SVN payload
  *
  * @fmc: SVN of FMC firmware
  * @boot_loader: SVN of PSP bootloader
@@ -1037,9 +1099,9 @@ int sev_platform_status(struct sev_user_
  * behalf of userspace. The caller must pass a valid SEV file descriptor
  * so that we know that it has access to SEV device.
  *
- * @filep - SEV device file pointer
- * @cmd - command to issue
- * @data - command buffer
+ * @filep: SEV device file pointer
+ * @id: command to issue
+ * @data: command buffer
  * @error: SEV command return code
  *
  * Returns:
@@ -1056,8 +1118,8 @@ int sev_issue_cmd_external_user(struct f
 /**
  * sev_guest_deactivate - perform SEV DEACTIVATE command
  *
- * @deactivate: sev_data_deactivate structure to be processed
- * @sev_ret: sev command return code
+ * @data: sev_data_deactivate structure to be processed
+ * @error: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
@@ -1071,8 +1133,8 @@ int sev_guest_deactivate(struct sev_data
 /**
  * sev_guest_activate - perform SEV ACTIVATE command
  *
- * @activate: sev_data_activate structure to be processed
- * @sev_ret: sev command return code
+ * @data: sev_data_activate structure to be processed
+ * @error: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
@@ -1086,7 +1148,7 @@ int sev_guest_activate(struct sev_data_a
 /**
  * sev_guest_df_flush - perform SEV DF_FLUSH command
  *
- * @sev_ret: sev command return code
+ * @error: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
@@ -1100,8 +1162,8 @@ int sev_guest_df_flush(int *error);
 /**
  * sev_guest_decommission - perform SEV DECOMMISSION command
  *
- * @decommission: sev_data_decommission structure to be processed
- * @sev_ret: sev command return code
+ * @data: sev_data_decommission structure to be processed
+ * @error: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
--- linux-next-20260828.orig/include/uapi/linux/psp-sev.h
+++ linux-next-20260828/include/uapi/linux/psp-sev.h
@@ -15,7 +15,7 @@
 
 #include <linux/types.h>
 
-/**
+/*
  * SEV platform commands
  */
 enum {
@@ -36,7 +36,7 @@ enum {
 	SEV_MAX,
 };
 
-/**
+/*
  * SEV Firmware status code
  */
 typedef enum {
@@ -109,8 +109,8 @@ typedef enum {
 /**
  * struct sev_user_data_status - PLATFORM_STATUS command parameters
  *
- * @major: major API version
- * @minor: minor API version
+ * @api_major: major API version
+ * @api_minor: minor API version
  * @state: platform state
  * @flags: platform config flags
  * @build: firmware build id for API version
@@ -139,12 +139,12 @@ struct sev_user_data_pek_csr {
 } __packed;
 
 /**
- * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
+ * struct sev_user_data_pek_cert_import - PEK_CERT_IMPORT command parameters
  *
- * @pek_address: PEK certificate chain
- * @pek_len: length of PEK certificate
- * @oca_address: OCA certificate chain
- * @oca_len: length of OCA certificate
+ * @pek_cert_address: PEK certificate chain
+ * @pek_cert_len: length of PEK certificate
+ * @oca_cert_address: OCA certificate chain
+ * @oca_cert_len: length of OCA certificate
  */
 struct sev_user_data_pek_cert_import {
 	__u64 pek_cert_address;			/* In */
@@ -156,8 +156,8 @@ struct sev_user_data_pek_cert_import {
 /**
  * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
  *
- * @pdh_address: PDH certificate address
- * @pdh_len: length of PDH certificate
+ * @pdh_cert_address: PDH certificate address
+ * @pdh_cert_len: length of PDH certificate
  * @cert_chain_address: PDH certificate chain
  * @cert_chain_len: length of PDH certificate chain
  */
@@ -248,7 +248,7 @@ struct sev_user_data_snp_config {
 } __packed;
 
 /**
- * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
+ * struct sev_user_data_snp_vlek_load - SNP_VLEK_LOAD structure
  *
  * @len: length of the command buffer read by the PSP
  * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
@@ -264,7 +264,7 @@ struct sev_user_data_snp_vlek_load {
 } __packed;
 
 /**
- * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK data
+ * struct sev_user_data_snp_wrapped_vlek_hashstick - Wrapped VLEK data
  *
  * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmware ABI
  *        1.54, SNP_VLEK_LOAD)
