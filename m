Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C176A28152D;
	Thu,  4 Sep 2025 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001453; cv=none; b=cVitxsNtEU4y7dGC9b5JfipwBX81o/GJhulD49KIkNHH/sCkbPL7VxIagUAsWkweQQRXqeqO7N7nV5VA4MFMRsl6xQtoXZrPQUtj0sWqiZi40fFZ4jYnF8ocIM9OBGaUy/rVVD/PJ4Z7lWYhRi59G1zDsaPWk4lMq/391NqKx4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001453; c=relaxed/simple;
	bh=69x7XijXLz0AJMCMvZs4V/kzgarYhl/iXu9nYVys7FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t1Ak8iGhySGkTqr0MU8g28iQ1JP09qkxZbDep2GvPqxVxDfk06MtIfCmuVwQCOYvbU8C3WxHGkVnBxSmk1nL4QzgbBb0A8uOIzOyXRWf90OcGm67ACzn0CPyXX6ePJwUiSBHxuHIrcpEwq3CwVj0FnQubmf3Rli7WB0ghLAKw1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p0t3h0G8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p0t3h0G8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftp4s027802;
	Thu, 4 Sep 2025 15:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=pu7u6
	b6jVItHFE9/TKsAtRBtuEIHnlIE3l4n/jRY1CQ=; b=p0t3h0G8n/n4PMC0OsO5L
	uKFczLTFnb1pvpPN8TkhWtRZTwNsYhyIHKfTNQVKyxMTsKiQHc8pW6l7mQRmb4eC
	2KEhhGTXYZgDmr4TqeVg51bKldY9QeGL9JMZEouhgljlcCT7ffmOc3sXfU88NhGM
	djTv5a6GTsccCQ74PGfGDtZ+7aC1LrCgxR9/xdSAmJGqRNTpjYt/odU/QJ4jXHRU
	arzC9h3dxrIcaK1GrQhz0q+pD59+DdkZ6YgybPSmLMtH43FkvqQC8h2/nD+WOPW1
	uF2GWq+5VUfjAztmWG1CmMj9pIbyorpyu1EanXLNg2C0w65RZFrbKcwGdBU6ZqoU
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn0726-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDefT040212;
	Thu, 4 Sep 2025 15:57:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:17 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx62000707;
	Thu, 4 Sep 2025 15:57:16 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-38;
	Thu, 04 Sep 2025 15:57:16 +0000
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
Subject: [PATCH RFC 037/104] crypto: fips140: convert crypto/authencesn.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:09 +0200
Message-Id: <20250904155216.460962-38-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6de b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=7ZN4cI0QAAAA:8 a=tMpgJh8_B_x24Oo6PBgA:9
 a=Dl0WHwQvj8hGZljrFLtM:22 cc=ntf awl=host:12068
X-Proofpoint-GUID: Ii6kPo8yjFgE5Zxi5li8Ozu-bnOKtYwc
X-Proofpoint-ORIG-GUID: Ii6kPo8yjFgE5Zxi5li8Ozu-bnOKtYwc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX+YmugXMdZxMV
 G9jwtcjdk5L3u5e2U2KQlCVosGx2AEVsM1rzwS7bu/c133fgc6Unm3fivTxNmkD31rj0xvyCiFL
 JiouMyBE8hPHni2DEhcUCTqdLsbePckE1VKsxvpNdewtorYOnMifLnwOPaB6XABjCRNKcF4wHcr
 +c/FowBtPpNsgOoxbs4twA12OtusclP0h3SB6x0z9wa0LZNwZdTRCtel0M0O0XvMuIr2rLt6N1n
 3xKq267AjprlEI6ISMr4gI4AhTgxH1sbfaA9yFgco+aQd7SZnnTH/5rUwzVMuT3KKC+XOYQMvFr
 zv/XW2wSlpe0usKxgKNj2c/L1hCe9SAl4A6wDIFZIU7xILQZmMuGVD1KvHAHUYzud6C66vCsL7Y
 7O2bzbw6uE4G0xXr4KuCLqOHzW66uQ==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_AUTHENC --source crypto/authencesn.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/authencesn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index d1bf0fda3f2e..caed4eaec6a6 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -433,8 +433,8 @@ static void __exit crypto_authenc_esn_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_esn_tmpl);
 }
 
-module_init(crypto_authenc_esn_module_init);
-module_exit(crypto_authenc_esn_module_exit);
+crypto_module_init(crypto_authenc_esn_module_init);
+crypto_module_exit(crypto_authenc_esn_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
-- 
2.39.3

