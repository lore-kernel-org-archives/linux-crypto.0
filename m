Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21FF271454;
	Thu,  4 Sep 2025 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001319; cv=none; b=WHVJSypywtrivUGp+PRIXQNhnV3opPW1zNLfdB2k7oiZLW5milTjTQDc8eUh5n+4DtGSMVjcZS2CCPwJ45+atGKTPKfWxh9STy3BLYE6ejQ2nouPMsqgAohmI2wOrXWgpxgRqp9oxhNwYYf2QeGApjUgPtR1Jnf1cPtyOnMOo9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001319; c=relaxed/simple;
	bh=+iyqRz5as2by5DWf1kDCcyNeziWC/OnK7AuVPVKX0zE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YH7+zhcad2JM1/Sw7CcTNBmTe1k+OSI+jut+LGmOqdrsNojL9u3YL8ILk/sokY7HfFlhSvmY7OHmqjQg2JNMxiFtokSzMnHTgetjWyaNuxHMKwo4BmPnzdMaEL5+bnkwA423vFgJzzF93haGZE7KFjKiqSQ5ZPOL199OHeIc7ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ivxOBs//; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivxOBs//"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fje8Z006294;
	Thu, 4 Sep 2025 15:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=u/MUM
	bEhvgMy0mGkJZhb5eMP3ycPXWG4xfTfKjQJrPA=; b=ivxOBs//84DiZk6UxA+cZ
	igYau20Hdt1WEOBmMWotN1KFRWC2G5FMqiJmPrp3F9+Be9Mj5V8exnqTAOiqkCeZ
	eG7J5svJEkB0HfL3L9dZvC+ZcAS6oya4EsJtkffbUdDWPcDZ0kI/xcfy92uwMBwC
	EMVCNhy/vm7w7B/NR1CrcLXiMUgD9YpqsC1u51GCifUkxex4pGQCZJ3u619BZvEp
	HzGqjtCgFZ7EN6JngCOVJaAk9dehIHHqex0gsWEbFFfpxGQOdiWzmJWHyEO0Rw/B
	Rfs4Nej2kBoqhehRlFK5HXr8JCJx0O2RVMfCM4WiY692S1RY6//nEvM8jkj1t38i
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd01xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Evw1i040310;
	Thu, 4 Sep 2025 15:55:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtkkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4m000707;
	Thu, 4 Sep 2025 15:55:03 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-2;
	Thu, 04 Sep 2025 15:55:03 +0000
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
Subject: [PATCH RFC 001/104] params: use arch_initcall to initialize params sysfs earlier
Date: Thu,  4 Sep 2025 17:50:33 +0200
Message-Id: <20250904155216.460962-2-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX/y4YNiGa7LlH
 1QGCf1l5kdnmNS95WBzHYKGZAnP7p2jrDrw5vLNr02h77DMAE2MKKcP3GQ19DYiN85NOlNIzZzY
 MwSikiUQR5fq/57QmKkPEhmidDSA4AFAP+mNjOr0dP63FWo6+AEHiBYYV2gRNNNWbICBsx0AoK+
 W9AuEWluo7ALMB6laeFho/eEf6/8cg2VU1MYsDCIba5PhCsYjudN7vPsKq5bYpDVYsu4D534b0b
 +6EChDLY90s/vC4dHNzQ1d2QKIL6mALlEKDk3hdnGjPz/mcwDmJIrNZzy3ZKYy29hp9D9nhlLnJ
 Txxf2PUIfXjBZjciLyVsh70ZJATWPSBJ/JvkkmGVoQN9vuv2+G3dtydpabe7YkUj4yndzcpQyFe
 wVwCyS47DWw82WQo/sgbytIjtmaaLw==
X-Proofpoint-GUID: lI4dHSUw_XuPCyWYoWIcy4ybVOVCBUrH
X-Proofpoint-ORIG-GUID: lI4dHSUw_XuPCyWYoWIcy4ybVOVCBUrH
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b659 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=1VSU6518iVBqUgcQX8gA:9 a=WzC6qhA0u3u7Ye7llzcV:22 cc=ntf
 awl=host:12068

We need to load and initialize the FIPS module quite early in the boot
process, but in order to load modules we need to have params sysfs set
up. Bump it up a bit in the boot process.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Daniel Gomez <da.gomez@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: linux-modules@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 kernel/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index b92d64161b75..03a55ff70bd8 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -971,7 +971,7 @@ static int __init param_sysfs_init(void)
 
 	return 0;
 }
-subsys_initcall(param_sysfs_init);
+arch_initcall(param_sysfs_init);
 
 /*
  * param_sysfs_builtin_init - add sysfs version and parameter
-- 
2.39.3

