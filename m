Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454C16C879
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724077166; cv=none; b=ZvaJNEuMXLxLb5CSosH1/Z78sjTI5bDp5JFPMh9D6rJqFZTDSEVI+Z3fwDgWNwlQ2xDKeAoIfmSux6J+IxaW9NuDpOAeIFibADo1ebXdQXIq4osK/39SNVSVE1OV1F49JiJoRK5jJGll4SloF6K9s/tRUZc/sHVhzUEe0/tew5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724077166; c=relaxed/simple;
	bh=qS7ZSrFqh4rU5Ft5q1twy5K9515FjzeEZNzbn0Q+UyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r7igMXY9/X+BvBA2ktyqPxU2c4N3sR2LCAl7onyf0AX5XYZXdNYbRZe1unTryLdky6pBd8YPQRNbGnPZ1tWjLn0RjueGyPKZ7KmYz0YaPbZqRpRlsxcuGXPDiwHeuOvEszi0CIua/T6V+mJSaiFCvEc49luGID1Vs01KfGEMqMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=VIwZYXWv; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="VIwZYXWv"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7b2dbd81e3so605567466b.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 07:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724077163; x=1724681963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RFS3Wv8nLSrNGmJ2U9Jj6TGefpKqXVtUCaCEYux9qa8=;
        b=VIwZYXWvtEY20GoQQfRDk+zFxgo1jSlxGLaxs7dYKKpbp0q0QV5owq4RXimhVurWy2
         EQSGEjyzkx9YjRThWWEKP/QMnWmIQeI4DyMBjWCoGMKRwETwyMBelpoMHEbv8it4F/3G
         dh7Owu074MH1F02i2xIke23pHxt8vLEb3PqXHkJeDKd4zQf+EWTBU9McpQ9WAzw6fvQL
         Pm9AZ2AXHDwYOoyz74dpmTkovHxEHoVMeuUQXYmvcJuSepBhvTLG51itil37CfsQirs9
         HxA4RXzJ+UtsrPa+S/8652QU/T2HNgLjFhayttMgheQIrc/mRQq8OZjoH494AmECRhPO
         1H5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724077163; x=1724681963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RFS3Wv8nLSrNGmJ2U9Jj6TGefpKqXVtUCaCEYux9qa8=;
        b=uikgv3xQg5OzzJWLLKRFgymRp3aVYyrqqZ0Y39iMKF+EwDixVcaRhnATl4vo5QYzpt
         d6ltH5AYUA3flzLSkrAkLnQHHSqqBJvJZfoVYkh0btjlNL4CRQrTocT3NaUxW12jRW6O
         x2QsfGtaN8smn3iD+1Rm57ksFZpVmYUjBdpzpu2H2ItkAkgQ5P06GLbNRDrPY3q+WARO
         pt9VnCBpruwLuJwSvG42FzUATKSaUAh6IEmGeQG8vmKplVifaqjuULUx+UAvlupebWid
         qpczHIEHJyACxhf5nUE6HE8Opo8hfWs6fEHfPnF0M14i4OCZB3OJ2AszZa7ik/xeqgok
         k5EQ==
X-Gm-Message-State: AOJu0YyxpdPVT+fWjQs2ejR7lUhuw7ZcQ1izjH5D0LDlj7R+6mrA72uk
	/B4dhWNsnNaXdazVCVVXM+01Yf8aPoe+XpW8YK7SnwHMKQFTyaNct4nT1LIoLyc=
X-Google-Smtp-Source: AGHT+IEcN/Sjk7o3QNL1D2HctPW1wo0igtSMNE6KnvXG9XGrBUFPctC4HUtzHRg0JtJLyL/iKhgYUQ==
X-Received: by 2002:a17:907:60d6:b0:a77:cd4f:e4ed with SMTP id a640c23a62f3a-a8392a47a15mr745465466b.63.1724077162735;
        Mon, 19 Aug 2024 07:19:22 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-163.dynamic.mnet-online.de. [62.216.208.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383947799sm646235366b.177.2024.08.19.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 07:19:22 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] crypto: jitter - Use min() to simplify jent_read_entropy()
Date: Mon, 19 Aug 2024 16:18:44 +0200
Message-ID: <20240819141843.875665-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the min() macro to simplify the jent_read_entropy() function and
improve its readability.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 crypto/jitterentropy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index d7056de8c0d7..3b390bd6c119 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -146,6 +146,7 @@ struct rand_data {
 #define JENT_ENTROPY_SAFETY_FACTOR	64
 
 #include <linux/fips.h>
+#include <linux/minmax.h>
 #include "jitterentropy.h"
 
 /***************************************************************************
@@ -638,10 +639,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			return -2;
 		}
 
-		if ((DATA_SIZE_BITS / 8) < len)
-			tocopy = (DATA_SIZE_BITS / 8);
-		else
-			tocopy = len;
+		tocopy = min(DATA_SIZE_BITS / 8, len);
 		if (jent_read_random_block(ec->hash_state, p, tocopy))
 			return -1;
 
-- 
2.46.0

