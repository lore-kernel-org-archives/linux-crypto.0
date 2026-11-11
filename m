Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396724;
	b=Q6QSQ1/LGXMYOvDiAJxVxluclQ5WiRvkjRPkQeZXqWZXW5JyB7SGRQ+2UDRxEnYKD8S6
	 MqwhJWeNl7aaoMbg4jrOIP4VC1cDV/rX1rQNuPVd38/DPMGSwbxmUOZkhf8qu6KqYkxbu
	 1d+BHiJqmduy8mA2M9buDRwDQz8JlwW2ueMW8Z3KfRIAQT3gWV8BI7P/5vbsX8A6i+HmC
	 BPWXERSz9pXlhsosqG2grB/6bjs4lFFV+nH4Z2771tcJDDIUlisJ+zq36R/AzSz2ox+j7
	 uTYAmSY35O/A9l7fi2KE/17/zAvVoq8+9ueeL4nzeP97kZVlsPHR3Khx/hMYYK2GVdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=frBVeqwplwR5m53kO6bZ3ZT+hKJmGjH0RV1j/WWknVA=;
	b=BCRfMi86t2WLSQ/9CjZ6GFHXthZ2lA7IZR8IFqtpdDFtWQBlyh8PFcknxfegMEQcgEyN
	 VdntE7VqMVoBhU2IOvdA3+dkQkyvYCZIWSPAd9qAspR23HrKjm4/neJsWLpet/+tddgVQ
	 22gVquJWEnxPIyo9bvIjROq/T3h/zyKw8mBS30fAsNGejN/1okxdk9J7STE72ZavM3ugz
	 DZXLFFw/6LQJIgwDV2SwXaPcOBhmG/sedYvm61LjqfM8DECZaZJSb4dASo2d0yklhcg22
	 8qeFj2vbczZKzCR0G/CMmR62xFi9y8KYJJquhT6Ao0Ax7vKpj8dWxmDzAz2rD+rNXow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4PoGpfH;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF390606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 11:32:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF390606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4PoGpfH
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso3571851a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 03:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396722; x=1795001522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=frBVeqwplwR5m53kO6bZ3ZT+hKJmGjH0RV1j/WWknVA=;
        b=U4PoGpfHyccAxe6YWR560fSnDkpHv3Yeg5xxrEVC4Hj0TjnpBUynJsx44WtCSTeKTS
         yW8oAd70S4cmgVDBonuTBLMQChfXGVi0/BsFxBqm9znzrxrcEI9MdwEfOu9YNlg7f5f2
         w1SPvXaGLqh1N5GnEAWNaRXlXY3Y/yWzhjyGR7+TiXjBh7WSEyvIbvFTg6pNUf9znzKl
         POXH2qpaJdPBlFllhjFAS6R1ZV/KR8ht1P1XiniROewt2Xi/7a1lx5o35oTyHww9HeFD
         8ihjAUdTf/FS1+TZwnkgOXrlZlMZnbTzRBv9q1w1gghyFdCDJxUiE8PCzDswqZYZ5CEy
         DVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396722; x=1795001522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=frBVeqwplwR5m53kO6bZ3ZT+hKJmGjH0RV1j/WWknVA=;
        b=kgdIGCCWS7OU4FkVj5SXQbBPeM+/a7bNkee3nd/ciCj/unZKZMYVKyf4CYrlg7jVfP
         kd+GLFtN+jNDV/++LqfvYUSAXA8tqAwD+st+0GYTnGGLo5nXwMFNBPMu5c+HJMoEnzOx
         8ExrNBZxLTl/KJongvdVWru3qmdlHIS/AbjdGJNvVcr6UW0S20MQ8Js7JwWCi8TTDoDx
         ocglT1tVSISsRvyfAQHUxbMNiymjtisUEKe5uSu3TM3jmK8MBrEh+S1vn4kS65YPFA29
         J34RUU9qTBIAJRv3c4B95KDPDSrTf3Htb0/2Nxwg7LGIvqibHipfQUpV5EooyoGF/9AR
         q7sg==
X-Forwarded-Encrypted: i=1; AL+hErH7/jWWHbv6ihjivFE5ZBuu+xxnkyezlvyhFwhsFDhgUVcajNeNjtk3Pxbui4WEQmO5ZEGOm0zIAAU/ASA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8cZCrSFvM/6O/0PD24u8YbjoSaXfIVyQ1KXPk6uzys62r25HNv
	7XI4U7Iz8qJQdq8olL0Tk1xqifpcZ/5uTmqycU9VbEX7MhVAJmrM4ASNtlk0MBZC
X-Gm-Gg: AYBFou2lA2SZw+rmUFb19xF7GYJ5/Z+XciI4VnwCr4hxmn8sJtUcyM63keIZWHF10ky
	H3jRyxPjDcWKu8ljM0tQRwODMs3zhsqhOiQeJ/na+P4ghPQPyt+gESuy5gnONF8bLGPpRjLsBvM
	g7itEN73NFv/AZ44v2x5iryOQGwFScH1uY5tqVvUMigz73DXbh/GoEahJirlLpHg0kftWMEyATd
	LV+JALtNRLSFEfxCQk/g7BPn8DQBpnG7I4XJkW9y5No++tbRbeMRGBviJJiWOt7RlrJDUi0Ud/O
	ZzAOveDBedWPRPWe9hyc32HJgWo/lxl1xpTQm+NXC3Rlq0TR+QqnR2LfyFeaMGJOiiKQYymz3pW
	+pzV8u715sHnQGoTuwMwbY5naFfR8n/nutODw6kyBxq7XRS9NwDItWiG1URrEXj1FjMvE2r0pSq
	C9A0wzZWnzhuXEMSFvYNJI7KCdZzbp3ps2zRNXwh6Gy4ZUTMlpaKESVz1bnA04UGyY3yzCPbEd8
	IDoLon+OBXtEThcryZlE8ycPmfp6BeTTuTPXbowrVI/K57ZWXL/x7cJgKmpx4yOis68Fir/J8Ts
	bn6kQrh1LEyfmwDE63enV5gY6ONq3Ib91rUt1NJG7etA6j6LwiqrjT4=
X-Received: by 2002:a05:6402:a646:b0:6b4:6464:8a8 with SMTP id 4fb4d7f45d1cf-6b777707042mr1155901a12.27.1794396721909;
        Wed, 11 Nov 2026 03:32:01 -0800 (PST)
Received: from IRS-520670-Linux.atlascopco.group ([147.161.188.115])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7579031e0sm2309141a12.29.2026.11.11.03.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:31:59 -0800 (PST)
From: efecanicoz@gmail.com
To: lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Efe Can Icoz <efe.canicoz@atlascopco.com>
Subject: [PATCH] crypto: rsassa-pkcs1 - Allocate the RSA buffer separately
Date: Wed, 11 Nov 2026 12:30:22 +0100
Message-ID: <20261111113022.2033191-1-efecanicoz@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Efe Can Icoz <efe.canicoz@atlascopco.com>

rsassa_pkcs1_verify() allocates the akcipher request, its private
context, and the RSA input/output buffer in a single allocation.
The buffer starts immediately after the request context, whose size
is not necessarily a multiple of ARCH_DMA_MINALIGN.

Although kmalloc() aligns the allocation itself, this does not
guarantee suitable alignment of the interior buffer. On systems with
non-coherent DMA, the buffer can therefore share cache lines with
CPU-accessed request state. Updates to that state after DMA mapping
can interfere with the device-written result during cache maintenance.

This is reproducible on i.MX7D with rsa-caam, whose request context is
48 bytes while the kernel DMA alignment is 64 bytes. CAAM reports
successful completion, but the recovered output retains the original
signature prefix and PKCS#1 verification fails. This prevents the
shipped X.509 certificates and regulatory database signature from
being verified.

Allocate the RSA buffer separately with kmemdup() so that it benefits
from kmalloc's DMA alignment guarantees and does not share cache lines
with the request context. Keep a separate pointer to the allocation
base for sensitive cleanup, since verification may advance out_buf
past the leading zero byte.

Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
Signed-off-by: Efe Can Icoz <efe.canicoz@atlascopco.com>
---
Tested on a custom board with i.MX7D and i.MX8QXP, running Linux
6.18.37 with:

     CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API=y
     CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
     CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y

During diagnosis, the selected signature driver was
pkcs1(rsa-caam,sha256), with a 256-byte RSA buffer and a 48-byte
child request context.

Before the change, hardware completion returned success, but
verification rejected the recovered output because it lacked the
expected leading zero byte. Its prefix matched the input signature.

After the change, the sforshee and wens certificates load successfully
and regulatory database signature verification succeeds.

The cache-line interference described above is supported by the
allocation layout and the runtime comparison; the exact corruption
sequence has not been directly traced.

 crypto/rsassa-pkcs1.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 39137476ce81..87243458eb5b 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -237,13 +237,15 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize, GFP_KERNEL);
 	if (!child_req)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
-	memcpy(out_buf, src, slen);
+	u8 *rsa_buf __free(kfree_sensitive) = kmemdup(src, slen, GFP_KERNEL);
+
+	if (!rsa_buf)
+		return -ENOMEM;
+	out_buf = rsa_buf;
 
 	crypto_init_wait(&cwait);
 	sg_init_one(&sg, out_buf, slen);
-- 
2.43.0

