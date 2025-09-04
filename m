Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D774228150A;
	Thu,  4 Sep 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001340; cv=none; b=jTEERqroQKPk9w5BvZ78TjBEg12IFe6Daoggcj7bss2YSAmt1KmvaXOkW3rY8k6LCZ+hNBa7kP7+M4OaV0vLR2ZXTtm2ygCxiv2rh3R9a4ZnqzZ/ugYPaJH1RxMiZVmsDu6Z2/UtcQWPEx1DL/xsnlAJGFTjZ0nDrb+5+VFWrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001340; c=relaxed/simple;
	bh=ssTs8u/Ft3vHFLoH91wA5CuPYIuRe8S9etsV7jUBwuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mLhDYFDobrIVwJvPesPzYjlAt8eR51QmWuJTLAHg04ChlOxpcmLK8CWNmYvI/EARBbkD82YPhXctBHZ0XO3nsaHH1l9/IH2DlHdUNtSOjRCR7TeY2XWNwPAiWb//aX2ryfXsQt4kgOZPgCr8hGRr4qX8by9TORdqGNhiL/fh5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=la7kpfMU; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="la7kpfMU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fk4Xx006697;
	Thu, 4 Sep 2025 15:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=v92fQ
	JAX3c3QLypWGkL7xA0bX40waTou9VBWkKDkE+E=; b=la7kpfMUx584nd4OkEuzU
	NYv6vcb/yICG2Gien1Y260hdgZ+iSJ/LpAUZ9t4GILRSodC8U+kwwxTB5yBtgLUG
	pSKNckRiECYCVAF9Kux9knD6FR0Qy4j91A8kczTmOZ6stCWFrtJ9x4d3+o2pOybH
	s74aJzLrH3KFz43Fo4q82IXZ5LZBrcmPMk/oF1jUAe6EQvMhSVUAquVAO7Bkp7z8
	/qcxbvTaJWErZWpItsEU9xuv9s9b+tGIHraW6pdHIbB4Ma61YE/OcJdkB+6LWUPH
	ALWqyn99ZkMB9LsT79Ms0nJHnNsze5w8T748UvRmgzdBolghz5pAhRtSgNpFvS6a
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd01yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FQ1YE040081;
	Thu, 4 Sep 2025 15:55:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtm3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4w000707;
	Thu, 4 Sep 2025 15:55:24 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-7;
	Thu, 04 Sep 2025 15:55:24 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Vijaykumar Hegde <vijaykumar.hegde@oracle.com>,
        Sriharsha Yadagudde <sriharsha.devdas@oracle.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH RFC 006/104] KEYS: trusted: eat -ENOENT from the crypto API
Date: Thu,  4 Sep 2025 17:50:38 +0200
Message-Id: <20250904155216.460962-7-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX0k9/anH3iohw
 pfprgFr6s2up8R0Txvu9U76rfbLZtC7VH44Pv1d6jsly+TNPMuLc4sqzzWTCC+UDDgDkw9Lmp/Z
 6QBXUMj0FwEIJ9w7cricWrL+Gl2p8rzno1tDQ0Ye2Z8CGLivejoSBwfVzdAeqTgQmpXWTJ2C423
 g7IAyPk/0Eokask0ta1XyOzPg3OkqNqButfLRg217qy/EDMi6QT1RzGGKXtrM3b2ufHUzE94fjJ
 YqRvs5m91FdjO1G4jO4T+Ke8zCSXAR9HEU6+C7q1tm0xHKMNf9xZviILNcEf9LVhHmHYquBmoBo
 P0BDrxJ4fZexTXpmqOrLXmkGCwLpe4EAAcrw9il0/G+CkPyBY0Dsqgr8QHj4bWI1GYoT4hmWiD5
 JVWfVkl2b/4595I/haUz+4TsIS3B/A==
X-Proofpoint-GUID: rsNx-o0acR0QKGTJeP503egy0sHfNTL2
X-Proofpoint-ORIG-GUID: rsNx-o0acR0QKGTJeP503egy0sHfNTL2
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b66e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=KKAkSRfTAAAA:8 a=FNyBlpCuAAAA:8 a=Z4Rwk6OoAAAA:8 a=Bx8krx5fFIaEeihWbnsA:9
 a=cvBusfyB2V15izCimMoJ:22 a=RlW-AWeGUCXs_Nkyno-6:22 a=HkZW87K1Qel5hWWM3VKY:22
 cc=ntf awl=host:12068

If we have a config with:

CONFIG_TRUSTED_KEYS=m
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_DM_CRYPT=m

then dm-crypt.ko will depend on trusted.ko (due to using the exported
symbol 'key_type_trusted'), meaning trusted.ko will need to successfully
load before dm-crypt.ko can load.

However, since commit 9d50a25eeb05c ("crypto: testmgr - desupport SHA-1
for FIPS 140") when booting with fips=1, the SHA-1 algorithm (or anything
that uses it, like HMAC-SHA-1) will be unavailable.

security/keys/trusted-keys/trusted_tpm1.c is hard-coded to use SHA-1 and
will fail with -ENOENT when attempting to initialize the hash instance
using the crypto API _if_ the hardware is available. This in turn causes
the entire trusted.ko to fail to load.

(If TPM1 hardware is not available, trusted_tpm1.c will fail to load with
-ENODEV, which is handled in init_trusted() to allow the module to load
anyway.)

Long story short, having TPM1 hardware and booting with fips=1 will cause
dm-crypt to fail loading, even though SHA-1 may not actually be used or
needed at any point.

There's already some history of fiddling with the module init/exit code
and the return values here, but I think we can simplify the code somewhat:

- return immediately on success; there is no point in breaking out of the
  loop and rechecking the return value

- return immediately on non-ENODEV/ENOENT errors; again, no point in
  rechecking the return value

We could even consider retrying other trusted key sources regardless of
the exact error value, but that would change the semantics too much for
my comfort here.

Reported-by: Vijaykumar Hegde <vijaykumar.hegde@oracle.com>
Reported-by: Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
Fixes: 9d50a25eeb05c ("crypto: testmgr - desupport SHA-1 for FIPS 140")
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/linux-integrity/CAHk-=whOPoLaWM8S8GgoOPT7a2+nMH5h3TLKtn=R_3w4R1_Uvg@mail.gmail.com/
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 security/keys/trusted-keys/trusted_core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index e2d9644efde1..152832735bac 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -370,20 +370,22 @@ static int __init init_trusted(void)
 
 			trusted_key_exit = trusted_key_sources[i].ops->exit;
 			migratable = trusted_key_sources[i].ops->migratable;
+			return 0;
 		}
 
-		if (!ret || ret != -ENODEV)
-			break;
+		/*
+		 * The crypto API returns -ENOENT if it doesn't support a
+		 * given hashing algorithm (e.g. SHA1 in FIPS mode).
+		 */
+		if (ret != -ENODEV && ret != -ENOENT)
+			return ret;
 	}
 
 	/*
-	 * encrypted_keys.ko depends on successful load of this module even if
-	 * trusted key implementation is not found.
+	 * encrypted_keys.ko and dm-crypt depend on successful load of
+	 * this module even if trusted key implementation is not found.
 	 */
-	if (ret == -ENODEV)
-		return 0;
-
-	return ret;
+	return 0;
 }
 
 static void __exit cleanup_trusted(void)
-- 
2.39.3

