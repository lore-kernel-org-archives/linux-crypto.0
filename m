Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995474;
	b=xxx06Fe1OCgiY9V8IlcQQxhMv5RX/Iu1+ayQRXOeFJKhnHX9ChVL347pVdzY6RrQS2QX
	 wdV5kzJQMLq3I4ZL6ZUKOvuE8W6kt8JAezD1pjEZZFsRmLqH4nbF9jsEJEJQi9tqRpOuU
	 8zW/jMKAJBUu3WuGo2Pg1e4ThmzViXdL4AdQO36ZIJ3UFnOSrHFpKVl9MHKpxJo54NLia
	 DB2UiW1vRRQ8NpZ0oAZqE/7wmHNuMiUqQtupSnuDh1uNCj798hgqrp05zv1v3vEHP5gJU
	 ZxrL1IcLJqjeKMO1ZGvsq7426Vq4rhpsmTpN5+vuKKNReBJksYK8IeUzjjQ3RcXRi8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qdzzuDHKyfn9MEDqIa+4Jje9jOJuwPCdKzFPnU5vUZU=;
	b=TJ8axmXislN0w/Fi7AvHFfyjBPyZ8A8LCBCigRpMYtuE8Zx5HcUgmvinoDx3n4mDo3+c
	 epd9vCWM24ikOqo/O3ciLlwkS+z4zXuy/eruRTjHOR7AyDHfYJwcVHZvGVxVmspNcf9SY
	 dfFiy7luxOLNO1fdVRtKBBRld8slysrKRivhumT+k+cQPEH0dw+s08If7QqIs4aLbHp51
	 i9cNV4bTbyyiFBYECfwjdEqAaIx6D5bwz78PjimTnSMpsM4IZ4Nu7YdgkV38lQObkQG1D
	 Mz0clcLlJ+8SjzNeZJY171YW8v4WSKtRcBlLi/ffLhGrfGijyw8ed+MUAN0AwIiy6KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0EaSKAHq;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98463606A329
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 20:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98463606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0EaSKAHq
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so10441595e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793995473; x=1794600273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qdzzuDHKyfn9MEDqIa+4Jje9jOJuwPCdKzFPnU5vUZU=;
        b=0EaSKAHqfT6MH8ZkinKIWE9zvrSc79drozCAYUhfgwN1m4IXV5z8n7RslTiGPtjbks
         8vK9vNKjmpB2vCiu82GrSYnB7PriyUI9woE+kdH/u1SeQ6RDamBgmFLd3Q3y6RWgAYpL
         gmxNBdiPLUIC9Iq9auW8I24skXfVqMt1s8SVEl5yAEoY0A/eN2BAwW7kWLtmS4SMKYau
         6RTbon4zvOqZi9yMA+4XmSKUmzQReJL1OAEaiOteb/X1HYQoOIwIMqUPcm1S8w/mM2SU
         tMZhlgkHK0CHkJKjkLF+F+7KNVaEUCCaTOShURJCGPeygCU6Z11sKRGrVyg+Xz7e3+Ob
         yz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793995473; x=1794600273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdzzuDHKyfn9MEDqIa+4Jje9jOJuwPCdKzFPnU5vUZU=;
        b=MhNJEGar2ClUE6aRitN2DWRLNmM6lhjLOl9r7X90h1pIBCRZNL0PEGoYIyFvRYD0ty
         TrnQ+FhQAjaQyT9aVwP3I+V6/ajs5Se/SxpWuEdYzpDbuDuTyr9RNjgLVtvIE2LhEQ8j
         h7a8VTa8SZv3RFPkxLu1yuk4dIINDZUHCSMNQv/vXAWB0wgfeslDZO6OU28RJQE/c+Q+
         XMoOvYbp2PZiPodiHkUH9ZkQxjlqyJ5+q3Y5jHpw7jz26j8TKLpdZQWs/ZtPYR9qqOZF
         GzVgRlTGc+GSo3tHuMROl4JMvJUXcHOHGJwVF6qYHgKK7sCuBVACdPbVkcivJuz7e0QG
         UX7g==
X-Forwarded-Encrypted: i=1; AKwUvBx2OmemBkanMf8ncEr4PmKYpqmmKdEYH67ID7ZA5yRhGRqGbfKWKqU/a/HPrisDQGkJNL5yo6+AaXpJr4w=@vger.kernel.org
X-Gm-Message-State: APuU4Z98gr24tfLh5Ly/0kP8sf3r7qj/z9fB1V0AnVvWQwj0NHE5VIU1
	uUJUnfBNg0GKRx0F1x4cXMVmP4Ki+iStmteRrEueEVYO+6PL8XdWMAmY
X-Gm-Gg: AYBFou3w+L9S+WoZLzky+m0uGvpXyvxe+jQ7eHF2Uu3rTNIif3d3WSqdnhrMhgZH3EY
	C4BKfUtWya+vvaYbN3T9Nxsiqr/njRLl1e684IdI3m20NefsnMCx7PXPKt37eBa7a4UHPrtIHvZ
	Y5IgArazlcrezcifVa1HXouafGEOrK6sQ5FjFbBaivmP/Mg23+b58djYxuHP3XF/7bcFp5KG1IJ
	VbN+rb4tgKGXiKAiVmKQ4IbbkTYBn53hNMw9thOz5mf+ofTb3V5BIGNWEnwV2YIyzXwwQFRqa12
	oL7vcpTtizZgTuHkH/QjUdYMeBLypqe4LlUc7Rsqw0k68Iz74CvhiCSR95Zd8Kq/x9ynokoxqhr
	ycOSn/bSE1eVveHxS2yhkQnGs1aJYBQ9sby4h3BybJ8nD7cu4FS8vkdfDxv7QmiYvs4aSrF19AD
	qUnWEe/bBraP0bbmKsuwOFJaJdFHyKu8sUCz0plKlD1fIivHtmOwzhOjLNoJUT5l7azkV6b7WZS
	N90KHO/i+nDfLBKiARu4/yLyzmXdv1NkTp2xpgPtfUrboGauhFAoju4H91A4WzUEAgR67ahJZzy
	zeotp1JrPVPyfn4fz0Zhg1f8s0uCUIWrwLloSA==
X-Received: by 2002:a05:600c:3ba0:b0:4a7:a5db:a93e with SMTP id 5b1f17b1804b1-4b6db1c5f48mr71249715e9.4.1793995472786;
        Fri, 06 Nov 2026 12:04:32 -0800 (PST)
Received: from fedora.domain.name ([217.218.152.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b76cbdb9cdsm16959195e9.1.2026.11.06.12.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 12:04:32 -0800 (PST)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: ampr.mhd@gmail.com
Cc: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] pkcs7: Return -EOPNOTSUPP for data-taking algorithms in pkcs7_get_digest()
Date: Fri,  6 Nov 2026 23:33:56 +0330
Message-ID: <20261106200423.37769-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
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

pkcs7_get_digest() is documented to return a digest for IMA to use
when verifying a modsig.  For signature algorithms where the public
key algorithm consumes the raw data rather than a precomputed hash
(algo_takes_data, currently ML-DSA), pkcs7_digest() does not produce
an intermediate digest.

When such a signature has no authenticated attributes, sig->m points
at the raw data and m_free is false, so the existing check rejects it.
But when the signature does have authenticated attributes, sig->m is
an allocated buffer containing a modified copy of the AuthAttrs and
m_free is true.  The existing check therefore returns that buffer to
the caller as if it were a digest.

Test for algo_takes_data directly and report that no digest is
available, before attempting to call pkcs7_digest().  This covers
both ML-DSA cases consistently and removes the now-dead m_free check.

The only in-tree caller, ima_collect_modsig(), does not check the
return value of pkcs7_get_digest(); for a data-taking algorithm it
will now leave the digest fields unset and fall through with no
digest, which is the correct outcome for an algorithm that does not
produce an intermediate digest.  Callers that do care can detect the
new -EOPNOTSUPP return.

Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digestion it wants itself")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
v2:
 - Add algorithm name to the pr_notice_once() message (Ignat)
 - Add Fixes: and Cc: stable tags (Ignat)

 crypto/asymmetric_keys/pkcs7_verify.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 474e2c1ae21b..c2e0eda502e2 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -147,14 +147,15 @@ int pkcs7_get_digest(struct pkcs7_message *pkcs7, const u8 **buf, u32 *len,
 	if (sinfo == NULL || sinfo->next != NULL)
 		return -EBADMSG;
 
+	if (sinfo->sig->algo_takes_data) {
+		pr_notice_once("%s: No digest for data-taking algorithm (%s)\n",
+			       __func__, sinfo->sig->pkey_algo);
+		return -EOPNOTSUPP;
+	}
+
 	ret = pkcs7_digest(pkcs7, sinfo);
 	if (ret)
 		return ret;
-	if (!sinfo->sig->m_free) {
-		pr_notice_once("%s: No digest available\n", __func__);
-		return -EINVAL; /* TODO: MLDSA doesn't necessarily calculate an
-				 * intermediate digest. */
-	}
 
 	*buf = sinfo->sig->m;
 	*len = sinfo->sig->m_size;
-- 
2.55.0

