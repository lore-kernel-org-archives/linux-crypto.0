Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4E528314E;
	Thu,  4 Sep 2025 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001444; cv=none; b=I7FR/iAsyjDQgfgczrw1TS+5ijaPe5cKfwx6kxdm8H3XMO6QoRgwq1ONvlPvfZH9NQdIODoBcnzUkZrPhULKsSuqcwwKdXklLhYRv/NWMASjeKMyj8MCORCBnx08ejVnZ0vy3XLb84ULocfx06tnhRR+4R2uhWrmig3u4zW4eNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001444; c=relaxed/simple;
	bh=cPEcYyDaDvxFCM4I7IQ9DdQh6rRzkD3TKbICc9GtErM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bPw4mE1XCg6Q6IAgVtG4wPBzwbcGNp2LahrHEiGPvkEh9x85ROrEvTQaBq6OildyY3YYbnhn0nbGUT2+92PIjaeCASvEuHvv2V22DPMkScpOpCS9BVIWbDzP2Dj0A4jkzQ0sQhyw600/AkpnLa4QKPsuhXZBoH4G27h5kQToUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IB6QcMw9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IB6QcMw9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftj1u027676;
	Thu, 4 Sep 2025 15:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=4lfDE
	VpmloKOJHEGeClvMQMD5aJ8yS/pz6okj/cHTuw=; b=IB6QcMw98BXJNvfEqnIyD
	7pebiRRLLyOIlDXKEhMYH/Y8ebJxRKsR2zFMc0Yj57CykPk8eFWZn3WQdbr81Rde
	Ny2ppqIQsH2k/KJkjJxg16Frx+q185XIwzafu97niJQu6+k2NQlvPcUXi2ibfmAh
	qJsJWTEY+nzd7MysTOxE6PsE+2snrGZGAZmEDhfkwv8eIsEosvu+jjMud4rBGDqV
	Zw8hFLeAVARAeDscveH9WN548V//GEujTK2X3PraJIuJmkDdDca+v1jmRvyk+sCV
	lpYVqsHt62jAYxv0nR+SpnQ3bC5bg3euE2Rt/dAesl9mIO/durE77T3kASR9bJRG
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn071m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EPF0t040051;
	Thu, 4 Sep 2025 15:57:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:07 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5u000707;
	Thu, 4 Sep 2025 15:57:06 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-35;
	Thu, 04 Sep 2025 15:57:06 +0000
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
Subject: [PATCH RFC 034/104] crypto: fips140: convert crypto/algboss.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:06 +0200
Message-Id: <20250904155216.460962-35-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6d5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=uMv1ocpt3EWN7nqkutoA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: XAh23rQfG4dRNFTQZUvkppIrm6Sw91P1
X-Proofpoint-ORIG-GUID: XAh23rQfG4dRNFTQZUvkppIrm6Sw91P1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX3MdlZn8Dfta2
 JoFlYKKNvjfClEJJDCcJlpNqXkoT2Q4MC/DEDR7cAIP46xQ0CjO5TDd6r4+eBwM2yV67r3MoPLs
 7Z5w23nuOHrghUIl5s9z2uIm74BSseLeZbWqOhzPnoTvP2JTe6VZBwD9Fz7a+0+Cc1tDJGxhQIg
 ctqd3hkjbiL4LVIW+wj3OQMOK+HMWtKuV3G50SHe9xrRoxs0ACx0G7cpM+GEsXQAEZzE7uDiAb1
 +pre53y+dNDMWi5VO2QrqyX4G9ZHD1DghavVQmUxL1+qO6luXAWJvsz1ar5JbKe+UqmQwsmYIVT
 a/gDsUloZGJ2YxPZdVa1nhUf0yhWvPCL3zmRtDtbCLg+1PwDZzU3nr16JHIWYpmPRA4SSJ8O02n
 rVYVwsVL2MN3apAQXLCS/bVsnHWscw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_MANAGER2 --source crypto/algboss.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algboss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 2599c54a49ff..9d540ab27e9e 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -235,8 +235,8 @@ static void __exit cryptomgr_exit(void)
 	BUG_ON(err);
 }
 
-module_init(cryptomgr_init);
-module_exit(cryptomgr_exit);
+crypto_module_init(cryptomgr_init);
+crypto_module_exit(cryptomgr_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto Algorithm Manager");
-- 
2.39.3

