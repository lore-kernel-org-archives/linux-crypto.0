Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A741E33ADBA
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762868207; cv=none; b=K6AdxRt+fH5gk1tzGXLZfdu3tWOOQxdAeY0BoYVBymeSKMUPdOQN48TSmuysoIfdBJqloX7Df2ESNyQtkkixwprpHgmMfXn7R0UR88l6gqbpg3UscZeC2T6fIlPX/xJyN4+E1fKIMerMP4MD/r8L0rMNlxoub+jmpPolhEre60w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762868207; c=relaxed/simple;
	bh=C4jDMoBv98CSnFsm9ZYy/OozYXX7fEl+I/JjNn3CwEM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=AK5uOsNxH5E0qdDZl8TZqNTl21/OWVTrYWduhlxm+gTcbt1DgPcRoegoHTWop0N5Z8I0H90H0LXfn79O2iWtPl/DcpvkADy/1HjeAz9MbhxUUsGIqxgJZ583Lnsmy+x3wj9eAreoLNYSHpZTMG9loYpxTNu4pTr5XCuNi4U2a38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/eyGGKq; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/eyGGKq"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b9ef786babcso2697128a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762868205; x=1763473005; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsHsngf+EnNDyi9/PjOxDn0IIEfbCT4oM4rKfdkxmWQ=;
        b=b/eyGGKqcArFnC9KG3KCZ61yAhQNZIFh4UMJ8xtCC7MA5sYbBFJ0YN1Xzorl/OzgKU
         8ewoAcWwTJS9u+o/5eAV4Og/z5m33rOF/RV0F7+uwE1cL/E+GorPP9QTDDHMmufLxuFV
         nYD+zU5dKHH4hKe/bnGdL2ow/b5ZuuN2qYbs8YMCCZBrmcyzT7RKkRBSI4cyWRDyEERz
         iVz77q+FLjAmVBYcnDAV+TUxlyRPFo/qw4ipWjJsQzHbx3x9Y2zAFSc2rhs66qUwR8kL
         kVROH/IhVzJAfJuaRQNHYuanbPFahwY0k0WVZgqYPkoybMi2OdhbzJJoaC/nuxSHe482
         B89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762868205; x=1763473005;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsHsngf+EnNDyi9/PjOxDn0IIEfbCT4oM4rKfdkxmWQ=;
        b=r11HrTU+e9edBGwMUjZ1s9tqJvf1cO758Owryzmu77BuBa4cF4ehRnKxZCB3m+hGX8
         P4KSYUbKKx2yEslWJzebiaK5zb70psHLhvA0uk/LcKrDk0PyJpu6f+NDu6uUgMzSzT9w
         0MrdfxxVL+acObfD/RK8evHoR1Z93ueM2MqOWa+0rMJFlQdyaIm3K4e9pVZlekBe+xiV
         2+cut7c8Mu0pbIL3YVaFSTnTP2VYVwx7NTQf6EDp044Bd6x4Yy9NL+cfu0jzEL9paaeK
         dJGefnCUAvQe9XIl5womAZTp+akVumN3NQjoNUOy7OH+aQBKPDrcJjrmYbW9RPeDAvSj
         AIHw==
X-Forwarded-Encrypted: i=1; AJvYcCX6tKOtKn5FK+YxMNrFXUCm/zBgto0fPYMepEK4Kr7zc4N9njQ2AirgwQ/lNaRGtQfysZLZ6PELjM5dE4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgQQ6FQObrfJ1f+50aHgABfPfPZX+triBMFApj7KdUw+eV4IKR
	JAEiqsR1GKySWYJWTrJXoyD4OaT4AOxRO8AboOY58ilvFXTrvSe2HJRJ
X-Gm-Gg: ASbGnctQ7P9XlE3kBhW3UmgMwp4yHlIBnORqP6dPuKcw+eCq0iwI7xeCFAVSBooQy6L
	yMrjY+K8vLLNKup9UXOKIWBRDk4r5sLM1ZqGYHCrO8XNFHZZdKM3enqjHL1kIGlQ766Om1HY0xK
	wFVIa0bg7yzpjJmRMjAQk2VtU9ZCphyouK7EgWHkAqe/QTE+k+/iO7o/G0IU9zVU6CT/i4ItHw0
	yXN2jii9WKg2vaPCOGpN6SKlMVYGOD46Mce441mbL9y9DV/rjWMRdfbyglnz64M4xWZ+EYzUBSA
	EcMkEATSDhtM66hbYGX3pZkDNqR1ex9NUs4qrOEoel5pzTpGFph2eaT9H0PdKoBMg+c8S7U1gut
	JcIVsgtl91e+S7q/EF2UIObWVVeEOnchqG9HRkaJqvunQmP2IVT1CgRbBmMCIo9UlIpiT+Om43K
	8HGdTatXqgjQ==
X-Google-Smtp-Source: AGHT+IGiHOIAjf30lk+UFmNrFQaWvBdKfD8cfNSSkXgEJsYVgGWHQ+DWs0KkzZMegs6oZI7jmZ85kQ==
X-Received: by 2002:a17:902:fc8f:b0:295:7804:13b7 with SMTP id d9443c01a7336-297e53f8126mr144158995ad.10.1762868204702;
        Tue, 11 Nov 2025 05:36:44 -0800 (PST)
Received: from aheev.home ([2401:4900:8fcc:9f81:b4f9:45ad:465b:1f4a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17ad4asm15405645b3a.37.2025.11.11.05.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 05:36:44 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Tue, 11 Nov 2025 19:06:29 +0530
Subject: [PATCH v2] crypto: asymmetric_keys: fix uninitialized pointers
 with free attribute
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-aheev-uninitialized-free-attr-crypto-v2-1-33699a37a3ed@gmail.com>
X-B4-Tracking: v=1; b=H4sIANw7E2kC/5XNQQ6CMBCF4auQrh3DFEjQlfcwLEo7wCTQkrY2I
 uHuVm7g8n+L9+0ikGcK4l7swlPiwM7mkJdC6EnZkYBNbiFL2SCWDaiJKMHLsuXIauYPGRg8Eag
 YPWi/rdFBr281aeylbCqRr1ZPA79P5tnlnjhE57dTTfhb/wQSAkJbGYWEJbW6foyL4vmq3SK64
 zi+7FeCA9gAAAA=
X-Change-ID: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin <ignat@cloudflare.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
 Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2497; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=C4jDMoBv98CSnFsm9ZYy/OozYXX7fEl+I/JjNn3CwEM=;
 b=kA0DAAoWlj2i1D/XexwByyZiAGkTO+Kh2b6RqD7EGmO/BCI/q1zMuOv1Th2Kz5mOb/1thRizI
 Ih1BAAWCgAdFiEEARUaTi6yGpBew2L2lj2i1D/XexwFAmkTO+IACgkQlj2i1D/Xexyo6AEA3d1+
 BqJbTn/YkvKO/IkOQ28XtN83T+r08K3xzqHaQEsA/1lPQwd07Lp4NP1oGLvR7m2Otvo6xT3FMTY
 JxZW1PMkB
X-Developer-Key: i=allyheev@gmail.com; a=openpgp;
 fpr=01151A4E2EB21A905EC362F6963DA2D43FD77B1C

Uninitialized pointers with `__free` attribute can cause undefined
behavior as the memory assigned randomly to the pointer is freed
automatically when the pointer goes out of scope.

crypto/asymmetric_keys doesn't have any bugs related to this as of now,
but, it is better to initialize and assign pointers with `__free`
attribute in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Signed-off-by: Ally Heev <allyheev@gmail.com>
---
Changes in v2:
- moved declarations to the top and initialized them with NULL
- Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free-attr-crypto-v1-1-83da1e10e8c4@gmail.com
---
 crypto/asymmetric_keys/x509_cert_parser.c | 2 +-
 crypto/asymmetric_keys/x509_public_key.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 8df3fa60a44f80fbd71af17faeca2e92b6cc03ce..b37cae914987b69c996d6559058c00f13c92b5b9 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(x509_free_certificate);
  */
 struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 {
-	struct x509_certificate *cert __free(x509_free_certificate);
+	struct x509_certificate *cert __free(x509_free_certificate) = NULL;
 	struct x509_parse_context *ctx __free(kfree) = NULL;
 	struct asymmetric_key_id *kid;
 	long ret;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 8409d7d36cb4f3582e15f9ee4d25f302b3b29358..12e3341e806b8db93803325a96a3821fd5d0a9f0 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -148,7 +148,7 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
  */
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
-	struct x509_certificate *cert __free(x509_free_certificate);
+	struct x509_certificate *cert __free(x509_free_certificate) = NULL;
 	struct asymmetric_key_ids *kids __free(kfree) = NULL;
 	char *p, *desc __free(kfree) = NULL;
 	const char *q;

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

