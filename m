Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADC23101BC
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352641; cv=none; b=IqNOc29hxLjNOf4YDo7yH7uR6cxIEiPMcApf3iyZnJKFPK2MnS6YcA0wZBJ7t6wKK3hD1iutIbOQGEHivgInucwOe4WyBAvov5Rp2Ny0LRlHgr5CJMyBfUup5ACdChKuepxtcCc0G1Sc1adkWtimkWD/UM64GbR5anUAX/UFahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352641; c=relaxed/simple;
	bh=G71rjTtZIaGIXR3UGbv3E5LniLfYD2qy9Arh2X+LvNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eW2cgjVXsm1jIBaYIDSRZH7JvHJZ2SYS32b/4TA/TujCFOj6X27o2HZBPVWsSEOV4QDTYZ7IEZ5S6sbf2h1wi96yS1VzQozj8EL8One8/H8h19X8CGmX2ctgHCEy6/MvoUdyTD4/pcsTF91EIT9+yjZFN3Pzz7ybdpreHHj2dQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c1+HtXub; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c1+HtXub"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso78700f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352638; x=1759957438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4j20MEC8Ax3r4R1mIrlpRXC+UmhNM+andOU7drpFlJg=;
        b=c1+HtXub1tsW6Ro/L61pROfXURB4H1hVBy/UvsvtwubqYow8d4Jywu4xt6S29GXX/C
         52xPUQ1o7dxEfXlf8FU8XGM6UFfTI2e52i90Ur6MAuHGq/Q317Z9ewr212k+1bkX8Ljk
         GdWjmj1rsJuUGEgcZmJmk1Fkd4dvpri6tZY5xXQYcPMzGAT37il9C+4RWej+QSe5WV5X
         Bi644UlA4m8QQtP4/1icEOc2VCvSH9QoIL0jHUZn0O3eL7oIryyguz/thA9d7L2MmwDZ
         0TBSqoJa7PqNuOZhrB/maL7kQUmpmZgNXxWqwnO3HXbHiFYV8DtgumHMF++1c4wMhheD
         Kxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352638; x=1759957438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4j20MEC8Ax3r4R1mIrlpRXC+UmhNM+andOU7drpFlJg=;
        b=R5S+wkpK5gyVRZvVP0NbMPGZDJK+AnD9NOTD6dcvX8k4MErINTTX8X0sEy0VCpPtB2
         /EmG4KZ8Gk5MHPZR4P2RuM5ROeg98FPY1kP1ZHQzTdjOA3UnMgGV/Jn5m9koATtElMpO
         hJMDX2R8CgtLDazLkjfCTie/zqfveidrhzpQd47gkbqMS5OYgc4dCXgLO7CGcYPZuO0i
         j8ZbSHhv8Y7Y1Px3yKINeyJQi67O+eFuXnZyaHOvvqMBOzGur7seaeuTFXV0YFq9/C81
         L/rDI4my7S1USbvTSRiAdtgFnkV4+kAMW3zCOWyqahTxcQWi/fdIPD594uIMFyNAdCOs
         jsFQ==
X-Gm-Message-State: AOJu0Yy1V6vFcLtlFXbadBThPMyliNmS2ZEAFAeV9ZnbygVw7ilIsRF5
	s3KtDrkQWf8fC6oHxDzE0zGeajTyIOWn/oD+3R1TbusNAL6Lnn3q0DbV6TGWnfdhjiUSAOk6QA=
	=
X-Google-Smtp-Source: AGHT+IEuG1RbtJ6FiwIucAXGOGuLO6+jN3odMsNV/hZ3o58B9bsNzZE7dpr8nZZ7AG2wrt76ICGCYLz6
X-Received: from wmph10.prod.google.com ([2002:a05:600c:498a:b0:46e:3d73:fc5f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:220b:b0:402:71e6:5e00
 with SMTP id ffacd0b85a97d-425577ed455mr3244884f8f.7.1759352638294; Wed, 01
 Oct 2025 14:03:58 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:08 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=923; i=ardb@kernel.org;
 h=from:subject; bh=cfu0++gxesQ+j0mFCsE0nnO6ije/EROXIJJwVNT18uY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutMcBulsb9Sf4Rn696XB38WaDfWe15F4pq8cpdulUF
 insmBLQUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYiF8zwT73e6+Ks9K/+Zebd
 R+6sq/m6USFAcL2p+MU135V7PqktCmRk+LXMZ/6d0FIN7xxPpoX/jt5W3mGrLFV3wuGL08ZXstw XeQE=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-28-ardb+git@google.com>
Subject: [PATCH v2 06/20] crypto/arm64: aes-ce-ccm - Avoid pointless yield of
 the NEON unit
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

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it explicitly in order to prevent scheduling latency
spikes.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 2d791d51891b..2eb4e76cabc3 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -114,11 +114,8 @@ static u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
 			in += adv;
 			abytes -= adv;
 
-			if (unlikely(rem)) {
-				kernel_neon_end();
-				kernel_neon_begin();
+			if (unlikely(rem))
 				macp = 0;
-			}
 		} else {
 			u32 l = min(AES_BLOCK_SIZE - macp, abytes);
 
-- 
2.51.0.618.g983fd99d29-goog

