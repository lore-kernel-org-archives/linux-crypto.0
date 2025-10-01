Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A434D31282B
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352653; cv=none; b=O1lStFwnWbyLZXnNUaZeKdKdLpqBZoxbds0HZhj8MA8q+H2cQqlDIMKd97F/9PsfG9bNkw7F6ONpPM6j63HnH4ufMYX9fYFJfZrQgSNQU2DffcQPcpfpV6SLfakojadcH+KM4kW8SVZ9aQuyIzu2hI5CyBpMhYWPlAwQwuAQWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352653; c=relaxed/simple;
	bh=ZgELTmYgz5fIxY25szP3ldagosc57h1+aL7duMm8keQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KTYe+epunlUjG/yYYYkygax2GkqtDSSVQknhIvc3E7umP1kJTHK9D4Z85HNPEVpSiwPK8DgyMvTGRF/5EOoHc1YQISdJpldoka1RJc8EVqL3Q92kz8vnBXcYoM4wfcglrFyOa2GSWJfxILZDVzTFi/2OHmcNHZpPC/EVYngBxfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AqV4lIUV; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AqV4lIUV"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f93db57449so103496f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352650; x=1759957450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AGpAD7So2A8Y91ye2lz/R4t8i6WlG+BPLoLmcvlg798=;
        b=AqV4lIUV0SLUhZYRWXSW4BndnhYOU63hd9R7TZC6FZvmtEj9iLQmUwwt3ApyYeENEL
         EHusT6kaccNoC8cZCSNlla52JvAJM2sDD4S+694q6PiR8eznuPdw2BSF2I7rZZ4JEMfE
         KQf7c8oP91ZSDs3aCBf7WNfFJzw+xAsaidMuoAwA3JNiYH3Z0lEsNrKjM/zFPaE6y5ur
         FreJBY4p9PTTpSOMNwgK1iLNflvagS4Vo20J8qbMGcBDn7ChnFYetl9HYnJVyqL5meLX
         j5ccSg+kbSFatYFZl7tB6b03KiNmdNiJ5rv2XYkS8NFNsUywuk8YqItRqKJgpbiAo/1z
         oxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352650; x=1759957450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AGpAD7So2A8Y91ye2lz/R4t8i6WlG+BPLoLmcvlg798=;
        b=JIb2cJwMSCl9rZNXHU5tDlWvD4Np9tqYSbAuAiSQm1X1Pnv1jfHQBTPRpmpIBytSWC
         0Km+NxVqcCVgv9orrEBK2QF3mGwA6LZ89fzMUyibGKqvPDXtPCEuSGOmdOI8Vuot61cz
         Sp+xVy5M24yKYK1pmPHCpiSXLXwqIbVapIVh+nvXRNGCkDnPDrHBMMbygIQc6B1njVyT
         9oscuYi//n9MzqVBKr4nypSvr+KSWvgyj/xXcaPcnN6zhl7PNsDdlsPh+dir4KxwM2/Y
         4O8JcaoFLFcgD5jHbWnAa8OXCG71H6Rl99sev04/YhyVVLYENUjvDPv7nTmebMCRG+7s
         zfqw==
X-Gm-Message-State: AOJu0YwrYc7J3TwCTHaICjyk62YLjE9+zCvZ7/yjUEdOwurXq0BsBtP2
	YJ19n3u4jzPboloLMBDfa5WOM61JPhHRfPUvyjctLFKPcQtG23fIkcETxjxQka6xDMi2ubbZAA=
	=
X-Google-Smtp-Source: AGHT+IHWWReVgSgZUQEq8XT+L+cxH1DIu/oJIKEaKdRtIQPT1yPlkOb9ch5vfT9GQM1XrYkcIG8pVP20
X-Received: from wrxg11.prod.google.com ([2002:a05:6000:118b:b0:403:1719:fe2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f53:0:b0:3ee:1296:d9e8
 with SMTP id ffacd0b85a97d-425577f057cmr3436647f8f.17.1759352650072; Wed, 01
 Oct 2025 14:04:10 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:18 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1156; i=ardb@kernel.org;
 h=from:subject; bh=oFEUnftgBXE3h0R5t48zlJmEk3FO4wNTPpQmOq7/RvQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePudD65SYn5avG5Dcvubcq+/Oeqwd7/dv8Lvh7dE+bzK
 E5H5/bpjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARkQRGhu9nlry9Ll7B9c5p
 S3eg+lWV5s/JX2a+vP7s0xz5d3LhTPsZ/kplbDI8nSli739/azmz6Vbd0ilZXGuOBjtYvLxl614 7jwEA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-38-ardb+git@google.com>
Subject: [PATCH v2 16/20] crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sha3-ce-glue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index b4f1001046c9..22732760edd3 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -46,9 +46,8 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 	do {
 		int rem;
 
-		kernel_neon_begin();
-		rem = sha3_ce_transform(sctx->st, data, blocks, ds);
-		kernel_neon_end();
+		scoped_ksimd()
+			rem = sha3_ce_transform(sctx->st, data, blocks, ds);
 		data += (blocks - rem) * bs;
 		blocks = rem;
 	} while (blocks);
@@ -73,9 +72,8 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 	memset(block + len, 0, bs - len);
 	block[bs - 1] |= 0x80;
 
-	kernel_neon_begin();
-	sha3_ce_transform(sctx->st, block, 1, ds);
-	kernel_neon_end();
+	scoped_ksimd()
+		sha3_ce_transform(sctx->st, block, 1, ds);
 	memzero_explicit(block , sizeof(block));
 
 	for (i = 0; i < ds / 8; i++)
-- 
2.51.0.618.g983fd99d29-goog

