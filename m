Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197609;
	b=VeZeR2gZSOxXDmw6Kl9JeRn/Gqd6gvBpnXbQBJVUGrBhyfHJZThvppsotICmvkrMDBnb
	 stYeEvrfO9sDbihIov6KBjsTGestn6ngj2MpqaMi18vFuECojLdk1zQpK9f7i3FpAXdLg
	 rzajybDkt9VPpU7P0UukAoIuoXmL0ewZMewLcc1abSjVnAwmA5vToDr6XdvucspBODOza
	 bMW5NkFePw0xraCz9EvYoyfZo5WriQ0llyAl9+HgDFpvgD8BC4ZesqglJ9uXncdhIGIEL
	 3PpJgfkCm1ygQVJQIIKeIgcirdITcwMB3mtIzBfNOKeZtRjDgL9qWPMXILcv6abmjqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197609;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mAUpM9hp2JPWH7qVzCiMmZQ9MdNMzKuSufpGFP57zjI=;
	b=IR4fQdjnJHTO8io1Tx0BEIP2YK/7g/LKFBWS1WKSsp0On9RQd2SYMBFDsaPzry1T5SZW
	 dp99Mn5GbttJDIKGG+4T9bClQTDxs71HYrKI3UB/x2zzmTzcTV+6CwZvYg+0rWkst0L+U
	 1oXefVDh43MJdCyelkgkq8xCrmOPrKJR3i0EmXzxagTXO7dDHD9eRWYLZ7hCd4HKgSmhx
	 qGWTy/GFJyq7tAlygNyVma0CNRpzza6qs1ANxaYizYp0j91F4jPCIGgrWFEmoZ15aWuJ/
	 hSPinfVD5s0NbLt0PgWMgv/d88VZkM7PLJ9i8JYK9LuBTk6MDYPQoh9wzaOjY5s17AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdVan7rM;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17871606A329
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 14:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17871606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdVan7rM
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36a1947498bso2990573eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 07:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197608; x=1793802408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mAUpM9hp2JPWH7qVzCiMmZQ9MdNMzKuSufpGFP57zjI=;
        b=pdVan7rMDZM7NKWH+O5IGlX1yGDtitzpKHJQxhL4R8ucesVs9X8Xcb30l6Jc5MZLJk
         GPjhbUTOJAjYFnyBmASUngPocuIpIqc+qR6vbklKDkpwAdrzSSllz3QXrmJpGRf7kIvO
         /0YCqMMljVU9dCUO+41AAKOehtwZ1ApgNSz39cjVHuDwcaVTFk8R3npdvuuvw0yUKyY+
         JyQzs23d53KMIVuHuUNr3unkc/qpAE0HwdNnOEGGeoCecqE+yDMCWTlGPx85xL2rtqZN
         oZfsERiBkL0aXBcHa/Dd+q8MCzJtuzdR9QfsHe5+EiRw6yjBNCJLnsMKBc5Yn+lCvAW1
         OYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197608; x=1793802408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mAUpM9hp2JPWH7qVzCiMmZQ9MdNMzKuSufpGFP57zjI=;
        b=ttGmDKIVjgCY519qDO+8mc4DPnwuX1FmW+BUEcxHFDKQVNn9ZrZF3iMqDhmgn7U7Al
         CQP/FbFC9huDFnDkG3hZQFawYYb3rwDCrrgfo7BcQrVM9Pg34vZLXmcXXyX5CZ3Y7jTT
         QKKgI6dBMhR2IoyCbkyeO4+i2Ir5an8Ey2RP8blIF+cikvmTI9+cS38W7/lIyVsN5hQc
         sZwEvzEYzyzD7gQ4dXEZBXoex4TE7+t+laUgr1Z8pdJjY5psYO9g5ACGgjviHfT3QEAK
         zPGoC8Mhyb9gNgS+dXGUVrLcIsabk3nMkSoDZfIHqRS1IHRKL4nXN1bUTIpUwsIbCHPS
         Dmcw==
X-Forwarded-Encrypted: i=1; AKwUvBzLPsySlCV2x1luc20DVAV5+S8nz5gne7AhrtLTiKg55aniVANYbt/gzkFA1R1CvWnNgql9cu1Jvl2vPgs=@vger.kernel.org
X-Gm-Message-State: AFq9FYLoDmIn/iLvylJSUorn4iqGwf89W8/77lIGx7Uc0TYjW0nMczI4
	S3aNpLV6xSUo0iPNYKSBXZcyYNM4t2F/7+AyxCR4c/Ot75ZK3F6H0f6z
X-Gm-Gg: AYBFou3jzYUzSNVF+kqamiqUVZxsRpsYEmw2xNwT3xZ/z1h8hyYrYhhM8rLq8rxs9yL
	LR/z5kg30SZGpfvuyCpqLy5Qiz5tWRHL65myJ1wHi/ZUEoyiE/khHyZVaFyW5sws54sKykzv6F6
	9v6U/3RDAitRB4l/sX27arFnCbcMISFMVVQx0Hs2x0khew30buJHx4PtIXnP/sfl91ouaBgvnob
	pjokCuE4Vxe3ALy0EWk/UvV5UIm/CWSfD9T/wK1vUnxyIUJeTFZE318E+CxiHhOCBP4NYb4R2XW
	mwC41R8AEXpQoeq41xADrIynk5eLtg5C8fum9q0wa66+TKFkFnsq9ZBL1+weWt79PjY9/VJmSKf
	OO+KRnrJ075eW6fhDp/50eyjA41KgI1tMxHkPA2F6AkSdMAkFOpcrmW/qB67vF8FQZU0Z6OElHq
	ENuNIdEPGVVHJXtYXzNL8jm45vrY3+4CfuMIAHzAC38H7uhAmGGrQ3UFJoo6STA/a0Bef9+h332
	JwEV3r5fZf8NmeTJFEdLN5EE+V8l0sGegzOMJI3C/dPp+idfLaKsvL/cTRtCAE1gWuNiRfd9Hbl
	07tUfUQdHwXuZDTx/wFi6VTHawEcMer34rFEE54ngznCVjhhPAoc0X7XYDA419C6ary+fmA=
X-Received: by 2002:a05:7300:f0ce:b0:35d:d9a9:e455 with SMTP id 5a478bee46e88-36a203f3c8bmr3950191eec.21.1793197607827;
        Wed, 28 Oct 2026 07:26:47 -0700 (PDT)
Received: from kernel ([223.181.214.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2398fa4csm8689638eec.24.2026.10.28.07.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 07:26:47 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org
Cc: ardb@kernel.org,
	Jason@zx2c4.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] lib/crypto: aes: use memzero_explicit() instead of memset()
Date: Wed, 28 Oct 2026 19:56:36 +0530
Message-ID: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
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

aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
output buffer when authentication fails. But the compiler can optimize
that wipe away, so use memzero_explicit() instead of memset().

This matches every other sensitive wipes in this file, which already
uses memzero_explicit() for keystream blocks, tmp buffers, ctx
teardowns.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 lib/crypto/aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index e1c191551736..7814ef525239 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -1733,7 +1733,7 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
 		 * Clear the inauthentic decrypted data so that callers won't
 		 * receive it even if they fail to correctly handle errors.
 		 */
-		memset(dst, 0, data_len);
+		memzero_explicit(dst, data_len);
 	}
 	return err;
 }
@@ -2074,7 +2074,7 @@ int aes_ccm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
 		 * Clear the inauthentic decrypted data so that callers won't
 		 * receive it even if they fail to correctly handle errors.
 		 */
-		memset(dst, 0, data_len);
+		memzero_explicit(dst, data_len);
 	}
 	return err;
 }
-- 
2.53.0

