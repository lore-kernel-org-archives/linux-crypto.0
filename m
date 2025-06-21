Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2A16F0FE;
	Sat, 21 Jun 2025 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750505816; cv=none; b=thpeweHrcIa9g1DvM/DOAgHVTkdVgXAF33Ney28xqG+XldJTwncXUR/gUv+vMnmzo6tebO7gj73nIfi/EEk4ZIwDOS1ISuTj8vhBWJUI5yXC4C07XBMH/uhZkO0ENj+sBQcZZFfw/RVeEotTqfSuLBA62+qYjuaDXzhAYVOr8ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750505816; c=relaxed/simple;
	bh=mV0/m19M4pHbxXr+qp1ElJCzSPGhO1oydQg5fcI09WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eOb0Cc5G35UNJCihlVj/w10IBu3FH8TO6PKZywVbUCHre75KAtCuv0Z8dZdEcuQCh6Y9GjrV4UnTyJ8P3rhESYhaiMMKNibq5CR+Jikb4KDdxS+BHuhMBz+JPYrlXTr72qhkSAOiDEJeeJFI3etsHyK+kLYhLGtSZrj8/iUbVmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBN0Lqkf; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBN0Lqkf"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso4893725a12.0;
        Sat, 21 Jun 2025 04:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750505813; x=1751110613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sda2OhoJ3w8LYPtAn5n421n5aeMrDBa7WPjqMgtd13s=;
        b=fBN0Lqkf1GLMhu59pHmgcVeA37gUSiz6bvLFy1yzsO38xI28l7PwzPK/5HeYne8Uu4
         4ujKyE0bhUrOb2DZUtKqeM+fsQ9fAOQv2TpjYRNZeFKVXlQuyYL1qQPzlakGJk6OgiRm
         NYR8gEdQgUebA6YZxCb9yrlOdO0EdrSolPQhKCPPLHiqTwCrWquZCPa9KuuP7A2ruk/t
         bpuiosCXjgwa8BGwacgSo/axtB6oYRTWR5akV5t4K/ejcQkBMtANfbs13NAF+mPtB1To
         dvgq6CIefyOHSHOjUXKgI8LHvlV7AjlbExVuFCt/l1FW6OEAOIB0wRbMnsuiuGAK82yb
         cNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750505813; x=1751110613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sda2OhoJ3w8LYPtAn5n421n5aeMrDBa7WPjqMgtd13s=;
        b=tNRSPVg43EYvA3TwTB6tj3oiculDLGV+S1Ar2dqM2w9q6h8if2c3w3RfhTXLQbpP8l
         MTQEqwWAo2LR1qiV+oEETIoHsExzUu7kP3W/dIdxfRfeKeRJWt7NNXFfEQJob0nqfuK5
         Jw1Ialx1v51SUs2QaRfIJxHX2TqPGkFgD1Lg3MjwvjZedY+e71mIxrYdHHUVHR4RXeYx
         DaFc0VzPXh3h8a72WET15ptn7FCHlhKCezpnNxllLeXNSQSVrGl2iqrg7MxgCO8ngfvI
         1uQhUrUd5Y3UwvzFxv6RHIF5v3VRRpW+SC843pnwUz0HNJtf0OtVexp9mnuMyhMf4sh6
         y1Ug==
X-Forwarded-Encrypted: i=1; AJvYcCXnDGZyUvJKfemek7mUOg1CqrSTk4MUFByp4DUi+KH8nhqsMpM2H7DcMa7Z69bqTVguEhi7nqDJGHpgN4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YztP1fBTFsPTHyTmINeGjunWL6vKJrCJrUVeIxVCkCyimK54bUW
	9ll7f80B7dWuiUgO6JfLJfCXcXbQZEI9KXHYERfXVOSEhVyRNBHujdxImZg6vSZcUbYA4g==
X-Gm-Gg: ASbGncsgpv7TagIlrv9gIOpb/fBDIsQ9mJaceiSzSgmYGftalZ+kqekMyAeQFJQ/Zzb
	OmkMznIK36EBrFwpVe+P7nsiaN5bKIUWVgoO68Lr6DueBFZoMoDOmFuwEuXs91WOsNnQF7HEMzA
	I9vzw3/c6Jgk/27fCK2iLQi2hF5r4c6RXzF1eFKJXNCjBDTjcNvLiDxVVPBRVtKWwEyUXaS+B0E
	Q74WN04ZZhKGHFatQEC6PlGiNkKzkaIbI8sS/A+Xy1AvlaIWe02/RKO8KZ193KUkUvNIOR8izFg
	0LpIFLBkUZ1L2WnUzm56j8M2f3x0UPUdTTxAeFLFCNahlH06bA/v/pjuiA8AnPpQxEvbYkeNzzx
	IRQtxUgKOiZbCvQPtyr3kohiFe91ZqfJd0qdXjvPjRJjpu3df6i6S6Wnq6VITYA==
X-Google-Smtp-Source: AGHT+IH/5TXSI1rj6xMu+Z81IX/O+NCoOrZDWhCbbXjbeQkCbJVMBKJOWDLDRetam300s58ViUcaow==
X-Received: by 2002:a05:6402:35c2:b0:608:6189:eb59 with SMTP id 4fb4d7f45d1cf-60a1ccb4db9mr6411974a12.13.1750505812856;
        Sat, 21 Jun 2025 04:36:52 -0700 (PDT)
Received: from legolas.fritz.box (p200300d0af416e00f1f3934e32485304.dip0.t-ipconnect.de. [2003:d0:af41:6e00:f1f3:934e:3248:5304])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60a1855374csm2968698a12.31.2025.06.21.04.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jun 2025 04:36:52 -0700 (PDT)
From: Markus Theil <theil.markus@gmail.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	Markus Theil <theil.markus@gmail.com>,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: jitter - fix intermediary handling
Date: Sat, 21 Jun 2025 13:36:43 +0200
Message-ID: <20250621113643.107745-1-theil.markus@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intermediary value was included in the wrong
hash state. While there, adapt to user-space by
setting the timestamp to 0 if stuck and inserting
the values nevertheless.

Acked-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Markus Theil <theil.markus@gmail.com>
---
 crypto/jitterentropy-kcapi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index c24d4ff2b4a8..1266eb790708 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -144,7 +144,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
 	if (ret)
 		goto err;
 
@@ -157,11 +157,12 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * conditioning operation to have an identical amount of input data
 	 * according to section 3.1.5.
 	 */
-	if (!stuck) {
-		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
-					  sizeof(__u64));
+	if (stuck) {
+		time = 0;
 	}
 
+	ret = crypto_shash_update(hash_state_desc, (u8 *)&time, sizeof(__u64));
+
 err:
 	shash_desc_zero(desc);
 	memzero_explicit(intermediary, sizeof(intermediary));
-- 
2.49.0

