Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838EA26C399;
	Thu,  4 Sep 2025 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001688; cv=none; b=rmF1V3OGYAoCHkgsK32ZNm6L8zuj0xg70NGtX1UxLZhrVwWc6ng3PpbgvfpIdaOttSh/jyVN6XT69PhH/n3oQU7zJph/kZmJuDte3mN8TpJlgL29ezr+phB/6CqVCLyMz+b3vXwrGHErx8sbNeIIC8X+wZ183SopmAflZiDdf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001688; c=relaxed/simple;
	bh=nLTC1tyVRXr5Dq2jjaZccIP82GMSakarfb8N3XXq8sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=koybn58NplehbZk6VyXHzHZrKM90+e3Vpd7YDNinW70esXxolua0ts+N4xjvBedb+uS7BxAuy7KRrzSCB6yxPIAOfZiaM5El6OSF/bpHNGluDgdyFe+OlHd4ZDaqXC7EWeUccJF3XvzVWsuYvFcSHwUgfdx5EUAIVm4odJswjj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJ5svsPQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJ5svsPQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmVV014916;
	Thu, 4 Sep 2025 16:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=xXnun
	SrrK4iKpA0jKPK1eww6Bwl6ptTzDQXgOIGDOzs=; b=jJ5svsPQUY5x/ljkvg6tS
	MYZtLAZ4K6x8k3QtKjwqPCED/9OD9y3q6+bkDi6CQ31b633/RDtrmfAQi6SMVYno
	cRDAgUb3+t41Pihmtn1UJMc1gzzvMC20otU8M22FV2Ap6izSqtsrr/Gl3z/fxRH2
	WLD+f5Rj58BGErl8Jvet9Bc18fCA2k3aKXmSN/b5/vUjkdzHNJ74NCp2zD+/TB/J
	Y+TX+Gyoxb8Fr9y2WjuVWksgn8EgV4drfWzmWgd0x4dNTjJe9rJLGSwAS5FsP+y3
	OzimUAtLMiOhNU08dlsyNWTacBa2A7buKS6ky7dvhtkub/oYZL9iqL/LmQT+/d5I
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedqi040082;
	Thu, 4 Sep 2025 16:01:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:06 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7s000707;
	Thu, 4 Sep 2025 16:01:05 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-94;
	Thu, 04 Sep 2025 16:01:05 +0000
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
Subject: [PATCH RFC 093/104] crypto: fips140: manual fixups for crypto/internal.h
Date: Thu,  4 Sep 2025 17:52:05 +0200
Message-Id: <20250904155216.460962-94-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX/8h7MElbz5LW
 qy/6FL0tvQjSfSnJedMrKZsm9yex20dxYmk4WehMI19ybsOEZuDdFPHRt2t1H1nH40QVIBoG8eV
 ykniQ4xI6dMMzroqdXMJ2w8aAGLUo/bHBCVfY+3dZT56Zx5xoLjh9EVLHR5GFVF0P+P3wUga/ko
 v0xAwQQxKFiWBrti4iUbVbTgA7xBMtxmWjRawPyEqxtd2fuqoew5Hmafm86aMJn3eSeIFrVCNBY
 cBTeaLOTM95z4Mh4BzNARMLUUDX319lOIYCjfHIqfv0bYRIGV10VYhF9GstJwQT3o/bx1yI/wVT
 pFAW2nRGIRBbNKIXNfhQM8mNjPwcnnVoJPl5aU3GMI80Ei8Cre9Zi/qiYEengG5z869dd8A6XnV
 /uEKlsW2zcrYjHSxYC6XcYZ7mfDy5A==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7c4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=DB-_GfZPeZJ4hgePeuEA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: zZUI7vqT-xLeArusDKPJeGZQrn_NiUy-
X-Proofpoint-ORIG-GUID: zZUI7vqT-xLeArusDKPJeGZQrn_NiUy-

Define fips_/nonfips_ variants of cryoto_{alg_list,alg_sem,chain} when
the kernel is configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/internal.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/internal.h b/crypto/internal.h
index f4b12863d922..08f2f04b010d 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -62,6 +62,18 @@ enum {
 /* Maximum number of (rtattr) parameters for each template. */
 #define CRYPTO_MAX_ATTRS 32
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define crypto_alg_list fips_crypto_alg_list
+#define crypto_alg_sem fips_crypto_alg_sem
+#define crypto_chain fips_crypto_chain
+#else
+#define crypto_alg_list nonfips_crypto_alg_list
+#define crypto_alg_sem nonfips_crypto_alg_sem
+#define crypto_chain nonfips_crypto_chain
+#endif
+#endif
+
 extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
-- 
2.39.3

