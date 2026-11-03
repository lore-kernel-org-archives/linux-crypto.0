Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729453;
	b=NrOY1cg0ehqBNLxFA5O6/0rW5gdn33B16hXSLb+2cmlICzee9+p17UBqXnprzd24sNDY
	 pcKSm+jBLe8BxeJib6Q7nWH++J4k6mSs6cqyqYZ5500YFSmCxoRqmnce3c4ZRNqlvy9Qp
	 JL7sV9xLWF/9cYX4l/EHthFihWlhaE+bX0qwHLgIR/caf0oDtFUiwGr/rVvEOsE3mxNbH
	 ecN8/isAay/09a/YVNT8fgkOTLHit0gRp/9l4/wrPCnbeMsXp1+jCpSXbK/RFegdqllnK
	 5cvagXAq1zzQ+L0tFs13z4Ztu3l/Cy/hJcn4cEqX3my/TiJzxcESx65jddgjMkRMpEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IUv0LVrIai06l5dnT0TT6i3U0HxSAiBNWp3JqKX1xRQ=;
	b=CGBAgcFgUTwgF221VdL6WgdWK+vZmR+KxhETjBA2kZA3oWMVdpbthFJAP5yhMTUGcGd0
	 SGx3mctMhOAILMCJwkS7GOkzg4K4rjZI4AVnPI1ff9arIhNxsorTsnXZckbAizGBZV189
	 3kutywq5d760eNFov9jSjyZ32VeVpl4ljiPtXwL7U7AM2r/AZ+kxVRQF0cZGh038DFKrH
	 e3Lzjh7g54rBDeOjpbszemm+Q9Bt15yb+VlfegyGAGZergBhoX4brIneZXSN8Td3IN1hW
	 yg8d1TsaBiDCzUleX9RpMuCyCvhUA/XCLkl45cCVjHvPvvvpaC36l6GCBFM/+gTHFrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EUvhtt/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71847606A324;
	Tue,  3 Nov 2026 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUvhtt/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABBE1F00A02;
	Tue,  3 Nov 2026 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729453;
	bh=IUv0LVrIai06l5dnT0TT6i3U0HxSAiBNWp3JqKX1xRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUvhtt/HeM15GtcTZ9+cXYjnQmTbs71LHzTxdJiCERr4f9XMgW94Rt1T94qfJ957d
	 SWoyzXdLfjKufVOgYvNb2cPvW7SybxSsZgOEhWP1nYN5uaUroTAczYi0bU+PuBChZh
	 X8TmJYhxi8x2DpZxSVwuLahQb5f+HJRo/KctoBQeyDlGUL4R8SgfNQgcSIN2OU5Opg
	 3U92gpkW9kW3ze3LQ+vgtRCFra0gUwcEen7RxDJ1hFvCpfPBc2i6/JaS+7IfztiBZq
	 AiB/AwIB+OQH4jqthtG3Yns9AAZu+f33li0RoNkpzXgDzrqAnMoxJDM2HDZwp/jeJD
	 oYOcBFOdK7ldg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 2/2] crypto: ccp - Drop support for SNP without INIT_EX
Date: Tue,  3 Nov 2026 11:10:02 -0700
Message-ID: <20261103181002.2200214-2-tycho@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103181002.2200214-1-tycho@kernel.org>
References: <20261103181002.2200214-1-tycho@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Now that the minimum version of firmware allowed is 1.55,
__sev_snp_init_locked() no longer needs the special case for version 1.52
so delete it and its associated locals.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 110 +++++++++++++++--------------------
 1 file changed, 46 insertions(+), 64 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 13e6af5549f5..ad296c5e94dd 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1511,8 +1511,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data = {};
 	struct sev_device *sev;
-	void *arg = &data;
-	int cmd, rc = 0;
+	bool tio_supp;
+	int rc = 0;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
@@ -1532,73 +1532,56 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	if (rc)
 		return rc;
 
+	tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
+
 	/*
-	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
-	 * of system physical address ranges to convert into HV-fixed page
-	 * states during the RMP initialization.  For instance, the memory that
-	 * UEFI reserves should be included in the that list. This allows system
-	 * components that occasionally write to memory (e.g. logging to UEFI
-	 * reserved regions) to not fail due to RMP initialization and SNP
-	 * enablement.
-	 *
+	 * Firmware checks that the pages containing the ranges enumerated
+	 * in the RANGES structure are either in the default page state or in the
+	 * firmware page state.
 	 */
-	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
-		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
-
-		/*
-		 * Firmware checks that the pages containing the ranges enumerated
-		 * in the RANGES structure are either in the default page state or in the
-		 * firmware page state.
-		 */
-		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!snp_range_list) {
-			dev_err(sev->dev,
-				"SEV: SNP_INIT_EX range list memory allocation failed\n");
-			return -ENOMEM;
-		}
-
-		/*
-		 * Retrieve all reserved memory regions from the e820 memory map
-		 * to be setup as HV-fixed pages.
-		 */
-		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
-					 snp_range_list, snp_filter_reserved_mem_regions);
-		if (rc) {
-			dev_err(sev->dev,
-				"SEV: SNP_INIT_EX walk_iomem_res_desc failed rc = %d\n", rc);
-			return rc;
-		}
+	snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!snp_range_list) {
+		dev_err(sev->dev,
+			"SEV: SNP_INIT_EX range list memory allocation failed\n");
+		return -ENOMEM;
+	}
 
-		/*
-		 * Add HV_Fixed pages from other PSP sub-devices, such as SFS to the
-		 * HV_Fixed page list.
-		 */
-		snp_add_hv_fixed_pages(sev, snp_range_list);
+	/*
+	 * Retrieve all reserved memory regions from the e820 memory map
+	 * to be setup as HV-fixed pages.
+	 */
+	rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
+				 snp_range_list, snp_filter_reserved_mem_regions);
+	if (rc) {
+		dev_err(sev->dev,
+			"SEV: SNP_INIT_EX walk_iomem_res_desc failed rc = %d\n", rc);
+		return rc;
+	}
 
-		if (max_snp_asid) {
-			data.ciphertext_hiding_en = 1;
-			data.max_snp_asid = max_snp_asid;
-		}
+	/*
+	 * Add HV_Fixed pages from other PSP sub-devices, such as SFS to the
+	 * HV_Fixed page list.
+	 */
+	snp_add_hv_fixed_pages(sev, snp_range_list);
 
-		data.init_rmp = 1;
-		data.list_paddr_en = 1;
-		data.list_paddr = __psp_pa(snp_range_list);
+	if (max_snp_asid) {
+		data.ciphertext_hiding_en = 1;
+		data.max_snp_asid = max_snp_asid;
+	}
 
-		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
+	data.init_rmp = 1;
+	data.list_paddr_en = 1;
+	data.list_paddr = __psp_pa(snp_range_list);
 
-		/*
-		 * When psp_init_on_probe is disabled, the userspace calling
-		 * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
-		 * unexpected state loss.
-		 */
-		if (data.tio_en && !psp_init_on_probe)
-			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
+	data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
 
-		cmd = SEV_CMD_SNP_INIT_EX;
-	} else {
-		cmd = SEV_CMD_SNP_INIT;
-		arg = NULL;
-	}
+	/*
+	 * When psp_init_on_probe is disabled, the userspace calling
+	 * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
+	 * unexpected state loss.
+	 */
+	if (data.tio_en && !psp_init_on_probe)
+		dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
 
 	/*
 	 * The following sequence must be issued before launching the first SNP
@@ -1612,10 +1595,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	 */
 	wbinvd_on_all_cpus();
 
-	rc = __sev_do_cmd_locked(cmd, arg, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX, &data, error);
 	if (rc) {
-		dev_err(sev->dev, "SEV-SNP: %s failed rc %d, error %#x\n",
-			cmd == SEV_CMD_SNP_INIT_EX ? "SNP_INIT_EX" : "SNP_INIT",
+		dev_err(sev->dev, "SEV-SNP: SNP_INIT_EX failed rc %d, error %#x\n",
 			rc, *error);
 		return rc;
 	}
-- 
2.56.0

