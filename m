Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44D31F3D54;
	Thu,  4 Sep 2025 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001675; cv=none; b=cDrB0PsG0QGGLggrrXEGzt7CCa0yoKy/9OkprIysvdDNrnKHJ14NWOnL/2d7nDsYqptKKwFPNpfUNPY85XVjypNZeBnV43uwaQHiK5+yRJLzZQF40EpO7djyx+4w4bSsfm/8ftI5f2EgHeep7yA0QaaevGCL0IJ6blncg1wHrKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001675; c=relaxed/simple;
	bh=z1XwwqSKtHktahgJZcIryU3TRksGEzVkIrbJ9DBnrJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jq5kUxDB/saTRps3f9DXYOVUqm7HCu4k1RPP23EQGHZgTsyJj/VPEQ65d7WxIhM2lStThnhFp+aMYNuAbE4e7sTL5vhETzEbernzfp0N2l8t4pi+rlgpZV0x9d3T4/Rz0eXW7xfT8mXyj4YLJpr3GvBcEgQ2er0topdBu5Zznzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E7AEPwKn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E7AEPwKn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjKZ014848;
	Thu, 4 Sep 2025 16:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=iLD8S
	tQgQsgfYtkLD+QqKesfrNn/S/xwaYCnFtMjppI=; b=E7AEPwKnfuiHkrA7AIBss
	IwiZv651eg4JQryCNqyIdYvUE4RnCDozw0jLCb/kYLnEByoBCWsvYq9lK8SirS/b
	h9nVptgoBFBkJp6FF8fPtFOm43hAJCLFmebdqBfeX0nhQjJYSbyyDrMRN2/3diww
	p1Y6XflebKO5JnpY0swgilneTJgHwvzN+5UjEdTFFL1n0DiGvgRdglyUyTHAeO5V
	t5Bxw36uV1k9kM0szcuTFEGIFWOILAehOy4f5QZQT0ya7gsjrEqMIYaMFq0YxT/8
	/+qIPUcImwhZJhozXtpqKkBHiGA89KK6f0z4DwDI8oi7n88FRoQ2gC+ec/Nji8uh
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0ckb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FUN8T040090;
	Thu, 4 Sep 2025 16:00:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:51 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7k000707;
	Thu, 4 Sep 2025 16:00:51 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-90;
	Thu, 04 Sep 2025 16:00:50 +0000
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
Subject: [PATCH RFC 089/104] crypto: fips140: manual fixups for include/keys/asymmetric-type.h
Date: Thu,  4 Sep 2025 17:52:01 +0200
Message-Id: <20250904155216.460962-90-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfXyA17lks86jsK
 /qecWpCYcqrEjZh3SUUQz/Xj2bx4+Ud0jtp4X+Gp429r5jIZdGSIFt53F7UBPKKnUfYMiRZVGkt
 S8P21SrjSdAY4suqnDoT2xPBrMFZOTNkVN+w2PSXjL7t1mb/2LpJj61EmIqjuKhaT8ZgSGt9wZL
 DkDM5DapvbCwfFST5SZIaERwps9s0CGss4OSrUHYHt4PgdKVTsx/aX0IItyrQ+Zfv3qhn0fIab4
 C2ZIXhuJ4uMRZAsmw28LaxU4LLkQPQBQcP3Edd6/IFrDmwPA5O1ynbFU/YgZkP410jOIZwtMGRe
 2ejI1/Fo31axd+XN6l8QYdl7Gj+aotWuFN9wJcbhdyMtGSuFAihRP+5JuhoxEL87Q7ZSz3h2L/d
 J7ldEa4i4H9gHmNvERn/zFTWHf4EGw==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7b5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=dzlzSZQwo39a48xGDy8A:9 a=zZCYzV9kfG8A:10
 cc=ntf awl=host:12068
X-Proofpoint-GUID: gKmGvGB6mPtFSyzO9IHtPvouWAvQA-DZ
X-Proofpoint-ORIG-GUID: gKmGvGB6mPtFSyzO9IHtPvouWAvQA-DZ

Define fips_/nonfips_ variants of key_type_asymmetric when the kernel is
configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/keys/asymmetric-type.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index ee1bf9b28bfd..12c6f113b612 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -14,6 +14,14 @@
 #include <linux/key-type.h>
 #include <linux/verification.h>
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define key_type_asymmetric fips_key_type_asymmetric
+#else
+#define key_type_asymmetric nonfips_key_type_asymmetric
+#endif
+#endif
+
 extern struct key_type key_type_asymmetric;
 
 /*
-- 
2.39.3

