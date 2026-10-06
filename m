Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720E037F310
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 22:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791324372; cv=none; b=pwCZ5DErWOaij9v0ln72XBjgJtvlHRoq6N03NKH9mfC6Q9/FJ7J0o0NLej3xbDWArAmcqd4bkHdZhwIr7ie0hKLE62J41qV2Ll982xR3ZL9sy2QKReoqIPrKXZLbCsWC0VyFtPNZ1++/rxKBnqQoHxV51UfTgw0ttA8LCXXvfQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791324372; c=relaxed/simple;
	bh=c/drCJen5LJMtn3pQqXT+RbL6rm/KkIjmd4Ej7ez9pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K8+JNlTzMiGMRTzLXPHAjQXtwKFboe9wx/stVxhSjM6zNa+XXq6OGOR3fVxvcYNphYb7FxS/zIh2/u2eKKONA0t20nZo3auserRLF041t1PlQDAREnUqBLBN7YU8v3/Ia3IlA84UCePbpAg6S9QhSJobw5V0s9pYr4QnjnGRYc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=Xb2csrNa; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="Xb2csrNa"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4af81963f35so648977b6e.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 15:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791324370; x=1791929170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r/J703MqDk74gwFcythehYWn182MykFiNjG1Hjsd4aM=;
        b=Xb2csrNakjRLjNRB8ncODQgCjnoOrcaNFjigLK37WK34bGwgjwXqOvpC2rcBxHBszU
         H0oQdbn1L42Xrh+UW9VMA0RzxO8GH2YWmt/mDXs4A3ty4Vh5CKc5ORPnDJ1hU2/O6Hbk
         +/63XA/Debbbi+u98D1pGrHf2PAEt67OFkis0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791324370; x=1791929170;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r/J703MqDk74gwFcythehYWn182MykFiNjG1Hjsd4aM=;
        b=JkXechGtlL9VM/OGMG8Do6TSMdshNo0VQ/uv5IvY+uoKlTfDsT5OzF6iRA7gwOWzs9
         nFPP1XIz7moSZsm0Ot6XA2dnAM4twPQfEijnkp6LYeMt+8K4rkdYkuY5egfJbavhBtBg
         w5r5dQDTpH8a1ydUsM5XKZgkBjh+e8OHWdtkiFsUD2ob3tmDSHmvsnWgZkcUnJpFEhtD
         gbgXvkHeR7mfkDIjxFQzxz0sT5KvNvxIAl0uuOjHfbBUnrjPR+AZxCtLl+MUVWtedlbd
         Kdk+updNnxTxbr6UAxNzNsBxAIue144V5ERBg10HDNhvqwUmpe0vKZewi/P62dXj5Dtk
         4bJw==
X-Gm-Message-State: AFuF++mY5z5hbO+qqaCv7b1QouxrXYa1g91j3L2jNsEC4RD9iav/1UvX
	AwJLti4WXb73L8eGiOS+qSArcV0JreqrUnWj8Bw7gPE1i5kBrEF6hMVVFBqdoq3vB5vd05yaNte
	zJbxGilM=
X-Gm-Gg: AYBFou1PoIBUhANAuDAnp0a9zmpd5DhHDxn3isxBdFR/F8H9eVkHldGGLRjdj0IIJg2
	Anth3blil6LicQKeAKXKZL3KyikN96bSlvhh2OdIE7JS7oG7VIbsggqhuzSslkqiWX3MK0ktFAH
	yoD4BC52Flb08y6B5iAZsspcEx1ckik84PfZMTVWa8Z9nGnN4pSjfS+1nw4/D3vUMFvgbNKkxPN
	KvzxQR0H1laE2aybqq3vQD9Jh6SrmTVfYshTZ8Fv1vVMsOkfGf6L3g8K3Yu7KWT4J681BnVtY/f
	zyNDLTDhf3T1z68kt3diZr0/vmxN3f0ZEMNGwlcFDiSaRGkvHPifBlLNwcP/TEoc6xZ3D9Ji7ts
	uyvE0c9W4sJxqB3zCLL3+MZrIRhciwrhb7h7TcT0QBpGaXjvVg5wBr3kJcAKECMf7KAXu5qPN5o
	QurF3K6ZcovzvH5/FbAdZZhPBwprVLLmOvg8gSWHJspybPjxmkNuz/SZXddwFOpyzteO7wrLisy
	Mu6ldsZa64Xl3bazu2hXQ8BJ0yIg9Q1/joUHR0oDnBzWeXHvmxaYwo5daCH2rKwsEkJsDKKsmob
	DHlzPf58JQ==
X-Received: by 2002:a05:6808:13cf:b0:4c3:95d:91f1 with SMTP id 5614622812f47-4fc435fc500mr735773b6e.1.1791324370150;
        Tue, 06 Oct 2026 15:06:10 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4fc48e35ba6sm508311b6e.8.2026.10.06.15.06.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 15:06:09 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: algif_skcipher - Fix receive iterator advancement
Date: Tue,  6 Oct 2026 15:05:23 -0700
Message-ID: <20261006220523.31218-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

af_alg_get_rsgl() advances the receive iterator by the full RX scatterlist
length.  A non-final skcipher request then rounds that length down to a
multiple of the cipher's chunksize without returning the unused suffix
to the iterator.  If the receive loop processes another request, it
writes past that suffix even though the returned byte count includes
only the processed lengths.  The socket splice fallback can consequently
publish uninitialized bytes from its newly allocated pages.

Save the iterator before gathering the RX scatterlist.  After processing
the request and releasing its resources, restore the iterator and advance
it only by the successfully processed length.  This also leaves the
iterator unchanged if gathering or processing the request fails.  Keep
the existing cipher request lengths, continuation flags and scatterlist
cleanup unchanged.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 crypto/algif_skcipher.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1e61fe6e24b9..21d077a54dd5 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -107,6 +107,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
+	struct iov_iter saved_iter = msg->msg_iter;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
 	struct af_alg_async_req *areq;
 	unsigned cflags = 0;
@@ -193,6 +194,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 free:
 	af_alg_free_resources(areq);
 
+	/* The RX SGL may be longer than the request actually processed. */
+	msg->msg_iter = saved_iter;
+	if (!err)
+		iov_iter_advance(&msg->msg_iter, len);
+
 	return err ? err : len;
 }
 

base-commit: fd179f8a05be3ccae366b9b96e176b51fbe54aab
-- 
2.53.0

