Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867631717B
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651956; cv=none; b=PvslMAORg/fBpTyXChjuaO99V6rX3lIfrFdmPNuL8gd8yGD+jux+ktkh5/aJwzXFouJu8Agc5MHLGvMEE2vqIhXP5brx5Poiyq9KFF1tFI3iluVGnRoOj/N/e3BlEat99o72CdIi9AYKJPRBOiCrR2GfsENp/KEuWOe1fy4mjOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651956; c=relaxed/simple;
	bh=q26UTZln7vxpVLQUpB2k7H9kOQSzRK3kvbnGt02k2yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecmitKv+jMS4+RUDT54AUgzp6OQZpua34D8R6pAv4S0eWHfOtzkM/tAgO9YhJhIGkjT4WytPc01SqLNf4vWK02jDH/HGh5X1sGaYjP4ycvOfgX+TdSLtnwKVql9eEFBwKbx++cPU4VPRURpcORiPESKQ74oKTWaQ6lhUtPphrj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IV4182/R; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IV4182/R"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b4650d5f5cso36736285ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651954; x=1780256754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neaNKTc1iKEb7KTL27Z88clko1muflEHCUKBETav0TM=;
        b=IV4182/RWut+1YEBR+MLLOhF6j9FL1lcX9nS2n4rMpYUnEKWNCii08kYx04B8AqBw9
         Nxb9s47iZ393HN3k6xOZevbRxCqHOkf650Wea1Y2dURF4XjjC00bALDYn5yJp3qaFnsO
         EnN9HqQNrDVKA1NNx+EHlygYYuEj5/eU2/X4a/rlRJ5dvs7IL24CsLKq0S1AxdfLOaFb
         NxgnyEDqKWSv34TT9csLdG4m30wZE+ZUM57yWSoRrOYTZNqauMcZQXrBE2ZaRlaWGpbl
         D0PhqbTfOd2yVxOe+XyVX0ExzVnk/QI07q/VRiFUnol5XepagXZCFVoj0TgwNX9O9nbg
         7RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651954; x=1780256754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=neaNKTc1iKEb7KTL27Z88clko1muflEHCUKBETav0TM=;
        b=lR/oALPODP55b8/LEFABP7BTlOMIpaRGwMvwBLscIMhtRRHAGAPa9+NnOuvZAYFsn+
         TKIB8ScETF+8pQ0XaIpept7S32uN4DmKUklCMwuOQgfjRWGiw8gKkcunWP27WTDe82s+
         TKBdNKNeEm/e+VDrLJb8ERqImcpGaymtRDAk651gYqJFBInqmcor2lj7aNZK/ZCIrh8l
         +Qp/DZiPjrfwhGWoZfvXCkMWtcfvkTdEqlS/t90Fzh/JcIcdTpwxIH8N4w7YUAmR1byO
         PRBS4MqcDxznfsT82TGSzkcFMZXMbm3kraHHwG5jh81B09ZePaigygpM7yowQ+gbNgVX
         /hfg==
X-Forwarded-Encrypted: i=1; AFNElJ/Tz7jj0LuAdx0Wm8zXUhNnrbXnl7rh6vdbcjLKGdRb4Q5wBC2MAG6gKkuA95BfF+Bss6FZsSivPm02V3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBO78P2DGs1J1RHfYz46hKCxjjlRbIz4Tk3dut4R33P4NxM4N9
	sT6v8MMxsh8Lcikb8Nzfs45bYvtv+b3QtVpDwlMpgW6WNPN4XjZT3qQa
X-Gm-Gg: Acq92OEdyEIp0Rrw6FCtbeRgVhkKdKTFiQ2rHcx5ERAglo9dkWuRRRP++DvzwJaj3hA
	daIjEG1rLXgPSHgMjjNmwKO38ZChIUtteyUlcSM6ifhRY553nQHLyLW8+l9EVGIoVwlwLJ8+BvP
	0myZNSz34BBXriuMRwD0F7bSbDoVepKRHhkV/RcAKXBNWbV6++2Cu1VQ+38dhGuGwmOiZLA145a
	5k2MG296WSSJRvrzCiQpwHVvPElKcR/knVAWDtbyCBKvXZl94PfxnesietmXtltfqBsmqBDfiZP
	aNODlU2nrLuulChoi7rqoKuiTs491qYCr8TdeUMDPvkCZGbzYkoI9boOgp9L9sspVqEbscCnZPb
	NGdwepsn3KuLScP/5B1BXoHz2DLO5y1s2f4odzV71rjIPaE6Zjtd/PjsKKdfhgs19TePj8m0XyW
	zYfhssV9InRJ0oAJA4+Pw/VjNX
X-Received: by 2002:a17:903:1a70:b0:2bc:d1ec:9f09 with SMTP id d9443c01a7336-2beb06be3d4mr123969875ad.40.1779651953703;
        Sun, 24 May 2026 12:45:53 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:45:53 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 3/6] crypto: eip93: reject HMAC requests before setkey
Date: Mon, 25 May 2026 04:45:25 +0900
Message-ID: <20260524194528.3666383-4-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260524194528.3666383-1-hurryman2212@gmail.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

HMAC requests need the precomputed ipad/opad state installed by setkey().
Using an HMAC tfm before setkey() initializes the request with an all-zero
ipad and produces invalid hardware input.

Reject those requests during hash init so the failure is explicit.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Originally-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 63bb6c4670cb..060e90c5eaa7 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -300,6 +300,9 @@ static int eip93_hash_init(struct ahash_request *req)
 	struct eip93_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct sa_state *sa_state = &rctx->sa_state;
 
+	if (IS_HMAC(ctx->flags) && !memchr_inv(ctx->ipad, 0, SHA256_BLOCK_SIZE))
+		return -EINVAL;
+
 	memset(sa_state->state_byte_cnt, 0, sizeof(u32) * 2);
 	eip93_hash_init_sa_state_digest(ctx->flags & EIP93_HASH_MASK,
 					sa_state->state_i_digest);
-- 
2.53.0

