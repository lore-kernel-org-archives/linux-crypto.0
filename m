Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EED124C07D;
	Fri, 25 Apr 2025 12:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585151; cv=none; b=CXFBxxN+SbS29BwrvZYNXmQwVab+DGWYbERV2ijOBSKr3qdb/rqxFqxW8sY+RsQr8VC4cSNEArKnpZGZVmmQOvOJETWDBK2z2wxf/PTjLvuNtUhz78tWAwlXKoSq6fE6ppLQzowawdoUdC+4s3JXDbufl0GSGu9+g90oFaCzIMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585151; c=relaxed/simple;
	bh=3iija+D+wAivPTxPgQkDWS76dXwwDw+JDuIms6/61uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imNlsI1thN4p+UVr6AM6GP1RiGFESY1ajMRX57R1ujSMZcTfI4BCgN7Bjk+VgaKQTkat0D7O44AhjOJyOk5XG2qd4gW5L54x9wE7BcBUlUj90vISu5rfj6eW95GjZnrB5rmu4F5EIqVP/LCw5YIfvayShmzpRPBUt3RwtFMRArg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V2qglfNn; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2qglfNn"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-acbb85ce788so437889766b.3;
        Fri, 25 Apr 2025 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745585148; x=1746189948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5+vsDywURKto5J2uSvLDBbpGVTjH81pRFa24AxG5QI=;
        b=V2qglfNnQ+ZljguBgk/nzz/ykFldNnvWD8Gl/XfhUd1FnHI8CeVjh8+NNSGxuJYhKV
         IgJoDxSwOS/6u+0i/afhAE8gs+ZvuOLZPmymfUbQNTvjJFKoSa6L/praoFDH2r5uP7/K
         lDCz23U4s9HO0SZTmyeorlIZWX83iB4iPJTvZT55q49gbMtY8kz0udWCplqgIeX1pN30
         dGTzr54anqNAqLnFwBKUWZbN+y5DSU5TCcFINV22VDjTRGMOBckDsVZ+lrvQcC2kBtI4
         C7DnrT6nr5VxfksBecBlxtBi11FXR75/pmDcdmDf9aX/CkBCBQH5xxkRJjZ97ZLwYmOJ
         ao/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585148; x=1746189948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5+vsDywURKto5J2uSvLDBbpGVTjH81pRFa24AxG5QI=;
        b=o+HG9bDZ/7p5+s6hieNfZRr4Micqa4gYr5lTMzGG6QCReUGSYZ0E0FfHdXYEF4c5jh
         Qun9rQg3tjsSb6NJj4wwaRy+2LUTs4QvnX/+75fyVY9vWkR8s6PacsDtiBsoJUamMIeE
         digjTalXGZ2bUoRg3JiudqaTNzXiVZ15JMpVoVmRVjU2HE9R/Q6OZB+feVcRYWqfxlql
         ZeM2xgFGfGVf2BJOonzZFVeavvAQiP1HKIyb9CzKWpnHJkUk4DwoEqR6YqFda1iUdlEX
         KukjxqZ/Xy96jWjZrdbooe33N6vtesm0FfHZ8LX1BBgnYWn1uGJHYUfDrtOiIayLCuPv
         NwPw==
X-Forwarded-Encrypted: i=1; AJvYcCUTYAyKw7wnc/QlbKW5jYzEAl/PX9JfOniuBX66ZAYBfGpZY9AcrKEmdW5swdGuni7Eq8KPHxs+Db+XUxIc@vger.kernel.org, AJvYcCXVUgSXn6osEoMDpSveGxbldojVciis1MIMFBiAeDSm378tODLzgpJtZmVpae504Fs1DoQG8kWEdWk06VA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzihvDjt9Hvmmh/mJaogFv8epL2enKiccPpUvTI0M88LyeYfOZ2
	gr76yoLlh7oCkXnVKsSLd/GdSb/wxNV9/xjDtMVNolX+OGrus+Fi
X-Gm-Gg: ASbGnctXKe2x2jOQa/c8tdjaPF6OGT2To7JBuKBrguct/lyhnLWbXAWz/oVYa3LHj6I
	0GCtTWes2Do3q+MxSVC84JCiElVnAU6P10jbJZr8gPV4TyLL+OkwdJbuOSBsjOTVfTaYDgEw3vp
	BRjb9izr3X35yodQ2KniNa9LP4i9pKX9GxAE2ZxtyqcbgO8MtxBUIIjPcp3EKabdCml766MkOqB
	bLr253HLGe75koV6RZxlqS9hOJEVyQFTS06Ya4LHgy8ilI9g6aqThFewZ6hq+Lv3gUfjvN0rHvE
	O8UG0zPtntrZnF/DH8emIwgBYowRp1CXJyRHp9BxwTbWExQvV5x2O3SYqNBdv36obYcQ
X-Google-Smtp-Source: AGHT+IHslZla2YsavTI3FKWyUmmzSPKtVbN76hsEb/Nq6bQTRCWaVxHsrrr0xKG5Y0qcVDJqED8AMg==
X-Received: by 2002:a17:907:9485:b0:aca:c507:a4e8 with SMTP id a640c23a62f3a-ace71095212mr185275866b.21.1745585147374;
        Fri, 25 Apr 2025 05:45:47 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7094sm134641766b.56.2025.04.25.05.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:45:47 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 2/4] crypto: sun8i-ce-cipher - use crypto_skcipher_driver_name()
Date: Fri, 25 Apr 2025 15:45:15 +0300
Message-ID: <20250425124517.2225963-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use crypto_skcipher_driver_name() helper from <crypto/skcipher.h>, instead
of accessing struct crypto_alg directly.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 05f67661553c..f03a8fa7bfa2 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 #include "sun8i-ce.h"
@@ -438,7 +439,7 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	memcpy(algt->fbname,
-	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
+	       crypto_skcipher_driver_name(op->fallback_tfm),
 	       CRYPTO_MAX_ALG_NAME);
 
 	err = pm_runtime_get_sync(op->ce->dev);
-- 
2.48.1

