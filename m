Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637C33E0C7A
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410442; cv=none; b=iun6u3rgUCiyaY2SyizOxUe7VYf4r0J8i1n+ZkKJGJ8dfoqYoydbizm1WjWi9lmPHpOfXJFeZlDemRtX4MfAl1u9cEnPxPg8umFW096QC21Q6gPv5xOU4gPxMPntcXgC378dsQVCja1HZlmoc88WuoYFL5YcvN7d1Z0mnyr2A2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410442; c=relaxed/simple;
	bh=a51/JbmjomePrg3BD83fj4YRlxf0Ru/rIXYOjUehCZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NwQ68npOALvsSOEemkjhmL1J56Fq81j9B7JRu6g5hMPH6ZtM8TYUyhHfF9ZOysORMLfsLPRVEcM6OqVsHUsLi0L9aadD4l3MCZK0JeGP7OKVVEtOnMpnXNtSNNJm/iP45G607auQxipPBVjaWS3pTuT66bH0XkYVYzDhINA9GNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=eEVmiUQl; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="eEVmiUQl"
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A3F353F9A6
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785410436;
	bh=emWGlwCR096Tp0952lwWV6p+kGuauKQ78d5fk1DQuOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=eEVmiUQlZSbBA6R8b4o7vASX7wr4ErIe3PkNnhUTF6VBnOCdVt958nbWHXJeeenX8
	 d9c6tER9P/hAi4PMLPafurTyyli+8u+WmFQJF45Qek8sKR2bkce8JuOUQbs6QJ1W6N
	 HFQw9c3LR9fuCGf/YM1zoFzGUbnnPGz6DB90Hf0o0StADj9PweuOCqrQySltHW0DL6
	 T0M0AHIwp4XEDYW9+Sbh6QNDyhN0jAVtUSvzqJQ5ydOfNcpAmSZGUs8Y4JH1s918rk
	 Y/O9PfCybjMlHp/GSoT+diA9hpGWLpvD6S+f/AxmlAzIUOtw38VOqcT/Fm9k2D0i3W
	 cD3ZsjVc6GRko0xStVTiTdRY8sjzWb95tUZHDbVGFkMofbwM5bAoJiaTBuS/hWaAEa
	 iiNnber6it99DK2tEvQIiUv3uvCn5RaMVKYeXISN2/q6b690C7Fas6eijBbNo26IeL
	 SPfkYw4lVhkF2nDS7N6TRmqWR7f5+fPi1DCJx0ZtL7kRWEmGHWu4uVGfEljn8iML0U
	 8G9anB8OkO+52iJWgOqMKuD5szkzgQLuhQYis6Xlp1R+bqS0SmOKjVjYH/6JEcMUQh
	 Xm5JvFaZy39ea/kJBp1WM9j9Q8HX180xndy1TSASRLkxqBn7FY8lxe+Iy+5iyOqLH3
	 s/CxeMA8mvTpjOimLrsTNqLA=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8485b7e18b4so3487560b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 04:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785410435; x=1786015235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=emWGlwCR096Tp0952lwWV6p+kGuauKQ78d5fk1DQuOk=;
        b=dW6pGqZUL27MvECQuiZvVO2/GH61CMoPjKEPa/LgJG248aNetq/pL6EMsLkMDjv6WO
         ZNEbAQkWsw4tQLHD2N5biIZ4/KyLi8KWikIMvBG7EuJ9x/GoQY3ZjnVumSoE3wqXjunv
         EDYTF9zQjXqYmpvttnTnaqO9PXBKLiH4dLPFe27jga1WlD+Z2MsFT/hPetn39uIA7LW3
         mjsF0MWVZUv98PukK0HXIp8wn1eMNyulvq5R4WTFpozdXXJbQIOxHJ75AotmRV+8LrPj
         ANo9zuoJD9f0BPWjiVWMZio5FxMOeJpjU8rBM2/bMaAV3UbGacZD+P/7V6ze6tGnckLH
         QGnA==
X-Forwarded-Encrypted: i=1; AHgh+RpExH1NSg8o8c7XsfYfM9Pr5mSj5CHR7OYWcFgTfVyYYbNYPg0OqOC+sazfROE+zSwAW7E5Q1v3TSKK7VA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm8j5ehCDHxGFcAvi1k7IRJ47BhX8wSiCD4j3h6oi6/fHQvWHP
	2+HGVEU5DFw6A2d+Cs7kdf1oZVz7Cjhvr5k3m7RHlg0IyeRtDgVXedMd9uF9EgtmFD1tqCdL960
	spdbXAPwEWsuFKhu/0BHWp6eq7xCDxYlSrCljbBarOOpz/T+1Y4ttZGJjWrWCCYsoV1KUJryhlz
	JOvza6Sg==
X-Gm-Gg: AR+sD13QHfPfGjYa4rJwjfA+UGlTM2dAKIuQ2Ps0DU8+qXz/+aTj51iqjvVf9NLBv9a
	h5Z9rGEMs9VzXpKLBugyUXocNSk/HyckZ9eB5rv96qUPPWF71cqqzzSoPNXzGd8/JIc6NLqQg00
	xVqEzx3ifylFnZA6OK9I1P5Ah0oV/wYJh0kcs7JBGYyeV/Dx4JdkK5DbW8vbYJue89Jd0KeFAW8
	zrnRNHIreI0GuEWy1R5uq47AB5Zi49kttobGJEpajzJ5/M3v0HwmKZ2UezFo3IX3aS+QwuGdcq8
	taW17Kfsg8FSo1E99elYago11frxR9lltCKWVbOpNrrwi4Nk+RAH/f4l1KvkuPpvr9H+UIU6KfB
	Y+QYVS+ZAL54=
X-Received: by 2002:a05:6a00:4003:b0:84e:a0b:1a4c with SMTP id d2e1a72fcca58-84ebc432c42mr2188860b3a.62.1785410435026;
        Thu, 30 Jul 2026 04:20:35 -0700 (PDT)
X-Received: by 2002:a05:6a00:4003:b0:84e:a0b:1a4c with SMTP id d2e1a72fcca58-84ebc432c42mr2188828b3a.62.1785410434591;
        Thu, 30 Jul 2026 04:20:34 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea7344ca8sm2562185b3a.21.2026.07.30.04.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 04:20:34 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: lukas@wunner.de
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: [PATCH v4] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Thu, 30 Jul 2026 21:20:26 +1000
Message-ID: <20260730112026.1612066-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

out_buf is used as a DMA buffer for the RSA verification operation.
If out_buf is not aligned to CRYPTO_DMA_ALIGN, cacheline sharing
problems (data corruption) would occur on CPUs with DMA-incoherent caches,
leading to -EKEYREJECTED.

Allocate out_buf separately via kmalloc(), which guarantees cacheline
alignment on architectures without fully coherent DMA.
This acts as a defensive measure, and avoids the need for an extra copy
in the underlying driver, which should check alignment before supplying
buffers to the hardware.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules.

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
---
 crypto/rsassa-pkcs1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..cbd76394ebf0 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -227,6 +227,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	struct scatterlist sg;
 	unsigned int dst_len;
 	unsigned int pos;
+	u8 *key_buf __free(kfree_sensitive) = NULL;
 	u8 *out_buf;
 	int err;
 
@@ -237,12 +238,12 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
-	if (!child_req)
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize, GFP_KERNEL);
+	key_buf = kmalloc(ctx->key_size, GFP_KERNEL);
+	if (!child_req || !key_buf)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
+	out_buf = key_buf;
 	memcpy(out_buf, src, slen);
 
 	crypto_init_wait(&cwait);
-- 
2.43.0

