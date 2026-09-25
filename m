Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAFD3CFF44;
	Fri, 25 Sep 2026 05:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314373; cv=none; b=uGoKiklyLfn8wHkK8bvwQZnwgr7Nm6mEwR7kAcYXMWJ/XL3JnVnfpmd5HPU1ohofH1/eYZhMmS+dRi1TJddtjVos7/qCyOGU0c9htCvGNu601psnKCukqQnjaEgu7+4FzMDvLul2CDzI+GKrRkar1ZrFk4hwKDFeerJjBmNOxQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314373; c=relaxed/simple;
	bh=T4F1AtXOGaopsvccnl71wlmC/7QDXyejikqQn/XY7y8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fnO6g5dFvtQM3txLgnEVlqH2pHyOH2GC2nPRJJsgwBQ1OcTKE5bPEwxVISOxmcdkuDJN3KCgEMucBx+kSRDl8K5eNQttbrbc3cJApNSw336z3ycvdu0XQ+RzG4PuGGhZWcBptcZXw84ylXFioDGZEdV7t0Q8SDIxIIsrnawAysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWgLZkHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWgLZkHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051E41F000FF;
	Fri, 25 Sep 2026 05:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790314372;
	bh=xAGBELmoLKJk45xKYd6Kx/CkqQ+/Q5vwxfgOwHZoR0I=;
	h=From:To:Cc:Subject:Date;
	b=UWgLZkHhHDFli2kL6Mlga2FsfQD2u0tS20U11nIVK3GpxquNAh2yw3fL6Zo4kzvZQ
	 BxEHTy/30zhpjnj4Xu3bdTFA0xh9Y0hvFNctIE9PJUfTGtNOLZ5P30ELfkVAoIgErB
	 a8bnWAOCv0d0ZAdnlFPCdlBXEobmlPUl1IAl1LYcFDiMBYC4wJ4Vsgt0F3DzU9tC9s
	 BLqUDIlJ10wxoF4jbYNDkOBZy+7/8TKUTMwUu0pwMXirgL21/mPc2X8gGvQeiDXHE1
	 6UW6sQa0wYY+ikaN/DHI6uaZokmwmRI8/hxBjWQ2OP8FxiM8k0KDj/rb5/cPqmZnvf
	 pO3gKMaauFIHA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-doc@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] MAINTAINERS: Place libcrypto docs under CRYPTO LIBRARY
Date: Thu, 24 Sep 2026 22:32:40 -0700
Message-ID: <20260925053240.189395-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place Documentation/crypto/libcrypto* under the appropriate entry in
MAINTAINERS.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to be taken through libcrypto-next

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c52ec2d7d3c1..12647d3b367a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6980,6 +6980,7 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
+F:	Documentation/crypto/libcrypto*
 F:	lib/crypto/
 F:	scripts/crypto/
 

base-commit: 165768bb70265b5c38cf0b73fafd75be235f8b14
-- 
2.55.0

