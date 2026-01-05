Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50805322A1F;
	Mon,  5 Jan 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767633798; cv=none; b=tNGOMeCZIcG+RhcD6ZBcizJBqn7gexOdWqsPzhLva1eScf12Nj2Mm6QO1GrspzCAdPOQe1gDr+xtoBlKmHEPXMpjWUcu4wvU3M/WrkHIvaRy9ZG4L5j73Cu3XFQi4YnEy31fAOQSnnmB4ci1jLwAD7ZArOgqTLyg61SQvhNC6z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767633798; c=relaxed/simple;
	bh=mJAm8b+yBSmiqJk8MfSavqbSSdEBlwUfjWH2/TiT0QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiA2vWN/lLatZ9BwXCArldXA46OANyBJ+uiLcnXJKg7yrzFM2FpViryBL8RZFNAfEKoW7Vzl4/qJyZ2S7VtN+tQthY93dtZPSYkXAfjBiFriR5CT5veb1ra6uN3L1+KJtGEmx9W0mZnI9Z9y1gRk3Aqy1WyDCnH0U/6dlFAMbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVWze/fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVWze/fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8053C19421;
	Mon,  5 Jan 2026 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767633797;
	bh=mJAm8b+yBSmiqJk8MfSavqbSSdEBlwUfjWH2/TiT0QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVWze/fFemeLiBbUaoLp96+sPxtxczDxhBQneGeWiarQ7Yw0e7LabSWBAex4YgqFJ
	 0so/B4Q2im4OqHguzxJ226OEBrQrpdJZUds1JdjqUIJ1AFc1IHyQpPDHUfp4n8hiqw
	 hIxkzGKOgd+Z8p6Jsbsm/4FxAxjj4y/QgttUkQV0YmG6WJbXMbprSWFbPA18t/VHnO
	 RE84MP/hbofXSaWT0TKAvhEf8zHbcOOtw0dGfSbv2W4C835PlyYY/5f0xvr+npSfxS
	 o25PM06QEJRBiP2I7gz9iM+d9d9eyzucxamxp0gBnEG7I/ao/x9UP4+gqx8SX3gnOZ
	 MTIlPQ1uzmBuQ==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH 2/2] crypto/ccp: narrow scope of snp_range_list
Date: Mon,  5 Jan 2026 10:22:18 -0700
Message-ID: <20260105172218.39993-2-tycho@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105172218.39993-1-tycho@kernel.org>
References: <20260105172218.39993-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

snp_range_list is only used in __sev_snp_init_locked() in the SNP_INIT_EX
case, move the declaration there and add a __free() cleanup helper for it
instead of waiting until shutdown.

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6e6011e363e3..1cdadddb744e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -127,13 +127,6 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
 #define NV_LENGTH (32 * 1024)
 static void *sev_init_ex_buffer;
 
-/*
- * SEV_DATA_RANGE_LIST:
- *   Array containing range of pages that firmware transitions to HV-fixed
- *   page state.
- */
-static struct sev_data_range_list *snp_range_list;
-
 static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
@@ -1361,6 +1354,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
+	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
 	struct sev_device *sev;
@@ -2780,11 +2774,6 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 		sev_init_ex_buffer = NULL;
 	}
 
-	if (snp_range_list) {
-		kfree(snp_range_list);
-		snp_range_list = NULL;
-	}
-
 	__sev_snp_shutdown_locked(&error, panic);
 }
 
-- 
2.52.0

