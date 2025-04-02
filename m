Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FFB23957D;
	Wed,  2 Apr 2025 11:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743592433; cv=none; b=ieSH1iL9p4H3ag+eIy1Y4x7z5Wg6fG/tWCflKTfk3kWqwzJQYMtveEl3H/uBoFay2riRYKYAAotXuxEQ995rYBGK1cvL1Ns3g9KPaqXqdDt+dV44wkbmVEub5NwjZg0mbdOm0FZy9kgGa545pGho8Rs5aQUfJ6pjYLWSJo8FqEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743592433; c=relaxed/simple;
	bh=cvXqM0ZQA/SF5d06nBpidPXazZn2wTHw/rrXERReFoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Uikc4tkJx38cF5wfcTrfY+DQ2We0+w5Xv5DrCq239AnctMPggvveBIPgj/stYONfy/rCw6JCuejrCG5+AWmTKPyizAX3r9F/tPxYGlFZ4kqcPfsMjNjqQWTUHLrXp6NM/L57WKqHQ80lfqKeUcz7L+gOhr+JNo6ySSP4DAUSnQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECW8CUKv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECW8CUKv"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso62790185e9.3;
        Wed, 02 Apr 2025 04:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743592429; x=1744197229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WxbAHoRPWMHISvbcRp+L5Pi9IuQda2X07kyg6gEi27s=;
        b=ECW8CUKvcqJVHQAiUtFxjBHkwyrQhVxVeYpzsNDAeIvDbTmJmYkQb5wwaf1kAiTVOe
         w8nu6BwmlQwGn+MfqrGkKMhwYuxCSgKeFT/H27rdmx7MD5v1k0OP6YIPJEJganrDxgGx
         j5nRaT/41Jfv/+tYAJkt56Sdm0i931WLmUcSQLMTSLfaBSY8d2GefvNtN9yqT4hzTZHI
         EKiNjv4+zG1OrOuwp5mmAaRARSMdYesC9WXz/kYq4NHG4T470RhFD14HtU+mQxVXIML1
         40TwM2drsT0CPdvdVUDElZa/VFYSWye1tNk2fIfs5EsjrzHpuKBhapD95KNOIpwX6f9a
         du+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743592429; x=1744197229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WxbAHoRPWMHISvbcRp+L5Pi9IuQda2X07kyg6gEi27s=;
        b=IUmZrnCmlIoT7EVZsjdGvAyoC0zVNOomlhDCsPo5ZFOWlgEkOXuY742F/ZdeFTHHgO
         ZZ/+vklTlfoi8omE+MUZZIweL6G+PvZZ92USbS0m87q8mHlz4G4InY96AkTZk7XWKAnS
         r8zLOjw+LQx1N87qQUEdU7TUgtHE1kzbOwr86RgUwPHgDLhZTpGOemX+t87kuTC/fjyI
         sUcC7NIeK99pbWdSIf9yUq1uVpGnSSuoGUNViXvgCadyEorSZJi+hk3SnDxO1bWfEylf
         5fZ2MKqBPlTKYRRCyvmiB9qNN3SfJNE93za0Q8qUtNsUz4EQ/vlTrTxJmLud2KzeE1tH
         TJtw==
X-Forwarded-Encrypted: i=1; AJvYcCU8YWYFcdzU7rmLWIRhXMr6Zhx8TWnJTkBuRfPkOi98gdynjFDPMrN+MFvzkNcs/9YuQIQGPq1pCwosh30=@vger.kernel.org, AJvYcCUwh71gYK711+8MTzEo+JuunyK3M7MC595JhBiT4vZwPvvjDVsPIay7dbL3VHmky8Vas3MT3vhlWcu5s2EC@vger.kernel.org
X-Gm-Message-State: AOJu0YzVvPcEbK34gU05tjZi5CIFAoanT0sgyM2nou5JITvSJ/DKHDLf
	EWmQdLlX9Rd3Zi+ZPmbN4trHQcTYxtNsHERvpyuX08CTFndgunx3
X-Gm-Gg: ASbGncsDAqVRGpOovliEtKJdLR/MeRnaw8DB1cfCLQd+7Kg++qIFr/er9+0s4NynyZ3
	PTOd9joLHSVd4uFHWB+3xcUtaBEAYLRgSMa95Dg5tnNx17HvKLc3dWnnGV+HgPDRBmmDa9OpvoC
	uTbUi8uJNGjJmZLTB4q9a8fNa9DSAJWJOkOI08vusXnzKN8Pm9ePDOvjZPgWmLmrRdZlUyzMlqG
	LpKyaFAMQtHwY2dso3XvaCBhud8DOoBCj1B+kgoz/AEUROGL+hXjGSryoLaR+y0/bXi68av31dM
	4Ejk1g9toSkex5IyKpOIFCl9W3x0ay07xu8xaN/81h260g==
X-Google-Smtp-Source: AGHT+IG8DjSotHCrsDLuuunlwFAcflox5He58nr411E9AWlWpXQ0JWgp9n1qos67GnisIzgeoT6EDg==
X-Received: by 2002:a05:600c:4fd1:b0:43c:f6b0:e807 with SMTP id 5b1f17b1804b1-43db8527142mr168905395e9.31.1743592429245;
        Wed, 02 Apr 2025 04:13:49 -0700 (PDT)
Received: from localhost ([194.120.133.58])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39c0b7a433bsm16858788f8f.97.2025.04.02.04.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 04:13:48 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: eip93: Make read-only arrays static const
Date: Wed,  2 Apr 2025 12:13:47 +0100
Message-ID: <20250402111347.409795-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Don't populate the read-only arrays sha256_init, sha224_init, sha1_init
and md5_init on the stack at run time, instead make them static.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-hash.c   | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 5e9627467a42..528d5bd864c9 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -97,12 +97,20 @@ void eip93_hash_handle_result(struct crypto_async_request *async, int err)
 
 static void eip93_hash_init_sa_state_digest(u32 hash, u8 *digest)
 {
-	u32 sha256_init[] = { SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
-			      SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7 };
-	u32 sha224_init[] = { SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
-			      SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7 };
-	u32 sha1_init[] = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 };
-	u32 md5_init[] = { MD5_H0, MD5_H1, MD5_H2, MD5_H3 };
+	static const u32 sha256_init[] = {
+		SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+		SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
+	};
+	static const u32 sha224_init[] = {
+		SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
+		SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7
+	};
+	static const u32 sha1_init[] = {
+		SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4
+	};
+	static const u32 md5_init[] = {
+		MD5_H0, MD5_H1, MD5_H2, MD5_H3
+	};
 
 	/* Init HASH constant */
 	switch (hash) {
-- 
2.49.0

