Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1347278D;
	Thu, 30 Apr 2026 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565286; cv=none; b=iCzvkLHGGnT7CZgR/ASl4C1yZMWttPTncuepUj52ZLayYrj/lvmz0GcIhkNvppm0q1Xw39ShbnRqhBr1fpBuhZi8IWjCnow3YWPXeHxVtlOEXeQoqS5nt3IfVO1GAAU9jD+VNdq5Y1/cBFDZTa+CN21HUM+xR9lSolU+somHaY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565286; c=relaxed/simple;
	bh=YzGD1DNsaiZ2gMNu0AtMCMF96uvzxD5DY9G8hcz0NQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx4F1CSavMO3HyPx4wbAsJDVplOJqvME409nV9RsuFDC1SQj6CPFTK9E/CW/kx2SjlXaU4rwuGlUJJzqMkko0YatbESa1iyJyCawbrLVwykum3rOuuXRyuPx3T8PKK9fx3PRfpe1rKfvcVNOnx0uLWJ2+HrG/uR4XEcDOkDtjC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBR3CLVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBR3CLVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FACC2BCB3;
	Thu, 30 Apr 2026 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565285;
	bh=YzGD1DNsaiZ2gMNu0AtMCMF96uvzxD5DY9G8hcz0NQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBR3CLVEu/rbXXSc2FGNc3taISQaC2KoYuGCJvaXWGSfM3qTBq0RK9p0F+qBJuEqk
	 IkzZ6TiqM0LsMTeKWgYgYvgOVdzB80Bt/QvuUj81Aj1brK5juZW86TePBY/ac0OJjg
	 aG+4SHjFxXUUDMNnUm6gkgQUc22uuJweMiQw9IC1HXXGoHkvLDmSMaXRypXJwLcF+V
	 LYn68nx/ghJPdSkbzVKehwkMHoJ14XN1Wh2FyNJoHOeZDGuvMe68TKw8UU5puuWAPh
	 SrMtQBSB31yLK42nnVJUVWjnGsDyGVfkkIKNZewDngepPxcE9+5h2jJf4IJ0wzYxyv
	 rY3pvsx3XpXCA==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [RFC v1 3/6] crypto/ccp: Add DOWNLOAD_FIRMWARE_EX message struct
Date: Thu, 30 Apr 2026 10:07:13 -0600
Message-ID: <20260430160716.1120553-4-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430160716.1120553-1-tycho@kernel.org>
References: <20260430160716.1120553-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

...and appropriate sizeof() in sev_cmd_buffer_len() for use in
do_sev_cmd(). The message is documented in SEV-SNP firmware document id
56860.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c |  1 +
 include/linux/psp-sev.h      | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7ca29ccda0e7..defdc1bc226e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -252,6 +252,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
+	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d5099a2baca5..5227e901bff2 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -855,6 +855,26 @@ struct sev_platform_init_args {
 	unsigned int max_snp_asid;
 };
 
+/**
+ * struct sev_data_download_firmware_ex
+ *
+ * @len: length of the command buffer read by the PSP
+ * @rsvd0: reserved
+ * @fw_paddr: physical address of the start of the firmware blob
+ * @fw_len: length of the firmware blob
+ * @commit: whether to immediately commit the firmware update. If set, this
+ *  operation behaves like DOWNLOAD_FIRMWARE.
+ * @rsvd1: reserved
+ */
+struct sev_data_download_firmware_ex {
+	u32 len;		/* In */
+	u32 rsvd0;
+	u64 fw_paddr;		/* In */
+	u32 fw_len;		/* In */
+	u32 commit:1;		/* In */
+	u32 rsvd1:31;
+} __packed;
+
 /**
  * struct sev_data_snp_commit - SNP_COMMIT structure
  *
-- 
2.54.0

