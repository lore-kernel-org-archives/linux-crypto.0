Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC85524B28;
	Sun, 11 Aug 2024 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723357714; cv=none; b=H+9Pn7KBaLLFTi7ZqNZ5B+2gpa+pD3COhmUg2LpVVduLcjw9p02ipOejH+3vHRX25q5EqCZMDhpfbGlq3UMRfIg39zEOSofbrj//OWUq7oT6Gim72tbzjw0e53QOr/OJ5SoQMkdpXRWX1aBYD82BjUUCr0p41wT4c8UHlzh/ZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723357714; c=relaxed/simple;
	bh=9ZkdAe9Ke7PD237/+CHPox+nY7Q64p614CBHQGtg8e8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kMlMecUeF1ba+C4TW/s2z3A/6LdSOaCmjSSAbFDtBR1hpdWsP2OgzVkj/VTNSpo3dgSZzCJAyNl9Rz1uUYD0fDO+bbyvKBGGfUo5IGnJ7N6FtyKsaqmT2JB4jo/r9938/zkpiKrF0brilnvKUHklIU1K5NnO1zmpoL9TbSGYm4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEXepUcq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEXepUcq"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc53171e56so2004505ad.3;
        Sat, 10 Aug 2024 23:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723357712; x=1723962512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InerpERUTShRbv/VugKq7TcCuS6dPEaJJKrcgohqHKg=;
        b=nEXepUcqk5LaSnjm2ueiGfOalvuD3/LvULwdrOOiy2ZfZWDiRJZE1DOD91P8uOxsUl
         zc33jULMnVjHvn8K/BsJ7j4d1UcqDr7Y+w0c/Pdmfwu0hLMADt1GeHkDRUtF8QrT6ADQ
         +RkOqMGR5Xarrzynt/LVtfzTCaHEGwcNJRqx6Fj0ZIf1MpiGgEjuco2mVHs9TX4nwoEx
         qKb9NXNLvA/GP1+ziHhi3us5jeG3CmP5IS+ocFGTvtEtE9B4jielUQHoreWiE0qqDNQJ
         4Et84qO/QytZ7l6PCvmvQkYCP28l7+jngB1xlpkVEZFZm1Rhn28NJoJaB6UJ4+fqE+I+
         Or6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723357712; x=1723962512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=InerpERUTShRbv/VugKq7TcCuS6dPEaJJKrcgohqHKg=;
        b=QbL2EANdFu3n8+K+87lcyZUa8/riuVRkGk7XnrosPfU3rZcpz0Opf/R9eUdJwxbc9c
         1A+fdYAyloqM5LCbfNgYKaRj9pY5vetzpdXyDaUhjfvjzZlZa7pumNWadAyW1tE4WGAh
         m9I9x+6jQtnCqZQ8vgMJfj0kHQzhtQrDMtuKTVKw+H6+X/jDrSYbOij+y7fnLF3Ue2Sa
         HKzxuF9ltVF9bI81C0ZZUI4mYZ4lM8e4Ph36beHyrF+Lkk9J9bYi9hZMEfyy+pjnmwKV
         XfqmfHmCAkuWjEbhcDTQ8jbV+YgLxYQYbOdoocPae+T7fogkQDEiK9cj0cKSChOHfVd8
         0bGA==
X-Forwarded-Encrypted: i=1; AJvYcCUfbOtA++ZzxtK2Z7CKfoHHQ1C3FVfyysI8ulV5EC4WXD3fzGqgz3OuV45c6AtiAFk3CsGvuSWgqx9p2FZbZX6QdeRwjGtQe1BpYjffyZHR+4dRNvw8HdFVP1YDdxXNNirzCsXfBh6UgvTj
X-Gm-Message-State: AOJu0YwUFMtGNHeo3y0P+oy9OF305jAD9tONOJAWqo3AN3VmctOMewKm
	L5hz/N8o3VgHzuSLvWRI0gZTPxUpH2Q8jnWwGxIHTs7M2cxdtvc5
X-Google-Smtp-Source: AGHT+IHvdBL2rMWB7oeGir6Skh1qb4tcnrTXVhWVceA1z4a31aZa3M19yfoqi70+O1nIpgeE9RH4oQ==
X-Received: by 2002:a17:902:d50e:b0:1f7:2576:7f88 with SMTP id d9443c01a7336-200ae5733f2mr47672915ad.6.1723357711881;
        Sat, 10 Aug 2024 23:28:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9038fesm18836795ad.114.2024.08.10.23.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 23:28:31 -0700 (PDT)
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
Subject: [PATCH 2/2] crypto: octeontx2 - Remove custom swap functions in favor of built-in sort swap
Date: Sun, 11 Aug 2024 14:28:17 +0800
Message-Id: <20240811062817.210527-3-visitorckw@gmail.com>
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

The custom swap functions used in octeontx2 driver do not perform any
special operations and can be replaced with the built-in swap function
of sort. This change not only reduces code size but also improves
efficiency, especially in scenarios where CONFIG_RETPOLINE is enabled,
as it makes indirect function calls more expensive.

By using the built-in swap, we avoid these costly indirect function
calls, leading to better performance.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Note: Build test only.

 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 1604fc58dc13..ff7cc8c13e73 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1702,14 +1702,6 @@ static int compare_func(const void *lptr, const void *rptr)
 	return 0;
 }
 
-static void swap_func(void *lptr, void *rptr, int size)
-{
-	struct cpt_device_desc *ldesc = lptr;
-	struct cpt_device_desc *rdesc = rptr;
-
-	swap(*ldesc, *rdesc);
-}
-
 int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 			 int num_queues, int num_devices)
 {
@@ -1739,7 +1731,7 @@ int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 		is_crypto_registered = true;
 	}
 	sort(se_devices.desc, count, sizeof(struct cpt_device_desc),
-	     compare_func, swap_func);
+	     compare_func, NULL);
 
 unlock:
 	mutex_unlock(&mutex);
-- 
2.34.1

