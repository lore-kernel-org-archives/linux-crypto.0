Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B620ABA42;
	Wed,  4 Jun 2025 20:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749070068; cv=none; b=FWVxv4hYlDe/vr4Xju+ZWJD27y2V0m+T1RmDJtQh1JcWVOClYp52WpZGTHhCTHQ+mSY7oxg07YrKcznI7iaWpwfwJSrsOa/mVhkdJWsHQjqUqBuPS7d/ibsWm8x5KACQSEbnej3fJLGzUyEmw/ffYsyTsIN++PYtCeazuVWhB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749070068; c=relaxed/simple;
	bh=RtHwNpiafW8lh4RMaVBEcTJkb9on9G2678OvSBi07bI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vx79kSbWD+LUSSAuTCUp9C8l0wxdFzbJQB97l013+Zw/eFv6jbCoyPEGRxffjnOw/T3Q9xpnRVK3OEevg+Nc4jSdHMyUvDLJRhX3zcGot/crZyF6yAsufepN8x2oda9A1CrS/LzXjuNk1Ew4YDS+QrRY81xdVZpCXffLZbyDeVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAdLUBgc; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAdLUBgc"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e812fc35985so336013276.0;
        Wed, 04 Jun 2025 13:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749070064; x=1749674864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vjwViiFJwU8CgwCU7LAAMLSZKpx7OJjGK3xVMyJx3OI=;
        b=VAdLUBgcR1KaX7P6nFn2zQBJ/VOuBWexVwKnEePukYKGRkV0FHbNevWYC2gNWIjE9D
         aW5eWAvTVfQnatR7rbgOAEJ3KPF1HH9KQp8Aiw461cfgKDqkoaUO/p1B+mWL4piJTgKh
         hdphprbFtX5gbLuOruOvqxLG9zfpLd6XlvcavN+cLcK6gaQQy8yoc63PgAANAjlsomWc
         1qLsUVS2vFhIS8pgzv0sJeN0RE0Wnqg0JaencuwJ3/KsstS7VAJxw5KbYoFt/OyM9dzc
         aBbRtt3WK+Dz6p08TDGpS3pshMuzRBFOffmLi6Zbq4QkGIunT0luyLdtaKWiMQlHz2Ff
         L9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749070064; x=1749674864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vjwViiFJwU8CgwCU7LAAMLSZKpx7OJjGK3xVMyJx3OI=;
        b=B9i0z/8lcnSWy7/y+InL9UEjhyV2huH4yly70BeazsuNMLlFtzw/7zBLy52lrLKd5F
         gNQ0ESjFJRtYZoCD2lnvA/Xrvy+Nixq8wdiOM0D45cZutY8gd6noTy3SNgd1gm1Nop4O
         kUBeNUKpRGRYzAq5GJZmlR7l944EfmEoMtS8j16jrVliIQDVuGD6tu577fHVjIIUNO+W
         XsMY8vRM+StyCZ3LYQZAQMyqGeT7L/z4ymlnFsH9IHLQO7l09y2hsAHmFxX6WlLkeEV9
         XgQ6DLAsH3g11XSC8qgARZYJJyMJYF+c19MMzPmeK5aLMxtCEyoDS8PLWsu32pdf9Lbv
         L73g==
X-Forwarded-Encrypted: i=1; AJvYcCXfJPiqfvZmngxkxVq9Wc0LqTlvHjvdRjbsMVEFN3odB1zmp312NcdvWtXIGLEtik8dybtGndQTtqhNntw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEu+dXfkfxi2E1P0SDLL0rkxskqATInF6E/NtjU8uTCo7wCgb4
	JtvkmL9O7T2/2oqTcBMW8YGkGn2qpFX1kt7RBhvXbj0lmmUHKj7SkgooR+X7Bg==
X-Gm-Gg: ASbGncvme7ak+kNQaQcLnF/jhKZou+oFmdMDEras7Kg5JNfeOG9HtcGGCm88bFksb4a
	gw4TKww4gS+PjZVOHh57yu+WORwnPcvC/G1InQH5qOd6F051RBxO/3eypnaG5mbUFnSsNin2quw
	6pruxs4rMt2dTQH/PQS4pzlqyEKc6ni4N6PPkngKkES4kc6NN7z6IYSa9To40r4PZAm3zTyRyvr
	yIBQ242fqckA60vUcjlKgto6giPbKn7wG926evP3LTW9aMgsM3uHcgOpaiAA64eOyAj4LzNGMhx
	lvYPbYXbsEVraCfyz5IZn9/wMa/u973moHUxKmeyZCoFcEr0q2Y9JtehAur5fO1QIEtVvcUNt/P
	2mPg+mp7AOMI=
X-Google-Smtp-Source: AGHT+IHh5FeDd9yAuTUr4b6I32rGBvp1Xw2l6fOORmIF52EiRq6xHKfuHyoeapaXL005Tr7o9y7pcw==
X-Received: by 2002:a05:690c:4984:b0:70d:f47a:7e3f with SMTP id 00721157ae682-710d9afa6a8mr62253357b3.20.1749070064529;
        Wed, 04 Jun 2025 13:47:44 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-70f8abce520sm31878677b3.22.2025.06.04.13.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 13:47:43 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Cc: "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: [PATCH 0/2] crypto: replace cpumask_next with better API
Date: Wed,  4 Jun 2025 16:47:39 -0400
Message-ID: <20250604204742.21183-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov [NVIDIA]  <yury.norov@gmail.com>

Recently added cpumask_next_wrap() and cpumask_nth() work better than
cpumask_next(). Use them where appropriate.

Yury Norov [NVIDIA] (2):
  crypto: pcrypt: Optimize pcrypt_aead_init_tfm()
  crypto: caam - Fix opencoded cpumask_next_wrap() in
    caam_drv_ctx_init()

 crypto/pcrypt.c          | 7 ++-----
 drivers/crypto/caam/qi.c | 5 +----
 2 files changed, 3 insertions(+), 9 deletions(-)

-- 
2.43.0

