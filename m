Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A237AE78
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708694442; cv=none; b=eI/KYw1qakWPfbo+mmtmc8kqf70C/0YsHLbRMyB3UDAZOKsNzPmM9FDFwzkPoX6j5XPf54J44UOkTvwB12OweWHPAHPPngr/lQ3vateZQwXuzH7P+bBH449oeokTTnMSyGMrcWhVRIzvW4OF8HvVsqu12VY7H9M5a22Sti+88iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708694442; c=relaxed/simple;
	bh=5E+OoSqSoQTndkcwGZFogrHK3nFb1dj+UrNziPgAP3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WnDugTM8NVOgRDiuS2e5NBJ5w0OokWV3G2bPff1n6SWfKu6QeDRKXA4htWEJWlNxkJ2y1m3X5bEq2nsyGShOfmcW2wc7kSvyFDo5zE6i+6ZvsSRssVZV0Ek0qF1rx71GLx57AnlrcZ95KbdJOARK2/qffqBxG8U33LIblx6ZzVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hPwnzrLW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hPwnzrLW"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608ab197437so13781867b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 05:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708694440; x=1709299240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pk0ivWFgwazFvdornWzcdn2oDTlWSx8rasiYQ95PLx4=;
        b=hPwnzrLWZf2AapbHbQQsJGRTAjJxZOCaXDH6PGo1ubvMXuf55nhurgSKiYE7ga8EIr
         V1mHXlM3SQ4OQhEVAbB+xLCtbZEOCrA59VRToyaDpip+eyOyEKFBMkeWFSmo1OU73ysP
         BmcfGNHySeGC+OS69W0pvlRWFNULf0MzYQ3UEew1G69Vj+3Hk4sq4j1y2aPJRNrCflje
         ySZCuhq4ySt89oy7d/TTBgebyZPsnLcREx3X+y8J+uO/CHb6koffECWv6ezAOdIMmoQu
         +Q1lXUguPbiNLw6NDTTziVamWrTvlJfflFjM9Zw5dhpkTHKP+PANBCp8tBPtUhnItaLW
         1CZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708694440; x=1709299240;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pk0ivWFgwazFvdornWzcdn2oDTlWSx8rasiYQ95PLx4=;
        b=LlBkJgySHx6Z2e0TGeC+9yk/d9b4W1dAbM8Iv+V+YqYHkAJDHWAe0LL+U9a72Knwpz
         DZeUEEBjNbQiedLofxkeIiCV81rZPaipThaLZQiGUCRnqun1uwK7OznB0asHNZfjf6Nz
         L7j9S0VHvJBCYxLEMVQj7ggOTfVNvz/jOil6GwoW4MoZQ4ns0UmWqNBm7hpR1V2B+IZB
         D5tDw12Z4a7oYUHxRaET/utRecDjZppMhieifL929rc7b0wvoWYcym7T+iAdSvuY++to
         WOuE0WOupQshKnAfpuANBTiLZesqGmayaAowocoJg6YTx1mg4DuGCuRJ2T4pPyCA78Hh
         iZPg==
X-Gm-Message-State: AOJu0YwR+63/uiPiyONbpEv9+Ro3vJnNmZyy6SAIpgyL/6n4BYuV+Ks8
	vRdXnNQfYbOlptc/+oEDghl7DvxhXZxO+i5UrNY8W6VX6D9lHGxYEr1ZtTtf22CusH2JIjXieWA
	XSyVaISiLvX+eEK2oOZKmzznZzCKlqdKeQ1gHn2FfaSClV5qd/kB5VgFbfNhJBxCu8trhILgaNq
	JNz6wAexZlbEWTxcY2tDZAM5LvT4EhUA==
X-Google-Smtp-Source: AGHT+IE+KyhpvkgEUcCSsPSZ1apoBnV/vW7BnZC5nepU+wRmsBhKUjBwBU0qHYUzyffhGGxCtzpoPV1r
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a25:6913:0:b0:dcd:ad52:6932 with SMTP id
 e19-20020a256913000000b00dcdad526932mr522179ybc.5.1708694440210; Fri, 23 Feb
 2024 05:20:40 -0800 (PST)
Date: Fri, 23 Feb 2024 14:20:35 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223132035.3174952-1-ardb+git@google.com>
Subject: [PATCH v2] crypto: arm64/neonbs - fix out-of-bounds access on short input
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>, 
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The bit-sliced implementation of AES-CTR operates on blocks of 128
bytes, and will fall back to the plain NEON version for tail blocks or
inputs that are shorter than 128 bytes to begin with.

It will call straight into the plain NEON asm helper, which performs all
memory accesses in granules of 16 bytes (the size of a NEON register).
For this reason, the associated plain NEON glue code will copy inputs
shorter than 16 bytes into a temporary buffer, given that this is a rare
occurrence and it is not worth the effort to work around this in the asm
code.

The fallback from the bit-sliced NEON version fails to take this into
account, potentially resulting in out-of-bounds accesses. So clone the
same workaround, and use a temp buffer for short in/outputs.

Fixes: fc074e130051 ("crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk")
Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index bac4cabef607..467ac2f768ac 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -227,8 +227,19 @@ static int ctr_encrypt(struct skcipher_request *req)
 			src += blocks * AES_BLOCK_SIZE;
 		}
 		if (nbytes && walk.nbytes == walk.total) {
+			u8 buf[AES_BLOCK_SIZE];
+			u8 *d = dst;
+
+			if (unlikely(nbytes < AES_BLOCK_SIZE))
+				src = dst = memcpy(buf + sizeof(buf) - nbytes,
+						   src, nbytes);
+
 			neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
 					     nbytes, walk.iv);
+
+			if (unlikely(nbytes < AES_BLOCK_SIZE))
+				memcpy(d, dst, nbytes);
+
 			nbytes = 0;
 		}
 		kernel_neon_end();
-- 
2.44.0.rc0.258.g7320e95886-goog

