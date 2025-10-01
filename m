Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A226D4F7
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 16:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334835; cv=none; b=dSxCCrKiEuwjzRUaAIs5HeNRlQaxeVx+lJJawNixJvyW39LgG6vvA2lf6wlloU01g4p2JHa5KPpBVeMIpuzRne4LGMnJ9lj7oCyzxb1bDWvjifm02s2Impt6NQ+U3TcsSVaI+JsFGExlCHhV9OCvoC4dUvc+8ltSdUVGA8O7lB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334835; c=relaxed/simple;
	bh=yGthKrJgjptv1SsVBgVQ+xaQq3apEw2V386nO3JE0tA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=CW3x3QKRRHQw042pdwLiGq1QpYusw32raT+N7MNaiw1GYqc8i93VKmvCZz0f6dM0kOYKAOdEGYW86/r88p6gtM7rEFt1SzYWmFVlWPu+P9rYRVAzIErcrAB0Aq/kwp4b5vJeC1BIihzLlJHIYmAinq83/4IkOfmns8pU3bbvidU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso11847766b.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 09:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334832; x=1759939632;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5F/ZlmahY4v9ng57M3b3RixWviloAxPsx1h4/uNyS2w=;
        b=W7ZGX9CsZP2RGe2ZJ+kgpeIhevG0qfh8gUhHAbMCGKIC8whKM/TDZBIcTdqbhR/I+p
         2kDJAAgpppnUm9f2ipQe3SOCxaBeAjF5C4bIRfHLpTRuWeIPm/DDTGFOUScsXe10NS9W
         IESPIqzYrztGFi85ISzL351hcFsTBdyYHKF6CTdKLMeStq9nNh3yYqOnfbCx5MmhXYlW
         DbbJtNM9u/xiMwWe3gCyXqbWuUYy8gJAlY++1m2QtAI4BPYkAO92ai4bxmYqzz38Bz6x
         WTSJ7T3ybubL0nAq+VZIhHB70GtKMVfCr/sLfmx0z0CY1B85VqWewYFdVbHv8Y3Lig1j
         uZhw==
X-Forwarded-Encrypted: i=1; AJvYcCU/O0/JKN2a8KA4Mg3Yr33X3vhpY/RqYyeiZy2jDyH7oy37Ri+EvBIpmCLcE7h9FqQSmDJcahdZAcBMDFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEDXi8cT5u/YMc3HgIM7tavdCKZkb5tRrOP3ZSNrn03killco9
	mhsmV7aDyNzwoxMVX0/COpdf51SFi3VfpwjYbRoIllhxP01pGFJDb1jJnL5hmA==
X-Gm-Gg: ASbGncvXR9SfCxULcPPhOY0rnfim7h+F6iOxLJ3fEpVPuqGTB9Usa/Sf7kAD2N2jqLC
	5s0ZF96cxrzMl8FDPB7GA5cKC5kemZxpgTxr1JswXKT3zpBe28RlvyeBcgGae1zHAw36Gzn414F
	pmTM8+t9V4iGy02GsTOihrWp9eLWuycNR3ciE8O0fthKV0ZnzvWKm9vAoV6HhrOyO8ZLBKbFRQd
	9XS5H/1i7nPChN+qH7rtyzmoSLOARiNlnVRqE895en1UWN2rPr6V+YlETvOkYEK+ZXVjHsouO6S
	kHZl2PxiZ8uMMWKtmgR1SvC991pIlBPF9/yf3pbixAY6g2z20Z4hvbAL0Nc8Kwcx0nKrljzpicq
	gbV2imU8vZr8LE4lkoxrbEFcYctJ3+MMnKVI1
X-Google-Smtp-Source: AGHT+IGU2oV2XoghFFNjXpeXFR8ZpMH3QCRErktbMJOKfZuJaKAV1DQAvKt87juoFqsJakAyIPoG8w==
X-Received: by 2002:a17:907:7212:b0:b43:b7ec:b891 with SMTP id a640c23a62f3a-b46e3ae19e4mr491578466b.28.1759334831631;
        Wed, 01 Oct 2025 09:07:11 -0700 (PDT)
Received: from localhost ([2a03:2880:30ff:7::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6376b3b8df3sm51976a12.13.2025.10.01.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 09:07:11 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Oct 2025 09:07:07 -0700
Subject: [PATCH] stable: crypto: sha256 - fix crash at kexec
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>
X-B4-Tracking: v=1; b=H4sIAKpR3WgC/x3MQQqDMBAF0KsMf20gk+omVymlJHaiAyVKRkSQ3
 L3Qd4B3w6SpGCLdaHKq6VYRiQfCvKa6iNMPIiH4MLH37OxI+SvvuSVbXQk8cU7Fj4+MgbA3KXr
 9u+er9x9vAtTRXgAAAA==
X-Change-ID: 20251001-stable_crash-f2151baf043b
To: gregkh@linuxfoundation.org, sashal@kernel.org
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>, 
 Michael van der Westhuizen <rmikey@meta.com>, 
 Tobias Fleig <tfleig@meta.com>
X-Mailer: b4 0.15-dev-dd21f
X-Developer-Signature: v=1; a=openpgp-sha256; l=2044; i=leitao@debian.org;
 h=from:subject:message-id; bh=yGthKrJgjptv1SsVBgVQ+xaQq3apEw2V386nO3JE0tA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBo3VGuPtPcA/FbB8X5L3sATv/wd4PcV5twNu9J+
 9M1P703yCSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaN1RrgAKCRA1o5Of/Hh3
 bYx/D/4oyRu9MKW9AfBVPio3fDNu8pXycH+g5imDGXWy45s4UXL9Ncnb/lNfMBFFL44hC8uAB/Y
 bycLfU3OJLP40P3WwHV+tXrT0cSU2N5Zwy2x21twyp59R/G6EkXhRQdXsAf8vTMuQAPXcZV0BLg
 Ok7fk1Jwsc4QD835ibz1CzTegXZtyye0LoCCbF2kuJHY0C82L2SsoVfsCf2K7SLc2vlWZCWMEOX
 zE7u8Q7Z7RJbA2nllYagJWW+byq3R2bO/f0gdbNhU9AtfkqgW5tAg8kNZb4cCYBqtbfgPANc6Nk
 eHRz6xvX2EZlABpCZfbxccm+km7nVlj+1jIS8zd5DCJKEup/wLEO31r7gYZ+N3h+RE8KidBKbp/
 DV/90DK0MoU2wFb+GT7rz+yRhBNmasapS4rocrCkCD0oWs0zPhmWScBnF1D2SbNvAunTFVBQDnn
 DdiKCFho3CfON96LAkZzpgEPbkIjW8ZzjA0nxNJ6Ts3TvZRatgNpt4qYxDSh6SurunNgYanK2Kv
 tzPEsvGghgTVWjMa5ViHlWTIEsVqSR3vzmIWXi0RyK3ZuEq0EwRfxdWgqNuCP4xwJAuUoE/w738
 024vq5PU3sfeOEcbA6wv9IIAKH7+wpVurdwQk5BgV9KoL36qQYRkW4ampOy0jJS8YZuF9YYJh83
 xSEprJRPwLiyb/A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D

Loading a large (~2.1G) files with kexec crashes the host with when
running:

  # kexec --load kernel --initrd initrd_with_2G_or_more

  UBSAN: signed-integer-overflow in ./include/crypto/sha256_base.h:64:19
  34152083 * 64 cannot be represented in type 'int'
  ...
  BUG: unable to handle page fault for address: ff9fffff83b624c0
  sha256_update (lib/crypto/sha256.c:137)
  crypto_sha256_update (crypto/sha256_generic.c:40)
  kexec_calculate_store_digests (kernel/kexec_file.c:769)
  __se_sys_kexec_file_load (kernel/kexec_file.c:397 kernel/kexec_file.c:332)
  ...

(Line numbers based on commit da274362a7bd9 ("Linux 6.12.49")

This is not happening upstream (v6.16+), given that `block` type was
upgraded from "int" to "size_t" in commit 74a43a2cf5e8 ("crypto:
lib/sha256 - Move partial block handling out")

Upgrade the block type similar to the commit above, avoiding hitting the
overflow.

This patch is only suitable for the stable tree, and before 6.16, which
got commit 74a43a2cf5e8 ("crypto: lib/sha256 - Move partial block
handling out")

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: 11b8d5ef9138 ("crypto: sha256 - implement base layer for SHA-256") # not after v6.16
Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Reported-by: Tobias Fleig <tfleig@meta.com>
---
 include/crypto/sha256_base.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index e0418818d63c8..fa63af10102b2 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -44,7 +44,7 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 	sctx->count += len;
 
 	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
-		int blocks;
+		size_t blocks;
 
 		if (partial) {
 			int p = SHA256_BLOCK_SIZE - partial;

---
base-commit: da274362a7bd9ab3a6e46d15945029145ebce672
change-id: 20251001-stable_crash-f2151baf043b

Best regards,
--  
Breno Leitao <leitao@debian.org>

