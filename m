Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4779283CAF;
	Thu,  4 Sep 2025 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001483; cv=none; b=uKQ7piWctjvekgsj4q1DpoWNTQ6TUjvda+MWHco0/GaLuC2ckVpRmmS+DtbfCjyssXqejNotlYvtrp0kOdFsakdD+WlGyb/OJr1EHF5IRRlP62Qcu43PZPElIDugvh1LCyc4OYZa2+Qu7iqy0WFWM+D/z8XzC2ysnWpoCEyEg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001483; c=relaxed/simple;
	bh=PRY9XdvmeIWvGd/LngI3PKYpmahFhOGVKFI2lnd77TU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJbWsfdfaJ/x2/6g137CE8nENv60PpxtOoRMqtSJWJk2x8bP0TTyfsUVU1kiXEXFwtOk1SEryCcy9/PqVLCAspZWWTMoM4AFoghlcbHBtcA+vhPSZ95XekICyuEi/El5gm/qJns1kxbQdLW6AiWcTYOpa3vI90GRMHrxQhMmEa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MCK+5w4a; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MCK+5w4a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuh0D004085;
	Thu, 4 Sep 2025 15:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=rrDRX
	/bsAKZq6Ow7jsTfw2TExuITEOFUN05Vz6VvJo4=; b=MCK+5w4a2W3NhEjssdyVv
	woQKCuj1jdeVCJeEp/J1yzLAkcUQBfASZ5k3nJlop9lbT6nHSdhr0FqIPHHlsilW
	xjgrWh8Xchh0LRQXVD9fWLWyvhjZXVB2W14AylCvN6bOjo34TyZQLxQLjXM6mqgB
	hHGw28frP280Hy2AQZAmBa+ui7pOcRcySjLTPllOyLdG/z6Y8EwINNmft4Td0rtF
	WC2JCAN0I8OCZRlGgkzAqo6YHhYWvfBpWcEibeBq4pYrw9lmqwbeHzzduadgewrp
	0g4R1d0l89aIKk1Sv+FTJ9p1JjeAoAE2PN++TmOUIiR0cJ5ffxxSmCfWeZUkVZCu
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun001w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDefi040212;
	Thu, 4 Sep 2025 15:57:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:50 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6M000707;
	Thu, 4 Sep 2025 15:57:49 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-48;
	Thu, 04 Sep 2025 15:57:49 +0000
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
Subject: [PATCH RFC 047/104] crypto: fips140: convert crypto/ecb.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:19 +0200
Message-Id: <20250904155216.460962-48-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: sG3gxfxjcGgG50uMXnpOnfLwNjd8MYJw
X-Proofpoint-GUID: sG3gxfxjcGgG50uMXnpOnfLwNjd8MYJw
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b6ff b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=Urz5WjdG_RdvbiEx2i4A:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXxFBlnlTAO8Yc
 Rt57m+QKTVl5mUncL6s9OwGSdjensUOQ+csi+webyjR3I6rRab433Hg3lLkqWyqiyHflwIFtwUg
 +ePCoxd3E9/7IWXGqW9zdJLcokgADSE4o7hO9DQU1yIJlOTPiKUR4NbHepqr+WWe1axWEN5d+gQ
 UWnSuFjbaZ18ujjg+72kiDLv7lB8uCIDSS5KZ71Hl4Ol3NZooJyEULUDpQa1gUQRkMLurnshrD/
 tE7U1GzY3u6rgdVlKIGc+UMCMx3kc5x7byuH5hOO/w8uoyxDiCZbw88199zG8K94LVL6qKZUuN6
 ShFs8vhw5vryGU6YzJm6+LLU5hOJXHykYVxYQ8hSjo7CnZ0yE2ScGAg1z+DiugjuZVlyA2s2ZRL
 dewDZK6nnY5Nbq0va0VnZSyiV6Llgw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECB --source crypto/ecb.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ecb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index cd1b20456dad..20127b20f483 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -219,8 +219,8 @@ static void __exit crypto_ecb_module_exit(void)
 	crypto_unregister_template(&crypto_ecb_tmpl);
 }
 
-module_init(crypto_ecb_module_init);
-module_exit(crypto_ecb_module_exit);
+crypto_module_init(crypto_ecb_module_init);
+crypto_module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ECB block cipher mode of operation");
-- 
2.39.3

