Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBEA4921A8;
	Tue,  3 Mar 2026 19:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565349; cv=none; b=UrcUOrs68Vza6N9EXGF3hlhujJekuMCdNb9h5oHdE/9aBWgkXwvCrX47ZqduNiaEpTkJblTdMOdoXiNRlWhS3HVH5oJKqrWVd2Ew3vZYn/NHYvQQjJyYa2slI2ncUNi9aCyn0qHcAq3V205O61FI5uuYQREZQ/LHXMisP25TlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565349; c=relaxed/simple;
	bh=USzS+j/HlJJOM6USKME2ZBBT3FdqAKbYlWY6kgwo66k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvpzketLejSJAoiH6dG9cnDWNLP4pe3CyQ6zjrET1ybLqdmQuBIrHdssR9dr38NRrocYFsjNV4kLG+C0Wh0zkkcm4Ss596SnVwNohLyoVmszsuFQNCTX1W8CS0vRsqEsKOJD+m7A1vK7V1KapdBI5SE/bugRi+kpWjUwnjcDUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJb1MoIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJb1MoIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50862C116C6;
	Tue,  3 Mar 2026 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565348;
	bh=USzS+j/HlJJOM6USKME2ZBBT3FdqAKbYlWY6kgwo66k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJb1MoIVL7hZ3fnmLtklcOX/QmD/rsBl2XVsnafFu7vD3Nwq66c5KEe33FXU1iq2O
	 ScbHJeC5UtyU2l2ihTMjloA36Rm/tVOwHc/ejVG3dO12jGrlLfrdoPM3aGGd+ggxhD
	 6naSAPgDbSn6HCNr9KwjsuukrM4pMqNOhd/lBT7GT3wpbFgt4m1UCg+zjUmtWNC7xj
	 Pwc240ozooHHWZN3GoWqWTvIkIi4OM44d15wNUpHpF3nCWbeXtTuIWRaaQbbBgjXO1
	 8U//hj02Dn/a6KifmV7Ke9a/RfX+/toL8Z5SzlpZv1imQGOCIjnmkzTZe3aWlZo7fn
	 APyvRqMyqwnOQ==
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shuah Khan <shuah@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"Pratik R. Sampat" <prsampat@amd.com>
Subject: [PATCH 2/5] crypto/ccp: introduce SNP_VERIFY_MITIGATION
Date: Tue,  3 Mar 2026 12:15:06 -0700
Message-ID: <20260303191509.1565629-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303191509.1565629-1-tycho@kernel.org>
References: <20260303191509.1565629-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

These are all documented in the SEV FW document ID 56860.

These are based on the previous patch in the link, though moved out of
uapi.

Link: https://lore.kernel.org/linux-crypto/20250630202319.56331-2-prsampat@amd.com/
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
CC: "Pratik R. Sampat" <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  1 +
 include/linux/psp-sev.h      | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..9eba3fe1a27f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -222,6 +222,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_GUEST_STATUS:		return sizeof(struct sev_data_guest_status);
 	case SEV_CMD_DBG_DECRYPT:		return sizeof(struct sev_data_dbg);
 	case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
 	case SEV_CMD_SEND_START:		return sizeof(struct sev_data_send_start);
 	case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update_data);
 	case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update_vmsa);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..2b4b56632b4e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -129,6 +129,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
 	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
 	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
+	SEV_CMD_SNP_VERIFY_MITIGATION	= 0x0B2,
 	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
 	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
 	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
@@ -578,6 +579,51 @@ struct sev_data_dbg {
 	u32 len;				/* In */
 } __packed;
 
+/**
+ * struct sev_data_snp_verify_mitigation - SNP_VERIFY_MITIGATION command params
+ *
+ * @length: Length of the command buffer read by the PSP
+ * @subcommand: Mitigation sub-command for the firmware to execute.
+ * @rsvd: Reserved
+ * @vector: Bit specifying the vulnerability mitigation to process
+ * @dst_paddr_en: Destination paddr enabled
+ * @src_paddr_en: Source paddr enabled
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @src_paddr: Source address for optional input data
+ * @dst_paddr: Destination address to write the result
+ * @rsvd3: Reserved
+ */
+struct sev_data_snp_verify_mitigation {
+	u32 length;
+	u16 subcommand;
+	u16 rsvd;
+	u64 vector;
+	u32 dst_paddr_en : 1,
+	   src_paddr_en : 1,
+	   rsvd1 : 30;
+	u8 rsvd2[4];
+	u64 src_paddr;
+	u64 dst_paddr;
+	u8 rsvd3[24];
+} __packed;
+
+#define SNP_MIT_SUBCMD_REQ_STATUS	0x0
+#define SNP_MIT_SUBCMD_REQ_VERIFY	0x1
+
+/**
+ * struct snp_verify_mitigation_dst - mitigation result vectors
+ *
+ * @mit_verified_vector: Bit vector of vulnerability mitigations verified
+ * @mit_supported_vector: Bit vector of vulnerability mitigations supported
+ * @mit_failure_status: Status of the verification operation
+ */
+struct snp_verify_mitigation_dst {
+	u64 mit_verified_vector;		/* OUT */
+	u64 mit_supported_vector;		/* OUT */
+	u32 mit_failure_status;			/* OUT */
+} __packed;
+
 /**
  * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
  *
@@ -895,6 +941,7 @@ struct snp_feature_info {
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
 #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
 #define SNP_CXL_ALLOW_POLICY_SUPPORTED		BIT(5)
+#define SNP_VERIFY_MITIGATION_SUPPORTED		BIT(13)
 
 /* Feature bits in EBX */
 #define SNP_SEV_TIO_SUPPORTED			BIT(1)
-- 
2.53.0

