Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20146372070
	for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783704579; cv=none; b=VY8QYY845BFEXpcpINVx+UTseZ410cK0pdNTWt7HoE2g7/1G/tNuEYjVnmIDpX9XkLJNqcY4LBnlgcWg4VzHCFJtXOFG+TzZORV0AQ94e81ZW7zPNs4TV1X7zfqODCXJIUa2grIYv+AlDyZm5X4dgSx0gSX+Vuivi5FvpMT/NPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783704579; c=relaxed/simple;
	bh=sHYhG4DNygGPej0hSQJB/7SJr7cdvMyQNw2AVk0hPhA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s3cXR8ddOLNjxC1sx2o5EMf1c+aVVeqZsUkKK43+GQFAG5YUh5llxYYHuv7MXRm5FSeu3AIEUySCUZblz1cQBvNNqK0ZbsdJ24sAqisfJ22ZI3QSiMYHFj4CQhJ0rI3BbpC3+06Mot8tn0yBkHOr8mAV1N8b6VhZcO6dSScEjkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=I6LlpBKd; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="I6LlpBKd"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so144857766b.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 10:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783704576; x=1784309376; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yM6C7TqLs0ysaf4+YV06Fpssphvvfjwqj9luc4OgHeg=;
        b=I6LlpBKd0tJRxZZtlZC/rZlIpgslOWqHEpF0Tzmn4482m3DEBaPQIDUByWHJLVZeMV
         +ZVEhVqqvbuwGvj4wycTQzfrhxhEw/hz0xqaXD2DTcAv06YI45H2TcUERYL/pn6IM9BV
         tMpZAnRhK5SADEaTlqX+BV2TcjhucsgRUjhTfhEq8/0qBJdMdrBoVVKb7Zl+wbFD8Cl9
         yKzfMPmZPIp1oq+nsR9922Nzw7IFHa1QonR4Xgu6xju07PD08XVCQ0+AbFZDV3gIGK65
         75hw2QmTp4qAi9Fw/II09Fkf4Snz04MYsJSMRDxNvpQEUUrGJz7u/i9wdqwyZHNsENVj
         kq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783704576; x=1784309376;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yM6C7TqLs0ysaf4+YV06Fpssphvvfjwqj9luc4OgHeg=;
        b=rEGhpMiiL8QeNzuQkrlnJXpAd5us6rOzZBUsSCxKzuFJ/+zsu+smiG5gKoOPY821lW
         BRtkWyT1GXokRMaF6EJEhoXjWPeGEyqliPwJL+4bdDM9b0nCFSqSQ6w1nQOX7e7rDbf3
         kaH+uT0b/L14SVmbsljZyh9g8Q/Ir3lRtMrO0ZUglZYxBwVcn8B92yishkkbbLKnR7rl
         pLoDXyA5UKtIFGghRpzqFk5m5lrpebqjTEwWOXMQSWenkaeEsogNAdmBDeXAa7NYQjyv
         fPsZUWI0O7N25/wljFErE5m8GK6yQ3TGLv2HCTug2TM/bEWLWhyL4qzyOnYE8psjuzDt
         C0qw==
X-Forwarded-Encrypted: i=1; AHgh+RoiMGROue+iJx8odXw+x7bEtagJuHAm/9s1gJZ6rbngq2u+Z2t5omjGZ+5sek/HAo9f1y54telXOW5e82M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0Hq5+pPR786+5pNUfMEEuy1YaI+0HP55EzoRD5eJ5XgB56YGx
	RFMeeB1rsjWBcodYbdDsRD9Krg+c4MvCa8QBZr3PRV3zQ2u9UFQpubMm
X-Gm-Gg: AfdE7cm0WCD7lvoFU6N9wyyoGbLx1mzhG7FjjWh5wy4JoYbAW0XhBl0/Kryw4lVH7HB
	Gp4A2vAGyh+S4eMGCpGMDVyRwH4UsEyT2ciyDrt5dZtnB5INpB/arH+jozVenER804Xwj1wY0ew
	qltKEj1egvF6hQ0pUPh+IPMPUQlsLRf20s9+ZVrApCMTNN2q0kGUHjo9AJkpLPa83cWtzir5Gq5
	Gwt6iCL6Dre/aa/ALUzSg24pqd/Mspe31EifB+6bw3+xZqbR7aCIym5fur8B/Yb1wIbKKbNRzlZ
	zr/6+3e/erz8slZYNpxBO+Y3rSWn+5akg6OlMpPKar+nsY8QUW7oip0cnbRQTNuiIrGwU0Q8fut
	ervqAixpfK6eltVb1TBFRdTL8z605tGkVT1nEUZfdQF044f/TdvxEMPObZnz3/9rae0ABGtFL2N
	cXg7WnLPd4ZHUXWfjEy9i6vXyjNpFyGva+UZYoCgUI
X-Received: by 2002:a17:907:9713:b0:c16:9bd:39cc with SMTP id a640c23a62f3a-c1609bd3edfmr119069666b.5.1783704576367;
        Fri, 10 Jul 2026 10:29:36 -0700 (PDT)
Received: from fudgebox (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15bc428775sm581447866b.6.2026.07.10.10.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 10:29:35 -0700 (PDT)
Date: Fri, 10 Jul 2026 19:29:33 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: rsassa-pkcs1: use constant-time comparison for
 digest and signature verification
Message-ID: <alEr_e-G0L2nxxv-@fudgebox>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Replace memcmp() with crypto_memneq() for cryptographic digest and
signature comparisons to prevent timing side-channel attacks.

crypto/rsassa-pkcs1.c: RSA signature digest verification used memcmp
which can leak valid prefix length via timing analysis, user data
could reach the leaky comparison via the digest argument to verify.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 crypto/rsassa-pkcs1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..a612a9eef2dd 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -291,7 +291,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	/* RFC 8017 sec 8.2.2 step 4 - comparison of digest with out_buf */
 	if (dlen != dst_len - pos)
 		return -EKEYREJECTED;
-	if (memcmp(digest, out_buf + pos, dlen) != 0)
+	if (crypto_memneq(digest, out_buf + pos, dlen))
 		return -EKEYREJECTED;
 
 	return 0;
-- 
2.43.0

