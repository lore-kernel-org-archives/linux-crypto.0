Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1069543B6E9
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444564; cv=none; b=V0khsAQfrlsuU18ZdJfyQQTLD+PO7rNlCWWu2H0p9TVit5NdFA4/UuJUeTTGGitNPJ7rF08YAIp9YecDkeZ1UBvcKCJv3rls28H6foK1Gt1IdPQNSVydWoX7S5+4HKwu4trb3REL3y9K6u/68cQyvAU4uqhysZ9HVXj4xWccIDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444564; c=relaxed/simple;
	bh=q26UTZln7vxpVLQUpB2k7H9kOQSzRK3kvbnGt02k2yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghTzXhC+GTrkuZdZqM4fnWf+aMe6Y36OJNLIulPyyJbKegUZplmc9aBhHcTZPqsGup9yH1W/+iVLhGKFszHCRSyKA4KO5I2Oqh86sXWXxEFM+3hGn8YVy4jpFP0wfZNDXp14xxKSnGy0kGlQhT+5VnjQvA5IJGhOQPnxME+d2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrNZ0Krn; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrNZ0Krn"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8478cc93299so4981807b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444562; x=1784049362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neaNKTc1iKEb7KTL27Z88clko1muflEHCUKBETav0TM=;
        b=hrNZ0KrnKJjuGIv301tCmJnhw5uvLo5jxU2yl/LWaGzYETvmtTyUCC9DDxNurc0EW9
         oqE8FtvfkMP/4ukxtuChiiAvd3L18TxngrZ7WwXXKP2s7VXpbfAGF54sJq6p1TdjN+12
         eshFymlL0UkezooHdUxLQi1vEdMxkpa0zQmBImfbJT5cXKNgBPQ/ka4i1spGfh2Zyi8G
         tr3Q6P8SE3T2cNHi/UOmre0U1NcsiZdW/r8JJNsA2lt/7uTsJXNLJscRnhdGck3Jq70w
         W8yClDh3MLmrkVCDZ72UyuXHWRCyGfE5zwSlPTVI5C0RiJIv/47/YtrFDzxsqXdhCimI
         zC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444562; x=1784049362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=neaNKTc1iKEb7KTL27Z88clko1muflEHCUKBETav0TM=;
        b=J9a+XFFXCqbNvKQIb3mBpQbnx7NCVLc4IBgIWCF3YSZlILVmkkR5p7gLqQpziU1l/q
         GuAxuAzQuGZGNEnLg0Ugn/3WhUHGDSK1pqJbIsLJdDM6Vk/ZmQc/sstPdWpg/VqJVZt7
         VmmVILKemBYOQx3dWWawTGc1e0NHLtrJSNhkQdfk6D3DAvHh+stfE8e7KjUJGyxv8ifY
         NXZqlc9uQy+QB8+1hXbs54bWIhRHMaeKzMSndO96s3uvObG0Iyg5eBYAv4G4mc/Ft1xh
         cuDsITnMBGJvkLEkbMPBJwWjK5nFAuCJ8xpOD7NQKRU1eDVCCQcxXdeXaru4maBXLj3S
         NJOg==
X-Gm-Message-State: AOJu0Yw7bG7U1sPdVY4lWyBtCkJ818tvs+cz8Wo5AJ01hV8YKiajt1Jc
	Q8Sh3etNZifSptbjI1lUGNA92IRape2Dj8iqp6ApLlkg4tYF0Fb8ec7X
X-Gm-Gg: AfdE7cmIClU6euMyBiLKM0J5Zf9LH195TGcks1qrhFs8nDpRPnh+4WVy4rTNRThJTRt
	D8bGfssx43itJWPrgR2kYDPPlQSQGyIY/84nQ+n5iRa4SD2trM7Y0iW/o3H9BRluN6S5w3mvAgG
	k1/FK7CWBciQZl3ofc5ftCXmbWsbofjEiTsDWY5emrrsTG3SuENHIqQ1kLJgze4VGhmu6vvrVNS
	Ms3ffFButc7oRnBOIW5+ZShe7+5TQNHAZzPtm0Brlw+5aQsTI3ytYCC17AvZLdkY+2drgkK9qv9
	/womGgwI6Oo7QgwdCceZ+LG3STnWN18UK73JhEQGTWdKVeGL7E7TAraUoPRwm+IvH3LKrJvA27z
	mdAiFZuW5kFEJsyeGm0OYWKo1iiiXzZXw+aHd8TTBemOBbIMXsVipX99IW3+MmJr6L0H2FWyHSn
	z16E9ND/yzQXuO
X-Received: by 2002:a05:6a00:e14:b0:847:84b9:f3f1 with SMTP id d2e1a72fcca58-84826c9f53emr5525867b3a.27.1783444562455;
        Tue, 07 Jul 2026 10:16:02 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:16:02 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH v2 2/5] crypto: eip93: reject HMAC requests before setkey
Date: Wed,  8 Jul 2026 02:15:34 +0900
Message-ID: <20260707171537.467608-3-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707171537.467608-1-hurryman2212@gmail.com>
References: <20260707171537.467608-1-hurryman2212@gmail.com>
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

