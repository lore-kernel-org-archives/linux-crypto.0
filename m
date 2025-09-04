Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEEC2F39A2;
	Thu,  4 Sep 2025 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001467; cv=none; b=imUXHOixt/GklnmUZSxK8BOglxUcGhULIy4nDtNX81gFzzaN+i8wiD+gR2UaSFu4q5JVMARNw59hjG+I9oHVQBnDYGzQAtkYqhL+vp3YcKYgVcNw6NC9pKCb156LyCCwkijajRISUwbpgUjGVhdbHVC7AuZNRFrNwBeEO8PMjw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001467; c=relaxed/simple;
	bh=XzoRHRheBWR6DgWGnwdukVC0+SMO5GGJA9k7VPPhTns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jQeAVOnsvWwlSu1rLipwcc9ah5rl2pu/USmR9AGiwm9TEHFyj6kNpSN+NFYWGFEuNF5pg+hU6qzJ7oSNMAzeQigZxL/Y02uanY+fFc3XFMq4FH92pe0vvMJyRsrqkFpMS7q3F7HEue7WAKpvLlSVkb3tGD1e9SpjPL2TPcPrtFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OExuoZkI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OExuoZkI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtpcD027797;
	Thu, 4 Sep 2025 15:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Sm0Ae
	/M61z7YGZ+Biqt9kgwTDLE8cSwJxnuFOuNePvA=; b=OExuoZkI3J0QFeqK8jlgS
	BFkNV5Y+SS90b3f3zGoclYuS4DhX/zyom5oPRN4dHV01oY4PPpB63twBBIQzW2a5
	XdYym/MOgQyFQczm2ZbhApPQ5ISCmNpsiWxVYVk8BQkd8DTibwZuJE1DLD9bf+MM
	ker6j2G49jPhzLpvxtatltcUEGiJkalfGf6sd2PARIRX64SJMifx4jZVwov24Aj0
	Y6oVKUUrGlRKn9ZUFGdoYbptsYHsbAOWcpQlmQZfsvxqYENZqmMEOWqhbxjDqhYV
	3KB3+j+bmMMGJeevt2A1yxpTztdhdH8VxhjE3UQV8wQ/nJVJGXO6/nNfFgyxHv6+
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn073b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FcVp0040046;
	Thu, 4 Sep 2025 15:57:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6A000707;
	Thu, 4 Sep 2025 15:57:30 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-42;
	Thu, 04 Sep 2025 15:57:30 +0000
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
Subject: [PATCH RFC 041/104] crypto: fips140: convert crypto/cmac.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:13 +0200
Message-Id: <20250904155216.460962-42-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6ec b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=oyGJYfZxFYIEVFfqQogA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: NFa3kFe3EzbgUGNJL9BXivDXKtJec5hh
X-Proofpoint-ORIG-GUID: NFa3kFe3EzbgUGNJL9BXivDXKtJec5hh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX5xkBJaqEn5oP
 cDEHW2K0fUDzyJsVsDRLv2GPs45FSGNp5+2tm0GOwF5g02wHbkcKxRXpW98i6aQ+Nlg0qzhj5Jk
 ER/khAwei8Og6bRX/v23ekKDrRyHWC7Sbb2JfrsaD6Rek7CXl4GUhEpJ9igUWjYJesgijdQ+wca
 K0DWWVT2nnDdJGVfnYrXVGc/6rJ6f/hoFI97ilKMv3Jns9iSvYWvqhSoBghY2wQeyQeroIEBkQc
 29J9NNp91J3NBiJ0gzSLTSdXcDWclUGN4U81+4aoKrIIGHXaTj3PeKUGH4Y07rv6vpJDkWSyL8s
 RXd4H0kjSHVt5HCgBuDBS9UtE9KgESWK75aQ8s90zjkvPOYZOEXnCxSLxUKOBlbffx5Rk1IyVnF
 OFX7hCoOmO9Qno1ErWo3lwsrTFGw/w==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_CMAC --source crypto/cmac.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/cmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index 1b03964abe00..f898c4612312 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -251,8 +251,8 @@ static void __exit crypto_cmac_module_exit(void)
 	crypto_unregister_template(&crypto_cmac_tmpl);
 }
 
-module_init(crypto_cmac_module_init);
-module_exit(crypto_cmac_module_exit);
+crypto_module_init(crypto_cmac_module_init);
+crypto_module_exit(crypto_cmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CMAC keyed hash algorithm");
-- 
2.39.3

