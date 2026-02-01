Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0422C21F0
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 03:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769918121; cv=none; b=Wek9TWi0Phn/O92SuxbsLLauJ2sK7hkxtELX2aJ5M0Cm6r9zDHMcrUQ8/mHZ/tQcykFKbSa0sR5NrpRGsO8OlykYK4q31Vm6wG3J7Rr6sLo6iTrEBQfcMUVPvL/DcNO0fPNGfS33Jz6eFuoX90wDeQhnKJIbAiA/65TA+7Ur93A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769918121; c=relaxed/simple;
	bh=uBUXd7dYrPocVm6WvMDYdUkgoR2vf922tUEchxcUplk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pXgs/72AknLgGeztRDViELKcJOCRuDqcg3s4PI77thZNwyyvG87XfYT6d/qKaiy6m3+gzqUor0Qk7/5umvOdJJa0OXNesKKCTZUxx534+YifePi7L0pbCORUfPB6Opxq4XZ/Z7RG7pLvh4OhNn/H0KZ3IdwtDKhyQPzipHSwrck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ukImCiPm; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ukImCiPm"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61112qZd2519072
	for <linux-crypto@vger.kernel.org>; Sat, 31 Jan 2026 19:55:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=uiZDsa/PELTpsTHnve
	H4WfK3/ySBJZX627YFriPyBbQ=; b=ukImCiPmSrhkGdzRQy6PnkN8ZmjNAgsFz7
	cli0dwObuCqKzCPQ5ZaqIkMbm8r7TxZQzFmddLACXSgVdV60ejNv1kbErjbjC5HV
	RwuvWexPh8daR2JAidhr76Bz68/QRt8Mf1mrUxxugMJwZeUSrjOWKmJlHy5rA2Gg
	wX01KP+3R8r+9HzGY67fZV1abejZtIoFtyr4JW6sm/pFC/8mjNqAYQWXTy+vRnGg
	hR09b26s3AlU5Mu5g/abm98YQMU6hwWPyrWQoy26nb5t/9yXkGq114PvoFt8F3t/
	Fkdbp2egLx5/L2WzAb9/6w9cn/XY+LaOx6BVBlcyAvDKsV61SLvg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c1hwjw686-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 31 Jan 2026 19:55:19 -0800 (PST)
Received: from twshared13080.31.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 1 Feb 2026 03:55:18 +0000
Received: by devbig010.atn3.facebook.com (Postfix, from userid 224791)
	id DE78677F296; Sat, 31 Jan 2026 19:55:03 -0800 (PST)
From: Daniel Hodges <hodgesd@meta.com>
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
        Ignat
 Korchagin <ignat@cloudflare.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Daniel Hodges <hodgesd@meta.com>
Subject: [PATCH] crypto: pkcs7 - use constant-time digest comparison
Date: Sat, 31 Jan 2026 19:55:03 -0800
Message-ID: <20260201035503.3945067-1-hodgesd@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAxMDAzMiBTYWx0ZWRfX5lEQJ0nLpwWp
 VJvN8sp8oUe4lbicv90Al/Mo2yNwN1aKCtufrExGsf5ZqyQp8a/DqsqYkpkFloMwa+bv6o3MGxj
 0kIvQyVmTW3oSDc9A6wyhbR9tmgxxX/hEjWT7xELvb0kI+zz0BOLmfLhzv0d1JezX6WLFPiHv9e
 9gHlotHOp7TNeeVkFh2vRouJBzwnPe16amvrK35ox59ZZdOAeonA9LgFiNLGrates3N32gIjSGP
 oCMMmY233Ud5EiO3gx26atBTQvB7V5rpBmruEJ5RbrIulxPLozfiM3ruVt1U40hztkVakkAIM8m
 7ZpKawRl0hrofUiooPywKCsH24o2VrqAdkcFYqeIBNnMhkrqizUhKUG2+g00ohn/jPMDV9xQiKf
 pFczjAG5f2080rqDp7hAouWlFA25vbvA9BoZ/Egm041CAoKHEgRlpTmqpCT/64QJ/HUcgWp7MD2
 8dizv/3XsK0bwWc8PjQ==
X-Proofpoint-ORIG-GUID: W_airIDr0tx88UkbddvKJWTZGKmnG6Fs
X-Authority-Analysis: v=2.4 cv=BLu+bVQG c=1 sm=1 tr=0 ts=697ecea7 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VabnemYjAAAA:8 a=20KFwNOVAAAA:8
 a=ucDApK5nfv-_8VxgTh4A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: W_airIDr0tx88UkbddvKJWTZGKmnG6Fs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-01_01,2026-01-30_04,2025-10-01_01

Replace memcmp() with crypto_memneq() when comparing message digests
during PKCS#7 signature verification.

memcmp() is not constant-time and returns early on the first byte
mismatch. This creates a timing side-channel that could allow an
attacker to forge valid signatures by measuring verification time
and recovering the expected digest value byte-by-byte.

crypto_memneq() performs a constant-time comparison, eliminating
the timing oracle.

This affects all users of PKCS#7 signature verification including:
 - Kernel module signature verification (CONFIG_MODULE_SIG)
 - Firmware signature verification
 - Kexec image signature verification
 - IMA appraisal

Fixes: 9f0d33146e2a ("PKCS#7: Digest the data in a signed-data message")
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_ke=
ys/pkcs7_verify.c
index 6d6475e3a9bf..c69cd240bd7e 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -4,20 +4,21 @@
  * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  */
=20
 #define pr_fmt(fmt) "PKCS7: "fmt
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/asn1.h>
+#include <crypto/utils.h>
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
 #include <crypto/public_key.h>
 #include "pkcs7_parser.h"
=20
 /*
  * Digest the relevant parts of the PKCS#7 data
  */
 static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			struct pkcs7_signed_info *sinfo)
@@ -78,22 +79,22 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			goto error;
 		}
=20
 		if (sinfo->msgdigest_len !=3D sig->digest_size) {
 			pr_warn("Sig %u: Invalid digest size (%u)\n",
 				sinfo->index, sinfo->msgdigest_len);
 			ret =3D -EBADMSG;
 			goto error;
 		}
=20
-		if (memcmp(sig->digest, sinfo->msgdigest,
-			   sinfo->msgdigest_len) !=3D 0) {
+		if (crypto_memneq(sig->digest, sinfo->msgdigest,
+				  sinfo->msgdigest_len)) {
 			pr_warn("Sig %u: Message digest doesn't match\n",
 				sinfo->index);
 			ret =3D -EKEYREJECTED;
 			goto error;
 		}
=20
 		/* We then calculate anew, using the authenticated attributes
 		 * as the contents of the digest instead.  Note that we need to
 		 * convert the attributes from a CONT.0 into a SET before we
 		 * hash it.
--=20
2.47.3

