Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A5F372673;
	Fri, 18 Sep 2026 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789774066; cv=none; b=YKAvcpo6wMMN5994BsrPzAQp5ghtDa4CkDBi8u3pPXmMoovwsdoLlrY9Nt8qDjBCvS371cmUI7Fxt7Ucek3+RGMtgomav3UMY+bobqPhG+zz4zYKhj/b2EdWU9RVfahWZg7M6taztVFHqONFXR010VO+AEbepOccnJVrafD2ctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789774066; c=relaxed/simple;
	bh=nMR8tVXDHf2xR/FZgxrtztlcRHXvNk4iaGJSzaquUAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSsCr17q/Z5z67kd0mMzX7zvBV510ea6RuF9of7Bubrm/W0EM6dm05bwoZTk2WqGTHTgOwAKWGqD7/OGKhdY/hiW7ec7NsWir4mGXghnYtCJKYrSXEWpX2reAjtxPq1zbYzRfHdoS1ryBhdmgDcbVZ8vvus/H4Ml/hK6Ec5irmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cDq7I4l0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cDq7I4l0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=oXPS1HhvaytVgVbSDhC5/UFDpxPAgmRUlTySpL/plMA=; b=cDq7I4l0/0CJGQOFPzRgaDnU8+
	07M/khQYRh1Gh3X3VpSkHOWQdkM1Sj8heSCMG5Z0PIhMqV+oFZVvJPxT4LoAx/NhU8Ys6CnxVxBaU
	vH0cTY4V2Q18kAyRQ/dJuo2huAZlEW1Xndjlyk/xlu97TrEVXLdnI0rru71o1k/ztrKHPTkYrm5P4
	BgwTdhHv1fweC07y+K4W56ThUqD/zPvnNOHxZKuAEo4gIfqfY5wr8lW6FYJouMh8rhDdUNtDOncON
	nny2bdeb31CPqiyM3duld/mK6pTE/YoNkoxKNTzyiyichODy+CI9wp4dWOuoyq+u1S41hJbDDQJco
	jalDkdiQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7hzW-0000000Fh98-2awY;
	Fri, 18 Sep 2026 23:27:38 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
Date: Fri, 18 Sep 2026 16:27:36 -0700
Message-ID: <20260918232736.3095763-1-rdunlap@infradead.org>
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
v2: don't use private: for reserved fields; just describe them in
    kernel-doc (Tom)

Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>

 include/linux/psp-sev.h      |   86 +++++++++++++++++++++++----------
 include/uapi/linux/psp-sev.h |   26 ++++-----
 2 files changed, 73 insertions(+), 39 deletions(-)

--- linux-next-20260918.orig/include/linux/psp-sev.h
+++ linux-next-20260918/include/linux/psp-sev.h
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
@@ -157,6 +157,7 @@ enum sev_cmd {
  * struct sev_data_init - INIT command parameters
  *
  * @flags: processing flags
+ * @reserved: reserved
  * @tmr_address: system physical address used for SEV-ES
  * @tmr_len: len of tmr_address
  */
@@ -174,6 +175,7 @@ struct sev_data_init {
  * @flags: processing flags
  * @tmr_address: system physical address used for SEV-ES
  * @tmr_len: len of tmr_address
+ * @reserved: reserved
  * @nv_address: system physical address used for PSP NV storage
  * @nv_len: len of nv_address
  */
@@ -201,12 +203,13 @@ struct sev_data_pek_csr {
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
+ * @reserved: reserved
+ * @oca_cert_address: OCA certificate chain
+ * @oca_cert_len: len of OCA certificate
  */
 struct sev_data_pek_cert_import {
 	u64 pek_cert_address;			/* In */
@@ -240,8 +243,9 @@ struct sev_data_get_id {
 /**
  * struct sev_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
  *
- * @pdh_address: PDH certificate address
- * @pdh_len: len of PDH certificate
+ * @pdh_cert_address: PDH certificate address
+ * @pdh_cert_len: len of PDH certificate
+ * @reserved: reserved
  * @cert_chain_address: PDH certificate chain
  * @cert_chain_len: len of PDH certificate chain
  */
@@ -304,6 +308,7 @@ struct sev_data_guest_status {
  * @policy: guest launch policy
  * @dh_cert_address: physical address of DH certificate blob
  * @dh_cert_len: len of DH certificate blob
+ * @reserved: reserved
  * @session_address: physical address of session parameters
  * @session_len: len of session parameters
  */
@@ -321,6 +326,7 @@ struct sev_data_launch_start {
  * struct sev_data_launch_update_data - LAUNCH_UPDATE_DATA command parameter
  *
  * @handle: handle of the VM to update
+ * @reserved: reserved
  * @len: len of memory to be encrypted
  * @address: physical address of memory region to encrypt
  */
@@ -335,6 +341,7 @@ struct sev_data_launch_update_data {
  * struct sev_data_launch_update_vmsa - LAUNCH_UPDATE_VMSA command
  *
  * @handle: handle of the VM
+ * @reserved: reserved
  * @address: physical address of memory region to encrypt
  * @len: len of memory region to encrypt
  */
@@ -349,6 +356,7 @@ struct sev_data_launch_update_vmsa {
  * struct sev_data_launch_measure - LAUNCH_MEASURE command parameters
  *
  * @handle: handle of the VM to process
+ * @reserved: reserved
  * @address: physical address containing the measurement blob
  * @len: len of measurement blob
  */
@@ -363,10 +371,13 @@ struct sev_data_launch_measure {
  * struct sev_data_launch_secret - LAUNCH_SECRET command parameters
  *
  * @handle: handle of the VM to process
+ * @reserved1: reserved
  * @hdr_address: physical address containing the packet header
  * @hdr_len: len of packet header
+ * @reserved2: reserved
  * @guest_address: system physical address of guest memory region
  * @guest_len: len of guest_paddr
+ * @reserved3: reserved
  * @trans_address: physical address of transport memory buffer
  * @trans_len: len of transport memory buffer
  */
@@ -399,10 +410,13 @@ struct sev_data_launch_finish {
  * @policy: policy information for the VM
  * @pdh_cert_address: physical address containing PDH certificate
  * @pdh_cert_len: len of PDH certificate
+ * @reserved1: reserved
  * @plat_certs_address: physical address containing platform certificate
  * @plat_certs_len: len of platform certificate
+ * @reserved2: reserved
  * @amd_certs_address: physical address containing AMD certificate
  * @amd_certs_len: len of AMD certificate
+ * @reserved3: reserved
  * @session_address: physical address containing Session data
  * @session_len: len of session data
  */
@@ -423,13 +437,16 @@ struct sev_data_send_start {
 } __packed;
 
 /**
- * struct sev_data_send_update - SEND_UPDATE_DATA command
+ * struct sev_data_send_update_data - SEND_UPDATE_DATA command
  *
  * @handle: handle of the VM to process
+ * @reserved1: reserved
  * @hdr_address: physical address containing packet header
  * @hdr_len: len of packet header
+ * @reserved2: reserved
  * @guest_address: physical address of guest memory region to send
  * @guest_len: len of guest memory region to send
+ * @reserved3: reserved
  * @trans_address: physical address of host memory region
  * @trans_len: len of host memory region
  */
@@ -447,13 +464,15 @@ struct sev_data_send_update_data {
 } __packed;
 
 /**
- * struct sev_data_send_update - SEND_UPDATE_VMSA command
+ * struct sev_data_send_update_vmsa - SEND_UPDATE_VMSA command
  *
  * @handle: handle of the VM to process
  * @hdr_address: physical address containing packet header
  * @hdr_len: len of packet header
+ * @reserved2: reserved
  * @guest_address: physical address of guest memory region to send
  * @guest_len: len of guest memory region to send
+ * @reserved3: reserved
  * @trans_address: physical address of host memory region
  * @trans_len: len of host memory region
  */
@@ -491,8 +510,10 @@ struct sev_data_send_cancel {
  * struct sev_data_receive_start - RECEIVE_START command parameters
  *
  * @handle: handle of the VM to perform receive operation
+ * @policy: policy information for the VM
  * @pdh_cert_address: system physical address containing PDH certificate blob
  * @pdh_cert_len: len of PDH certificate blob
+ * @reserved1: reserved
  * @session_address: system physical address containing session blob
  * @session_len: len of session blob
  */
@@ -510,10 +531,13 @@ struct sev_data_receive_start {
  * struct sev_data_receive_update_data - RECEIVE_UPDATE_DATA command parameters
  *
  * @handle: handle of the VM to update
+ * @reserved1: reserved
  * @hdr_address: physical address containing packet header blob
  * @hdr_len: len of packet header
+ * @reserved2: reserved
  * @guest_address: system physical address of guest memory region
  * @guest_len: len of guest memory region
+ * @reserved3: reserved
  * @trans_address: system physical address of transport buffer
  * @trans_len: len of transport buffer
  */
@@ -534,10 +558,13 @@ struct sev_data_receive_update_data {
  * struct sev_data_receive_update_vmsa - RECEIVE_UPDATE_VMSA command parameters
  *
  * @handle: handle of the VM to update
+ * @reserved1: reserved
  * @hdr_address: physical address containing packet header blob
  * @hdr_len: len of packet header
+ * @reserved2: reserved
  * @guest_address: system physical address of guest memory region
  * @guest_len: len of guest memory region
+ * @reserved3: reserved
  * @trans_address: system physical address of transport buffer
  * @trans_len: len of transport buffer
  */
@@ -567,6 +594,7 @@ struct sev_data_receive_finish {
  * struct sev_data_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
  *
  * @handle: handle of the VM to perform debug operation
+ * @reserved: reserved
  * @src_addr: source address of data to operate on
  * @dst_addr: destination address of data to operate on
  * @len: len of data to operate on
@@ -583,6 +611,7 @@ struct sev_data_dbg {
  * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
  *
  * @handle: handle of the VM
+ * @reserved: reserved
  * @mnonce: a random nonce that will be included in the report.
  * @address: physical address where the report will be copied.
  * @len: length of the physical buffer.
@@ -781,9 +810,14 @@ struct sev_data_snp_guest_request {
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
@@ -841,7 +875,7 @@ struct sev_data_snp_shutdown_ex {
 } __packed;
 
 /**
- * struct sev_platform_init_args
+ * struct sev_platform_init_args - parameters for sev_platform_init()
  *
  * @error: SEV firmware error code
  * @probe: True if this is being called as part of CCP module probe, which
@@ -879,12 +913,12 @@ struct sev_data_snp_feature_info {
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
@@ -954,7 +988,7 @@ struct sev_data_snp_verify_mitigation_ds
 } __packed;
 
 /**
- * struct sev_snp_tcb_version_genoa_milan
+ * struct sev_snp_tcb_version_genoa_milan - v1 SVN payload
  *
  * @boot_loader: SVN of PSP bootloader
  * @tee: SVN of PSP operating system
@@ -971,7 +1005,7 @@ struct sev_snp_tcb_version_genoa_milan {
 };
 
 /**
- * struct sev_snp_tcb_version_turin
+ * struct sev_snp_tcb_version_turin - v2 SVN payload
  *
  * @fmc: SVN of FMC firmware
  * @boot_loader: SVN of PSP bootloader
@@ -1037,9 +1071,9 @@ int sev_platform_status(struct sev_user_
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
@@ -1056,8 +1090,8 @@ int sev_issue_cmd_external_user(struct f
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
@@ -1071,8 +1105,8 @@ int sev_guest_deactivate(struct sev_data
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
@@ -1086,7 +1120,7 @@ int sev_guest_activate(struct sev_data_a
 /**
  * sev_guest_df_flush - perform SEV DF_FLUSH command
  *
- * @sev_ret: sev command return code
+ * @error: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
@@ -1100,8 +1134,8 @@ int sev_guest_df_flush(int *error);
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
--- linux-next-20260918.orig/include/uapi/linux/psp-sev.h
+++ linux-next-20260918/include/uapi/linux/psp-sev.h
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
