Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D340C35CBCB
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 23:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009942; cv=none; b=r5inHpUuNrQAim65YFIPmRY6JMN9oU52lS01Rmi8iRm9CWWZWT3SVDzn8+XtCNC/5s4I64+0Wsi04WT03w2J1I41Y3sr/kuidGpfBwVmLppBizl6v1oUh+KkuXcyWQdQmO0bkHGOdrGd6QITIEXc53Sii25oIyU4aonWbjZNC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009942; c=relaxed/simple;
	bh=bVPsmHC32xMRnbCUQzo2sQikrGCF693UprcC5PbkroU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c2H0l4qj4rpXRZcLNTjQve8r0dcLnvKzRs4xjNecpDwqAlO3hVQZA60Aq03rRaZeREAqTji5iuJCHfJTUZMLFwhEpTumv4Z7YLJ71UCqyGES3rCZsbdygPW5HqBefdg0Fz9JUkTs6IPnZuwoTwftLTL/Cv5kNYHtzF/646dxCFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fhbku1QA; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fhbku1QA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780009928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5LGH1mkBrJOdssFnEtVdpG6R6AtAmt3hnR2uiZ+kU=;
	b=fhbku1QAuBnhIqfvm5s0FPPQK3B6XIFAoLV/zwOcoCLIgFb0DZjJoPBF/PNCIsj5HU3unC
	LoRMInPlcITIuutgWFavAu+v1eNnFS+JcGcNjV76d7bBtGwbTvI7USqkJZWsN9keo+LhEo
	j8XEs+xq13SPdSHCbmm6xAggUzbJyKk=
From: Atish Patra <atish.patra@linux.dev>
Date: Thu, 28 May 2026 16:11:39 -0700
Subject: [PATCH 2/2] crypto: ccp: Fix possible deadlock in SEV init failure
 path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-sev_snp_fixes-v1-2-d67a08151779@meta.com>
References: <20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com>
In-Reply-To: <20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
 Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>, 
 Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>, 
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

__sev_platform_init_handle_init_ex_path() called
rmp_mark_pages_firmware() with locked=false but while the parent
function of init_ex_path already acquired the sev_cmd_mutex.
In case of a rmpupdate failure for any page after the first, the cleanup
path would invoke reclaim pages which would result in a deadlock in
sev_do_cmd.

Pass locked=true to honor the lock status of the parent function.

Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")

Reported-by: Chris Mason <clm@meta.com>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Atish Patra <atishp@meta.com>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..3d4793e8e34b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1557,7 +1557,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		unsigned long npages;
 
 		npages = 1UL << get_order(NV_LENGTH);
-		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
+		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
 			return -ENOMEM;
 		}

-- 
2.53.0-Meta

