Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C4418C333
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142156; cv=none; b=X2fOiE1wlaPu/OfksCk86nLmPkpQuyfbP7Owqzz5xdP9akoayMvK4oVdeUJUCga+HmjeNnvY4bmpM8vrHZJGdmBBK2VmZrX1iRE9Q7yB6RdWPdk4TgnezaH4SEeC9TLoD6JO0330uo0MvsWCksM0N2y/YVYhHDD483xn71WzD3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142156; c=relaxed/simple;
	bh=+5/2gDQzUGvCacg+JbMY2HNOSPPEjQzmPsrzsnEblxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b+Ga4owi3c82LmWKZZPe5WLe2m/6hzXG/GRWFIODeGqXovBx8tvAa05+TiYSxrkkaZYUAi33Q/bLLvXedZovEoLCRB9m8PgJeMMZ3kw3iu+xrwj7PSr6xERfWrD4fHI/d9RVw5ELVnbL195mSW248qHwYks2WObzRPeDHKWQwUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NWyWyb6P; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NWyWyb6P"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d462b64e3so2349730f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142152; x=1730746952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rF/BajsA4u9lnrpfeqsxR/4AwVRpiKJbattjpDj/5to=;
        b=NWyWyb6PrxYZCowoFbru8URblbaAlUKPqbio3kZW40zX5evcuHLjQI3JGkxTC00mpt
         k4UqpJlgAw4qz+TDPkOOsrQ3k0UH7uU8aAdcRzgYVOE8q7n+OUPZN+Te5KRqsMxKfAbY
         BgndYgKKoHp1y6UEtSeCPQnCPr1Ye1zL8NeZ7RVlRi8l6Fg9u1rekn7suurv4TVomOd7
         mjOO6NvrvXDwk+lAjKRcykvC6tT618umbo6VQKXSLBCxc+YgrfriZ2vqugjYMt3asX/u
         CbbB2W+v+nulM4G2Rj+dXP13ssA0s99c4cVjzBqVARdY2QM/96Mj2sEdv2SMWYRYI94f
         Hqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142152; x=1730746952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rF/BajsA4u9lnrpfeqsxR/4AwVRpiKJbattjpDj/5to=;
        b=u/y9b276X8F1G7MgaknxTkWL/1gf8mgjpIv1+CWmokiIPdQoh+E4EUTxs2rZfg4lKj
         +vKUT967G6l5zh8Q6GLEqMSda7PtHZPOaNXkBqOzIEdlPa4Vdf7eqaONkuPLrJ8vpB3J
         NBHzcWRwIuKhUZBbJmYAlamEQE3bG5wfceFCH688UEBUW/oCmsULX9OmeKK2SkEgvD23
         uklyhqqZGSGKpRlC9KsyLd9MJqh4VUr9PKStEDk7xyFiMr7PmK/gqdCBRzHGKtuHoxCE
         SVTDKaiOu+wOtsanYrGebeYgAEbiNknhCKX95U4a493b7Ylh4ii06ob/ax3Eh7Io3I97
         oYfg==
X-Gm-Message-State: AOJu0YxGAvmhixxxfyOIYXcaQO8/e6H8CrTOAAGwnMo9Qis4ZO1i8L7L
	epk1hxfXsEr3rH4H1iiuCGWVBySjBdlWz9PjtzyV9nSnL5Mf4Z/OISK53DTd2tGnZFr7hILEut0
	wZrpLa2plU6bR3z/HpKydvbO/Az7afk6O9eSAr4Qo+DQqdYnAmv1xcTFK2/wLEx/ieIbFhXUqee
	wP2cYzpIU3clcJLRkERwSPkrUDErKgkA==
X-Google-Smtp-Source: AGHT+IHnKiYkcGHQSPrTxUsrUDubZTKuRI+DKoCgVg6SVEfpN0Ad0Wkc6hbgZTQpyG+ynHifIYyUvtxr
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a5d:6605:0:b0:37d:5134:fdd with SMTP id
 ffacd0b85a97d-38061238a43mr5286f8f.11.1730142151662; Mon, 28 Oct 2024
 12:02:31 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:09 +0100
In-Reply-To: <20241028190207.1394367-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028190207.1394367-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; i=ardb@kernel.org;
 h=from:subject; bh=/q+jS0d+3r8GHzPCkmD3ZWCsmDV9ozYENJWU6Pwv9u8=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/sYNYuXnd/Tz9v7avEL+xMo6W3MvT/XnAUIr9B3de
 U61hEd2lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIk8CGRkmFO9T69Y62N2abPk
 umULOm3W3XXqjjv3fUXXS8+DE+d4/Gf4p9au/aeo8tia+wcr9ktzRcYfPiXkf+bg7bBpYd0X7d/ fZQYA
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-9-ardb+git@google.com>
Subject: [PATCH 1/6] crypto: arm64/crct10dif - Remove obsolete chunking logic
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This is a partial revert of commit fc754c024a343b, which moved the logic
into C code which ensures that kernel mode NEON code does not hog the
CPU for too long.

This is no longer needed now that kernel mode NEON no longer disables
preemption, so we can drop this.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 30 ++++----------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 606d25c559ed..7b05094a0480 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -37,18 +37,9 @@ static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		do {
-			unsigned int chunk = length;
-
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
-				chunk = SZ_4K;
-
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull_p8(*crc, data, chunk);
-			kernel_neon_end();
-			data += chunk;
-			length -= chunk;
-		} while (length);
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull_p8(*crc, data, length);
+		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
@@ -62,18 +53,9 @@ static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		do {
-			unsigned int chunk = length;
-
-			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
-				chunk = SZ_4K;
-
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull_p64(*crc, data, chunk);
-			kernel_neon_end();
-			data += chunk;
-			length -= chunk;
-		} while (length);
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull_p64(*crc, data, length);
+		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
-- 
2.47.0.163.g1226f6d8fa-goog

