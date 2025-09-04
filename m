Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7502C21D8;
	Thu,  4 Sep 2025 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001708; cv=none; b=BZ30bl/Q01+J5nPLp+G9JqcTY65ST6569ibGfnF+g7zUB5pHIurLpagN6SUSx9aT4vT6a10lYLqL8K9QPjx12yIT88XD2wpq8TYzmUPELs9QX/mo9ug11/IhDDs7IlXwQx8zzuOlZ+pmFuJPKNiejj/plAFAYmiKElgllyM4PKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001708; c=relaxed/simple;
	bh=8575qUMNnu/AQa5Co18V2PGdnCsDat5wC6QJN4AkoTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rC7stMgF3ujFCFuVcjAQda7zzYttO0IcJZ6YWs/RwfmIJhw5H6Ex2rnZ16wKD0EMERqlwoi0kgCSEzhA5GrHMRW8O5321sn9/SUikADK0FT5xqsYWBJRkeUoOGE0LMCxddBJ7asXUj20rr6woJ1NstcNU86kX7LAKtrtG1F9mZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RbtGtzLo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RbtGtzLo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtpQZ027809;
	Thu, 4 Sep 2025 16:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=hQy7C
	4wRqpUpQKpEbLjoqvUxsqCQ0eQ4Xmm41thqOkM=; b=RbtGtzLoUHIKzqaLbbtVq
	RT0QVpfg3+twgXpPP7imiHrR2UYnKLK3mmEf+Ctwe4IppTPcp/r6dhxpVXaJz9me
	uECO0k4pEBK1qRsatQ7f+aeuF2MXvNsCIZdv14XZE4o0i7cJ4GNmv/U7zwbI3EhF
	HayHN/VxNs2iGIWhHN3WoWDoMwOrFziM0flu/nkUnCpSzUAJskWTTtPzNPvpXfKr
	//mbCqQkSgG7vg/UI8vsMhEfiu+5Y5vhnJtBBEPAx+7MFCBFTCNKn4nOt5NKHuUq
	GDnbZtyfUF3D/AEnOQtCyZ69Q7OqcXjqSf/vBnLbD7rcnHUfDQIAKrm/OyuTzXVU
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn07e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedqv040082;
	Thu, 4 Sep 2025 16:01:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtts9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx84000707;
	Thu, 4 Sep 2025 16:01:24 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-99;
	Thu, 04 Sep 2025 16:01:24 +0000
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
Subject: [PATCH RFC 098/104] crypto: fips140: manual fixups for lib/crypto/sha512.c
Date: Thu,  4 Sep 2025 17:52:10 +0200
Message-Id: <20250904155216.460962-99-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b7d7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=wiaB9s9MtoiBhrys12kA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: S_-fwzKP6HGMFEpc1RuSYQ0r6RXnDtXg
X-Proofpoint-ORIG-GUID: S_-fwzKP6HGMFEpc1RuSYQ0r6RXnDtXg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX2JzyWnF9xIO/
 yumDM7bpF5O+7+iGH5Ckf73Zi+P3ZFrPYI6La4Ilp7Nxznnqd3noCflCSgWzTaBDNUIqDVcfT0r
 28a3IrFxKEH6z9RajzqHv++U7PoBex6OjtQU28WyBeFWYCyo9bJIn1bTDPy3qra6vvoT8pbKLAe
 VRhQtK8nWRgZbP8iZrfj0xidiCTa/7StjCFMmnKDrgpL9bS2G+PJaTQR0JV/288og+tQWoaqaBD
 tFO0dr5ACe7WZm2aQuQ8QJMVrYPGoSvbL3+38J2H6InfAOXlza6LolYAZZwK8pTjt03UVedpCcT
 ht0RmItoOkAoBrtpakD8ITrdO3/15QjRV3vy4kqzE93M03xGyvYm0X9oL5iWkW/BmT2+m/r0lxy
 IUZyVkwMMR1GQvD60FHXPSTg/K+BFQ==

Don't build arch-specific SHA512 code yet when building the FIPS 140
standalone module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 lib/crypto/sha512.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
index 9a170bf1a48c..a6a3e102c6a8 100644
--- a/lib/crypto/sha512.c
+++ b/lib/crypto/sha512.c
@@ -132,7 +132,7 @@ sha512_blocks_generic(struct sha512_block_state *state,
 	} while (--nblocks);
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA512_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA512_ARCH) && !defined(FIPS_MODULE)
 #include "sha512.h" /* $(SRCARCH)/sha512.h */
 #else
 #define sha512_blocks sha512_blocks_generic
-- 
2.39.3

