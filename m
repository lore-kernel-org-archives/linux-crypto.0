Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0711C5D57
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771853359; cv=none; b=K+mc4bkQunBVQ2/vtO8WvEUIhfyrfPXwnCkWCPoGd61FRp4+Jr/XYDFeL96a/dJIQuIxmTBfrCihZBfBWtU2EDKn97SCQD5AdQa3Bch9ejwjUHVkmYvCmvcGxB/ya3ndHUyog7hOWuV53DtWadH5kxSF4HFGIik5sr/j/c3+G1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771853359; c=relaxed/simple;
	bh=oaA6DNQXxsM04m3tfom1XS9SO0Lri+0Iwf+sI+9PrY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZY16r0zfOv6PRWuaRJml6kqfFo2COQxa4TA7Pitsr9Wi8UycznxkZCrEv0oAa3fiGtn1aF+h8FaCXCKevNQEQJ1RaJHUtAkb86n781fRnMHOWTtPqJtKzWTfxWlDih3h7fqTmb67WmQf5fUui/vGcFOCtzHpWWyBF9nO4MxiEPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWefYr1x; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWefYr1x"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a79998d35aso26793555ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 05:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771853358; x=1772458158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9C9BNhNVdd+lQuTXkIJYUwqSO8EqzgaJtKCGGRuNxI=;
        b=LWefYr1xmyVUnxWl3MVTbJ/pZEyH13z9NwIO946702guaGutDG4Pn3Dmmno4o1shLt
         3Nn+7akdhY5fGsUogxr68LbmglAzx6kxSwl0L2Gux7wlN6SQ3quUVvWks0baNaW8REIu
         ry0t/rFVEm9Db7cAjkmUPrRuHLmsZqIYzibHWCHDvF5Y6RV8cTD3jRaUTmMUznGMTpFQ
         tzluHqF99NGMpC5fkZLIEItDpaCxuhE1FkVOnm7y/q7+aC/XTX9EfGChe0LM6J+iFnNC
         Ssuoea/6dihJ1/uNPhidtaALMaq99A8ijFQ4dLDGXAvRqgUH/pfPvDQFeAz1E45+NRNy
         Reuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771853358; x=1772458158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9C9BNhNVdd+lQuTXkIJYUwqSO8EqzgaJtKCGGRuNxI=;
        b=T/ofce8l/+g//eCVHL7b6eH4Y8qbQyn9bwUT6BL6NM0U0G7UPwB9SdMC15GKB+K6UT
         vF0WJWtMlxgynocxDNm5FVZgtMjhavZMFjGM6cNBex4NpDwdN0C7V/H415zvbMzyNAbi
         VJvgXbajMiKSqIZqAGrVeC91tJLrru50T5LO5FdsWS/nt0YPSa551pwO7H/xzeSZUfN0
         /x7esbPcF5HLA96F4v0T0TqGEkef9Zt3UwDsGt2kPAOHIc3LU2XMSoJVknzdjVJ4TkQk
         b39cvF5vfaj7RWvZY4vgN91kI6xccS2vugKllzerTQuQJb+iK2p7es8ZGFmIlf2M80LW
         GJrQ==
X-Gm-Message-State: AOJu0YwV60uW+RuPuPwvHOMsE4/jv4+Il/TPt4oD81BfEQXtkQ1mlu1p
	Kumsmf9Ky4fAUzjdgRTeyjY5G4QK+GF8mUsoP1ICjg+frkp4nRWhqPWO
X-Gm-Gg: ATEYQzzrrJc81S8e5DFuEYP1wkIKfRMc59CYoBPskkrkXXeeEBpWy5OH6PzkMeeiFeQ
	tn9iAPqXOs61ijlpYGjwCT4U6Nyqyl7U5of7zmTcWIpxuTOFLC7mNW5IS6w3598TGVhywJU+ix2
	6aTyXG9WlP/J7z+alpikahoYfce0I+Oo6+/f2WSh8PMoXNjLv7i+uTr7Vy2YQ/Rdxtne4y4AJXA
	P8Pekn3rdeiLgi/5FxPxKUy6U5Ac7TgFE3yQJlYMjHSWkSclT1K+jEhn0P0vpswgZg+YzMOyrAK
	xRzOQIpmy+42rz8bukOr/Pih4ai2GjTeXomADDOZhB5NKpXqL786AIirE8uc5rACZTRLSpqHchQ
	d4ESY8WOrMgu3yw3I4O5KIg4obevwQWYIT1BHavjineWURKUqAjf7KVbjrbDefVoTp6gyN963VT
	S1afipc0KybnvotsEpTq0P8JmyKsE=
X-Received: by 2002:a17:903:2283:b0:2a9:3397:2647 with SMTP id d9443c01a7336-2ad7455fdfamr76547735ad.50.1771853357749;
        Mon, 23 Feb 2026 05:29:17 -0800 (PST)
Received: from archlinux ([2408:8340:a622:6ad0:e841:fcfd:4323:9565])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad75029f11sm74542235ad.69.2026.02.23.05.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:29:17 -0800 (PST)
From: Sun Chaobo <suncoding913@gmail.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	Sun Chaobo <suncoding913@gmail.com>
Subject: [PATCH] crypto: fix spelling errors in comments
Date: Mon, 23 Feb 2026 21:28:53 +0800
Message-ID: <20260223132853.37393-1-suncoding913@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix several spelling mistakes in comments across the following files:

- crypto/tea.c: Correct "algorogrthm" to "algorithm"
- crypto/lrw.c: Correct "mutliple" to "multiple"
- crypto/drbg.c: Correct "additonal" to "additional"

No functional change.

Signed-off-by: Sun Chaobo <suncoding913@gmail.com>
---
 crypto/drbg.c | 2 +-
 crypto/lrw.c  | 2 +-
 crypto/tea.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1ed209e5d..9204e6edb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1780,7 +1780,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
+	/* overflow addtllen with additional info string */
 	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
 	BUG_ON(0 < len);
 	/* overflow max_bits */
diff --git a/crypto/lrw.c b/crypto/lrw.c
index dd403b800..aa31ab03a 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -134,7 +134,7 @@ static int lrw_next_index(u32 *counter)
 /*
  * We compute the tweak masks twice (both before and after the ECB encryption or
  * decryption) to avoid having to allocate a temporary buffer and/or make
- * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * multiple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the lrw_next_index() calls again.
  */
 static int lrw_xor_tweak(struct skcipher_request *req, bool second_pass)
diff --git a/crypto/tea.c b/crypto/tea.c
index cb05140e3..7c66efcb5 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -2,7 +2,7 @@
 /* 
  * Cryptographic API.
  *
- * TEA, XTEA, and XETA crypto alogrithms
+ * TEA, XTEA, and XETA crypto algorithms
  *
  * The TEA and Xtended TEA algorithms were developed by David Wheeler 
  * and Roger Needham at the Computer Laboratory of Cambridge University.
-- 
2.53.0

