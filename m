Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600989;
	b=x5PnwRDlYhCjYkf91k3doDInggtljYWPWi7wiA3I/3st5S+yLOM4Hvow8N+GDiWm9PMK
	 VB4KBkhMvgYLljGzXko4mCm4FFFv4si5NWMPYHwPs4ItS9Mxuisic0Chn4c9M1hzMpUbU
	 03oRYnbI60I/iiha6TjzCIKcOp6yXi/VNgQ/1rMPH6vklKHTljmbsm+klLBaZHHS8mh6/
	 o8Cl03LCqoJpIbfjfFM7XZffR9EiobpfSYpe0k5R/ffi0XXhmArgd1i5tcAdnMH06mi0z
	 Ky1R2cc4wLGUUydLnoK1FQzgM3eUgKXej+T0CgjF6sbe5P9FUMihIWFfU75J3gLr8fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600989;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f+38X7/93OJZ0w0/yOS0NSZnjJd7UdYjHJOWwQOd+XQ=;
	b=ZxMcTHG0GqnHX2FtsqA5qum6ZPa6AYPAR9kCJkPT/alCAoT4XkBtKQDYmYxqgkeES2Cr
	 pMAQEApMMR2mrsmsoSPlsOt0uycsVQ8tzQSOtuD0e8uHA9uFCa1OdHLOlrjqC7MlocN3d
	 s7AMA7LLiwyTR2LZnRqmJ6DV0Hx6Y0snskwu78tS6Nfl9ijtf8ckH+ZWWdudeVhTRTwjO
	 KuZof7GhY187HhpACsYLHtb6E1VWo6aMnekmA6CdVvhi93TJC/KgmzMhbJpVzK4FIGg39
	 /MGqvyTxV45fWor0Oo1ZqEy6rjZ3Wcej5e3+xEq8CbUPtK74f6ic/U7g9VoknDpet+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="O+o6V/9G";
	arc=none smtp.remote-ip=74.125.225.133
Received: from mail-wm2-f5.google.com (mail-wm2-f5.google.com [74.125.225.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E502C606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 06:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E502C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+o6V/9G
Received: by mail-wm2-f5.google.com with SMTP id 5b1f17b1804b1-4a35e178418so14574645e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Nov 2026 22:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793600987; x=1794205787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+38X7/93OJZ0w0/yOS0NSZnjJd7UdYjHJOWwQOd+XQ=;
        b=O+o6V/9G9qcrrD5uEeY2MT+wwGYpdxNfuZr21zm4ab+1ZltYZ2gkMCBCsbjvyjVlEb
         AIUueBf5hhZ9jwJb+5cWZleACmSXRGXXW2txSSX0P+3Ne45UMVO/Y5kZNTcc7lns/Hai
         X27+LuWKvzxAas7iZ/Jz4ErRg11mD3Dx6AWxzB1KG5tRUaFe1bFfPb8zVUfcfp1KoMA9
         izPXC7IBjzrl/egWOPtKNF9XlEoToCa8s1TfmEMhrcwUmiHSsHIHfBO+FS5WOCgUVkJE
         +uDT8m2BPBg0rvyn1roa4hIW7apuYIzQQq9N7qMsl9y5w06XzdE+uYtMJddsopVt1/UF
         5Xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600987; x=1794205787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+38X7/93OJZ0w0/yOS0NSZnjJd7UdYjHJOWwQOd+XQ=;
        b=iSvUXImHculbvgJzmUIFZzd4pIWNCXTu6xWFWXXe83ybWDIfVMy+xEID5kRpQcAXNE
         Zd8fBEYt8bKY+4Q5AwsZTTScDobCCunYclQz00FJpky0PCFEGj8cinEuEyvZLeBHNlhy
         umUNs8y10zM6rilwHOnCZayYWiGIwXouFWh9MEKRgsfJCW3iWyLZDg4/efXmL35wIKe5
         NHLJCp9yKx2lEiI+JGSiZX8W7QnSDoYMUn9Q076cT8Gd9sW7oGzFycBdi3EGGboqHU/9
         fwcT3GMxgPOzSonN8drJR8ehr/zHhzuMWiwyYP26/4lg4QKgvbllWEoVs6ib1D5Cpv4P
         zy9g==
X-Forwarded-Encrypted: i=1; AKwUvBx4UM6yj1J8CerQfXpG4jrigrBUjQV3SXDfW7tHMR8kfGQJKdPTd8FXo1Cg7UdDrY1c0bljQTCWged4E2I=@vger.kernel.org
X-Gm-Message-State: AFq9FYJV63uPsAdggoiCKHk4Kzze4Q0EfQ6+LY+wtv5OtEM/QfD6vuHB
	ZeIy8p7Rnw6HrrRZOgxQnZ2J0640q8ZNnbXmbrbAoXtzkk34pp1mcJv0sAARMXJf
X-Gm-Gg: AYBFou2A26dTqprzBwV00XYjbcLJsXC90JUiSQooKFzV/DGNJjWF/SutBV9oMDp+1GJ
	4H1y1WWGJrZzJ4r80Q0t0wJMqiOv6Ig3nF5uFtoKkcliuPe47JFAGPWnWBwfnMmgkJSKHWSFq//
	LIKcObsoMWHiJTpWFgI7x7XDOL9fuqR18gzePzXnvz2YQoL3W7Actq5hNRqGX+4QfDBgDLP3xu5
	QVm6gI4+74XmWAPHnQtfjiwHD+zAichUl9skyaHUlPZETpzLOT9himNB4XTieEEsAe0BAv6bRNu
	GqQ4uAkKwl16nQLEc70+5ipr2+5YHX9sE0XdXA9Sr7a7QyG98RTnviasFw6WxNtoIz5+Y5dZRHt
	h8y6+OxKVRFVFvCog0qZdMj898AtC2lLsR94d6RXqC0j6OG4pituaWRNPkY9yM0j1Hs/YRa6kIW
	+brOjHnxdshZQYcxHrGPKZo/zN/LxMBrBe4om0ABf/R33PklzIcXD5C18ozdO/6Az6I7WL1tgLm
	i89E7VfuodEzVLYMUSXoftnfsxwRSwfOiUo/Fh0DsVAxwxyRpRh0aUdkgF4IdoyQoGC6M5CFfsW
	QlZKSmyn7/9eLSpOHcn1By68SPPVD4V1xaYjcaDPSwUyxw==
X-Received: by 2002:a05:600c:354a:b0:4a3:5a55:f454 with SMTP id 5b1f17b1804b1-4ac17e10ac3mr219059815e9.19.1793600987081;
        Sun, 01 Nov 2026 22:29:47 -0800 (PST)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf751c2d2sm273759905e9.15.2026.11.01.22.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:29:46 -0800 (PST)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: stable@vger.kernel.org
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH 5.10 v2] crypto: ecdh - explicitly zeroize private_key
Date: Mon,  2 Nov 2026 09:29:08 +0300
Message-ID: <20261102062913.6603-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joachim Vandersmissen <git@jvdsn.com>

commit 73e5984e540a76a2ee1868b91590c922da8c24c9 upstream.

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
Backport fix for CVE-2024-42098

 crypto/ecdh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index b6f493e82812..c37e8d35387d 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
-- 
2.53.0

