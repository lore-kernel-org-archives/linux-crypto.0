Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8905A284696;
	Thu,  4 Sep 2025 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001559; cv=none; b=Ug04zWhTh7owkWmmL4N4hyLGpJ9HUIYE10GoEOzTlh97Fm8IwrI4jty8zT5e7dIhPsbxXanHFO9p+teTJkT50rV+ZQLbd5tfsYvJ61voWPRA3c8PMtZGzv55BOWGqkA0NmCPJqdKNU6h/tgQh0oqm4seM/sIy2RoD2Sw+p9Xytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001559; c=relaxed/simple;
	bh=FlbhKjrxK4sIBLsXehUfQjR3gDjSMFPj8gzRc0HaeDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VCQkEUiCbI4AeDLV5ACkTTvPH79NY24zODZbFWonGbzI1T1GV7fqONJnzeaaNcBRj/ITfQTp4cjxdMu/HK0Wwe6aJr/Rma+UNNQg4tX4cuK5HQHHNRJjx4sPkj+iIaPumxzXHXvt+aAEqlWRHA/qrLXBRzLxNppmhoDgb8Pj4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nK1A23Fc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nK1A23Fc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuk7n004100;
	Thu, 4 Sep 2025 15:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=FBlwa
	xnLiMx4j972AMZHE7EwvCuF8mtBGGlM4ypxMec=; b=nK1A23FcTozXFZAN0oaGs
	RVD2GmqISpLNG5c5Dz/95vnBTEgb4j3F7Ro5F/73QMggcvegIa/9IhEhCn/Dq2GE
	xzZCJs+HTEF3ER0bInqHNqyKQbMDPAwIoaLzKWbKyf0mDxA6KBE6D0jn8x9bSvdx
	/8S2kU+XqnZRnBM7NuRS9FPsUxJ+pcw/jvwzkG/+KimLPwEreFSX7E30PgHwhv3O
	84YeuinlCGypZrJpKd4etr1/wBb5Dk5hzcUOpDGOAV/4OJSIL18V/iXtpO09qaDf
	7HD/1FP5PNSEsfX68Re4394j0vwYZWdQhWcgeafjXA2iwvPh4Ilp0d8AqcDvKPt1
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun0064-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG6xO040116;
	Thu, 4 Sep 2025 15:59:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:06 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6o000707;
	Thu, 4 Sep 2025 15:59:05 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-62;
	Thu, 04 Sep 2025 15:59:05 +0000
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
Subject: [PATCH RFC 061/104] crypto: fips140: convert crypto/pcrypt.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:33 +0200
Message-Id: <20250904155216.460962-62-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: nxoFFquLYPWLVSBTOFnIwaW13Il5QOWE
X-Proofpoint-GUID: nxoFFquLYPWLVSBTOFnIwaW13Il5QOWE
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b74b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=7ZN4cI0QAAAA:8 a=tMpgJh8_B_x24Oo6PBgA:9
 a=Dl0WHwQvj8hGZljrFLtM:22 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXzbdyUfxuEjMU
 R98tuM7rvspqqsmUPidQw/9Up2eJm/J/W+YemkC3HF3aTZn3rF4DkNr1a/cJ0l+v5hk8UsCprHI
 lsRq7rYYo5BQNwZsVZTiLC/f563e2QzZx4Z2Lio/jxNWeKoH7AKRwnHM1zQ0PCKn0GUBn7NlpQz
 VUAZzvYMYa1fudTJfbTSQkjK4WRFLyw2kHIt3HsTLZnJWnc/9+ZXQ8nV4bDrK92lmgQmpHDhyHe
 YVyGnrbVVy9VYgFDrf3o3xar4l3YzgIzotUZ28dUcF7TI/nV6qsoaNJvT6ByoNUuCgL89ZLxvlG
 OECGGOExZmKbDMRQPEc1DLxNFujFPW8VidnmbyXx1S/dqrt32Oq1lbLyDTxn2j5kiJC2GRG/GTj
 b4+KibKBZObWP2Mck6kb8WXxvo2oPg==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_PCRYPT --source crypto/pcrypt.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/pcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index c3a9d4f2995c..b9cf7df64c4e 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -378,8 +378,8 @@ static void __exit pcrypt_exit(void)
 	kset_unregister(pcrypt_kset);
 }
 
-module_init(pcrypt_init);
-module_exit(pcrypt_exit);
+crypto_module_init(pcrypt_init);
+crypto_module_exit(pcrypt_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
-- 
2.39.3

