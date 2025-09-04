Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3628152D;
	Thu,  4 Sep 2025 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001530; cv=none; b=DUViVjG69AzwxmKpdFQyNVzpb/QCag5fGl7UuV1if6IXOtsnXh+aCBPDlLZx5v+RfIhr6CI0AlK9nZ2ELAGKsywimWmisLV3SvvsHOXsGbzXMdNYMkPMBiDdJwenrC6OBDPt+ZyJp4juF8L1h3bmlkZxuxXgxk6lJAqCbTb4j78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001530; c=relaxed/simple;
	bh=WyHTgyNnDvf+HroM68B26LwmEiT7TkF9+JmT4HCxZ8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzEyvsZIlxtXcoGfREa9E5XynXXTKCqAmEKBAipQn8qmIw/P9/q3WpWwQR0yKoqI6m3uFWr8JTgYtRiuNvz+qAI3fc+TxXygM9WZeC9TWC3PoLuVNeDxoSUzZIS1VUz5n8AZ0FNXiy7FwP9JHAVusQ8cWS7ut0hPO+nWfHPwwmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V2nzRJuH; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V2nzRJuH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjXL009095;
	Thu, 4 Sep 2025 15:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=HLryR
	xa0enAezx+TaUOrEqudGDGcpTkDh/qE0lyzLDg=; b=V2nzRJuH4RZ7o/vfnPowW
	1ZZom8ewKGwySIWNiDakFPZnLojYaeiSz6bgzLFmtZDIj7gkUFXAhFG4jp7rx5hn
	YMdH2J/tmO9dnUCuBd4rQWQpGjy1n8gz8cYC5R1qRN1VufJn5RjZFWXtq91UCIDC
	K4l+ED5XgUjgaXe5Pl34iV3CG1IOUMEkvC8t6RhLdUrGYFbzwLBgSqn1UFLIyfqe
	VcdWMnZwv6OrGjp7TRVSRWgWEBij1Uj8zTWP1mylPBucJgDlEqzrImBJuTInPBxm
	Z/wSxTDQFUDWt+YajUY+mkkC9bp+cteEQhoiyoznLAXgnvRb/wF8P9A9p0+8OG06
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FgNVl040151;
	Thu, 4 Sep 2025 15:58:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6Y000707;
	Thu, 4 Sep 2025 15:58:37 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-54;
	Thu, 04 Sep 2025 15:58:36 +0000
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
Subject: [PATCH RFC 053/104] crypto: fips140: convert crypto/essiv.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:25 +0200
Message-Id: <20250904155216.460962-54-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: RKemTjHG73hzpOFYZp0-lmTGotmy-uHz
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b72e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=GW46Xep__aI-pRfpruYA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX3kCyGClBS5wc
 d70pPKzUliIBRuEM1eD9sNkpWaArc8so4qX8kAswgMD7Og1OrYH2QezTfEXeuW7kNK4A1724ZZr
 jDAAoY5b49Zv1SK3MUCamZDOgyex4OR4EX8RriKMDSxTe7XJS5FvzxIA8eR/1jB0LjTLxXYDlst
 XTLeR/AlQhEbNC5+IcDYOgUUiht0Dgvzypu4BgbNdLVpE4epzIeMnwLp5+MeO2is3d6Z4pgf/Eh
 DKK4aYRvNBmB026lz62Kv44MrhzkbDsu1Zcbz5NfSXGb2FZiCU4ls8P38ljFUIT7AbHIYfOHB4h
 xfq4NYqUItADEc4l/YUaRHs9/WR8FTJk/dWD0bMj2kTIl8ClCGflMCM4Q1oD5/+D0cgTgTCE9Kd
 jT30K4EhLHMc6kThyuHl2il1qVTVRg==
X-Proofpoint-GUID: RKemTjHG73hzpOFYZp0-lmTGotmy-uHz

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ESSIV --source crypto/essiv.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/essiv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index d003b78fcd85..579fa227476f 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -641,8 +641,8 @@ static void __exit essiv_module_exit(void)
 	crypto_unregister_template(&essiv_tmpl);
 }
 
-module_init(essiv_module_init);
-module_exit(essiv_module_exit);
+crypto_module_init(essiv_module_init);
+crypto_module_exit(essiv_module_exit);
 
 MODULE_DESCRIPTION("ESSIV skcipher/aead wrapper for block encryption");
 MODULE_LICENSE("GPL v2");
-- 
2.39.3

