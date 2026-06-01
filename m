Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C2736F91F
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 23:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355103; cv=none; b=W298XM/W3dN4LkgnQbHEGN9Wr4Y09TBaeV542MBCzeZPqlzpGMdyi33mUjPMSNVIbPh+QTXgLSEdFUSqkRbg9Uec+0dHuuX/AzC+PQynZ40CAg6UAfj2MUPBCv+4A6Jd7HtVkXCM7ySLHSv5o+ltZGLocL+iAhfDwwBeUb10ZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355103; c=relaxed/simple;
	bh=bVPsmHC32xMRnbCUQzo2sQikrGCF693UprcC5PbkroU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ApkO0y28rf369e1WI0BivtEXztthThyTIP99PARtVWRR3ujQpbEweczjNgtNmOWDS/Ot4fl1LQrMSA0QJdYk356cjdl6f3f/jWckT1b1xZ+PT2T2XixhfmcEW06RIiXJCLW7BNHkv8HqtV3VNJ/LZ5k9BkPs8amMY/bPwrStPcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pxo7gb14; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pxo7gb14"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780355099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5LGH1mkBrJOdssFnEtVdpG6R6AtAmt3hnR2uiZ+kU=;
	b=Pxo7gb14u7uOLz1Y0FCkQxiXki+1pmMfjLXzJszg5UslRDvTodrpHNNb2+Lw/HjDlVEz+D
	5N3t8cHdP1cd6hsNaMZFgtImsNbE1Gon8qjLDx8Fa7CdUSl/u15ETsrasdHxS2LjfdSAd9
	1tAZyJtU8BfQ1BykPjDnyhNVRhyvISo=
From: Atish Patra <atish.patra@linux.dev>
Date: Mon, 01 Jun 2026 16:04:37 -0700
Subject: [PATCH v2 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260601-sev_snp_fixes-v2-3-611891b28a86@meta.com>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
In-Reply-To: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
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

