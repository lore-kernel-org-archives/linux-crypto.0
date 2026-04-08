Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782A63D5256;
	Wed,  8 Apr 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658850; cv=none; b=TM4S+9m79ccdyV0ga6YMKlUOCOe+YTEV9EmaPpQr2U7V5Ow3ZavfyxKwL2BZxfd9fciDTtGll1t+9uOjKvvXPU+fN7QntldR4aQMyJijJOzYCrsCX6nMco7mEsBMpz84Kt/OQWVfqbiMJwQhMvaOJNG4VfyPKgz1yNO3XMoeZhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658850; c=relaxed/simple;
	bh=MtGTjVVC+mLYgJUWL3jI+tDSobLQGokRrpe7RX8KwkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL41JVU7/zO0p9SYDepF/jseOcbUusSi77B47VsySuySNSCm2kBHtZJI+LCtB7h9ZfDc9q60gPPK6w0f8vmamWooCIAjA7kEE+Smx1NIfuhA03U/jxk9rFnawEkVz4xGEuGTWCnE7aJmoncS9ABqzgAwsC9NVdnDhu2f5hgrnp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr6duhM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr6duhM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A659BC19421;
	Wed,  8 Apr 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658850;
	bh=MtGTjVVC+mLYgJUWL3jI+tDSobLQGokRrpe7RX8KwkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr6duhM14+/d0FsYFuIzrL/R4AgbfuBn3udk6cbDqas57kpf8bzvM3JPD4y6dsd2T
	 7uR7CsNRbsG+gXQjkxTkFQ2VK1uVIY1+fNcCwWpXtXW+AUPIjVlz2ievpGnqpyGrAn
	 n2sV4eht3ru+39CSv8KC6LOtpdIrWoTJiCy6KLrpTlTzPHIQ66ZysJjzDUo4gAUO0l
	 KZw+xomoQ2vZDmI278G54aP4X5HyRG3PsNroYGZsigPKcYQIo7/ifCI9p9Qdi5h0k8
	 y8XMotObieW32euYp+KdxzXYzoK7Z1HOtZyDDqtibZe3IVp9UtGvamrEk/tgUNxkBs
	 L84SjVc526C4g==
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
Subject: [PATCH v1 4/4] crypto/ccp: Initialize data during __sev_snp_init_locked()
Date: Wed,  8 Apr 2026 08:32:59 -0600
Message-ID: <20260408143259.602767-5-tycho@kernel.org>
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

> is the stack variable data left uninitialized when taking the else branch?
> Since data.tio_en is later evaluated unconditionally, could stack garbage
> cause it to evaluate to true, leading to erroneous attempts to allocate
> pages and initialize SEV-TIO on unsupported hardware?

If the firmware is too old to support SEV_INIT_EX, data is left
uninitialized but used in the debug logging about whether TIO is enabled or
not.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 11e2c667c0ad..7b8c1b44f2da 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1356,7 +1356,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
-	struct sev_data_snp_init_ex data;
+	struct sev_data_snp_init_ex data = {};
 	struct sev_device *sev;
 	void *arg = &data;
 	int cmd, rc = 0;
@@ -1420,8 +1420,6 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		 */
 		snp_add_hv_fixed_pages(sev, snp_range_list);
 
-		memset(&data, 0, sizeof(data));
-
 		if (max_snp_asid) {
 			data.ciphertext_hiding_en = 1;
 			data.max_snp_asid = max_snp_asid;
-- 
2.53.0

