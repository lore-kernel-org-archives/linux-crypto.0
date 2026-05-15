Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70EE4C77CD
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879717; cv=none; b=NltfycONcGHmGpZfIRVmRKRbZOk2i1cbDuSmdG4H/MWwvNMc2e1fnCl+QLzvTUTYvwt9qyzCyKqWhAS8inKtddXAsCWVF0mJgVMYTJ2VEeOCbTZTUPYzfzF3TdIeNuKjS1bzx3SJGPqOC9/67bDStKpYSsuQegYve2/wlhxSUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879717; c=relaxed/simple;
	bh=7BAv62SCJAZd+nbTYMXdF5QJlgc01qXtbND56r+tijw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNJcCsdun2MRF/kjlkExLmXWh891G0pHUTbK6GIWxW2ssQvnEt8eVF2rcjH+z/e+rtl7+P7t0yE5H6H8sjfM36/knTmUAuu3/bYde55QwnSES0x6TJUbeXDeetMgVls8JdYm0FtQrNKsMrqnmrmXRYS7nOgNQJnDm2FuD3SV9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NNLKh2Ja; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNLKh2Ja"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30246cfd41aso1512869eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879715; x=1779484515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpW1a/fScKIJOJjIsuP4+bGqNlbA4fQX64i8+rdO0zg=;
        b=NNLKh2Ja78Xg7YtTOJnXXrJO3+1web4zIBvPZyZZjN3nXzCs5iNssEUVficdqe3NQq
         2Ch+FsviA0JHGUNEUHj+op4que+AYQY/kcO4XMy8ivf7STGAi/zNN7UAI1WDYx2IpkP+
         1zR5mNKwxB8V3nOiJEX9J+BtjNGEaIHEG61Dx+niQlhjaLnEuIvtCbpsgAKmOhjjN0IG
         D6TQMwFOq+D1z/OZiCdR6jvuxrrutyZQw+tIvLXkxIG4SMJSnB6TDS+xa4qiKGC36DCW
         oFs+Vt1gpdouFFwNzklH2Q1Dw2UlB/cUvflsjn2gEjePUqb2JIt1EPxSjNxsOp3LTwGZ
         IU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879715; x=1779484515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RpW1a/fScKIJOJjIsuP4+bGqNlbA4fQX64i8+rdO0zg=;
        b=EjYawriTNM67XuWU63XN+pFTMFIsa6304MfDR9OcTPLXLYkpglRp0tbKsiO6lxcJ+j
         nIwObtYuQqEcnLeVsXVDOZp3cfypEkS2Kf1oiKK3OLQoXsQV72MPVY8xeHuyZVnCEQQV
         W2wc/PG/G9KXaNP/Rof89/QHcSTfN5ks2ePsfV0UVkh+X+qF6dmJyQ1XazRdpckUlg1G
         awUa5le1hF00agaO4K9Emamwd6bllzm06tuj/ehwlNz8t+WKac3dO1D+TnnCpY0vGngA
         GoJDKUwz0q1GxlHRGiIsBqTznbbcj6Fj9PN0ZKBQ9fM+VyOUCgSbbJAMQawE/wnEVJVg
         UwCg==
X-Forwarded-Encrypted: i=1; AFNElJ9gBUshbXSkCue+1Ap7xyoMBYOIAHNlQP+e7zrFPU2e8EhUFztheJAe3G7dmVp+nmTShe+GTRwF9MDd8J0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8oQO54eZLNxxlOAZDosPqm50Usn6FyI9VY8IFfgXhL/XbacDR
	65TPUj3+N25j8EclaZ8uJdyyRUsKWFdT9IKHGBssBQJdb05Kv314FKtp
X-Gm-Gg: Acq92OGLTmNX8fhEw2gaMWaE7DenKh0FeDbrEaJZmq0Zyei6Tnb7tDCk+1/oRmN2NqY
	moXzDlT1cVWcoxfc5ICfqLW4Jky4pfmwwxu45+PyE8iEcXdYYnN4jCL5HA12y9vOyS3DE2MIm7W
	04P0N4Hu2P3lJJhjfNOg19WZMEimj2mYRlSDJdpqLHdQEpzERNS4EQElXysGsFflxbZg9bQRnCj
	n1arHrOYIrRspiU/A2jRU5p6gCdZh7qvv5BTTYixMQub4ZI01lkQyuvd4/bFlyiDp4oTYuCnK1w
	mWcmxRTWEzFUmRqHFb0G+wdUFHvUaBUCCqIi52Vj5feVnUlxDHklY/i+9e5pYvCT75A7Xaul8Go
	7TZjMA/4L73vDHgkuj8lj8cQEpgo30EaG79KfaaMfuqG3NYQmwJ7/HFZS7PTqRE97PFTp5ZGSui
	SWrq+9WDgggynCRIGWF2yeojhVxPfOopE=
X-Received: by 2002:a05:7300:a94b:b0:2be:142f:d499 with SMTP id 5a478bee46e88-30398678a39mr2873251eec.16.1778879715061;
        Fri, 15 May 2026 14:15:15 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978ad18asm8003208eec.26.2026.05.15.14.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:14 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 22/38] lib/crypto: Add SHA512 support for pre-boot environments
Date: Fri, 15 May 2026 14:13:54 -0700
Message-ID: <20260515211410.31440-23-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the SHA512 library code in lib/crypto/sha512.c to be used in
pre-boot environments. Use the __DISABLE_EXPORTS macro to disable
function exports and define the proper values for that environment
as was done earlier for SHA256.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 lib/crypto/sha512.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
index 605eab51aabd..160e81d86da6 100644
--- a/lib/crypto/sha512.c
+++ b/lib/crypto/sha512.c
@@ -133,7 +133,7 @@ sha512_blocks_generic(struct sha512_block_state *state,
 	} while (--nblocks);
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA512_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA512_ARCH) && !defined(__DISABLE_EXPORTS)
 #include "sha512.h" /* $(SRCARCH)/sha512.h */
 #else
 #define sha512_blocks sha512_blocks_generic
@@ -250,6 +250,12 @@ void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
 }
 EXPORT_SYMBOL_GPL(sha512);
 
+/*
+ * Pre-boot environments (as indicated by __DISABLE_EXPORTS being defined)
+ * don't need the SHA2 HMAC support code.
+ */
+#ifndef __DISABLE_EXPORTS
+
 static void __hmac_sha512_preparekey(struct sha512_block_state *istate,
 				     struct sha512_block_state *ostate,
 				     const u8 *raw_key, size_t raw_key_len,
@@ -406,6 +412,8 @@ void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 }
 EXPORT_SYMBOL_GPL(hmac_sha512_usingrawkey);
 
+#endif /* !__DISABLE_EXPORTS */
+
 #if defined(sha512_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha512_mod_init(void)
 {
-- 
2.47.3

