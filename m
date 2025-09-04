Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FC283FEE;
	Thu,  4 Sep 2025 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001519; cv=none; b=Tl0hh6pU3PsBCp8jgs6rzEOpFBF0pGr+XLBxTzCb8KNUbnOydsf6T/hB3grN2O2n1ab8Q/JUDLxJfCAJSzC8vhwKUDcJZ/tju4kmoFkEoWWlavKrCftPjWP5PTcS0QULwXpE+gIbV904Mq/+FSlyxW4oD9ReeNKImAGvRBAoXhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001519; c=relaxed/simple;
	bh=6vlr3blMo2qsKSf3yTc/9QrX6a0wYk6V1yPItRjn5qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CDqSQv4fRfu5kqN7jYK3pQGGe/pmRLX4cMtK4NDNkVCMGvhcfQIOHDiq/3MZfLh6zyMfZglzPos0nYJzaowJm8N9YGdzpfDJ/bCueIsKh7Ka9f2Qn9Ikr8rARB93xU9wAbjONzkamz85IDTg33nJwf6WWqFUmK7OV+Mdhp4/j+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eyE0fYlW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eyE0fYlW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkhW014876;
	Thu, 4 Sep 2025 15:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=FBgv/
	1mAWWgPSefP5zca7fFznDb/LnPXiwhZXyjBks0=; b=eyE0fYlWzIL68sepCUj5f
	DIsWhtoo2paaNRbKR4LB17QE1dzXRbfgAeQ9Efg7rHEeK7qg9+LwERoU3EbnkpIz
	tOAZexrnYeTMqlkTSnT82GFs32++ElgdvQ9BA215Dk9H+I/TWJdgvBFceu4+7r0Y
	+BtC7jtgonYgHDhDoG/3W2sXEX6uWKWtC+4sRX2Y6kADX51S9hJQzTiNzhwFc+OM
	lt4Zr59kwPsAZ2rlIqpyz0uBoet4IXXAJ3N0t2CU3yuViQriS0koJrbKgUXwPLTC
	S/GPsELYYHLcxQQGHpQRXTSeVdLO7bQSS+xeedj8ylgjObyX00Fpz1JRgDgZnwwI
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fu9PF040030;
	Thu, 4 Sep 2025 15:58:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6Q000707;
	Thu, 4 Sep 2025 15:58:23 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-50;
	Thu, 04 Sep 2025 15:58:23 +0000
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
Subject: [PATCH RFC 049/104] crypto: fips140: convert crypto/ecdh.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:21 +0200
Message-Id: <20250904155216.460962-50-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX87clZ9IM+kjs
 4xi0c0MW/T+g/2BcxlMTztMpBJvEIRixVrnhxnJb0Hym7AuUFvx5aIgiXP74OT1lpEYn4Bv4r9S
 CJUGpM8z4uNE/J0Zb/p4LYAPN7VmwPFOOYDpk/pVSkrnHKoQRO6B0rKcdYd10k1dGvw4/t6ESNM
 XlN9llMJE7MV+K6GiUB541Q8jg5y+3hLZxBeHUpdzGjkc71K2ME6hlDB3pSsfERrAyaGEViWmSs
 39LnoUlKB7FtnFMlTZQbqKksxVKnRygGxIW7GfOAc4YMUiTwZZNLWHSDTHjEG//7kv0b2MK2P40
 zrPeaWPKhPZcnAtnqXC1iEVjb/L6qCfbmMSlrujTy3nvx82E+DNeFs0j2hgIlwmjSgG9paWO9Ub
 f7HmW4eh5nJlHXNUccjdWCWx7SFCVw==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b721 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=d0m22meLJraR9QSlNnUA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: dbnWf9J7vJkVpyl87lR098drV5LmSP9d
X-Proofpoint-ORIG-GUID: dbnWf9J7vJkVpyl87lR098drV5LmSP9d

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECDH --source crypto/ecdh.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ecdh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 9f0b93b3166d..32c98cebfda6 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -240,8 +240,8 @@ static void __exit ecdh_exit(void)
 	crypto_unregister_kpp(&ecdh_nist_p384);
 }
 
-module_init(ecdh_init);
-module_exit(ecdh_exit);
+crypto_module_init(ecdh_init);
+crypto_module_exit(ecdh_exit);
 MODULE_ALIAS_CRYPTO("ecdh");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ECDH generic algorithm");
-- 
2.39.3

