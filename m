Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B043D4129;
	Wed,  8 Apr 2026 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658845; cv=none; b=KLedsJAATK8/urHZ4ntjJJ2gv5+pe9A7RAXChpKMSo2XtdaeSN26tbSmTyMOwoWId4cDFihhI7LAiVunqtk9g3WX+ri0OXu/WwMoa1CHaI/PaJ6I0FIVqO6ieOJtMoyMf/Hb0U4ZjE0dSvJkYA5pL8bjqd+tZBD9eXW23ZN5hwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658845; c=relaxed/simple;
	bh=zLOyvLtj9bTMX8CGZAIXsO+GTfPSYgI63sCvH3xxgSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdVzeKjU546fH57qqrkjmlMA+iXg6gILooHIw5SZ3BeRC0YT6g2FEsnxCOZMDtDHoM33BuYLeOVkuxf5JaklhuBRh4dLQuMNka+14VyO82D1syOMCgyVhElITRrvfuHZ3lxVZ99oWgKqE2iyOD8EkNHJZROIrVqNNmiKPkRBvJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vPpvVVjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPpvVVjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22B4C19424;
	Wed,  8 Apr 2026 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658845;
	bh=zLOyvLtj9bTMX8CGZAIXsO+GTfPSYgI63sCvH3xxgSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPpvVVjdGxEhmJZmspFokRd9+HQbHkBuLmtE/3GzdpOD67xQF5GHSZrjWgO0BSXdW
	 iwuG2UHcHnlJv9Dlz7jz9Dw2q9TBhkTXZKJMMqHyftaG1KaVApqSTyAM5MOpyL5AK1
	 Qia/kLPcP308jaLXqUfknd0R/6FxQRpYT3XV4mBCGAx7IE6/WHm8h5fweFPvcJNmJf
	 tsDTbJCKd+HCccRbPoEHuq52/4vd1dQs0tkcRpZi/ud4ofxrrymGVsKVy9u3bfX8FZ
	 avaWq5E+bAbbIIHEuCMLtU1XHcDSI1mNBstqHBIS12ps5OI+QBtSqw8Hr2WeUTfRzV
	 vpDMQ1oEWNOLw==
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
Subject: [PATCH v1 1/4] crypto/ccp: Reverse the cleanup order in psp_dev_destroy()
Date: Wed,  8 Apr 2026 08:32:56 -0600
Message-ID: <20260408143259.602767-2-tycho@kernel.org>
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

Before SNP x86 shutdown [1], all HV_FIXED pages were always leaked on
module unload. Now pages can be reclaimed if they are freed before SNP
shutdown.

The SFS driver does sfs_dev_destroy() -> snp_free_hv_fixed_pages(), marking
the command buffer as free. But this happens after sev_dev_destroy() in
psp_dev_destroy(), so the pages are always leaked.

Rearrange psp_dev_destroy() to destroy things in the reverse order from
psp_init(), so that any dependencies can be unwound accordingly. This lets
SFS free the page and the subsequent SNP shutdown release it.

This was identified with use of Chris Mason's review-prompts:
https://github.com/masoncl/review-prompts

[1]: https://lore.kernel.org/all/20260324161301.1353976-1-tycho@kernel.org/

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Reported-by: review-prompts
Assisted-by: Claude:claude-4.6-opus
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 5c7f7e02a7d8..b14ce51065d5 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -316,15 +316,15 @@ void psp_dev_destroy(struct sp_device *sp)
 	if (!psp)
 		return;
 
-	sev_dev_destroy(psp);
+	dbc_dev_destroy(psp);
 
-	tee_dev_destroy(psp);
+	platform_access_dev_destroy(psp);
 
 	sfs_dev_destroy(psp);
 
-	dbc_dev_destroy(psp);
+	tee_dev_destroy(psp);
 
-	platform_access_dev_destroy(psp);
+	sev_dev_destroy(psp);
 
 	sp_free_psp_irq(sp, psp);
 
-- 
2.53.0

