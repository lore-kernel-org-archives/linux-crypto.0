Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F02B28724C;
	Thu,  4 Sep 2025 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001456; cv=none; b=Gc+IB6RPfl1yi2Oaoax2mz+D/skzCWOxSLcSl4R3JBTUoueGrDDD7RhtqzDd9GDe6EpfzfkcFpXuBirdBt09qEw/L+Cpjq8R63RcPJI7PA1XF+WMon1rPh7r4hNwE13RAhjfom6yuWoelf3jyOdhlXfzZ4Eq47t+m/xbWhmU/8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001456; c=relaxed/simple;
	bh=YQvB6JIXPzeOEs7reZRr7tzz7EQQaWP/IQD+Qmvgn6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R828+37xfdQcaNnknoUyu0t6SF9xmlwDQZWhcZXQ5Mgv/ys2MQdm1qqsdHGtBg35rex40RGVDHB12GutunJwJX3GPoLYr/jIuLQ1fYPiciGVcyDW4hcn8Mr3dvSUHqx4Esq4+ZEUtloEVV8WjrhYzXq1iNXGqoU2KeuAkWbICuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=niBAsmXQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="niBAsmXQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkRt014867;
	Thu, 4 Sep 2025 15:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2u/EW
	EdO16lLfAtnJItU0jjHlM4UCZqXqAWzVrGi2gI=; b=niBAsmXQvAOr0V6dcutoP
	fu7NjDx8ZfV6VBBXf76pHlAhBII8lqfqZMBBdZYl7ja4yO4UD5Vsy5AE0Nmbp7Xr
	7di8xED+JSK5hp1wdam2WbnWqZZIJU9pVqHBJx3Th/aP7kRfGyTKpNhBHJ1TfDbC
	Ecsr4w07ZovZ6VQ1axNVOzi0BX4t9IqjXS53jNSz25wvpXszllJ8//3yuFh32N+7
	5gdm0Lim33XBwEzgsE2Pj1/PGdHypKU/VSi0D3cEPuQ0JfZB3J1Z/a774a+ATUgH
	voxVsQTy2Kgz+Uq8k+zXxyDz75QEoFPPV48AJog1F3U52rqADd0TXGnCrHiOSHjt
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0ca6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedoi040082;
	Thu, 4 Sep 2025 15:57:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx64000707;
	Thu, 4 Sep 2025 15:57:20 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-39;
	Thu, 04 Sep 2025 15:57:19 +0000
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
Subject: [PATCH RFC 038/104] crypto: fips140: convert crypto/cbc.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:10 +0200
Message-Id: <20250904155216.460962-39-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX4iYp4zj4nLN8
 cyFgWxayhKt9mE9WCZuyUltdsjVaqWpvKBtMSEGWMvAEef0yvSXp/GIuqQXS7I6jP5Is/VZsrht
 s5tIiWsxXxj9K9Lv5r9Gf3j3CcgnncpNq4xFh6ljZlpzm6zTgut9+I0gRu7ve2s4DaAIbKadeWn
 ttEEwxwbkgOuY7MNTmzAvqOn9dETafEJKcqwu1949pWqKaUQti9NF/5tyuPdnO0Xrr2fxmE1EgY
 SsP9q6AjEHr27AJLLd0xOucBcz3D3rrwF9gjdZW0ohAPpMzkofWyodpA3FIrCB8Cnq00X+IJ523
 BK4S5dzruqON+Zv3FmEEGPCudrDwjETc0U7Szzhraj4U3b5IDjKqbZ9d3MGjUAfnWEWv9ioK1o5
 MSllB365Sg7Wp4Fm9xgaSVYtL+a61g==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b6e2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=bWW0iiC1QYcRXQsiE8UA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: lRnl8MMQPmrElBRUUlhBmR-1W6UJn7-m
X-Proofpoint-ORIG-GUID: lRnl8MMQPmrElBRUUlhBmR-1W6UJn7-m

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_CBC --source crypto/cbc.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/cbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index ed3df6246765..03ee7008ab12 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -179,8 +179,8 @@ static void __exit crypto_cbc_module_exit(void)
 	crypto_unregister_template(&crypto_cbc_tmpl);
 }
 
-module_init(crypto_cbc_module_init);
-module_exit(crypto_cbc_module_exit);
+crypto_module_init(crypto_cbc_module_init);
+crypto_module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CBC block cipher mode of operation");
-- 
2.39.3

