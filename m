Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB3D3DC84C
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2026 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780501821; cv=none; b=Y4R8FzHgeAI8DePyeGnYsN9HvwbjjCt1vDd6nCnghaRjfz9t9z51mJxSlIpJV/kPhEz+9LeiPdB6g+ocuUT6AUhr6ebEYSXYGQcF6A+XizV0aj954T3KNcSuPhRavAJcdgFEhVy2njJvZe+F6u+mdOuvWvXZWqt4gSZ05aimRPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780501821; c=relaxed/simple;
	bh=8NjgZt2ufUAKT0v0bEDjkuL9dEknYB921yRBkS4Ekhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ec96lVlHOth4t55cgFhuYOp5zDc3IcJWi59+wVCqAGEzSMlQEFRyKeR5RBBbBVXZXOgrUD1PduJ5W/7xD4XkU544LX+6hBPzbt3jrnJhUdyvT8KjPX+3aiCwkF5sq4Sn/VeXYLV1Dcco4+DTfvFPxwGCyh68BFIyFjaqKLDicPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9vX5dMu; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9vX5dMu"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ce9df31130so55490176d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2026 08:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780501817; x=1781106617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jloqLgrwKVIF8BOkstk2Z6hbrUd4wWC+As7piYPUuNE=;
        b=a9vX5dMuynpRaAkJik8o4navhUrQ8NM2A4PoKipy82rmGpcjFuL//U48zvk/GRQrGa
         /Lj/+F20oB97o3niHKAWc3DBt6Togx7Oydky0uDm9Ukx2P0bwxT0gHtl9rVhxTYPhJ5l
         RkxTblgCtZX5WUu6LrUAcsFv2VZJI2HFglI27mKmssU3hCBWz1sN684tu7JXrlq9nMVy
         qcADAHPNwnkpy+y/NHVC1UoETIB5gYPhTXZ2wGjHMhV1roMIPjmBathS880Sb6oBWELC
         2lRN16nifRraJe7ZEkALsAJjXfjjguPVNMR3WedG8VAl7YnZFGOHEATMBDIoYxs4bm+u
         9+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501817; x=1781106617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jloqLgrwKVIF8BOkstk2Z6hbrUd4wWC+As7piYPUuNE=;
        b=FDQhJJ7BWTGS0wn6GAbdnq+5sEx2yy3RE9qrJterMMUOoyLTsfr0evyKBn+76X4tWf
         d46ApLK+VLpJa7kiG0KEssnuUffsJQti0y8Ie82znPil/SOt4U/x3aMaS+BiTajJpMHf
         lonFbXlyS1RlxAjRPohZeX1yQrvpDV7GV0oUPh2bzXsFUGVGMqn93l+asGbDlsxnRI9P
         NW8RKj+KIoxvv2TpS+yspy1NDNXS0RlFj7Ar+uO93nyRMID0XARGavZl4MqWD2Q8n/BL
         j4mI0Lu/Oc+IkWFHJv6JFFQtDcar/b/lmL32D1XnK/4YHxqO4wMH11jRZS6a0hkwmRM8
         1jXg==
X-Forwarded-Encrypted: i=1; AFNElJ/WWoLCMO/7prvl+2Hm4gigQgDFRN7feeaH6F9vdq6v3CehHVALcgzN3ZrpKwVsTsp5fPjKxTmdPuwW6VU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh57LKLQAVLVbAcGoC4jojrv4g0iwieGp2jbVPrNQSpV7DlDQ5
	zWyBcUDD4WV/Iw1HdvvXJB/Fev4DP7igkG4IAUSwo1MSUCwZiPBifXfR
X-Gm-Gg: Acq92OErW4CuO9/CMuIWyUG5MIza7zBr3TFFZKfF09IlEeZxDkZkouATUGZZVE4yFtX
	alBgJCkLLO+8qiFnftULyIVCamFdhVtt31e+e0p2UWQt0ZRfOTQ2jYgExRiyFwd12JNIuN49D73
	Jg73RyVLmr6u49hLf312nur0uObPqyhIIlF41qghqPwXsSYxtcD6oW1AX3srRji5iBEQH1+c9ZW
	3zZZyZSjB4PN4bZ2qJT0pYm8deYTnOQFfK+KkuxPcMUncftd8BX63ecNvfug83aYheINCqaLky0
	u2bHGeufJQFG3RGSlew43HoHXfZqid+d8VZ3H4/QZsdcjEGGAZBUnPlUGYUUrEWuBWVjKk4ViWq
	d1AwCX3/f9taEYYW24tFMNiOCPQJwq97bTa2fDObaDJjcbzMmGY9O5LjhxxonhbjiB9+8F5aOUz
	aPsba6AkVc7bCdFrKWVaDe49d7FD6ucrIrYKxHTABUO4ZuWqV+zPpHj/JslbGhF1yXqDxniYb6I
	xPi/JVGPUcpbyw=
X-Received: by 2002:a05:6214:2589:b0:899:efbf:9292 with SMTP id 6a1803df08f44-8cece16190emr48394546d6.43.1780501816523;
        Wed, 03 Jun 2026 08:50:16 -0700 (PDT)
Received: from zambezi.front.sepia.ceph.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fc7dsm23645436d6.5.2026.06.03.08.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:50:15 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr - allow authenc(hmac(sha{256,384}),cts(cbc(aes))) in FIPS mode
Date: Wed,  3 Jun 2026 17:50:04 +0200
Message-ID: <20260603155008.736872-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hmac(sha256), hmac(sha384) and cts(cbc(aes)) algorithms have been
marked as FIPS allowed for years.  Mark the respective authenc()
constructions per RFC 8009 ("AES Encryption with HMAC-SHA2 for
Kerberos 5") as such as well.

SP 800-57 Part 3 Rev. 1 from Jan 2015 [1] links the draft of what
became RFC 8009 in Oct 2016 as approved in section 6.3 Procurement
Guidance (item/recommendation 3).

[1] https://csrc.nist.gov/pubs/sp/800/57/pt3/r1/final

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..7788e6fa80ce 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4215,6 +4215,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha256),cts(cbc(aes)))",
 		.generic_driver = "authenc(hmac-sha256-lib,cts(cbc(aes-lib)))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(krb5_test_aes128_cts_hmac_sha256_128)
 		}
@@ -4256,6 +4257,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha384),cts(cbc(aes)))",
 		.generic_driver = "authenc(hmac-sha384-lib,cts(cbc(aes-lib)))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(krb5_test_aes256_cts_hmac_sha384_192)
 		}
-- 
2.54.0

