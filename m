Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D61200A3;
	Sun, 11 Aug 2024 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723357710; cv=none; b=O5hQtLYBpU11Bdl0Y/kM8c4xKN7C99ydqzRRfeW59LmUHJ6RAsObGrCe1Kn0gNNe912OKX/S35vJryAQE1jjvi20YtOGjvJzJK397Ue0f9lMU5mbAMCh+oJiJSGrZSOo6xH+AkbiRBg/cvAlYBTMpeAkuYuo0oYrao7ggIYTkXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723357710; c=relaxed/simple;
	bh=iTE+xLA3B+tlp1hCzzFAMgjgDoqcgTjCL0j8FOJAbf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=su38YSHA7VIB8UM7/RcnGr5U2GzSXJkbYR5uYNKfk8FcPoO5pIvuqAnUY4ce0OkM16UNn2rxPyyfO0LmTeejPYTyu94pAf0EdWwjH8RpXQnMEHGxxRTojdY4gWejKr8Z/tEeRU/IBnzyXcXII/+h7j39+5nMiLGFEUEey0oIapQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJV/Kl2G; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJV/Kl2G"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2cb7344ed8cso642964a91.2;
        Sat, 10 Aug 2024 23:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723357709; x=1723962509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3R5pF8HtCcehMtndItIQQ+Jtvho0ignp1UJB5ebBc4=;
        b=lJV/Kl2GN6Ybja+MVdIlmhxnv8B/ySOvdvRIu1e3g9/61QrWVVL0JoUYQaghsib+8q
         rb7/wIAcsRya2HH8G3YLyMnTelNvPfxbolYqU5uQ/BgiP+6nh/w/2bifIljxRGefv0wc
         h5MAQTipXCFykNroNvScpL0tXBegFxuCP6Z20ULrljeOr2/A01G+c3IIGSnseBh0nfrD
         RUvPgJP45AePm8TIUMGSfn9kkA0Bi4M8fiPObcABB2iNjwKf2ivRbWYBnK8oeAABAhS7
         06Nk8+jKHlexjqms1vHQnqpMGg3Gf4+JGIriitJhetu+pq8mtw1N2PpQr/GfVj4AWDdM
         dZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723357709; x=1723962509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3R5pF8HtCcehMtndItIQQ+Jtvho0ignp1UJB5ebBc4=;
        b=rCq0ztrshj+AFssYJVsWpqR7F3FqIaxaqgnJl2hjJS334hJ29HCtCZi+oOYRSTDh/Y
         yX2YNnWnWYQl9sGpA6314hSRVAqg1K3Jl/48X5wRF1lv77fTjECNEmDp7z8IMGdNeo+2
         wYR8x2DOnyjJVdjb6r4W94rzS6zhW4K0eLo3eher+JseyCeQu178PYoBgHeBGL6fqAJ8
         y8y3Hjd7ofR5ku2oLiAhYgsaZ9E0dsyWjOFkDOztFM63STDnzQGrcqs6res3NwYd6LO4
         lUE/fHPbLfdlC6GNUjgEcDdxiUz/hvlC2FlDgLEWKbTEbqh0IVnnjqZZmDWTfcs7TOxm
         Iewg==
X-Forwarded-Encrypted: i=1; AJvYcCW0dfBVQa2sKGrRK2UTJNu6aE6DCv9NBwEYjosg2zT+uH8S0cLJw2HpXHiEyxmByie5ZlvLOSSuaGhbMN6+3mQdQfSmutBApTUYemvCRmeMVGJz72G+AsK4IL5jidoYJ4eWcX3b5jpsMb5U
X-Gm-Message-State: AOJu0Yzkz1fQ7gIBL7hBw0/dzmgahYEMzSZM1GJexApkjFclIXdsMakt
	KIgTdLY59IBuHb64qQoo3kSK/xJ+8NuoUjdR8N4qj6j7x0MYHm9L
X-Google-Smtp-Source: AGHT+IE+oASuU1RhJhEAhbUpz1kuyqUs1lSx5tWB047Apdire0EUdM65X97ZwkHxjAy++odOdVJuBg==
X-Received: by 2002:a17:902:c407:b0:1fd:a428:a021 with SMTP id d9443c01a7336-200ae5eeb66mr48315875ad.11.1723357708560;
        Sat, 10 Aug 2024 23:28:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9038fesm18836795ad.114.2024.08.10.23.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 23:28:28 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jserv@ccns.ncku.edu.tw,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 1/2] crypto: octeontx - Remove custom swap function in favor of built-in sort swap
Date: Sun, 11 Aug 2024 14:28:16 +0800
Message-Id: <20240811062817.210527-2-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240811062817.210527-1-visitorckw@gmail.com>
References: <20240811062817.210527-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom swap function used in octeontx driver do not perform any
special operations and can be replaced with the built-in swap function
of sort. This change not only reduces code size but also improves
efficiency, especially in scenarios where CONFIG_RETPOLINE is enabled,
as it makes indirect function calls more expensive.

By using the built-in swap, we avoid these costly indirect function
calls, leading to better performance.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Note: Build test only.

 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 3c5d577d8f0d..e53c79fe6342 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1613,14 +1613,6 @@ static int compare_func(const void *lptr, const void *rptr)
 	return 0;
 }
 
-static void swap_func(void *lptr, void *rptr, int size)
-{
-	struct cpt_device_desc *ldesc = (struct cpt_device_desc *) lptr;
-	struct cpt_device_desc *rdesc = (struct cpt_device_desc *) rptr;
-
-	swap(*ldesc, *rdesc);
-}
-
 int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 			enum otx_cptpf_type pf_type,
 			enum otx_cptvf_type engine_type,
@@ -1655,7 +1647,7 @@ int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 			is_crypto_registered = true;
 		}
 		sort(se_devices.desc, count, sizeof(struct cpt_device_desc),
-		     compare_func, swap_func);
+		     compare_func, NULL);
 		break;
 
 	case OTX_CPT_AE_TYPES:
@@ -1670,7 +1662,7 @@ int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 		ae_devices.desc[count++].dev = pdev;
 		atomic_inc(&ae_devices.count);
 		sort(ae_devices.desc, count, sizeof(struct cpt_device_desc),
-		     compare_func, swap_func);
+		     compare_func, NULL);
 		break;
 
 	default:
-- 
2.34.1

