Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352443CA4B3
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 22:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439825; cv=none; b=bwZG3tAdQhOTwEvsQFL0t/FP6S9aawV4vflvL773SiSXHNgsqzOisI3W2TOBwnOK+f8vxxD6GQ4B5FG4GdQFryT7LREWuYuVd2obZvHYSKKvaH/B/gqqKHNeZwiqqurQVNxAMhoi4wEh7TIeoQNwuI+5uX0GKkUghYGF41GQZCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439825; c=relaxed/simple;
	bh=jYNiQtLVpZZ7lTPv8P842pmNxaEEFedXW05/Mcqpfr0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ufZIRbAeOSpgw802n+6icVRvCdeYTMzk1kfC/5X59QtBOIoCuVAmYboBP/4BTi4p2zdEycjG4Q0E3tZKN+vbUIsmxDAR+SiUa+2NGdXCGCsgULSFeLJzBZjuZiac+MaVBq9ss+XoL0Ak89ivp1F8Md4pLTnDONddw3twVvI4w4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PJqSJABR; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PJqSJABR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780439822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k/dcKBQxfjoEPDMB8xdOqV0xZBkG7A4yvXz6y/EVP6M=;
	b=PJqSJABR7oQAgf37e8OY305ZCfXC2B8NHIya+ZCVmpv6J0CVUPRzhr/FXHdy1XSkkSrBvJ
	4+Q9N5UeijjegRq+GbqSOuC74ZGUUN6Aq0dx0BDeFY3gHRpPT65KKUd33wOZe17bamfywx
	UXSHlXVnfKCX+0tWX/zYkGHgh0qXsr8=
From: Atish Patra <atish.patra@linux.dev>
Date: Tue, 02 Jun 2026 15:36:35 -0700
Subject: [PATCH v3 4/4] crypto: ccp: Fix memory leak in SEV INIT_EX path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-sev_snp_fixes-v3-4-24bfd3ae047c@meta.com>
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
In-Reply-To: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
 Peter Gonda <pgonda@google.com>, Brijesh Singh <brijesh.singh@amd.com>, 
 Youngjae Lee <youngjaelee@meta.com>, Ashish Kalra <ashish.kalra@amd.com>, 
 Michael Roth <michael.roth@amd.com>, John Allen <john.allen@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
is left pointing at the leaked memory in case of any failures during the
function..

Fix by adding an error path that frees the pages and clears
sev_init_ex_buffer. Make sure we only free the memory if the failure
happens before the conversion. Otherwise, we may end up trying to free
up converted pages in case of reclaim failure. rmp_mark_pages_firmware
failures should be rare enough to avoid more code complexity to track
down which pages were reclaimed/leaked vs which are not.

Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3d4793e8e34b..57b4c1e79589 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1540,7 +1540,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 	if (sev_init_ex_buffer)
 		return 0;
 
-	page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(NV_LENGTH));
 	if (!page) {
 		dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
 		return -ENOMEM;
@@ -1550,7 +1550,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 
 	rc = sev_read_init_ex_file();
 	if (rc)
-		return rc;
+		goto err_free;
 
 	/* If SEV-SNP is initialized, transition to firmware page. */
 	if (sev->snp_initialized) {
@@ -1559,11 +1559,22 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		npages = 1UL << get_order(NV_LENGTH);
 		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
-			return -ENOMEM;
+			rc = -ENOMEM;
+			/*
+			 * Pages can be in an inconsistent state, don't release them back to the
+			 * system.
+			 */
+			goto err_reset;
 		}
 	}
 
 	return 0;
+
+err_free:
+	__free_pages(page, get_order(NV_LENGTH));
+err_reset:
+	sev_init_ex_buffer = NULL;
+	return rc;
 }
 
 static int __sev_platform_init_locked(int *error)

-- 
2.53.0-Meta

