Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BD02FB612
	for <linux-crypto@vger.kernel.org>; Wed,  5 Nov 2025 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762336397; cv=none; b=DGFyrZaP9YAoFVaBW9JUm26BaCteqsjBJKbzYKsbKhLYwgToLIqVKjCEMygIP7gOmJm0kgveQoOxZv47nfBQQIVA508dYULlX06LcAdcmW+eQXXABVhsoMPhW6kYNSXBnoktSLpaTVnvM9edAaITSwi2Gwo5FIe+DJmr+g7JCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762336397; c=relaxed/simple;
	bh=cwKLyl6OdghZKyjNWgxXk0ncG3e1oFv3E8bDIyhxCbE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=CLwH8aULSHecjHHoebqOm+NpV7jmhS/mrKBrNmQ9885oZSC8xAGqcPojVturq6rHFCgnxBlpWBC9R4dlCbbrweXdFLAGGUKZV/jI/51MBESGZvlfI05iQsGS9pk9ctWCHcKGZpsMhqS8VW1hpL5JgmlYJ++azem3h/5dAjIQO0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgShrYMV; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgShrYMV"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3402942e79cso8908951a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Nov 2025 01:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762336395; x=1762941195; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S4s1QvFjCp7Uz78I+HyHouqF2NDvrouz1NOZV4kpvz8=;
        b=QgShrYMVOu+Lt06Gq8whnDRhCsCyzV7HaCSQu5zHqWXnFh1KONtVnlDK8aiYTSoYsK
         ZDIp+otSugr0Bm5G/PU9/OPEathiIrW1PbS2JTyZUyS7BBsRkP/KkleOkV8RZrAKFNyc
         y1HsMH7VWWp0rTSNRUHhdrPDzQI/Wk8xmQUhnnG66SIo14NNJMeyMjeQlSRCU6BIuOtg
         kLsuZDN5oiCllXW4WgLtjRbuJWJBufVyMpYD//Dc+Yd3yGxog3SNZYXplGUXBko3lso4
         c6ZNeq4RUsmSsu0qZPQRN0i95oc4ZmkhVa+Erggo6bnNhq/rwIzKb15rdaqa/cpSWjHf
         lKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762336395; x=1762941195;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S4s1QvFjCp7Uz78I+HyHouqF2NDvrouz1NOZV4kpvz8=;
        b=l7Gbv0J2ftuMxOg8lH+iIpKrzn9wAMRQpBBLHkeK1F6TOhxYe0ZXIMA2YEPBVUNlWd
         jhKdIqMfgmC0My1A2eNlhTc8jst7jquugkRZqEkJu8rOT2JDSq9i6McUoIlEynbg5oi+
         9OXEvW8cXiHWGzn07QDYar82WxqUIpGQp5CmGiiXreOQ8bQj5Uxd7r/a0AuW3qU58aeV
         RxMHZsKMKZWcE6nK0UZqkEuN6yphxeqfIreBFJCOe+AGedB+iwZnaAFm37KxayYaLVx3
         pP1nGBIlGDlEPICPR0ASoDKVaZ8SdKEMG+8WKqr64jzmX0/GBnLhJTYoz2a+sytrxIX+
         W94A==
X-Forwarded-Encrypted: i=1; AJvYcCU2SP3BrMrhcKRwXlWN4CuL7Cqbtyu45sAQCSpLfbZBUzcE9V9CsxRjBmxGMkQ312C2XxdXJECQxsMyU0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTJFgltubvmHtXcK8s5YxPsdJdW963+MVRfUib9xVQSmQhsCXL
	NIRNr1A4BBbQVeO2OntwCvTngV2PVEzhpdCYeIKeoSLbHNa6C382UPMs
X-Gm-Gg: ASbGnctyi0CotNohWnxcfZSre5biJGdwcYMp+KyBhPRbOa0ujjZ0xQVbX6J7BkG/gPf
	323xJZGBBes855d1kp0uuKaVQ/nskGCt+kODLyt2S86nA3EescZ88QWUIp7Asz36PUyHTYlqxjI
	Q5lXQps8ZIdSiYloxSJSCcvKcQBGxmeOw2mO/GDibfIFshzY/cg1sYgrQwM7F0qeC6gfW8cg8I1
	lhmC1WhjmgUDciXewDB5eSdNXSgKpkdmykhJOkaF8mqMz5uTGUyv63lZdsdGArKhExmqVDQd/Q9
	D+Q2iwhd4IQnL7HMpQwBeFoUod35wXveaqumZ0TNZmoYhmzPp5j+rgcCL149wE3BemEAjaevjKg
	a2YjETaYPvTkGwGrQoPAdpKNbv6vMVbMghA5OljGdvg93pK+P0DF7S0yJtEiUSNJxoNHdiyjqY1
	/T
X-Google-Smtp-Source: AGHT+IGokQzyl1Ef/Pu7LXu2/t70l/hIJHf3/4OMEeOB67voqXxl/MqMrSSU//ZmVk/X50C9V/G3mw==
X-Received: by 2002:a17:90a:d605:b0:330:84c8:92d0 with SMTP id 98e67ed59e1d1-341a6dc40f3mr3373858a91.24.1762336395041;
        Wed, 05 Nov 2025 01:53:15 -0800 (PST)
Received: from aheev.home ([2401:4900:88f4:f6c4:54cc:cfa8:7cce:97b5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a67e1628sm2370422a91.0.2025.11.05.01.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 01:53:14 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Wed, 05 Nov 2025 15:23:08 +0530
Subject: [PATCH] crypto: asymmetric_keys: fix uninitialized pointers with
 free attr
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-aheev-uninitialized-free-attr-crypto-v1-1-83da1e10e8c4@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIMeC2kC/x3NywqDMBBG4VeRWTtgUrNoX6V0EeNvHShRJlG84
 Ls3uPw255yUoIJEr+okxSpJplhg6orC6OMXLH0x2cY6YxrHfgRWXqJEyeJ/cqDnQQH2OSsH3ec
 8cReeLYLprHUPKqlZMch2b96f6/oDPe/nqHYAAAA=
X-Change-ID: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin <ignat@cloudflare.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
 Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3886; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=cwKLyl6OdghZKyjNWgxXk0ncG3e1oFv3E8bDIyhxCbE=;
 b=owGbwMvMwCU2zXbRFfvr1TKMp9WSGDK55dqKPrit/lZw21lFM4thx/4aaavrn+ZUMqwMjzfqF
 3uvUGzRUcrCIMbFICumyMIoKuWnt0lqQtzhpG8wc1iZQIYwcHEKwES6FRkZzpZIPPRatmx3SmWh
 tWHr29ULpQMe7tN+uXpbeOPOj/tP5zMyPDv137eFeZe/b63UeycRjacH/cu0eoM3yG5K3R7Dv+w
 MLwA=
X-Developer-Key: i=allyheev@gmail.com; a=openpgp;
 fpr=01151A4E2EB21A905EC362F6963DA2D43FD77B1C

Uninitialized pointers with `__free` attribute can cause undefined
behaviour as the memory assigned(randomly) to the pointer is freed
automatically when the pointer goes out of scope

crypto/asymmetric_keys doesn't have any bugs related to this as of now,
but, it is better to initialize and assign pointers with `__free` attr
in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Signed-off-by: Ally Heev <allyheev@gmail.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 11 +++++++----
 crypto/asymmetric_keys/x509_public_key.c  | 14 ++++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 8df3fa60a44f80fbd71af17faeca2e92b6cc03ce..bfd2cb2a9d81e3c615dfd4fe6f41653869a8cbd6 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -60,12 +60,12 @@ EXPORT_SYMBOL_GPL(x509_free_certificate);
  */
 struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 {
-	struct x509_certificate *cert __free(x509_free_certificate);
-	struct x509_parse_context *ctx __free(kfree) = NULL;
 	struct asymmetric_key_id *kid;
 	long ret;
 
-	cert = kzalloc(sizeof(struct x509_certificate), GFP_KERNEL);
+	struct x509_certificate *cert __free(x509_free_certificate) = kzalloc(
+		sizeof(struct x509_certificate), GFP_KERNEL);
+
 	if (!cert)
 		return ERR_PTR(-ENOMEM);
 	cert->pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
@@ -74,7 +74,10 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	cert->sig = kzalloc(sizeof(struct public_key_signature), GFP_KERNEL);
 	if (!cert->sig)
 		return ERR_PTR(-ENOMEM);
-	ctx = kzalloc(sizeof(struct x509_parse_context), GFP_KERNEL);
+
+	struct x509_parse_context *ctx __free(kfree) = kzalloc(
+		sizeof(struct x509_parse_context), GFP_KERNEL);
+
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 8409d7d36cb4f3582e15f9ee4d25f302b3b29358..818c9ab5d63940ff62c21666fd549d3a1ff07e67 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -148,13 +148,13 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
  */
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
-	struct x509_certificate *cert __free(x509_free_certificate);
-	struct asymmetric_key_ids *kids __free(kfree) = NULL;
-	char *p, *desc __free(kfree) = NULL;
+	char *p;
 	const char *q;
 	size_t srlen, sulen;
 
-	cert = x509_cert_parse(prep->data, prep->datalen);
+	struct x509_certificate *cert __free(x509_free_certificate) =
+		x509_cert_parse(prep->data, prep->datalen);
+
 	if (IS_ERR(cert))
 		return PTR_ERR(cert);
 
@@ -187,7 +187,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		q = cert->raw_serial;
 	}
 
-	desc = kmalloc(sulen + 2 + srlen * 2 + 1, GFP_KERNEL);
+	char *desc __free(kfree) = kmalloc(sulen + 2 + srlen * 2 + 1, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 	p = memcpy(desc, cert->subject, sulen);
@@ -197,7 +197,9 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	p = bin2hex(p, q, srlen);
 	*p = 0;
 
-	kids = kmalloc(sizeof(struct asymmetric_key_ids), GFP_KERNEL);
+	struct asymmetric_key_ids *kids __free(kfree) = kmalloc(
+		sizeof(struct asymmetric_key_ids), GFP_KERNEL);
+
 	if (!kids)
 		return -ENOMEM;
 	kids->id[0] = cert->id;

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

