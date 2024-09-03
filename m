Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF131CA6B3;
	Tue,  3 Sep 2024 12:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725368151; cv=none; b=tb/uaWG+O+3GwtSqTd4OfECksynz7AQkxQZaX70WaSgESrNeimD4iaIeBPYOvHcsr9SkNd2aeZ46RluejAlzcIqQ5oaHoyCB9u0FbLwoOqrhupjx+ohsjZFm5y299Xot2eQhe7mkaB8wtD0h7wsAeWZiWi2lqD/o/qQLMkoGxmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725368151; c=relaxed/simple;
	bh=FR4eP3hFCVHV4yot3NIpLRkrKDFwbr7wCO+ZPZ9IT6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BMu9lxjYJaTw5wwVWE/OA1srMqq/dx1LZdTu6Dn350gaCiQltpQviCRLJcQqYO7vbvELqEMxh6B6u2LOaGGlextlHAVH+B+P76rysfDBf7giSEqERY8A/knBraDqbYZ7WyLthJcuGBDxPVxEBS/NO364d95UveAayhDwWHH/rS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNEO6m8K; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNEO6m8K"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-714187df604so3641952b3a.1;
        Tue, 03 Sep 2024 05:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725368149; x=1725972949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+IsWpqVgt+KJ6WzMhEvW26KeomE/4ZiUXtss83zz0RY=;
        b=XNEO6m8KMIHM+cMEE6mUA/QBQqxIZzCk0osRjcW2cNOiWhziseXCsN67I54bloa545
         j/Ml3ez3xhOBpe0BB9MPzlYrsPg5QPRRZ6kTkRW9xL6gg582MwzZwwFHcIsJFg5HYubl
         BANEb4PWmuh0NwwMQaVF/yv8tKpztCR3wqKsHIDLdFRdtYfICT1frlVe/4hXYD2d6idE
         ozCfIrmVrnR9A/2NexCB+W7BbqsIg5JYfwmjvVze/61mhFJ7Ebb2Gs71cRBd+96A7jYp
         yQmr00ZOCv7OEkEg36Iu6wJhr6PUpBrcGlON0oDey6lGWEkLlAypRtRSaa6GH3hTLeIQ
         Y9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725368149; x=1725972949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+IsWpqVgt+KJ6WzMhEvW26KeomE/4ZiUXtss83zz0RY=;
        b=BCkjwi9Ms3HHapDO6XAJfYiT8kCUoojgv+Gj+qXpoQ/+VH/E75yysxTu1xUWgmJnpo
         MmmQCf+AbrKpI/DS3wOvBphXoJvNZfADn6XHOLwfXj4STi43qgl+z3RXwT102Qd5aXtO
         zjmgx0XcB3w0qhVfwM8LThF0MN1kP8G9ipt+CSrqmqz8r9MNNGIJnkc5k5JuELkhJsrY
         aXZYQsTSBxQESbUslfFjmnTnXk58qCjGhlyOOXp41igQCmHAnfYAc3XTQMZmmdMn1ZOF
         xku6RtyWKc7+ewLeSqAsKcqbwWTCW78TJmQ70Rvu2FA1aovE7I7c9yVCKeTEJdSjmWfk
         5MmA==
X-Forwarded-Encrypted: i=1; AJvYcCVfM1G94KUR6qq8sZiiArXYNxmmjB4WsjuFu7GBGaXgoYqB5/fwR6AsHELY6ZhbK+2+kw2Sudw7DleUw8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaINPs3HuwLBvJhEIL0J9Zwoq+s+AE/yf8f6u9kRTCmhq8YlxQ
	rPP7LdQ1pphMS4pvxH46C2eGnY+J5kLXBiTiNFhpE5DAQEpgTLOnlNiTj0X4lkU=
X-Google-Smtp-Source: AGHT+IHUkTkxp4HLChhYmhajoCXVva33bPyWUMJt+1RyfTslmygXSbqtzhhnUBYWX5olbvVaOTb2wg==
X-Received: by 2002:a05:6a20:2594:b0:1c4:8694:6be8 with SMTP id adf61e73a8af0-1cce15f7ea3mr26840193637.3.1725368148746;
        Tue, 03 Sep 2024 05:55:48 -0700 (PDT)
Received: from fedora.. ([106.219.162.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e569f4bcsm8438250b3a.115.2024.09.03.05.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:55:48 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Riyan Dhiman <riyandhiman14@gmail.com>
Subject: [PATCH] crypto: aegis128: Fix indentation issue in crypto_aegis128_process_crypt()
Date: Tue,  3 Sep 2024 18:25:39 +0530
Message-ID: <20240903125539.12679-1-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code in crypto_aegis128_process_crypt() had an indentation
issue where spaces were used instead of tabs. This commit
corrects the indentation to use tabs, adhering to the
Linux kernel coding style guidelines.

Issue reported by checkpatch:
- ERROR: code indent should use tabs where possible

No functional changes are intended.

Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
---
 crypto/aegis128-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index c4f1bfa1d04f..4fdb53435827 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -323,8 +323,9 @@ static __always_inline
 int crypto_aegis128_process_crypt(struct aegis_state *state,
 				  struct skcipher_walk *walk,
 				  void (*crypt)(struct aegis_state *state,
-					        u8 *dst, const u8 *src,
-					        unsigned int size))
+						u8 *dst,
+						const u8 *src,
+						unsigned int size))
 {
 	int err = 0;
 
-- 
2.46.0

