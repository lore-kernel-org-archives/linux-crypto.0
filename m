Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2543859E9;
	Wed, 29 Apr 2026 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478288; cv=none; b=sfTBCTKnaB3TTVuGTIKgPiZlOhpnAH8tWj76rawW+4sXc7wQQ+tggq9S+GVQ03FGb22Yw1BspFijZlPkYLycnAKculIspwzUKUUZEwceTATWt9pRchNV3XmRpwqdS2SOhVNcVjXZrucfMKmVHSNErW+dqOzWta/sC24pVG12rJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478288; c=relaxed/simple;
	bh=HfDhBkWAEEjvyGBVchpDiTztqqcaRgDG6BYq0DBcebE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGu4wRBbBciZTzuXxK6PeW/Pue/KLZgc/TfYBdn+bDqCwWFejalESjPoDc84DrCGAZ+fSE2htZJipOU4oq7ShSP1uRzKYTuPLMOUFUVnaGv4Ty6RyDJLtBcTttsbQP/Nvfu0sovdQ5/zbMqjSZN/+6WNWfCCnBsbkiVZnvxK+B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5jIQxjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5jIQxjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5398C2BCC9;
	Wed, 29 Apr 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777478288;
	bh=HfDhBkWAEEjvyGBVchpDiTztqqcaRgDG6BYq0DBcebE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5jIQxjt6bP/0xC2F9T/dQ0ypbUGZV1OaVXz7BSyfIu4SFjP40HkIlR7phq+ILE78
	 LvcTAYp+v+RpVAQ10QUEXjnu+2BFWHfHXnqPmrdCswQdodjCt8kiPgN8yToOZP3UkE
	 +Kf5JtmxzFnCMPxo4MRmB6AIXmK6V140h/BjqW7ssXWVlibJkLzfzgAwUsBvTMxxhk
	 DC4ZLP8GvVMgijB/All8/u4+NIZpoynYYt8apuF9LlX4AOkj+mN7mnBaWcr7oxaBlL
	 tj2EoMTCl5629l+Hj9zuSbgIsWDFW0qTyay067vSfy2D5tQh2jPXRMHL3iXW2UogZK
	 eJUbLEXtPlNaw==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v4 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
Date: Wed, 29 Apr 2026 09:56:36 -0600
Message-ID: <20260429155636.540040-3-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429155636.540040-1-tycho@kernel.org>
References: <20260429155636.540040-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

If snp_prepare() failed SNP_INIT will fail, so skip it and return early.
Note that this is not a change in initialization behavior: if SNP_INIT
failed before this patch, it will still return an error
__sev_snp_init_locked() and fail initialization of other SEV modes.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..78f98aee7a66 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1374,7 +1374,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
-	snp_prepare();
+	rc = snp_prepare();
+	if (rc)
+		return rc;
 
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
-- 
2.54.0

