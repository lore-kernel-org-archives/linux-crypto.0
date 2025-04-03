Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D1F240604
	for <linux-crypto@vger.kernel.org>; Thu,  3 Apr 2025 07:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743664809; cv=none; b=pkOHu5kA/RXw0jEOUCT/4ImAE8KgHyUXKoz/6V/o+nbVVAzOOKkfefLuppzoXfZk6RiCDYdqQa9s5c7XpRmwGqz7poFNfrlF6WPxv8e/J/uZYnyL6rTQK82xxvUhpSu7QS5bEV5c7PYdZYqcFL25p4MneUTh1RRy8LA6zCiV5L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743664809; c=relaxed/simple;
	bh=v9xfDl6HCuFxDC7wtBfyNa6+UiSEMtiQrXpS6Tf0cew=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AFVuP1nWvw7TMSwTk/nJ8pAwfubTykSaCAHMRuNrc/NDdzvCXHNqHem2loKPD+KdMc8nL7fnCOkTw/Rkmcj8rS3q1qWzFtyky5+Lv+1LHFENMlG7XoRv2yM03Cf8+7Y7R3KHBN7AHvz/r+ayYv0XgZgCu9+CWtXKEYLQ0digcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zLc8Fqgh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zLc8Fqgh"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-438e180821aso2065955e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 03 Apr 2025 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743664806; x=1744269606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LOHlOpw+rL9bZwLX0L5IiavSSvBSY8N55kRnztDci4c=;
        b=zLc8FqghOCEBpa5bQe+0/7iHFaW1kn/kxwwoB6Eb9MNu8pZF7orQjfZyzB5tHrD3On
         J4iqLyEEP6jebDHAlZEL+XCBR+KCJexhkzKM59qgs24RkWqrb6zYXw/3hAaPnpVt1Mr+
         8Wxr3l4eeV+x8YHou4zgaN+gxa0xlbbOA2ckZJJU6jydYen1mdp0RKMtcc0n8Tfcb4+R
         KohjaPCzG7r0yBV7tnXEzRbDm+4AzMtOlfWfBMkLxgWvtkaAs7jn/SmVS0A73HJKH1/Z
         Vkk4Q9ERxTUqeRXho9r/ZkUyhaZq46w6W4kkf5Gcy02vJtDStxURStyoCqZtmQLznFwl
         REPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743664806; x=1744269606;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LOHlOpw+rL9bZwLX0L5IiavSSvBSY8N55kRnztDci4c=;
        b=N3G6cD4D0TlGQpMfioaly3GSZEff/W3UqVLmX2d5GsIoZ4LSyErEbV8D3Vp1Cc/Kxt
         5zihgzsBW+z47uaGuyhoIbDZ6IJcD+rC480nLx6O/kCt6xYvsjfEgnDNvROgw+PtwpQ1
         pPwKNBFY1UyoCDAz9uFLshYr/HyzB7g6gcTbWHP3Eguek/3JSfdCftSBHI6rGIfKHxST
         oCB5NNUXP2VTbjvFXnq70MdteghiT07HpnhqYhXdYZ2CAS7pb6VL+rB1ZZAT1USehSUk
         i5QVGaLAldjsWxAeIRxyCkVFqatNeH/0YNJsP6/SxNYY/fbS7H4OQjubEczUx9O/lW/l
         fQ9Q==
X-Gm-Message-State: AOJu0YxitYc2KkrbxpyWJqy3Sk/DPYhbMOUQgVOEKyiLk3+ATqxWagL/
	Fm0n5PRrdP0ImGISzDEvuaEJ8yZL/njA70MVANQwOky8kNNGE5UqdBd318Q0GUqNAHa0Nar9Lj2
	njCKot1gC8+rlUXxiL5VzpQy7EpEfyzl9/1YB0Gk1goUb6UwsenLhYCJ4HPXmFiuqCO+5uPngSu
	zJ97AizW0HDH8VnA4Z2BtL3JWJVnX2Ug==
X-Google-Smtp-Source: AGHT+IGgQHKv5K3Neyjj9hSorIlAQ3SrWqYgb4Kq33sUT6FbB41Tm3x9PIBtlBI/d/0+J99BsWG2qUg1
X-Received: from wmbfl12.prod.google.com ([2002:a05:600c:b8c:b0:43d:9035:df36])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:458b:b0:43c:efed:732c
 with SMTP id 5b1f17b1804b1-43ec1531fe6mr9872975e9.28.1743664806328; Thu, 03
 Apr 2025 00:20:06 -0700 (PDT)
Date: Thu,  3 Apr 2025 09:19:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=879; i=ardb@kernel.org;
 h=from:subject; bh=3QDcI3nC/0x8BzLQP6lJAcdrRaI58t4VCtI8q2lKKtk=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf2d2SwufV7PP5z1d3scvE4eYTZvWt3xeMXTh2vXn+e6s
 eLsB5fVHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAikSsYGS7XfFo9eRX7Nu5H
 KrzXJ8+K6QiaOzln6XSN5lvtJr9cbnMz/A9ImqfB4Z6syPQl1vGQzJbKWcvW537MOJx45sSujX/ 3LOUBAA==
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250403071953.2296514-5-ardb+git@google.com>
Subject: [PATCH v2 0/3] crypto: arm - drop dependency on SIMD helper
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au, 
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The non-SIMD fallbacks in the ARM skcipher implementations have become
dead code now that SIMD is always allowed in the contexts where
skciphers may be used. So remove them.

While at it, remove the sync CTR helper function now that its last
users have been dropped.

v2:
- drop unnecessary includes
- add patch #3

Ard Biesheuvel (3):
  crypto: arm/aes-ce - stop using the SIMD helper
  crypto: arm/aes-neonbs - stop using the SIMD helper
  crypto: ctr - remove unused crypto_ctr_encrypt_walk()

 arch/arm/crypto/Kconfig           |   2 -
 arch/arm/crypto/aes-ce-glue.c     | 104 ++----------------
 arch/arm/crypto/aes-neonbs-glue.c | 116 ++------------------
 include/crypto/ctr.h              |  47 --------
 4 files changed, 20 insertions(+), 249 deletions(-)


base-commit: 99585c2192cb1ce212876e82ef01d1c98c7f4699
-- 
2.49.0.472.ge94155a9ec-goog

