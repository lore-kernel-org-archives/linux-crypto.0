Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74666280A5A;
	Thu,  4 Sep 2025 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001459; cv=none; b=b2gh8PhZYNDUhRXNc8cJ2kc73e4EH8ynR/WSzAY0DASLnf1kswO+LvBHNDEUGjp5v6+RnB4XdkRor9Wnqz0o7NBWIDf5+pnAXn2ypNv2ZE3KpWSEuSJ5qfqq9WlEQDh8r+nv+n6mkBU5xL3neGBLgp33Elx7dXHJ7q69NBI6G+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001459; c=relaxed/simple;
	bh=6vn7VMUPicd7gEbOjN7MMZWuX2O1HyXsJuLzxaxVyrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qOIYRlYdJwyq3yqrQl07F6i8PtWfYtz75FCJep5CHrfG+SeRu93JSt916CViMNzcseQoX3DuveWmpEvuQFQi6PKJzExTCyTIyHWJfdFFMZEIVGvTd+ALIyg3WeSvWJibo1horgVVTHkhuzlh9lmg0ow3QshC4i+3zpqHN5zx+XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sZ9JEvyi; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZ9JEvyi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftrap010582;
	Thu, 4 Sep 2025 15:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=gTbwO
	QyRuniWF/nb0Mc3HvCrIicWzIL+Zrpq+Csca9k=; b=sZ9JEvyiv92I9CvQmuyY7
	irvoCu/dj5nrkzJhUHCBqpzQ/eh+4zTX8tOx8yasPxjnxd8IwmMzbO8lkjq0eTCP
	RiUMgf4TT7f7cHRSJ+yDyj5sUPTVs0dl2ODpOYNGUk6kYD/K7Gfx75f5rvqpY/7c
	yGEBEDl5WZNL2dDXaEj5Jlx/TlyIY+9Q3Ww9JgSgj8pXMz25MkDarjz8ceVcDtH7
	NZbsO3/5JFgh/9DCiQ7s3Wrwhz/XbmrFuh+907mrAaOblMePhvoV6d8uPvpfjw8T
	qSXDvG9LP22lyAIXX5Izog7xDsdXvVm3ZKU7RN8DH5+X5p9JspQGqclf9r5Irwdu
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EPF14040051;
	Thu, 4 Sep 2025 15:57:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx66000707;
	Thu, 4 Sep 2025 15:57:23 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-40;
	Thu, 04 Sep 2025 15:57:23 +0000
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
Subject: [PATCH RFC 039/104] crypto: fips140: convert crypto/ccm.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:11 +0200
Message-Id: <20250904155216.460962-40-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: 4ICKX1V2Sh8Nmlf-89tM81JXdz32UVmV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX0stGwTF8BY35
 ePTocUQ/ODG1dqY7oNCEnFiHfaD7z24V7XrULbSulA4gNbR3lF18OkzN9pOWsQlH3Fp2iIgP4M2
 eOvIvJBagrFCgEpz+xn4f5niPz5QWgTEkU6De41sa9AxYKpbIpThPVjd/PqhEIDGuYEJVnE4rJj
 03nTv0bYoKBSwypXZy/WGj70r3p6c8wsbgvQ0hYioBBcEYBX25gYj54N0GSok1lruPAjc0oWv+9
 yT51vyfKAmwgnGtTc3W09XUmD0OMvXsmsrLxviL3ZAoQJsZNYGh+v+zbPeQQ0NvS753/mRQ/d/8
 IPb9iBtoRyuwpfGp4YXAJ70t2I5Mb3eDTvFtxOVdcsaPoQIIO8TaaT5ARzVnbPDtAm/q0k+PvuQ
 sNfZFk5BpsltfBXaaJQAkA3rtkLqZw==
X-Proofpoint-ORIG-GUID: 4ICKX1V2Sh8Nmlf-89tM81JXdz32UVmV
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6e5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=PeKeWH23CQtElG552NwA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_CCM --source crypto/ccm.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ccm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 2ae929ffdef8..e76946e05b5e 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -929,8 +929,8 @@ static void __exit crypto_ccm_module_exit(void)
 				    ARRAY_SIZE(crypto_ccm_tmpls));
 }
 
-module_init(crypto_ccm_module_init);
-module_exit(crypto_ccm_module_exit);
+crypto_module_init(crypto_ccm_module_init);
+crypto_module_exit(crypto_ccm_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Counter with CBC MAC");
-- 
2.39.3

