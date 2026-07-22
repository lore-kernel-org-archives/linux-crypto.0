Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6482F9DA1;
	Wed, 22 Jul 2026 02:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784689026; cv=none; b=FagxaAri4qrnC1jQLV0Fo6lh0sWOyt7gM3ZkEq7hLpHO3zSzC3VfYWwCFHJCLZQc2WH3kc+sgLuwqC85qANL23dnv5kK4Oe7MMowXGXY+iSNfj1xVCMKtnFyYdnwIg4TULTh29VrlIS5AYqIcUPLAWXu8330x0m1LDjYwcTavT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784689026; c=relaxed/simple;
	bh=VwJapekecAXHgGnnfP97mMYGCse/AU5iXOGSSkwy9KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pihwo8JXaLqymu79yDlhRFzrS/YNeegEs++s/xXhiOLqUhQ+8eh8YI06K7YLU2yQqTjWjJTMEQNdLNc3j4ddfhmFejsV0WtnS/KrxEISWV1nolqYdNsmnOLY84lL1l+AXtVBouAa+HlTDMGUwbQW+4q1hdzvAzSwSCFRjVmCKPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFDWfWv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFDWfWv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AD51F00A3A;
	Wed, 22 Jul 2026 02:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784689023;
	bh=oL6B5yPI6RwB5+xPva+ODmso/yiH1ltTXoqrZzoHznU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFDWfWv69ybbfOfa1zOvIZFDT+fkK/woXMaYNn9stCiuyLO5eTEZy03GgR/W051JA
	 aze22L4emlU3viROLhJuSJyyg3Vl6G1Akxy/NnaZI4l3x+x5a8vRMF80IUWy81fhLX
	 feF1dYuVyxvNByXgfIFJy4DwKew+PhlEzArVAsCoFYYQatb0R8DIFNsVUo43EHe9wx
	 c832KyMRvPsLELPG1cNPk/RyQe3aZlrKfo3ccmkmLuynK4eWpZhPTi6cLcslCnPqCM
	 5jUXBw2YQRe31ms6VLNzElFPtBKJ7wNgpP8/X8wXpZX2TNIh+Q8RN3/RDIrH2TVEYd
	 B5kxiYWPpYk3g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] x86/sev: Remove obsolete virtual address check
Date: Tue, 21 Jul 2026 19:53:37 -0700
Message-ID: <20260722025338.33354-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722025338.33354-1-ebiggers@kernel.org>
References: <20260722025338.33354-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Virtual addresses used with the AES-GCM library don't have to be in the
linear mapping.  Remove the virt_addr_valid() checks from
snp_send_guest_request(), which were a workaround left over from when
this code used crypto_aead, which required scatterlists.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/coco/sev/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 54b122f6ef96a..cc292d7c6fd1e 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1867,15 +1867,6 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 	u64 seqno;
 	int rc;
 
-	/*
-	 * enc_payload() calls aesgcm_encrypt(), which can potentially offload to HW.
-	 * The offload's DMA SG list of data to encrypt has to be in linear mapping.
-	 */
-	if (!virt_addr_valid(req->req_buf) || !virt_addr_valid(req->resp_buf)) {
-		pr_warn("AES-GSM buffers must be in linear mapping");
-		return -EINVAL;
-	}
-
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-- 
2.55.0

