Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7668726C399;
	Thu,  4 Sep 2025 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001715; cv=none; b=lu2S0YIQ759U1cMe9XKpyBuIUTGWB5slCClbmbwyPc+EyYHbg5MSVB05QWdg+hwvTspprqFZtIDrM1Dad9vzpUGUCrQt6SO50lmtlUdTP41fXcQQay/gSoMcq0YAnhTdSV1YYtr/mlxitHWSF6sE+PmTMEiI8TQFjh6fKuHXPXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001715; c=relaxed/simple;
	bh=ZDJI/EgqtcW5yoTrC6ejNQ3yCHl1nmc++wpX/avirdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C9A4mRtWAdzZCs6U4lkkLHhzAhc4V6Ph2H4IwM/4VU9f/TqXcn4DHea4lUeKF1BcvC14aRWi+mOg9JuCjv9J91POKFj4WxpcbmAZIQeSWy78y/Gzggcb/IXNCfkmd9ODrj40qNsxBtvHMQ2PLbZvu+IcggxuKl0thHcrDMpvCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MYs36UvA; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MYs36UvA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftpct027797;
	Thu, 4 Sep 2025 16:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=j3jD/
	4ruMVwWhDMiQeDDPSS/Sw77P/CteKg3xHoEfb0=; b=MYs36UvAyVD5HsNz1fxO/
	vTfwsItWDtZZrufoGjpX0mhs11fjjW2bsUhbus0QlzDqEfkw8TZLvqLdC9Zq4yYp
	p1VgIpv7WVRq83ln2p4jjoLxaNuQ9gUz4/1QBDmwKF46j7/tHzeWFbshH18i0iiv
	DXQ9B3ooCWhWDG1RX0WV8ElYKZHvTYmz8UaALsO2OuBU2tA//2QqXE8DavuYLL49
	KVjk9gmTJMz+K79CLaqREqariTPkdMJfRlFUyeDenioWYTxZEtYs2IQz1g2ITXpo
	1UcxODUlsn/qEdxoIauAeUbFIKVfD6qIe6yyEkUcc1jQU6z4EKegG9Qxyq+sPTS/
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn07ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F7Qr6040109;
	Thu, 4 Sep 2025 16:01:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx86000707;
	Thu, 4 Sep 2025 16:01:29 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-100;
	Thu, 04 Sep 2025 16:01:28 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 099/104] crypto: fips140: add symlinks to kernel sources
Date: Thu,  4 Sep 2025 17:52:11 +0200
Message-Id: <20250904155216.460962-100-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b7dc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=yBohC7TJVOe54JvZ9MgA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: wclKAjm1_nA5hm79X5XXp7jzPpIxBIvt
X-Proofpoint-ORIG-GUID: wclKAjm1_nA5hm79X5XXp7jzPpIxBIvt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX3fzqFiL3kGiK
 /EYFU0SjuHNsi7+MJKT/Av4Awhq/sIDsEpTY1vUKi2PoYreMpNUusY3Np57zM7ITw1bsA9lRz3H
 /6mEc6JE8mdQAnH1BtdiuS7J5CQeTEm+hj2AoK2GVFMir0YoSrtcJoFfDu2dyQ6qtGrZccKzC4O
 SF2l+lL3eBFc8xVQqiJcSFcxd4WG7EUmGxNnjtGrw7o7fCuFWVkidqSuavwm9ZV+8WeKaX9vIVz
 FfqYPCEppbczqgADU+JNMwTmnvdaPtEKX2iITOrI3kwl0NBCYaoUD/DogXbgiRvRyo3hHoNS3Tt
 287PxHH+VvmWoNGEw3yA9d/kPDdCpAax1KD/HFnXISSGuYl6GhT2RmDLUh5HW5SOukWi5AY5TU8
 5Er2auqzrpxpDeLzJJQzTlcO18/4bw==

In order to minimize source code duplication, we symlink all files under
fips140/ to their top-level source tree equivalents, e.g.:

  fips140/crypto/api.c -> crypto/api.c

We're going to build these files as an out-of-tree module (with
-DFIPS_MODULE=1).

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fips140/crypto/aead.c                             | 1 +
 fips140/crypto/aes_generic.c                      | 1 +
 fips140/crypto/ahash.c                            | 1 +
 fips140/crypto/akcipher.c                         | 1 +
 fips140/crypto/algapi.c                           | 1 +
 fips140/crypto/algboss.c                          | 1 +
 fips140/crypto/api.c                              | 1 +
 fips140/crypto/asymmetric_keys/asymmetric_keys.h  | 1 +
 fips140/crypto/asymmetric_keys/asymmetric_type.c  | 1 +
 fips140/crypto/asymmetric_keys/mscode_parser.c    | 1 +
 fips140/crypto/asymmetric_keys/pkcs7.asn1         | 1 +
 fips140/crypto/asymmetric_keys/pkcs7_key_type.c   | 1 +
 fips140/crypto/asymmetric_keys/pkcs7_parser.c     | 1 +
 fips140/crypto/asymmetric_keys/pkcs7_parser.h     | 1 +
 fips140/crypto/asymmetric_keys/pkcs7_trust.c      | 1 +
 fips140/crypto/asymmetric_keys/pkcs7_verify.c     | 1 +
 fips140/crypto/asymmetric_keys/pkcs8.asn1         | 1 +
 fips140/crypto/asymmetric_keys/pkcs8_parser.c     | 1 +
 fips140/crypto/asymmetric_keys/public_key.c       | 1 +
 fips140/crypto/asymmetric_keys/restrict.c         | 1 +
 fips140/crypto/asymmetric_keys/selftest.c         | 1 +
 fips140/crypto/asymmetric_keys/selftest.h         | 1 +
 fips140/crypto/asymmetric_keys/selftest_ecdsa.c   | 1 +
 fips140/crypto/asymmetric_keys/selftest_rsa.c     | 1 +
 fips140/crypto/asymmetric_keys/signature.c        | 1 +
 fips140/crypto/asymmetric_keys/verify_pefile.c    | 1 +
 fips140/crypto/asymmetric_keys/verify_pefile.h    | 1 +
 fips140/crypto/asymmetric_keys/x509.asn1          | 1 +
 fips140/crypto/asymmetric_keys/x509_akid.asn1     | 1 +
 fips140/crypto/asymmetric_keys/x509_cert_parser.c | 1 +
 fips140/crypto/asymmetric_keys/x509_loader.c      | 1 +
 fips140/crypto/asymmetric_keys/x509_parser.h      | 1 +
 fips140/crypto/asymmetric_keys/x509_public_key.c  | 1 +
 fips140/crypto/authenc.c                          | 1 +
 fips140/crypto/authencesn.c                       | 1 +
 fips140/crypto/cbc.c                              | 1 +
 fips140/crypto/ccm.c                              | 1 +
 fips140/crypto/cipher.c                           | 1 +
 fips140/crypto/cmac.c                             | 1 +
 fips140/crypto/cryptd.c                           | 1 +
 fips140/crypto/ctr.c                              | 1 +
 fips140/crypto/dh.c                               | 1 +
 fips140/crypto/dh_helper.c                        | 1 +
 fips140/crypto/drbg.c                             | 1 +
 fips140/crypto/ecb.c                              | 1 +
 fips140/crypto/ecc.c                              | 1 +
 fips140/crypto/ecc_curve_defs.h                   | 1 +
 fips140/crypto/ecdh.c                             | 1 +
 fips140/crypto/ecdh_helper.c                      | 1 +
 fips140/crypto/ecdsa-p1363.c                      | 1 +
 fips140/crypto/ecdsa-x962.c                       | 1 +
 fips140/crypto/ecdsa.c                            | 1 +
 fips140/crypto/ecdsasignature.asn1                | 1 +
 fips140/crypto/echainiv.c                         | 1 +
 fips140/crypto/essiv.c                            | 1 +
 fips140/crypto/gcm.c                              | 1 +
 fips140/crypto/geniv.c                            | 1 +
 fips140/crypto/ghash-generic.c                    | 1 +
 fips140/crypto/hash.h                             | 1 +
 fips140/crypto/hmac.c                             | 1 +
 fips140/crypto/internal.h                         | 1 +
 fips140/crypto/jitterentropy-kcapi.c              | 1 +
 fips140/crypto/jitterentropy.c                    | 1 +
 fips140/crypto/jitterentropy.h                    | 1 +
 fips140/crypto/kpp.c                              | 1 +
 fips140/crypto/lskcipher.c                        | 1 +
 fips140/crypto/pcrypt.c                           | 1 +
 fips140/crypto/proc.c                             | 1 +
 fips140/crypto/rng.c                              | 1 +
 fips140/crypto/rsa-pkcs1pad.c                     | 1 +
 fips140/crypto/rsa.c                              | 1 +
 fips140/crypto/rsa_helper.c                       | 1 +
 fips140/crypto/rsaprivkey.asn1                    | 1 +
 fips140/crypto/rsapubkey.asn1                     | 1 +
 fips140/crypto/rsassa-pkcs1.c                     | 1 +
 fips140/crypto/seqiv.c                            | 1 +
 fips140/crypto/sha256.c                           | 1 +
 fips140/crypto/sha3_generic.c                     | 1 +
 fips140/crypto/sha512.c                           | 1 +
 fips140/crypto/shash.c                            | 1 +
 fips140/crypto/sig.c                              | 1 +
 fips140/crypto/simd.c                             | 1 +
 fips140/crypto/skcipher.c                         | 1 +
 fips140/crypto/skcipher.h                         | 1 +
 fips140/crypto/tcrypt.c                           | 1 +
 fips140/crypto/tcrypt.h                           | 1 +
 fips140/crypto/testmgr.c                          | 1 +
 fips140/crypto/testmgr.h                          | 1 +
 fips140/crypto/xts.c                              | 1 +
 fips140/lib/crypto/aes.c                          | 1 +
 fips140/lib/crypto/aesgcm.c                       | 1 +
 fips140/lib/crypto/gf128mul.c                     | 1 +
 fips140/lib/crypto/memneq.c                       | 1 +
 fips140/lib/crypto/sha256.c                       | 1 +
 fips140/lib/crypto/sha512.c                       | 1 +
 fips140/lib/crypto/utils.c                        | 1 +
 96 files changed, 96 insertions(+)
 create mode 120000 fips140/crypto/aead.c
 create mode 120000 fips140/crypto/aes_generic.c
 create mode 120000 fips140/crypto/ahash.c
 create mode 120000 fips140/crypto/akcipher.c
 create mode 120000 fips140/crypto/algapi.c
 create mode 120000 fips140/crypto/algboss.c
 create mode 120000 fips140/crypto/api.c
 create mode 120000 fips140/crypto/asymmetric_keys/asymmetric_keys.h
 create mode 120000 fips140/crypto/asymmetric_keys/asymmetric_type.c
 create mode 120000 fips140/crypto/asymmetric_keys/mscode_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_key_type.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_parser.h
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_trust.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_verify.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs8.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs8_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/public_key.c
 create mode 120000 fips140/crypto/asymmetric_keys/restrict.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest.h
 create mode 120000 fips140/crypto/asymmetric_keys/selftest_ecdsa.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest_rsa.c
 create mode 120000 fips140/crypto/asymmetric_keys/signature.c
 create mode 120000 fips140/crypto/asymmetric_keys/verify_pefile.c
 create mode 120000 fips140/crypto/asymmetric_keys/verify_pefile.h
 create mode 120000 fips140/crypto/asymmetric_keys/x509.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/x509_akid.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/x509_cert_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/x509_loader.c
 create mode 120000 fips140/crypto/asymmetric_keys/x509_parser.h
 create mode 120000 fips140/crypto/asymmetric_keys/x509_public_key.c
 create mode 120000 fips140/crypto/authenc.c
 create mode 120000 fips140/crypto/authencesn.c
 create mode 120000 fips140/crypto/cbc.c
 create mode 120000 fips140/crypto/ccm.c
 create mode 120000 fips140/crypto/cipher.c
 create mode 120000 fips140/crypto/cmac.c
 create mode 120000 fips140/crypto/cryptd.c
 create mode 120000 fips140/crypto/ctr.c
 create mode 120000 fips140/crypto/dh.c
 create mode 120000 fips140/crypto/dh_helper.c
 create mode 120000 fips140/crypto/drbg.c
 create mode 120000 fips140/crypto/ecb.c
 create mode 120000 fips140/crypto/ecc.c
 create mode 120000 fips140/crypto/ecc_curve_defs.h
 create mode 120000 fips140/crypto/ecdh.c
 create mode 120000 fips140/crypto/ecdh_helper.c
 create mode 120000 fips140/crypto/ecdsa-p1363.c
 create mode 120000 fips140/crypto/ecdsa-x962.c
 create mode 120000 fips140/crypto/ecdsa.c
 create mode 120000 fips140/crypto/ecdsasignature.asn1
 create mode 120000 fips140/crypto/echainiv.c
 create mode 120000 fips140/crypto/essiv.c
 create mode 120000 fips140/crypto/gcm.c
 create mode 120000 fips140/crypto/geniv.c
 create mode 120000 fips140/crypto/ghash-generic.c
 create mode 120000 fips140/crypto/hash.h
 create mode 120000 fips140/crypto/hmac.c
 create mode 120000 fips140/crypto/internal.h
 create mode 120000 fips140/crypto/jitterentropy-kcapi.c
 create mode 120000 fips140/crypto/jitterentropy.c
 create mode 120000 fips140/crypto/jitterentropy.h
 create mode 120000 fips140/crypto/kpp.c
 create mode 120000 fips140/crypto/lskcipher.c
 create mode 120000 fips140/crypto/pcrypt.c
 create mode 120000 fips140/crypto/proc.c
 create mode 120000 fips140/crypto/rng.c
 create mode 120000 fips140/crypto/rsa-pkcs1pad.c
 create mode 120000 fips140/crypto/rsa.c
 create mode 120000 fips140/crypto/rsa_helper.c
 create mode 120000 fips140/crypto/rsaprivkey.asn1
 create mode 120000 fips140/crypto/rsapubkey.asn1
 create mode 120000 fips140/crypto/rsassa-pkcs1.c
 create mode 120000 fips140/crypto/seqiv.c
 create mode 120000 fips140/crypto/sha256.c
 create mode 120000 fips140/crypto/sha3_generic.c
 create mode 120000 fips140/crypto/sha512.c
 create mode 120000 fips140/crypto/shash.c
 create mode 120000 fips140/crypto/sig.c
 create mode 120000 fips140/crypto/simd.c
 create mode 120000 fips140/crypto/skcipher.c
 create mode 120000 fips140/crypto/skcipher.h
 create mode 120000 fips140/crypto/tcrypt.c
 create mode 120000 fips140/crypto/tcrypt.h
 create mode 120000 fips140/crypto/testmgr.c
 create mode 120000 fips140/crypto/testmgr.h
 create mode 120000 fips140/crypto/xts.c
 create mode 120000 fips140/lib/crypto/aes.c
 create mode 120000 fips140/lib/crypto/aesgcm.c
 create mode 120000 fips140/lib/crypto/gf128mul.c
 create mode 120000 fips140/lib/crypto/memneq.c
 create mode 120000 fips140/lib/crypto/sha256.c
 create mode 120000 fips140/lib/crypto/sha512.c
 create mode 120000 fips140/lib/crypto/utils.c

diff --git a/fips140/crypto/aead.c b/fips140/crypto/aead.c
new file mode 120000
index 000000000000..212e18356521
--- /dev/null
+++ b/fips140/crypto/aead.c
@@ -0,0 +1 @@
+../../crypto/aead.c
\ No newline at end of file
diff --git a/fips140/crypto/aes_generic.c b/fips140/crypto/aes_generic.c
new file mode 120000
index 000000000000..98deccd59067
--- /dev/null
+++ b/fips140/crypto/aes_generic.c
@@ -0,0 +1 @@
+../../crypto/aes_generic.c
\ No newline at end of file
diff --git a/fips140/crypto/ahash.c b/fips140/crypto/ahash.c
new file mode 120000
index 000000000000..81e1d69b51b3
--- /dev/null
+++ b/fips140/crypto/ahash.c
@@ -0,0 +1 @@
+../../crypto/ahash.c
\ No newline at end of file
diff --git a/fips140/crypto/akcipher.c b/fips140/crypto/akcipher.c
new file mode 120000
index 000000000000..66a618824b92
--- /dev/null
+++ b/fips140/crypto/akcipher.c
@@ -0,0 +1 @@
+../../crypto/akcipher.c
\ No newline at end of file
diff --git a/fips140/crypto/algapi.c b/fips140/crypto/algapi.c
new file mode 120000
index 000000000000..31fc6b4fb765
--- /dev/null
+++ b/fips140/crypto/algapi.c
@@ -0,0 +1 @@
+../../crypto/algapi.c
\ No newline at end of file
diff --git a/fips140/crypto/algboss.c b/fips140/crypto/algboss.c
new file mode 120000
index 000000000000..e27142d777f7
--- /dev/null
+++ b/fips140/crypto/algboss.c
@@ -0,0 +1 @@
+../../crypto/algboss.c
\ No newline at end of file
diff --git a/fips140/crypto/api.c b/fips140/crypto/api.c
new file mode 120000
index 000000000000..7c60a1d33673
--- /dev/null
+++ b/fips140/crypto/api.c
@@ -0,0 +1 @@
+../../crypto/api.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/asymmetric_keys.h b/fips140/crypto/asymmetric_keys/asymmetric_keys.h
new file mode 120000
index 000000000000..16867d35838f
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/asymmetric_keys.h
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/asymmetric_keys.h
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/asymmetric_type.c b/fips140/crypto/asymmetric_keys/asymmetric_type.c
new file mode 120000
index 000000000000..9f9119a13078
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/asymmetric_type.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/asymmetric_type.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/mscode_parser.c b/fips140/crypto/asymmetric_keys/mscode_parser.c
new file mode 120000
index 000000000000..fc2e5ba2b6ba
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/mscode_parser.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/mscode_parser.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7.asn1 b/fips140/crypto/asymmetric_keys/pkcs7.asn1
new file mode 120000
index 000000000000..c05196a6916d
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7.asn1
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7.asn1
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7_key_type.c b/fips140/crypto/asymmetric_keys/pkcs7_key_type.c
new file mode 120000
index 000000000000..1483042a2f94
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7_key_type.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7_parser.c b/fips140/crypto/asymmetric_keys/pkcs7_parser.c
new file mode 120000
index 000000000000..fadba19812d9
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7_parser.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7_parser.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7_parser.h b/fips140/crypto/asymmetric_keys/pkcs7_parser.h
new file mode 120000
index 000000000000..a002feec14a9
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7_parser.h
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7_parser.h
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7_trust.c b/fips140/crypto/asymmetric_keys/pkcs7_trust.c
new file mode 120000
index 000000000000..bc319e2fa53f
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7_trust.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7_trust.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs7_verify.c b/fips140/crypto/asymmetric_keys/pkcs7_verify.c
new file mode 120000
index 000000000000..e973804a9fd5
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs7_verify.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs7_verify.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs8.asn1 b/fips140/crypto/asymmetric_keys/pkcs8.asn1
new file mode 120000
index 000000000000..c8696cd8abc9
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs8.asn1
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs8.asn1
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/pkcs8_parser.c b/fips140/crypto/asymmetric_keys/pkcs8_parser.c
new file mode 120000
index 000000000000..4549c6abdca6
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/pkcs8_parser.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/pkcs8_parser.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/public_key.c b/fips140/crypto/asymmetric_keys/public_key.c
new file mode 120000
index 000000000000..8095065156ab
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/public_key.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/public_key.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/restrict.c b/fips140/crypto/asymmetric_keys/restrict.c
new file mode 120000
index 000000000000..78d8775f18c6
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/restrict.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/restrict.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/selftest.c b/fips140/crypto/asymmetric_keys/selftest.c
new file mode 120000
index 000000000000..634ea04a70ac
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/selftest.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/selftest.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/selftest.h b/fips140/crypto/asymmetric_keys/selftest.h
new file mode 120000
index 000000000000..3a769362b7ca
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/selftest.h
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/selftest.h
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/selftest_ecdsa.c b/fips140/crypto/asymmetric_keys/selftest_ecdsa.c
new file mode 120000
index 000000000000..efaeb42740a9
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/selftest_ecdsa.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/selftest_ecdsa.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/selftest_rsa.c b/fips140/crypto/asymmetric_keys/selftest_rsa.c
new file mode 120000
index 000000000000..d6418f82a81b
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/selftest_rsa.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/selftest_rsa.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/signature.c b/fips140/crypto/asymmetric_keys/signature.c
new file mode 120000
index 000000000000..415c34d1e33b
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/signature.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/signature.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/verify_pefile.c b/fips140/crypto/asymmetric_keys/verify_pefile.c
new file mode 120000
index 000000000000..9b7153555f36
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/verify_pefile.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/verify_pefile.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/verify_pefile.h b/fips140/crypto/asymmetric_keys/verify_pefile.h
new file mode 120000
index 000000000000..62483171759e
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/verify_pefile.h
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/verify_pefile.h
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509.asn1 b/fips140/crypto/asymmetric_keys/x509.asn1
new file mode 120000
index 000000000000..1aa8edbc2ec4
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509.asn1
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509.asn1
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509_akid.asn1 b/fips140/crypto/asymmetric_keys/x509_akid.asn1
new file mode 120000
index 000000000000..f952c11063f3
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509_akid.asn1
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509_akid.asn1
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509_cert_parser.c b/fips140/crypto/asymmetric_keys/x509_cert_parser.c
new file mode 120000
index 000000000000..a86d71968d3f
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509_cert_parser.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509_cert_parser.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509_loader.c b/fips140/crypto/asymmetric_keys/x509_loader.c
new file mode 120000
index 000000000000..efa9c866d065
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509_loader.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509_loader.c
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509_parser.h b/fips140/crypto/asymmetric_keys/x509_parser.h
new file mode 120000
index 000000000000..cbf61d79a344
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509_parser.h
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509_parser.h
\ No newline at end of file
diff --git a/fips140/crypto/asymmetric_keys/x509_public_key.c b/fips140/crypto/asymmetric_keys/x509_public_key.c
new file mode 120000
index 000000000000..000f40135e91
--- /dev/null
+++ b/fips140/crypto/asymmetric_keys/x509_public_key.c
@@ -0,0 +1 @@
+../../../crypto/asymmetric_keys/x509_public_key.c
\ No newline at end of file
diff --git a/fips140/crypto/authenc.c b/fips140/crypto/authenc.c
new file mode 120000
index 000000000000..21e091ad0815
--- /dev/null
+++ b/fips140/crypto/authenc.c
@@ -0,0 +1 @@
+../../crypto/authenc.c
\ No newline at end of file
diff --git a/fips140/crypto/authencesn.c b/fips140/crypto/authencesn.c
new file mode 120000
index 000000000000..00bb54b7be3f
--- /dev/null
+++ b/fips140/crypto/authencesn.c
@@ -0,0 +1 @@
+../../crypto/authencesn.c
\ No newline at end of file
diff --git a/fips140/crypto/cbc.c b/fips140/crypto/cbc.c
new file mode 120000
index 000000000000..aa1f6fb840c0
--- /dev/null
+++ b/fips140/crypto/cbc.c
@@ -0,0 +1 @@
+../../crypto/cbc.c
\ No newline at end of file
diff --git a/fips140/crypto/ccm.c b/fips140/crypto/ccm.c
new file mode 120000
index 000000000000..879bd39b8843
--- /dev/null
+++ b/fips140/crypto/ccm.c
@@ -0,0 +1 @@
+../../crypto/ccm.c
\ No newline at end of file
diff --git a/fips140/crypto/cipher.c b/fips140/crypto/cipher.c
new file mode 120000
index 000000000000..53fd49f62385
--- /dev/null
+++ b/fips140/crypto/cipher.c
@@ -0,0 +1 @@
+../../crypto/cipher.c
\ No newline at end of file
diff --git a/fips140/crypto/cmac.c b/fips140/crypto/cmac.c
new file mode 120000
index 000000000000..da6195375be2
--- /dev/null
+++ b/fips140/crypto/cmac.c
@@ -0,0 +1 @@
+../../crypto/cmac.c
\ No newline at end of file
diff --git a/fips140/crypto/cryptd.c b/fips140/crypto/cryptd.c
new file mode 120000
index 000000000000..b18b260ec57d
--- /dev/null
+++ b/fips140/crypto/cryptd.c
@@ -0,0 +1 @@
+../../crypto/cryptd.c
\ No newline at end of file
diff --git a/fips140/crypto/ctr.c b/fips140/crypto/ctr.c
new file mode 120000
index 000000000000..3fe3cc809347
--- /dev/null
+++ b/fips140/crypto/ctr.c
@@ -0,0 +1 @@
+../../crypto/ctr.c
\ No newline at end of file
diff --git a/fips140/crypto/dh.c b/fips140/crypto/dh.c
new file mode 120000
index 000000000000..2052a9ead300
--- /dev/null
+++ b/fips140/crypto/dh.c
@@ -0,0 +1 @@
+../../crypto/dh.c
\ No newline at end of file
diff --git a/fips140/crypto/dh_helper.c b/fips140/crypto/dh_helper.c
new file mode 120000
index 000000000000..c14488c38829
--- /dev/null
+++ b/fips140/crypto/dh_helper.c
@@ -0,0 +1 @@
+../../crypto/dh_helper.c
\ No newline at end of file
diff --git a/fips140/crypto/drbg.c b/fips140/crypto/drbg.c
new file mode 120000
index 000000000000..7f59714d2569
--- /dev/null
+++ b/fips140/crypto/drbg.c
@@ -0,0 +1 @@
+../../crypto/drbg.c
\ No newline at end of file
diff --git a/fips140/crypto/ecb.c b/fips140/crypto/ecb.c
new file mode 120000
index 000000000000..3fc2a39f7569
--- /dev/null
+++ b/fips140/crypto/ecb.c
@@ -0,0 +1 @@
+../../crypto/ecb.c
\ No newline at end of file
diff --git a/fips140/crypto/ecc.c b/fips140/crypto/ecc.c
new file mode 120000
index 000000000000..45a59d048f04
--- /dev/null
+++ b/fips140/crypto/ecc.c
@@ -0,0 +1 @@
+../../crypto/ecc.c
\ No newline at end of file
diff --git a/fips140/crypto/ecc_curve_defs.h b/fips140/crypto/ecc_curve_defs.h
new file mode 120000
index 000000000000..7a065529702f
--- /dev/null
+++ b/fips140/crypto/ecc_curve_defs.h
@@ -0,0 +1 @@
+../../crypto/ecc_curve_defs.h
\ No newline at end of file
diff --git a/fips140/crypto/ecdh.c b/fips140/crypto/ecdh.c
new file mode 120000
index 000000000000..c82cae9a6272
--- /dev/null
+++ b/fips140/crypto/ecdh.c
@@ -0,0 +1 @@
+../../crypto/ecdh.c
\ No newline at end of file
diff --git a/fips140/crypto/ecdh_helper.c b/fips140/crypto/ecdh_helper.c
new file mode 120000
index 000000000000..a37954e0aa04
--- /dev/null
+++ b/fips140/crypto/ecdh_helper.c
@@ -0,0 +1 @@
+../../crypto/ecdh_helper.c
\ No newline at end of file
diff --git a/fips140/crypto/ecdsa-p1363.c b/fips140/crypto/ecdsa-p1363.c
new file mode 120000
index 000000000000..5795bc88ebaf
--- /dev/null
+++ b/fips140/crypto/ecdsa-p1363.c
@@ -0,0 +1 @@
+../../crypto/ecdsa-p1363.c
\ No newline at end of file
diff --git a/fips140/crypto/ecdsa-x962.c b/fips140/crypto/ecdsa-x962.c
new file mode 120000
index 000000000000..e0cf7c741683
--- /dev/null
+++ b/fips140/crypto/ecdsa-x962.c
@@ -0,0 +1 @@
+../../crypto/ecdsa-x962.c
\ No newline at end of file
diff --git a/fips140/crypto/ecdsa.c b/fips140/crypto/ecdsa.c
new file mode 120000
index 000000000000..b9bf37d37397
--- /dev/null
+++ b/fips140/crypto/ecdsa.c
@@ -0,0 +1 @@
+../../crypto/ecdsa.c
\ No newline at end of file
diff --git a/fips140/crypto/ecdsasignature.asn1 b/fips140/crypto/ecdsasignature.asn1
new file mode 120000
index 000000000000..7fa5850233fc
--- /dev/null
+++ b/fips140/crypto/ecdsasignature.asn1
@@ -0,0 +1 @@
+../../crypto/ecdsasignature.asn1
\ No newline at end of file
diff --git a/fips140/crypto/echainiv.c b/fips140/crypto/echainiv.c
new file mode 120000
index 000000000000..fee662c9a8d0
--- /dev/null
+++ b/fips140/crypto/echainiv.c
@@ -0,0 +1 @@
+../../crypto/echainiv.c
\ No newline at end of file
diff --git a/fips140/crypto/essiv.c b/fips140/crypto/essiv.c
new file mode 120000
index 000000000000..6554857abd79
--- /dev/null
+++ b/fips140/crypto/essiv.c
@@ -0,0 +1 @@
+../../crypto/essiv.c
\ No newline at end of file
diff --git a/fips140/crypto/gcm.c b/fips140/crypto/gcm.c
new file mode 120000
index 000000000000..b8ef945a7444
--- /dev/null
+++ b/fips140/crypto/gcm.c
@@ -0,0 +1 @@
+../../crypto/gcm.c
\ No newline at end of file
diff --git a/fips140/crypto/geniv.c b/fips140/crypto/geniv.c
new file mode 120000
index 000000000000..059afe3c124c
--- /dev/null
+++ b/fips140/crypto/geniv.c
@@ -0,0 +1 @@
+../../crypto/geniv.c
\ No newline at end of file
diff --git a/fips140/crypto/ghash-generic.c b/fips140/crypto/ghash-generic.c
new file mode 120000
index 000000000000..ebb7c8aee335
--- /dev/null
+++ b/fips140/crypto/ghash-generic.c
@@ -0,0 +1 @@
+../../crypto/ghash-generic.c
\ No newline at end of file
diff --git a/fips140/crypto/hash.h b/fips140/crypto/hash.h
new file mode 120000
index 000000000000..41ba73037bc9
--- /dev/null
+++ b/fips140/crypto/hash.h
@@ -0,0 +1 @@
+../../crypto/hash.h
\ No newline at end of file
diff --git a/fips140/crypto/hmac.c b/fips140/crypto/hmac.c
new file mode 120000
index 000000000000..162f4c205f1b
--- /dev/null
+++ b/fips140/crypto/hmac.c
@@ -0,0 +1 @@
+../../crypto/hmac.c
\ No newline at end of file
diff --git a/fips140/crypto/internal.h b/fips140/crypto/internal.h
new file mode 120000
index 000000000000..670e77b6a0d6
--- /dev/null
+++ b/fips140/crypto/internal.h
@@ -0,0 +1 @@
+../../crypto/internal.h
\ No newline at end of file
diff --git a/fips140/crypto/jitterentropy-kcapi.c b/fips140/crypto/jitterentropy-kcapi.c
new file mode 120000
index 000000000000..30e13bbd6099
--- /dev/null
+++ b/fips140/crypto/jitterentropy-kcapi.c
@@ -0,0 +1 @@
+../../crypto/jitterentropy-kcapi.c
\ No newline at end of file
diff --git a/fips140/crypto/jitterentropy.c b/fips140/crypto/jitterentropy.c
new file mode 120000
index 000000000000..cb9a117048af
--- /dev/null
+++ b/fips140/crypto/jitterentropy.c
@@ -0,0 +1 @@
+../../crypto/jitterentropy.c
\ No newline at end of file
diff --git a/fips140/crypto/jitterentropy.h b/fips140/crypto/jitterentropy.h
new file mode 120000
index 000000000000..991e4585e6e0
--- /dev/null
+++ b/fips140/crypto/jitterentropy.h
@@ -0,0 +1 @@
+../../crypto/jitterentropy.h
\ No newline at end of file
diff --git a/fips140/crypto/kpp.c b/fips140/crypto/kpp.c
new file mode 120000
index 000000000000..8fbd20de20df
--- /dev/null
+++ b/fips140/crypto/kpp.c
@@ -0,0 +1 @@
+../../crypto/kpp.c
\ No newline at end of file
diff --git a/fips140/crypto/lskcipher.c b/fips140/crypto/lskcipher.c
new file mode 120000
index 000000000000..997c2c0eafb4
--- /dev/null
+++ b/fips140/crypto/lskcipher.c
@@ -0,0 +1 @@
+../../crypto/lskcipher.c
\ No newline at end of file
diff --git a/fips140/crypto/pcrypt.c b/fips140/crypto/pcrypt.c
new file mode 120000
index 000000000000..9ef1ba4b9f66
--- /dev/null
+++ b/fips140/crypto/pcrypt.c
@@ -0,0 +1 @@
+../../crypto/pcrypt.c
\ No newline at end of file
diff --git a/fips140/crypto/proc.c b/fips140/crypto/proc.c
new file mode 120000
index 000000000000..5dfad57a688c
--- /dev/null
+++ b/fips140/crypto/proc.c
@@ -0,0 +1 @@
+../../crypto/proc.c
\ No newline at end of file
diff --git a/fips140/crypto/rng.c b/fips140/crypto/rng.c
new file mode 120000
index 000000000000..2ac107582b56
--- /dev/null
+++ b/fips140/crypto/rng.c
@@ -0,0 +1 @@
+../../crypto/rng.c
\ No newline at end of file
diff --git a/fips140/crypto/rsa-pkcs1pad.c b/fips140/crypto/rsa-pkcs1pad.c
new file mode 120000
index 000000000000..e81ca29bc1c0
--- /dev/null
+++ b/fips140/crypto/rsa-pkcs1pad.c
@@ -0,0 +1 @@
+../../crypto/rsa-pkcs1pad.c
\ No newline at end of file
diff --git a/fips140/crypto/rsa.c b/fips140/crypto/rsa.c
new file mode 120000
index 000000000000..05903a691c9f
--- /dev/null
+++ b/fips140/crypto/rsa.c
@@ -0,0 +1 @@
+../../crypto/rsa.c
\ No newline at end of file
diff --git a/fips140/crypto/rsa_helper.c b/fips140/crypto/rsa_helper.c
new file mode 120000
index 000000000000..ae17e923013c
--- /dev/null
+++ b/fips140/crypto/rsa_helper.c
@@ -0,0 +1 @@
+../../crypto/rsa_helper.c
\ No newline at end of file
diff --git a/fips140/crypto/rsaprivkey.asn1 b/fips140/crypto/rsaprivkey.asn1
new file mode 120000
index 000000000000..c798dadccde5
--- /dev/null
+++ b/fips140/crypto/rsaprivkey.asn1
@@ -0,0 +1 @@
+../../crypto/rsaprivkey.asn1
\ No newline at end of file
diff --git a/fips140/crypto/rsapubkey.asn1 b/fips140/crypto/rsapubkey.asn1
new file mode 120000
index 000000000000..e3bbdd50e4a1
--- /dev/null
+++ b/fips140/crypto/rsapubkey.asn1
@@ -0,0 +1 @@
+../../crypto/rsapubkey.asn1
\ No newline at end of file
diff --git a/fips140/crypto/rsassa-pkcs1.c b/fips140/crypto/rsassa-pkcs1.c
new file mode 120000
index 000000000000..8cb36646c148
--- /dev/null
+++ b/fips140/crypto/rsassa-pkcs1.c
@@ -0,0 +1 @@
+../../crypto/rsassa-pkcs1.c
\ No newline at end of file
diff --git a/fips140/crypto/seqiv.c b/fips140/crypto/seqiv.c
new file mode 120000
index 000000000000..dc7e9c533d2c
--- /dev/null
+++ b/fips140/crypto/seqiv.c
@@ -0,0 +1 @@
+../../crypto/seqiv.c
\ No newline at end of file
diff --git a/fips140/crypto/sha256.c b/fips140/crypto/sha256.c
new file mode 120000
index 000000000000..487d843d4d82
--- /dev/null
+++ b/fips140/crypto/sha256.c
@@ -0,0 +1 @@
+../../crypto/sha256.c
\ No newline at end of file
diff --git a/fips140/crypto/sha3_generic.c b/fips140/crypto/sha3_generic.c
new file mode 120000
index 000000000000..3719d7f58f4a
--- /dev/null
+++ b/fips140/crypto/sha3_generic.c
@@ -0,0 +1 @@
+../../crypto/sha3_generic.c
\ No newline at end of file
diff --git a/fips140/crypto/sha512.c b/fips140/crypto/sha512.c
new file mode 120000
index 000000000000..8639124175e2
--- /dev/null
+++ b/fips140/crypto/sha512.c
@@ -0,0 +1 @@
+../../crypto/sha512.c
\ No newline at end of file
diff --git a/fips140/crypto/shash.c b/fips140/crypto/shash.c
new file mode 120000
index 000000000000..ffb09e16c542
--- /dev/null
+++ b/fips140/crypto/shash.c
@@ -0,0 +1 @@
+../../crypto/shash.c
\ No newline at end of file
diff --git a/fips140/crypto/sig.c b/fips140/crypto/sig.c
new file mode 120000
index 000000000000..742f337b3cd5
--- /dev/null
+++ b/fips140/crypto/sig.c
@@ -0,0 +1 @@
+../../crypto/sig.c
\ No newline at end of file
diff --git a/fips140/crypto/simd.c b/fips140/crypto/simd.c
new file mode 120000
index 000000000000..72398481d19d
--- /dev/null
+++ b/fips140/crypto/simd.c
@@ -0,0 +1 @@
+../../crypto/simd.c
\ No newline at end of file
diff --git a/fips140/crypto/skcipher.c b/fips140/crypto/skcipher.c
new file mode 120000
index 000000000000..225d8cb56748
--- /dev/null
+++ b/fips140/crypto/skcipher.c
@@ -0,0 +1 @@
+../../crypto/skcipher.c
\ No newline at end of file
diff --git a/fips140/crypto/skcipher.h b/fips140/crypto/skcipher.h
new file mode 120000
index 000000000000..d93f94a9127e
--- /dev/null
+++ b/fips140/crypto/skcipher.h
@@ -0,0 +1 @@
+../../crypto/skcipher.h
\ No newline at end of file
diff --git a/fips140/crypto/tcrypt.c b/fips140/crypto/tcrypt.c
new file mode 120000
index 000000000000..5c59dd1d6109
--- /dev/null
+++ b/fips140/crypto/tcrypt.c
@@ -0,0 +1 @@
+../../crypto/tcrypt.c
\ No newline at end of file
diff --git a/fips140/crypto/tcrypt.h b/fips140/crypto/tcrypt.h
new file mode 120000
index 000000000000..d643316fd181
--- /dev/null
+++ b/fips140/crypto/tcrypt.h
@@ -0,0 +1 @@
+../../crypto/tcrypt.h
\ No newline at end of file
diff --git a/fips140/crypto/testmgr.c b/fips140/crypto/testmgr.c
new file mode 120000
index 000000000000..0b105587d3d8
--- /dev/null
+++ b/fips140/crypto/testmgr.c
@@ -0,0 +1 @@
+../../crypto/testmgr.c
\ No newline at end of file
diff --git a/fips140/crypto/testmgr.h b/fips140/crypto/testmgr.h
new file mode 120000
index 000000000000..486e31b584a5
--- /dev/null
+++ b/fips140/crypto/testmgr.h
@@ -0,0 +1 @@
+../../crypto/testmgr.h
\ No newline at end of file
diff --git a/fips140/crypto/xts.c b/fips140/crypto/xts.c
new file mode 120000
index 000000000000..2ee6ce8b2c43
--- /dev/null
+++ b/fips140/crypto/xts.c
@@ -0,0 +1 @@
+../../crypto/xts.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/aes.c b/fips140/lib/crypto/aes.c
new file mode 120000
index 000000000000..752e48faca8f
--- /dev/null
+++ b/fips140/lib/crypto/aes.c
@@ -0,0 +1 @@
+../../../lib/crypto/aes.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/aesgcm.c b/fips140/lib/crypto/aesgcm.c
new file mode 120000
index 000000000000..d36e6b666511
--- /dev/null
+++ b/fips140/lib/crypto/aesgcm.c
@@ -0,0 +1 @@
+../../../lib/crypto/aesgcm.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/gf128mul.c b/fips140/lib/crypto/gf128mul.c
new file mode 120000
index 000000000000..ad4f4a232bb0
--- /dev/null
+++ b/fips140/lib/crypto/gf128mul.c
@@ -0,0 +1 @@
+../../../lib/crypto/gf128mul.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/memneq.c b/fips140/lib/crypto/memneq.c
new file mode 120000
index 000000000000..3c73a12c9f71
--- /dev/null
+++ b/fips140/lib/crypto/memneq.c
@@ -0,0 +1 @@
+../../../lib/crypto/memneq.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/sha256.c b/fips140/lib/crypto/sha256.c
new file mode 120000
index 000000000000..d36c2b0f3b4f
--- /dev/null
+++ b/fips140/lib/crypto/sha256.c
@@ -0,0 +1 @@
+../../../lib/crypto/sha256.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/sha512.c b/fips140/lib/crypto/sha512.c
new file mode 120000
index 000000000000..94712c686209
--- /dev/null
+++ b/fips140/lib/crypto/sha512.c
@@ -0,0 +1 @@
+../../../lib/crypto/sha512.c
\ No newline at end of file
diff --git a/fips140/lib/crypto/utils.c b/fips140/lib/crypto/utils.c
new file mode 120000
index 000000000000..543c49b255de
--- /dev/null
+++ b/fips140/lib/crypto/utils.c
@@ -0,0 +1 @@
+../../../lib/crypto/utils.c
\ No newline at end of file
-- 
2.39.3

