Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B882D46AF;
	Thu,  4 Sep 2025 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001572; cv=none; b=CSuXWtfTZxmTMDLlRWqwt0zvodHzp/S1KhvbSugkSZs0xQmiQd1W4NH8CHV7PJEKNbu2Rmz5qPkLE7VeDQ0UnRpyV0/sPcRQA1bPYbzlLsxB8vTjkocfERcDgIjA+RctX7O7faCbQDxL61mUkv2CrA+QRvKg8Tj2vrVbbMbPZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001572; c=relaxed/simple;
	bh=/kHNznyxHECF6oHvT8qLAKyDsziYo5WgWISY9MQS4yg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgl8fRlGfu0e1ADJusDVeHFAT+Y56D+CrhqqEy1Wn85UU0jzrgkXs86lH0UunCxXDZMcIa+w38NBpL4cR7SSP48xBE2nO+rAdo+mXxgQ0JkZb/0k+5YOc1VdTG8VkFLFdnpMU4M15nQv3YehhR8ur/FdyaDryGt6OnWYpp/fXvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g9dvxYH0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g9dvxYH0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftr8x026810;
	Thu, 4 Sep 2025 15:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=S5KYi
	BrCq0fHhWgt6lmGKo21M0/Yj3fKy/5xkoXPxP8=; b=g9dvxYH0tj/+Z9g5EWY9a
	aTWlgue8Q++GYKEd4R5hRbnWkbQVI3BSJw55k2JvUHYuswSOzqvhhPIGWdLx/Cn1
	Ydal9J/GredtgXwIRzg8EGsYYiccSFfw6u4mzDD2HyUTHJ7fQZp3oUuF9zg9e1SI
	kCoplI8zLVbCNod5IXBWOi/nESqnB/Z/TzcEN8pUmalMyuiVnJmhvUjdbzJ7+t0v
	ITE4g4FP7+6zpVSo9AeaGBn2cqN0RCMW7GE9xWSDWU1c8l4YOMIPNtbTr8t87vI2
	te82+A7B1RKIe7OFKeQKfecq6qbfY6mF/B7/id1pzyxRIry281FJAI7hBpKZCjKc
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd100542-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Evw3i040310;
	Thu, 4 Sep 2025 15:59:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6w000707;
	Thu, 4 Sep 2025 15:59:19 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-66;
	Thu, 04 Sep 2025 15:59:19 +0000
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
Subject: [PATCH RFC 065/104] crypto: fips140: convert crypto/seqiv.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:37 +0200
Message-Id: <20250904155216.460962-66-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfXxatlUzlcI7aT
 O0GUBpGaLK4Zy8JH+hXlSo6vwmJC9nCyw0dlV6T/enNREfue1IjZX+OqPbnnyi5wGv3j1FlOnBx
 HSPGaPtVSJL+QLsaq53GpKLRnOmeJY6/Sf5kMY4bJ+G+kYVjP/TA8LNgXsVNC1jjPEQgok4BhAl
 29mL9Jzu4MmNCEM43wpDt176NZy8fv/SAUaoa/slQmEBAJW2sGKTQjXV5iLyXdyFUtLu8odIFNB
 U8YwFc6hrUlKVOkCF074GoprTfMr3ZThti0pnZlzMoi/cCjVEUKOmeJGUaBF09Yg9xrAR9iilkF
 LG5ZpOGuGYJzS7OZ0ii7TRlv9Zd1aHSlDQm6u762+YH3r1jrEowlHA6sXFSXECXKi30DN8f3BjY
 hQka1zlT7yjVROB+LiiAklw5Cv4brg==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b759 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=bK8MCgOIGeETVRxmlfMA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: 7ArrZoa4JuHnNDOzvbrUHhe1RAHkjVsA
X-Proofpoint-GUID: 7ArrZoa4JuHnNDOzvbrUHhe1RAHkjVsA

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SEQIV --source crypto/seqiv.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/seqiv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2bae99e33526..169f4f9e9df1 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -168,8 +168,8 @@ static void __exit seqiv_module_exit(void)
 	crypto_unregister_template(&seqiv_tmpl);
 }
 
-module_init(seqiv_module_init);
-module_exit(seqiv_module_exit);
+crypto_module_init(seqiv_module_init);
+crypto_module_exit(seqiv_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sequence Number IV Generator");
-- 
2.39.3

