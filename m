Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2321ABB1;
	Thu,  4 Sep 2025 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001702; cv=none; b=UddwduX2X9P0rV/Qi8shiAE1PGOUbkva3UnAlcDpP+EzondpksQZH7VT9vS6rM3cWPr+F8M76wk8zI5aL0QsfnaoqACGm6IoJOSOlsNyj49LSRF/glvy0u4FdcPi+dipbEWUUba7LBBq0cpzx2FcEZK2A8v1bUOcZqogaYGF4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001702; c=relaxed/simple;
	bh=FNeqXAaMucPagzsri91iXEduL5d5xIMrpSBnDI9ky/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lCYfPSP+ZFcYG5ZQYCefEYOvFN5C6dj8iN+Gh1YkZtlJZxFfe/tPEiAvZilNxRu2gZZS6d7GQsfZyQ6NgqcezBvID+klkc9x50VfZuv0e3uwoPk5NVQB6MzI77dUO1hnJFrYgkPc6DRM1ZPujHWEVGMBhX3DfEZ1uIq+IFiJbVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pyyddXRL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pyyddXRL"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmAt027778;
	Thu, 4 Sep 2025 16:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=pzJ1n
	bE/yAlJA8usGdVyqBL0WmRPYqxV2ietsKF58kk=; b=pyyddXRLEUCjEGdw3C5Ca
	XGuflstGM/zJxxB7A3X/E74wzJb9xQ+sk5CccvVxSCUGGMtK0l1BbYaMszxWFhS0
	UrNXgqGyitDHJdH91bgyA1WGTmhQQroVvYqZzp8j7U44tzjBQ3AKpFuccvPKsZpQ
	FWN2n+etn4DXWsJbVAUH5RRqs01NyycTOCRWNdpgaANFKWFsNKwHN56br0qitVrE
	BizTu97mv2CFw1BWYPmstnuv3J+y0NQSFY7rMz3/6fpKkdpQncTIJjCGd4UhtG6g
	PWTlObOV5XlvHjaklyZxDAHJoNC3oQ2KB2OdRhrZoLvOVp9iRbF+v1YEnxeyrYbz
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn07e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FTLSp040133;
	Thu, 4 Sep 2025 16:01:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx82000707;
	Thu, 4 Sep 2025 16:01:20 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-98;
	Thu, 04 Sep 2025 16:01:20 +0000
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
Subject: [PATCH RFC 097/104] crypto: fips140: manual fixups for lib/crypto/sha256.c
Date: Thu,  4 Sep 2025 17:52:09 +0200
Message-Id: <20250904155216.460962-98-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b7d3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=_KhmphtG89pKKc8N5QcA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: ZPfxiy41_4VRn3Rdj8CRBoSu0Stmy1i4
X-Proofpoint-ORIG-GUID: ZPfxiy41_4VRn3Rdj8CRBoSu0Stmy1i4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX1Ah0jwkrb6D6
 p6HLYWFxSc2T4OMhKm/pminiVoYw8DU4rXFmLWUnM1H4dVIJbE38UT3UbOJmcsYOhW4PzyQp8LZ
 fIeNkrWJkHCihIOHyyGTJZRW8Sq/KiYsFwPocCe7m3R9E8KEokGv/5D7+W2H7elsDJGzIj2zHDI
 hvbBsGOxxbaeau/izUiXDpQbL7eJwswGpPm8kASxu6EKqda5GUf3xeaPtyZMmc1gOQThYE7EjNn
 Jl7xJmWyzxr8ICPI7PJh3RwPIkUZmapKrOcz57zDYINo/bTMsT2l6lgWVbN0oHXiBcTt2zW2Blt
 5wGN6U1NEEtKdmDin0bVVJCK6s3rEgs4A6BV9uQekLnuGLi5h35bqvyACdPcrZLDvvg1W7/X3xz
 iKpifHdiLOZXzqvNuQe9ncsHZzdmaQ==

Don't build arch-specific SHA256 code yet when building the FIPS 140
standalone module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 lib/crypto/sha256.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 36a9f2bf77e2..bc20cdb9eb94 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -148,7 +148,7 @@ sha256_blocks_generic(struct sha256_block_state *state,
 	memzero_explicit(W, sizeof(W));
 }
 
-#if defined(CONFIG_CRYPTO_LIB_SHA256_ARCH) && !defined(__DISABLE_EXPORTS)
+#if defined(CONFIG_CRYPTO_LIB_SHA256_ARCH) && !defined(__DISABLE_EXPORTS) && !defined(FIPS_MODULE)
 #include "sha256.h" /* $(SRCARCH)/sha256.h */
 #else
 #define sha256_blocks sha256_blocks_generic
-- 
2.39.3

