Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF612F3C34;
	Thu,  4 Sep 2025 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001566; cv=none; b=R7VCgbTJWvnz1R41UrWkzpFszgs+olmXGp7/aiOiN3FVYlWinEN3R8IH1UuyaWmIOgKiSBVOsz+Rv4Aozer7x61K6Oxj2HEr0JVGNsa2yRYXrwS+CcsYESO0osqt/kaMelr1xe1LsRJBQwe+QW4xZYURAxOP+9HhANRmCSTDcxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001566; c=relaxed/simple;
	bh=OBKgs1d3oh06SV6R4IEy8HWbuZ0qMPnTyYLXkVgJvgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gVOzPpaXXZQNIgs3GHawwfYqLBXHfimZXhqi1zHwSp8mAncB5VTd+dD3HDuVyvW3B+ir7nEFpEPfbjbpY3cvZgBaQmczapJLzvDv+J5wbtQS1MYHz34wbQEpPf18RPfb/glq/1ixkljF75JdZoGSVEtXB/CdudUgEb1eALX9Sj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BGf8hFIr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BGf8hFIr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtnQL009150;
	Thu, 4 Sep 2025 15:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=XcMFK
	89/eTjdel/hlmxhbOJzD1bQjNtPbuFrE8ysviY=; b=BGf8hFIr0A/VRqhxyCj14
	7CwaRNc21ndBuxgaQD0Zke9bz4UKYEb1MwpKQMe7uy+N8Nuvi5ASZOohUltK6F36
	jRyHqBMnuo9p4HklncXVoRsXh7oJ0BrSIlm2eqgxHySPjPD7kdDjK6Vzo1m+83oD
	YnaTZsU+zZMzUA1tuzmbyC0spLERim6yJrQ+MemDkDCl7sewrijH/t1QSlBxppD9
	NOv7adq1jktIIWk3FkWrKrI84aIgbpI30e78acm2DCMFdGYTDBcDI5lwAlGso5Il
	4f+deHsmPJzsY79YbIVFeCi/d4boZdQ1ySrkUAHV08YZXHyo56dyLc7qD+qAfXEO
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FUN7E040090;
	Thu, 4 Sep 2025 15:59:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:13 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6s000707;
	Thu, 4 Sep 2025 15:59:13 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-64;
	Thu, 04 Sep 2025 15:59:12 +0000
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
Subject: [PATCH RFC 063/104] crypto: fips140: convert crypto/rsa.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:35 +0200
Message-Id: <20250904155216.460962-64-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: 0cGy64kXdvm1GW5IinwGysu2fTvUqbl3
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b752 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=_NidnqJEXu2SEUO4Z88A:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX0ZIYftOyEDbn
 oegwsbUB1jNGrpEbXPN/dnH7w9hBSkIwBKaJzkospvmgwyu6d8qPlMiLmYSsNgR5LxEzc4YUYOL
 4Qc8CNXeB6710XdN5ya66le+Ejk9drc6q15qbZOUs9mM/9Obn7RDDocUDAG6oATqjnWVXHmiI4T
 BmpWo1mwWGubmHBNy+4+L9JbTOZR8IxwWeqWeNroh2BUtQA2sYFsQNYlqhc1ScvP7j9r3NIjs02
 lr0xsyzhZPEgWnyTrAfF7nHU0MRLNA7MvsMiJJu89yhD4G8M4tZqZzoi35uVJoObg5MAwHc63FY
 sERvD16DpuuK0BjfqziiHuwIf8Vp9xhkOm4NeXHaI1+W+0nTPUW0zbhAZk5nN8q70zN4JuSR2T9
 +pHqLrhTY2NQ8i9UlPvlUuJi8uHMbQ==
X-Proofpoint-GUID: 0cGy64kXdvm1GW5IinwGysu2fTvUqbl3

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_RSA --source crypto/rsa.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/rsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 6c7734083c98..44eef74ebad8 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -430,8 +430,8 @@ static void __exit rsa_exit(void)
 	crypto_unregister_akcipher(&rsa);
 }
 
-module_init(rsa_init);
-module_exit(rsa_exit);
+crypto_module_init(rsa_init);
+crypto_module_exit(rsa_exit);
 MODULE_ALIAS_CRYPTO("rsa");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA generic algorithm");
-- 
2.39.3

