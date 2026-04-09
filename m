Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8064133AD9C;
	Thu,  9 Apr 2026 19:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775764585; cv=none; b=KViFu8q3IpsgDGaqvm7PUYwFZCxKzbR/sfGLm6hSAYQ8Wky7b2VGh4LaAym0+GSabdIZES2oazuvszEPz256ld2zPXqMYQ0MIdqCRI1xDRRGLq4ERwTcTRQR8yIdGUM5/kPUtqYJhmySmBgEodAPKmgSjhrowvf1IlkFxqeGpnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775764585; c=relaxed/simple;
	bh=C1phezGZwkRgf4uFqBgxEKHVwDzHoZcG/lLLp/65be4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/8RMK29ewFmeTJK3xj+mvev7XxFhNBXjY6Aihr1yS4UIcuURfcFafN0YiaB2pIT4P8ao0GJd0HwammCG+NG50x4w5IRH6p9zSVH0lvhoFU1ZLXlG7Zc8FCOHrDMw/u2FBxEpdEbf2hHuwW9QwhiL+PMi0pQVKeomIUms51rSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVDk47wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVDk47wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEA4C2BCB1;
	Thu,  9 Apr 2026 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775764585;
	bh=C1phezGZwkRgf4uFqBgxEKHVwDzHoZcG/lLLp/65be4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVDk47wyJ/VDXJqfDBQLLZQqzaLVeAZsZGFk87u8jcvQlRa1Bl8r9v73em66opv70
	 nBktqqZ3s0CvW2Dq2hAEZG/xaPQpAcCln8WhVqSa2lgKNED8QgxXp9SvFzEQtxizLw
	 gFYlOzXUvIA3buoT2HSfApSlVHrqhloh803sZ3KLUnzLkYI7y0onfhMonPxIiAEaAf
	 NmXdhhC2jouf0/qKgeXkHAcCgMPwCubEgJsw40Ls8qTUTqDDS0J7lvI2G1C+0gtkFR
	 AvqtCzN4hECaN71c88NZNZsEVpqpG5b2OH39idNoT2jgkt7Zn1pEpNiGyVY6r5OhIJ
	 OZm0aVKGWExJg==
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
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v3 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
Date: Thu,  9 Apr 2026 13:56:02 -0600
Message-ID: <20260409195602.851513-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260409195602.851513-1-tycho@kernel.org>
References: <20260409195602.851513-1-tycho@kernel.org>
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
index 939fa8aa155c..a37922d3d230 100644
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
2.53.0

