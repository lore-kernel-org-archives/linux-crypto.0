Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430E316EB4C
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823251; cv=none; b=AjFt83Mv9RWgFGhlq5dTxoz+eLBBWdVohdTB7nTnYnxHsb7sVkfGKNHzjN1lyqTWn5+1Lj1y6jOykIrzxpZUi41Z+gBJKOY5H6wzJtFqpHt/VX5FS/x98lNv4Pa8yW1JMWvzdqwvQOvq/7pHMHjmZ9ibyl3DdicnrFd2gPdqX/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823251; c=relaxed/simple;
	bh=O4DySk030alV4qXh53ub4rJXW91CA6oaiyXhv0TEi4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=odANYAOO0ilxy82LH3d97wJZGO7JU3QFr+A+iY3BK5r6OHUK5/K1ts87rmOvY24nf+ChquN/cpq7Pxx2lhXSebzXJ9WJCb3uedQTJ2NWumBXmFIT8EQULriA2+PZdGQZe5PUL+7yb9OTXjMpSXZXHJEWqdLnAcmwjhqPRq4Ic+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lXmhA8Wo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lXmhA8Wo"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a238068so51622427b3.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823249; x=1731428049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+PYWCpA35ebymISdfvrACDJD2IIeB/JqSCaz3DRtnXQ=;
        b=lXmhA8WopXBCcHAnJpQx12Iwk9wx4MGW3fzosaIrEOjnobYNw6g9bIliFKecWrsYsu
         vgFl3LEsD2ViVM7WEvU63VpW44gWBZD9KOi5xL66oS6fPEqPcgNI6lxFU3YIE20qVfQt
         YrCpAX+bSUV2daloJKQDChOpbiWEeKp8lLIpGF2XOJeu1vGMzqMH5o4KF60CPrVH4aUq
         71FXdVuHi5DPUmyQv+JMKihsIALHF/WofNzALIQejtLNf79hjPLcF7kbfEsOyLcjhkVJ
         JS2AS7yg969yHx2U22qEJJseK867AdXp09YwlWyh9WKI3yvCOQD63E/HSVJ6lVBddvHc
         UN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823249; x=1731428049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+PYWCpA35ebymISdfvrACDJD2IIeB/JqSCaz3DRtnXQ=;
        b=cPQD6ZQorYLOShV7djGHu9JR+uYyWzkiA8CyJOXv/sC+n02VfmmE86rSYtpS0kxwad
         QcoaxRgsOnFE/TzoEDLiL3RtutZ1SHLzUfq/BHWiqUbQQfsnFmKDwb9jnGpAkK7/Z20Y
         mkRZ2fyvvtuQqMh5yTcABuNBbXCz0R52MQBfJqQVJefbJCV6igTwMUsUWwG6XDTo+BOO
         64RUK1z5uuIuyHWykMXNjyzo7Lkmwq6XfMKBNffZ6D0E1llBH6OFPk5XGTEGD7oPUx2P
         pRVs27uLu5q/TL+eb6B5gYz95X+gzsNkdkw3uXM9Lnp3PSOIvNOEZHn8k+kf2+v0mKF3
         ZQGQ==
X-Gm-Message-State: AOJu0Yy4BleqEsstdafnIdzKVM15l7XGZKGKZP+STo5HsO3ey+8gHXgZ
	2b1ibnha6HRV6hdQ9uUfkUks/mSMua/0VacFruSMMiUURCtlMZKcXXsoebZ7XCt4US2zw6Vk8pA
	PQyWbRtQnlKI8ZYWVsvoc6qmmeXBQfGuRnZaae48PzTiByZdpz9yup2PGSeOs2ogrCAq9QvYIT1
	0FSjvKCEaihDvGqyueofc0ktjjMdMKOw==
X-Google-Smtp-Source: AGHT+IGLaooYqrcyk3qUe0TX4eujCqm8wQrES8XgTDSUNFOoXaBLxJAERPmv+9udro0XiVT+bvrfoocD
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:690c:308a:b0:6e9:f188:8638 with SMTP id
 00721157ae682-6e9f1888858mr13489617b3.7.1730823249265; Tue, 05 Nov 2024
 08:14:09 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:01 +0100
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160859.1459261-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2089; i=ardb@kernel.org;
 h=from:subject; bh=vU4XBM4NBrhTx0MFUyTDlm+FeMA4aQ6+vOJf2f1XAjY=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWTZuc35KvKbt0ZzF2/csPfPldd0h8z4dyc13ZyvG3
 1jsusmyo5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExEw4Thf9m8JKvMxNdXr5//
 uvm3Wd2xdscbMaVFr8vfFv8xWF55rJzhr/Ds5SV1nD8c7zLaG/PcENjJu3I3003jytPOj2ufRfv 68wAA
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-9-ardb+git@google.com>
Subject: [PATCH v2 1/6] crypto: arm64/crct10dif - Remove obsolete chunking logic
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This is a partial revert of commit fc754c024a343b, which moved the logic
into C code which ensures that kernel mode NEON code does not hog the
CPU for too long.

This is no longer needed now that kernel mode NEON no longer disables
preemption, so we can drop this.

Reviewed-by: Eric Biggers <ebiggers@google.com>
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
2.47.0.199.ga7371fff76-goog

