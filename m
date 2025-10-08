Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A239A2FB0A0
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938423; cv=none; b=MK3SmGLp+QPDUwxNu6PNSgclnroyVeLrpq3VmXLDF/C8X07WwP2WIhMk+LTnBCB3+R0JR4uO9psDODIlRAX9ouf90KiAp5BwtM5KQkXmsjAvvAd8WZPIHvKKx5Llqo1mCvIh1+1fEvxcVl1dyVGGK1CSuNsp13IsuJ31xSg7M7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938423; c=relaxed/simple;
	bh=8/2or9yCCRuAQ3rBPtjIaQu4DThn+Ww7LOmUhgaq6a4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uru+noT2I4pBaFy4pE9AKfN4LT5NEPPbogjKA7k6mc0w/AU2AcG3P5sf1ZeGJEV/Fgp/1/AvI/VeQYXARIAp1EOpt6Y6kzd+7RLAQmhBzxk9+7aanNWqN0tV1JhaTl3hs6ocA0/wfHFugy3Mtgt887MzLCTQvHpHss0U0SXbXFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFc2Hgb0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFc2Hgb0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e45899798so29370725e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938420; x=1760543220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ez+4eKtd+5d+DlN9/UyWopIVxOEbKik+aYqVxPQpTVQ=;
        b=bFc2Hgb0zvoq3jKqzFnDT6qW3Z69YmMOD1oVa9V7rqYs3VrG2vTBqWSrl0K8bp8S0U
         mqMXzhi5oH96/7ZNHvtJG/+Trimhcnok9gXL6ZCqi1dyXOZ49By+cXIT05TsEKORmwWX
         OvHxHSeHw72xKPDfFgZjzRS2uv7qCsCKcMo0bb/nsTsxDjFkcBFoDG4XNQuP+4y46Iei
         Rb2pWyjzt9ztizAwnkZ0iemkNunZx1Mn0cJiNa3pe1Kok4+1/NFXpn4ynjd85RpJUP1r
         SDaKEpLbbjvuNx59BGg+By+y16iUco1GRyDS14kJyxdGOYIO8DbMcOeFRDUk6TrP39bH
         fz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938420; x=1760543220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ez+4eKtd+5d+DlN9/UyWopIVxOEbKik+aYqVxPQpTVQ=;
        b=bBwoUdWSc+NDOPsByqj1M5ob6nMau8S8j87WBtRRdz/iyLjqVFvlM5p0MaSKvh8WpP
         MlareuRmrj8An+NLMIToaFihcQqMB9BLMhLSg6sUGeQiMAOm7qY+E0CG18XxZCjzYuN3
         Bksp4+ZZgBsfAthIcU/z97xqFiOeqPPD0GQWp1CYJyQ7BOPuq76bxGhlBhSumO8jEyl3
         dvLA0nmMOKua9sVFQKjqKnsqMcJ3OdtWY4BF5Vvyp9S5NnvJ1Pgjk47YZ2GYdNouOl6n
         GmP1QS3Mfaag3+GmEUVWGLgkCi3FzOewF4pVX4DDVGT7VoZzD3OFY88Ac0u+lfDPFmRq
         tDAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXq/Y5G2f5QrEe8OBmAWCCOBMs/0U++GbSnP+gTJ2zLNoFlhVRb6cNws/qqLxIwN9NHWBb8E9lz9XTdSEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV9zeOjIj5EfZf0oDIf0FMLdxg+mLBP5OdH5niJDPngoakc8hJ
	FMfa6UJl7esoyQ+b22MzXhhjDV5EovFTeI8bTZeuSZ12sQ+gLWWMu7/6yQu39S6h2QT0ofEmsg=
	=
X-Google-Smtp-Source: AGHT+IGTYM4Pf/38/W7UXSGOfa/Cz0TebUDvS0+woKJDjAs0iBAdrVv8aCM0ALs/qJZsRftZYcTgSa7a
X-Received: from wmvx6.prod.google.com ([2002:a05:600d:42e6:b0:46e:6a75:2910])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c162:b0:46e:4a60:ea2c
 with SMTP id 5b1f17b1804b1-46fa9b17e57mr26033895e9.37.1759938419976; Wed, 08
 Oct 2025 08:46:59 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:47 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1189; i=ardb@kernel.org;
 h=from:subject; bh=8sN9JxLWvPrUJL2U51Eh+5qEYXWcAYa7eZ5mEETt20c=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu/PzMHauZxLCKuERrRdfzF5wf7kDA39FxuHFVmtm5
 k9ZGbCyo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkiCIjw9wiF2ODjCNqLeKT
 1y57HJa2ecbP6MIlHaFB7NPv73o48RIjw6d9u7u+haqfKfBVlgpP4bO+/M9SaGnMwn/JDUovz4U dZAIA
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-36-ardb+git@google.com>
Subject: [PATCH v3 13/21] crypto/arm64: nhpoly1305 - Switch to 'ksimd' scoped
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
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index e4a0b463f080..013de6ac569a 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -25,9 +25,8 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 	do {
 		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
-		kernel_neon_begin();
-		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
-		kernel_neon_end();
+		scoped_ksimd()
+			crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
 		src += n;
 		srclen -= n;
 	} while (srclen);
-- 
2.51.0.710.ga91ca5db03-goog

