Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528A346FB1
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907205; cv=none; b=oazvhEB5RhFdAndOsfZkgYsbvkTzLjHS77s74DsM990b6AvBxCEdjqiH247Q7B9FD1a6ENFpvhqpOzlKbqA9qJBk8PJAXZc8JcAqQBlh1osBf6YCcDg6wcXu0BJnnLQfkb1bpqirAIospKKEUaty4AqVQKv9S4bHylrvyVb/sCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907205; c=relaxed/simple;
	bh=PquTLJC8FZmcZb9ob1Ts3zmY8+PS/ldlDEgQ/on24C8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JiLFdqY2yaqSGyUFemJVRLEZFEkLfXgyEw2zk1xvxJespB9GAx6z49a8GnKxPaHOp+SV8nEKjb4L6sP1mS2vRBCueLFiJopJQAlWmebiDLWGwtCBpolCZT+eloifv9sJH28zSKxDD/jQehJ5svJomRTpafaC2sBRSCLP9NdmX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uhzjIFGB; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uhzjIFGB"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429b8b8d9faso932694f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907200; x=1762512000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6yWeicN1l2mf2js2fMAiSU2E7NZlQ/I1rzR2l36yFu0=;
        b=uhzjIFGBEyfs6KirzUqUX3MsSoaMn7oIoquclF7gtX11TA/+L4U0LnitU52khBV+pz
         et79ZAwaAWoqwc3tfnftBZmNTtbtzfwGgtOb2qLMy08zeQ0qh/ls7+Fztmx9hTckB+v1
         N4dLRIh0ARAGR8HvzhBFIVFBBLsDnS07Xtvkcpwu3lF96FPxv/QiRdKOaUfQY+YECegJ
         UeQ1BehmzmAIPHLnxDQ4qyB2ezNalBIjQ1xrG2EJLpTAUckXWfRgx0Sjlpy877OEnuh4
         EIbdblMVKOsnNrZUwQQw62STcn7epmYqQ1fFzi6/GfwAL0ADqO3392NF/FP1qf+awOZH
         PUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907200; x=1762512000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6yWeicN1l2mf2js2fMAiSU2E7NZlQ/I1rzR2l36yFu0=;
        b=g6fI88TYvTMjeoutF1USbIxyF3mhUl0QdcRaBb6E8GwTsIg9Y3rPKt+GhJv1YXpY7k
         NYS4/k/s9Sat+EQDPrtb/YFMdClkdO+7cfZA+X6SUDS2tF8j+ARyAifzHJd0oJzH4dGA
         p9WNFiofB5l/dJQiNzuDKYAImsFCyezL1YnvnPVhaDa0d88U4xHVIveKWCfPKRxTJLrl
         2cg1FZgfsNdzkxI5Gk5s9t7xwjEk5QF9PQ8dwSIbpUb6/i3H5uNx9Oifl6zDa+CmNFRp
         TN7vFH1EQWQc4QFGMfHa/LV7lbclgVT60f+3AXF6VVBpS8eCbpd1uGVRlvppp/4ynZE4
         Nlsw==
X-Forwarded-Encrypted: i=1; AJvYcCWhRQYQrhYDvWd5eA6V1DRWVbKnDUm+k8hzWVwKsMjVNfsJnv/wP+fjqEYXx91YmCfc33c649PchIBuU44=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT9CIdTxCjHlPPqkjNmK4Q2OQbcdYwcKB+kzAzkQQ3EEJ/oc6d
	EfBaJb23KWOAQZ06gL+jsNsOB28iyo9N1sokIPrn64aInrwdkNMvsRMzYgmnYp9ABY9MR+Mi/Q=
	=
X-Google-Smtp-Source: AGHT+IGge7CDFO2OF9s+yRivgMJ3E9pJmbYtIoCyI0ADpE92mt1tOKjrtt06Hn0rVZeuCfWm13CM2Kef
X-Received: from wmbh2.prod.google.com ([2002:a05:600c:a102:b0:477:172a:1020])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:290c:b0:427:9e6:3a76
 with SMTP id ffacd0b85a97d-429bd69910emr2488587f8f.36.1761907200510; Fri, 31
 Oct 2025 03:40:00 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:14 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1531; i=ardb@kernel.org;
 h=from:subject; bh=HC3oKa6XX6UzW4T61UkwwEg9itjK9pSOgUvVasKYlBk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4k3lqGSf0tTW9dM3lu6fuKnZar2H1FFe5v+PezZ0m
 Zeta/vfUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbytZ3hn21Qzpv8ZRv+Har8
 9KmtbbbpjscfoguOVrx0LerWOarod5uRYUuDAgP/9kk7Mvbetlm0MWDyzq03jO+IzUisMv9cprf QmxkA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-38-ardb+git@google.com>
Subject: [PATCH v4 15/21] crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
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
2.51.1.930.gacf6e81ea2-goog

