Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EFA3469EE
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907203; cv=none; b=ElAR1BRtgtGGtS2s7N1tHVI6u7lhsrb0jHWx8zHWFp5OMxX3DfXhpGMtEEB7iRxuzjd29pRflQ+oz7F2nXeUEOLCyg/dS9P63Oz5m97eiuFjjaJsZJbyzsBOjGVXD+RYyA4+4p26ZDpJo5Tf89HBIuXE+iWFOsVqABLAOYlQoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907203; c=relaxed/simple;
	bh=OTHWBoff2PzsQfKx5tYIGytixloTvdhFhmJWQ7BVRmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tTgQqsMGQlV0Bx+GfKRGBICV8byUFOg8aD/6G9/DsDICnj7W6a7zDtqCaPp/cQloYdE7FTDD+S27eQLVYc7w49zouu5VX4hdVSlrJGoaK3WDpMx+Nzl7x8tpt3czdf17YO6tMEqGX5QTblNgWomlEKmC/l2ka3QfpG85aOWaIZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JIEniFNI; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JIEniFNI"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429be5aee5bso302208f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907199; x=1762511999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8r3QIAGejqa8NPmAEDiNAoce3SvTXlMmEJ2PuS5pgns=;
        b=JIEniFNIVqR68or89bm9dzpdB/YUnieWja71JcAlqbhZM+s04A1G3mgDxXdiOPRaLq
         /TMXg3Ih5DmYoPm7ouK/6UyH7BgkTWNiaArCMFf8z+7FZ1ErMA/xS9f01UnYVCn/MAGI
         CSPC7IXd/laNZQOXxyP822mXWrlH261M5B22VKfM4cKGDH8WWnXsiYimEy8nESmQm2PV
         5mD73nDG7dWiH8O1pZJKvsWwMb2B1JsvH6WfAr+77nHiHcqV3oDn62H50e0zpTPAkrAN
         UeopT1+Manbmubz0nslOACeIWICRg4/2WpYZpwCNTUU69/xOasjqb1cvDxUPnBMUY8tk
         V7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907199; x=1762511999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8r3QIAGejqa8NPmAEDiNAoce3SvTXlMmEJ2PuS5pgns=;
        b=RXf9P87gAbadMf0dTYNquPWB/5ash2zs+/Eq9MprZEQB7pdS0Jc+e4Lg0ljbBmmDA5
         7kLfNPxmnoFf4umIZ+/rDuyJl1iDCdOHq6CSHoz6hcXEJPBUkFO2YMIoy4m3MuHiSZSz
         r1GSFCUUzyUaq9eRDCsl7zJi/RGvqRndS3uMOmJIywO4MCqUaHX2czJ5iVXt5xLIJIkc
         91s3dc8FniCG+dmEilwQ6EB+JhI3R0jZnPxYwsApbEBdqrrP2KVF9c+dM+xpj0zaWaPs
         qtrnkOzDxS1INtLw0ZfCAiiGDJ1ITaKsaPpVc9YSpVEhjZihdV/UiuN8xZ5/hsspsQ7F
         Jygw==
X-Forwarded-Encrypted: i=1; AJvYcCXkHxlF67HRB8UIrzcVqeFYHWAajdyhdVjrUd5M+mauKmGsXt6TeG3Onoo+9cpPku0/xHFhxZ5PNsJhQCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi0hUX3HG7PjSbmbRbEDVMuv96aN1K8wODRnVKRYpc9euN/738
	CtJgEV2XFfW+t9ZhcQ34OUlALCmhkgFrYooKD4ivZ70/GvicLB9LJ2vZjwdNR8IvMeEUvGRR6A=
	=
X-Google-Smtp-Source: AGHT+IHA3+sT6jB9B/KN6RWBYWXqri0+R/04SATB2rPp1zUItDUhniCQ0O44BM/cLxoWHqbEStWH964U
X-Received: from wmdd17.prod.google.com ([2002:a05:600c:a211:b0:475:da28:9004])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3107:b0:3eb:5ff:cb2e
 with SMTP id ffacd0b85a97d-429bd6c18c6mr2345917f8f.29.1761907199634; Fri, 31
 Oct 2025 03:39:59 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:13 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1693; i=ardb@kernel.org;
 h=from:subject; bh=OwQNFyTd57ahcVrUrGlQonZMFcw8cHUaJECkttM55ZY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4vX9e1blpTIus+YpZ055on81Z6uG6Kzv/3bW/3FVt
 VieGfW2o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEyE/TAjw+ZcN4knofcXpPy4
 84prj+PpMyWG05oFHEREzzJYzPdvVWX4Hy/3sbJlSWGW+WfZ7pZugYuliV1rvwfdWbFudeXKb3f zmAA=
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-37-ardb+git@google.com>
Subject: [PATCH v4 14/21] crypto/arm64: polyval - Switch to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Switch to the more abstract 'scoped_ksimd()' API, which will be modified
in a future patch to transparently allocate a kernel mode FP/SIMD state
buffer on the stack, so that kernel mode FP/SIMD code remains
preemptible in principe, but without the memory overhead that adds 528
bytes to the size of struct task_struct.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/polyval-ce-glue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
index c4e653688ea0..51eefbe97885 100644
--- a/arch/arm64/crypto/polyval-ce-glue.c
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -15,7 +15,7 @@
  * ARMv8 Crypto Extensions instructions to implement the finite field operations.
  */
 
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/hash.h>
 #include <crypto/polyval.h>
 #include <crypto/utils.h>
@@ -45,16 +45,14 @@ asmlinkage void pmull_polyval_mul(u8 *op1, const u8 *op2);
 static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
-	kernel_neon_begin();
-	pmull_polyval_update(keys, in, nblocks, accumulator);
-	kernel_neon_end();
+	scoped_ksimd()
+		pmull_polyval_update(keys, in, nblocks, accumulator);
 }
 
 static void internal_polyval_mul(u8 *op1, const u8 *op2)
 {
-	kernel_neon_begin();
-	pmull_polyval_mul(op1, op2);
-	kernel_neon_end();
+	scoped_ksimd()
+		pmull_polyval_mul(op1, op2);
 }
 
 static int polyval_arm64_setkey(struct crypto_shash *tfm,
-- 
2.51.1.930.gacf6e81ea2-goog

