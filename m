Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BE940DB4B
	for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2026 11:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571021; cv=none; b=fIWFh2u3zkCPuW3aj7L3Iq/n6aSHACPMrnPoJbftiUONwS0rNVn1vIhYcV6A0aSKmhlWzR6q0deHUw9HanmR4jGK6h7NxBS6tKlcLN2otG7w8fMSPGpJamUMi+E57i4vG370azRA9V+0+aWGjKx/QoYUiwrP8uxMVx36iRw+4fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571021; c=relaxed/simple;
	bh=eIiHDNpGuJvlr6XzJzVZse8EFDoB8HDy4sppT9wCi+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dxTz5eznYjHtFDTvCduQ2+5Lzl+rb6NbSwiW/Co67XOTY5ofzMWWAn0BRNr5/qPNdue0/cE5tGiifaBHRhPpjqx7bDPGziTXh2xJeFP081ZXLO79yZkEqjLLp/L5LK/EGiZt3KuQUmyiuuVVcoojvS2UAM6PNmYmfbiPqhXymxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V8x3jT9Y; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8x3jT9Y"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso3386752b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2026 04:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787571019; x=1788175819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Yqy+VWHRiQmqGDvTYaHpxheSZahwTkk9CcTJ304p/4=;
        b=V8x3jT9YvM2MrlOBRgaZmcHR4FXpMpUbyk9NcsUuyixF2LqeSZC+16kLsA4iMJmOcH
         LePSvI+wRfzIs+INpcWdtXh6V630fe1p/GVNRwdhYszG6WcSMVKmJYP8kvZP984ghHKM
         mc6SRHOTi6oIbPB0NnUjycLLI2DlbNQmUNlMHF4sFZd12Fuctk2il0obUsksYLUFbcxx
         xhPmeruxVEUXWFwEcm+Q2Q8mrq47t263BTqEdm3BEHe8IMpeMNOHUlJMZstBT3piabcO
         0V1dVLkepeuEsBnG6B7svLSGLlxEn/p1i6qLIHH72uO8aeDnoUa6z2jLXbnqnjWwozYs
         3rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787571019; x=1788175819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Yqy+VWHRiQmqGDvTYaHpxheSZahwTkk9CcTJ304p/4=;
        b=GH0/kKlmooLvebBrtl8QxLNqrQqdoG3d72EllUmLfYazFm+arV7ohLLUdMMbWs7EuS
         p49rfd8shFvRJfJjOfI3X0KiBl2vHPDOP9ERDDEUpb+Z3jLLtQTnZ5J4IDRJ238qGMOX
         nBMUQdU+rN6X8a5gmIXQHZZcl5+mY4wnbZuEfS3XF48baRAkw0q4+l87Irbe7Zm/Sfal
         KKvpaim3vPk8KpSxFaL2nJrQWrkEZCq2qO3eYDqPwSSjWWC/U1uRgd9pl2SAqdgV6oBc
         AV4jN3echyrOEyka7/XApm5kwdolDh0kAOxMHoDogjSQMjG3/JoCe5feVqPEXNo8mbgw
         FBjQ==
X-Forwarded-Encrypted: i=1; AHgh+RoBaIore3BqhppRKBXPAY4lKYRTCJ7x53WFxyKget55BQDv3oS9hIFaNEyVv8phNHgH6RI/FD5/wPsTC2k=@vger.kernel.org
X-Gm-Message-State: AFuF++kJ6JhVesfrs0liQ2CborY9yWN1gpw4Vs8iduOMaa/twSS5VjqB
	nbrXePiKjaCDJ4Nf6lhwx/uPeH8jzHXX4CJJ5evkLaTLs/M8A+tR1lvK
X-Gm-Gg: AR+sD11YFIDa+o49FmtlCu8dMl8fqpNERPeJy9bb9MmhVl2FpwotBrPm8N2QS/fos7g
	tFDSo/zZRwVz6N77w2iZgo9AsUD8E0l1rA+3sioQ4Kuz0hWoxVsVa366hpg28StcmCBEbWPcVmO
	S/8GVSkzlgjQT3AERIOGuEPgM9ssX1OBui2bpKYNm2dWm93OCEWqFZbS0zQ9olhGXTHaDdhgZmr
	evVHMYDOXCDY4H5tmmJZ85HErKe3YpPJy4sv8ZGJ9noxci0nyYdc6d/ZUHPhs9yYMogtm582RHV
	zqYbouGUcX9Ojeg38uGI1kU3VrERyaf3EH7/eciJ5bHtDDniOff3uu3lXdDyHh0a6tLfDZxl4eO
	PDtVWgZ2lWM5Vaf0MmHocY8HNfuilBq3QAHgnfl2s6gaW4N7/88bUMCKNLadmMXkHIS0FqCzayA
	wukOQa3pEmxoSHWEaZaKwiHcdggCFQZviFY74l5feBCp+Tya3dSPGiKC3ktAe+5a7fH0XKcEkZ
X-Received: by 2002:a05:6a00:3690:b0:84f:d7e4:3404 with SMTP id d2e1a72fcca58-8520be6fd22mr30209102b3a.11.1787571018912;
        Mon, 24 Aug 2026 04:30:18 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f149ef3sm1870661b3a.41.2026.08.24.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:30:18 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: dhowells@redhat.com,
	jarkko@kernel.org,
	lukas@wunner.de,
	ignat@linux.win
Cc: paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH] keys: reject descriptions that exceed the index length
Date: Mon, 24 Aug 2026 20:30:04 +0900
Message-ID: <20260824113004.3755053-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct keyring_index_key::desc_len is a u16.  User-provided key
descriptions are limited to 4095 bytes, but a key type preparser can
generate a longer description when the caller passes NULL.

The X.509 parser forms a description from the certificate subject and
twice the raw serial length.  A certificate with a two-byte subject and a
32766-byte serial therefore produces a 65536-byte description.  Assigning
strlen() to desc_len wraps it to zero, after which __key_link_begin() hits:

    BUG_ON(index_key->desc_len == 0);

This is reachable through add_key() by an unprivileged user and can panic
the kernel when oopses are fatal.

Measure generated descriptions before narrowing the length and reject
values that cannot be represented.  The boundary input now returns EINVAL,
while the one-byte-short control still reaches the normal quota check.

Fixes: f771fde82051 ("keys: Simplify key description management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 security/keys/key.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/keys/key.c b/security/keys/key.c
index b34a64d81d47ab..f2f472b45f4eee 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/random.h>
 #include <linux/err.h>
+#include <linux/limits.h>
 #include "internal.h"
 
 struct kmem_cache *key_jar;
@@ -820,6 +821,7 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
 	const struct cred *cred = current_cred();
 	struct key *keyring, *key = NULL;
 	key_ref_t key_ref;
+	size_t desc_len;
 	int ret;
 	struct key_restriction *restrict_link = NULL;
 
@@ -865,7 +867,12 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
 		if (!index_key.description)
 			goto error_free_prep;
 	}
-	index_key.desc_len = strlen(index_key.description);
+	desc_len = strlen(index_key.description);
+	if (desc_len > U16_MAX) {
+		key_ref = ERR_PTR(-EINVAL);
+		goto error_free_prep;
+	}
+	index_key.desc_len = desc_len;
 	key_set_index_key(&index_key);
 
 	ret = __key_link_lock(keyring, &index_key);

base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
