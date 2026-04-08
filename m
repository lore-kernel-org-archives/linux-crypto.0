Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89FD3D3D03;
	Wed,  8 Apr 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658846; cv=none; b=kg1L1XlhV8k7rUHPCYKN288wSADOcpk//42wZJRyNkc1wkUkdgJBrYexR+4EoTIEsWIFoxpOJ+RhyO7y722KNV/X6kJHFR3JXaFoa+Ln7E/tJ/j+9fOnyZ4Cu6bAegyno5xLGD8VrFmICeuRpcIw3YBLaEgyqCBu/Zr2fr0XoLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658846; c=relaxed/simple;
	bh=eqeiAcPNJoTSStYt75yr4ts6fdSk7s1G6BqcIV2sk3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CChm55ealw3fWp4xUv16KOfsiDwaW4FRb9wf/uFTygOP1JNBQ6B0+TMXa9vTNaXM0KcZVAYR8c+2OBv3R0lXowHvix2pdKruYoNTCxdW9C4ErsH7By3ONiazXWD81CSB5Mz93pJRoVgvPn/YEZmqQzPnvCbc15CgbUh7aR2AZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+09DSAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+09DSAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52616C2BC87;
	Wed,  8 Apr 2026 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658846;
	bh=eqeiAcPNJoTSStYt75yr4ts6fdSk7s1G6BqcIV2sk3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+09DSAsZv+juc5pNeg+j9ihUj/dDi0Hrufvk3YCYrzYs2aJzJ21EKC85zfI5wXL3
	 DN7NP9D6R+cOIEMrRkeTyF9gT7cmFBwaLtABrQkC+v7Rqz5J1tqZlaETtb4jtkdzc5
	 GHYQNPACKEUdqY42xF3FuVD/9blljao8uwxa0SfNbRAfP4U5L50A1uGGgltloirsNB
	 7SujRG52zbKb1KkaJd/ah5Ga58sKU5YJ8ABbmF9BkAH4tgFYFyl1ZvyBlUleqZNbKW
	 OqW7vXCi5VOybUgyQ/Qh8XyoEzCloiyjnPn2Lr0g3kcyH9QOQjFndTo/MHKgZbJ2nj
	 DY+ykkLl3Yj9g==
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 2/4] crypto/ccp: Fix snp_filter_reserved_mem_regions() off-by-one
Date: Wed,  8 Apr 2026 08:32:57 -0600
Message-ID: <20260408143259.602767-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408143259.602767-1-tycho@kernel.org>
References: <20260408143259.602767-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Sashiko notes:

> regarding the bounds check in snp_filter_reserved_mem_regions()
> called via walk_iomem_res_desc(): does the check
> if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> allow an off-by-one heap buffer overflow?
>
> If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> PAGE_SIZE buffer.

Fix this by accounting for the entry about to be written to, in addition to
the entries that are already allocated.

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..e87efcff8df2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1328,10 +1328,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	size_t size;
 
 	/*
-	 * Ensure the list of HV_FIXED pages that will be passed to firmware
-	 * do not exceed the page-sized argument buffer.
+	 * Ensure the list of HV_FIXED pages passed to the firmware including
+	 * the one about to be written to do not exceed the page-sized argument
+	 * buffer.
 	 */
-	if ((range_list->num_elements * sizeof(struct sev_data_range) +
+	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
 	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
 		return -E2BIG;
 
-- 
2.53.0

