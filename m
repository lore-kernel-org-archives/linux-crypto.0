Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABBA16FF37
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 04:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773030767; cv=none; b=EWPIswqsBELf88/ziK34A1Dl8XKgrr0oMxBt9jP9RMErw0rs5cTiok14AwvV6Dzfm/tw8HeMchghZ4h2ae31z/6KCPtocPriSxA3Xr+MYk8xW+zwR+ouFX7fWkACk0A6T9S4P35Cl9c48fyk+jrxSE17M4nV/JiAxX9v8EGQTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773030767; c=relaxed/simple;
	bh=n8Z8j7J8KeLD2qfumTZTXkIWCn0qIapX8eZLr8l87Wg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k+8H0zh/ubPgC9IlYz/oWuVRGbZbusuKgntLS8Xdm/ct7lRvTIddFkos+enhnpmhMqnUgWmUNpRmnaSwIoytMYYHJl6QQmvgMVShUjY1dIuLXQewx6cpmGPr6wUJIU8/6PT+7enDzUyW8J6E10hQG5XabMxjoe2/c2lHYWm2fO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LE3k+Efo; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LE3k+Efo"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4c12ff3d5so10856042a34.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2026 21:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773030765; x=1773635565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tBowd+etvXYQXjEgXm0lJwwl9WFImoPg0SroWZsa4m8=;
        b=LE3k+EfoyCvyG6RNxso4MpF7ndfZS8rA0NclxFahSJMQDnBUzC6Ti4VaXdCOByTZP+
         VvDkoesrBcGssAt5yXijdvLDmJKQfV0aSf+isJ8+LQGFUM9aYESU9Z1ocdbvUp4B2PiA
         feILIA9LazTSILavzCkJFSlk96Z/VjcEHdqU8q9yJ36VaLYKtg+l1aImrklEKZrk+gpO
         Lk1P3Q/kYX2ZkDkbzK2gW9oGKEvPQvZkt+a0fJAW80MSV9qD5xSKvWJyoGlr3R1kRGzb
         2rwNaxLX26uIHKuqU+eimGXYYswPRDjNKVBPPGWxEEvEtvLn3S+P2+Tq8flcGxgjhwoA
         a9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773030765; x=1773635565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBowd+etvXYQXjEgXm0lJwwl9WFImoPg0SroWZsa4m8=;
        b=cwHXyihmHIgjnlU31SBduXKmQy9/CaU/N9LEoDWQjWwSd+4OMuFIHbf+v07Hq6PCxh
         2vF0eP7bBa2xQqU1xq+cJRM65fzh1q9t2gJwnCr7r+Q9lYAO9A2gdNgvraByHhYd/xbK
         CLxNmxXh8AvNymYG1oiX1zEtkoDamvWOiAy+e53G7lNeXBDSYIeANKb9sfOeYcQEBmIf
         Myk1pnO3Ore8aiXcjJNQXeqSThSxrrRNdr5fDl43u0/0PNFy/tib/C0KHhtIFwbVz3KE
         lD4k0SyakmQYIfIqJTBvY4BiJYx9+zi3VyLXY5c4/wK1/oW6ZwMa+qiBcYCwpZJHBnAw
         F1mQ==
X-Gm-Message-State: AOJu0YyDDXKbi0TGzWU2jm6znlED72rZauSwGsBhs8+eWfsXapLAVU+V
	e4BdH9RALH5O7YnOdg9KRXWV/y+oVfF/U7IaAa+EvXp6Unbq35QUgGnW
X-Gm-Gg: ATEYQzz5wZg4O03pRCOrtFQQoyLOsU0cV4db63FxNUvXH+4C/a3stMumJv8lq4EnL7Y
	sGt2SBlTr3AUfw6eUNVyt9tVWSjDlijVwejodKwZvi0pRr10HwvVDq4Gz9FaPcHQi4fJ6ZF2tLi
	fOmXrlgePVfzyX/aWpfv9PPlP5eyGQh9vYc6VaFPSGJTPA8kVSKz12r0EpoxrHPQpLvhA/aP+g8
	dOp4T3cfmNThRnOrv1NLhs9iKIX/GhhSIjf8bToluXRRWSSbkiWxahGcbnolDbu7+D2oKfARl40
	pAb2L7wscoIqXCfrHdAjHpmq7DFgrbagXe7cvkOU9Vy2krrVJ+g+R4idFdCQmuYgmAmwb4SOOVB
	d/NCz+qxZ8pa2oAsyRQUnjIaagsKUzE2QviqpbXBEQ4N6cFznXPE6VuV6knRQfAKcTV0YmZ+1Mv
	ZzMD5SbRdz8fbPVKERbcix06J7V1zv19lmRY3V4wfPE/hJw909lgaU8GM15HUCqD6cKu4/5yAAH
	0tTFquG+JNgPBR8pavKX9N1ooPTh48sjYldn78UfY6xyY6B
X-Received: by 2002:a05:6830:25c1:b0:7d5:c016:f740 with SMTP id 46e09a7af769-7d727057a56mr6807045a34.29.1773030765411;
        Sun, 08 Mar 2026 21:32:45 -0700 (PDT)
Received: from localhost.localdomain (108-212-132-20.lightspeed.irvnca.sbcglobal.net. [108.212.132.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d728c757cdsm5785684a34.11.2026.03.08.21.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 21:32:44 -0700 (PDT)
From: Wesley Atwell <atwellwea@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	ebiggers@google.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wesley Atwell <atwellwea@gmail.com>
Subject: [PATCH] crypto: simd - reject compat registrations without __ prefixes
Date: Sun,  8 Mar 2026 22:31:43 -0600
Message-Id: <20260309043143.3525376-1-atwellwea@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

simd_register_skciphers_compat() and simd_register_aeads_compat()
derive the wrapper algorithm names by stripping the __ prefix from the
internal algorithm names.

Currently they only WARN if cra_name or cra_driver_name lacks that prefix,
but they still continue and unconditionally add 2 to both strings. That
registers wrapper algorithms with incorrectly truncated names after a
violated precondition.

Reject such inputs with -EINVAL before registering anything, while keeping
the warning so invalid internal API usage is still visible.

Fixes: d14f0a1fc488 ("crypto: simd - allow registering multiple algorithms at once")
Fixes: 1661131a0479 ("crypto: simd - support wrapping AEAD algorithms")
Assisted-by: Codex:GPT-5
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
---
 crypto/simd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index f71c4a334c7d..4e6f437e9e77 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -214,13 +214,17 @@ int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
 	const char *basename;
 	struct simd_skcipher_alg *simd;
 
+	for (i = 0; i < count; i++) {
+		if (WARN_ON(strncmp(algs[i].base.cra_name, "__", 2) ||
+			    strncmp(algs[i].base.cra_driver_name, "__", 2)))
+			return -EINVAL;
+	}
+
 	err = crypto_register_skciphers(algs, count);
 	if (err)
 		return err;
 
 	for (i = 0; i < count; i++) {
-		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
-		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;
@@ -437,13 +441,17 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
 	const char *basename;
 	struct simd_aead_alg *simd;
 
+	for (i = 0; i < count; i++) {
+		if (WARN_ON(strncmp(algs[i].base.cra_name, "__", 2) ||
+			    strncmp(algs[i].base.cra_driver_name, "__", 2)))
+			return -EINVAL;
+	}
+
 	err = crypto_register_aeads(algs, count);
 	if (err)
 		return err;
 
 	for (i = 0; i < count; i++) {
-		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
-		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;

base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.34.1

