Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900E285078;
	Thu,  4 Sep 2025 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001525; cv=none; b=ji3HJ8c32e5lTm8o03dlsEZBoY49Mor1XnhGDtXdxq3OBEYvwCSJm+bDdg7j4QsOlymKahJML5EqqBOSbeP/UsqtqdyUdG0OgjNr3mGMaiOnUywKkmu4jXV2qupCAPx74ILvcBk0K9BNPG6wQAKDRpvTfoaL/wH89fTywvX3iHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001525; c=relaxed/simple;
	bh=0mK33PdhDSMjFVic6RdWZ/X3t179hMZP6IVCNpeoIvQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrJuEX5Psmbo5d/y/2KRRxEelv7K71SpX4hzZTzdQylCuRP4Efi9EPWQowFXgPLmnGvMdQn+B0L98LXdg3F0FJkQ4UwoL4vxlaMoQKAOq5/DGAVaVCvqfbzkbUQsPhGH1wvNtIL7VA4mg99OBn/kL1+6+yw9pSYhLQ734dwOTuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b1D9kwnu; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1D9kwnu"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmAN027778;
	Thu, 4 Sep 2025 15:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=6J89L
	GuJcuau+xwkR8DawZAI0p0U6GPfpRWrdHxPGSc=; b=b1D9kwnuNlmmN1yZLM2W1
	IVKYJWZjIMI8YRhm0mCwBFHN8dCVLDE6qnYHKJZlow29FXIv80GdUMBZaBJxYjfW
	BMdXxzsnEl/FbIbjcKWakecGjnhun+hRtXarSfxpYfYKR7BYojLcWOV7c4H1OTbM
	C5+epa5Cdqu4Khrz+WACb/EuvorHVTG+mxedklc1rHlQ0HQ4X1iMlmtr6dKiOT8h
	McRjULp9Rj3qb3lp31fRutV2wEDCKPJHrTyAEt0PlHmf7iQeAG15YsZ5LHZ1e6iu
	Du6Y4/F1xc4c67gwszRsl3WabWPdMf/P6qHar6TOuPhGUr5ofY3GnKgUm6b4MwqH
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn076c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FVapk040148;
	Thu, 4 Sep 2025 15:58:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6U000707;
	Thu, 4 Sep 2025 15:58:30 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-52;
	Thu, 04 Sep 2025 15:58:29 +0000
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
Subject: [PATCH RFC 051/104] crypto: fips140: convert crypto/ecdsa.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:23 +0200
Message-Id: <20250904155216.460962-52-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b728 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=tEKA9gXYSGk3Ct7IwcYA:9
 cc=ntf awl=host:12068
X-Proofpoint-GUID: MmRRL-oidphPDPpUTlOO0Q9lhsD9m-Mw
X-Proofpoint-ORIG-GUID: MmRRL-oidphPDPpUTlOO0Q9lhsD9m-Mw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfXy3yDUVj4xz/8
 eIYagnc999QfONkhyIZ4syy+4u01B7JmTjXdT6svyX1gWDRgsw5lhuqFoQam/9BNdSpUQHU7WEm
 lcA8CEOYsLILhFPwqzFC4OZUqS2XTGNXIVJ/sY92Sf2cbv5aXj9Z0LFOoS0y2jxcHWDoi21Scw7
 aAgzw3VX8pQJGYlNwZEouStVaLEHTaJ+wO3GbhElnZTUmsrwHIss25w5hHUgUcvrQmvM0rUhc9z
 eWwcMFw3JR62DhXep5uW/isu8dnmJF32MfkAUaSzvfKaByrcR4RaiRoayjgk8kOgXPR4Cg0mU3V
 BVCxhWjgsIdFg5uyH5PmghxIjzfe8UXHNcx8wgBCEA6Uyr2f+EVljewRbG32ElCalaHLjuHKCAy
 SXBjTjtRcnSjmGa7Sb8l67onwZfxCw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECDSA --source crypto/ecdsa.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ecdsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index ce8e4364842f..64903419e6db 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -334,8 +334,8 @@ static void __exit ecdsa_exit(void)
 	crypto_unregister_sig(&ecdsa_nist_p521);
 }
 
-module_init(ecdsa_init);
-module_exit(ecdsa_exit);
+crypto_module_init(ecdsa_init);
+crypto_module_exit(ecdsa_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefan Berger <stefanb@linux.ibm.com>");
-- 
2.39.3

