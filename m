Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A36A28312F;
	Thu,  4 Sep 2025 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001382; cv=none; b=MHbokXECH5w47LSvcdgGj4ItP3WOzh0C/eNLReysxeHWw6jheq+ELSdYzzc/ewhyXHxK5iQWUcH2Acqt53fIfMvCvJFmxgoeFEIKA+Ty+XAdH4VZCn4ml2XGONKEEex0zjqDpFGs1WjUT6M7896MgVmdzr5vEUrRSglOdyqgGwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001382; c=relaxed/simple;
	bh=4Xkj/5S7zUDammCQ0eht+sM/8/d+fByuBVVOJnYcRnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fEIqv0rMlbfiSWm/OWqwx5Perf8g3LqTt+t/DzTfbgeLpOPmLg/dyyluK+g/kxNRQ4yEDEB76VtXqAIcW76yiTlQigsO4ZV++CFJDP+0aqEgppb15LIwaJuSqOdOl491TBXzUHPyR3aV/Gng6q2MjhnlX1f3c0Fno3tO/WtXyLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XDDMU7k7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XDDMU7k7"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiTL009079;
	Thu, 4 Sep 2025 15:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=wCCxy
	46dNZ9KIy6NEEfs6bTt8B0vQqEaVrlLcM/NpaA=; b=XDDMU7k7I+IigMFs8c/2W
	Cdkv8zhvfftepym3MQmjRzXGrlsdUDRw9GfQCuTLBbTP3XZ8+rwjO1YrNRhXrJtF
	JJrJdokDj98zhxFYMCIKYKBBxDoAqAW2N0FIEAHcF0k2w2K4T54ViRQBEb4gpKXk
	iG7eSsMOL1n5gGzKF7cmxzAG9stsCyyru91ZaScT9w5ngkgA8LbJGm+5yj/APF1E
	RH4MXRgZg1gxLRWFgYmhC0ESz2PDHDlqjcJOJD/2N0aUlF1/lqosIrFasNUgQpIl
	/fT0bU5EHvBHOVmRMNb4QOU1mGA7nQRenVXefE3Bi5qIkAf9dZQVWd/LDHobtJiL
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt003y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FIfj4040023;
	Thu, 4 Sep 2025 15:56:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:10 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5O000707;
	Thu, 4 Sep 2025 15:56:09 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-19;
	Thu, 04 Sep 2025 15:56:09 +0000
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
Subject: [PATCH RFC 018/104] crypto: make sure crypto_alg_tested() finds the correct algorithm
Date: Thu,  4 Sep 2025 17:50:50 +0200
Message-Id: <20250904155216.460962-19-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: RHSWD4DdPYHSht-2Xe49yMy_FHiizMzC
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b69a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=BS3ycM36eBVjgJ0GY9gA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX4TbHGfXm1gtr
 Z6kbQ2PSUIlByWA1+bMoekAo67msMUCcYiIMRpaU0kWv8xhvtFPGSL4QKRSLupaDAaCXIWrm32v
 ib0IGa18z6MsspWQJwBu+fdMPs60WqrdRsi8hqvvMB5yloqFT0WzaB8cTgx0vYNlDNNy3nNqNjo
 b+mPqrvYbZ9KBTaqnqogdRIGr+VfSsBMaRAx1K2qTfQXMEr16IuzPldLop41s7nCq5zbdBmPEBe
 pY/t4zKGLFUX3AuOVLMbVcEaUvb4NBq49b1/T3uNa95L3EYxO9TiyA6e2JPYl0kmzOmijVgCzAL
 AwBtI68HITZhGxCGMKzbPQtSFSWWfQ1NVMcD4y3htnoCtlsTpWFAjockOleDVz30q0RkMICA9BK
 OpO9UsTbBAhihk58HSdI8eVXBU+bPA==
X-Proofpoint-GUID: RHSWD4DdPYHSht-2Xe49yMy_FHiizMzC

Like the previous commit, pass the algorithm by pointer instead of by
name in order to make sure we mark the algorithm that was actually
tested and not some other algorithm that has the same name.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c   | 9 +++------
 crypto/algboss.c  | 2 +-
 crypto/internal.h | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 29076797a938..8b4a1903557e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -366,10 +366,9 @@ __crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 	goto out;
 }
 
-void crypto_alg_tested(const char *name, int err)
+void crypto_alg_tested(struct crypto_alg *alg, int err)
 {
 	struct crypto_larval *test;
-	struct crypto_alg *alg;
 	struct crypto_alg *q;
 	LIST_HEAD(list);
 
@@ -379,18 +378,16 @@ void crypto_alg_tested(const char *name, int err)
 			continue;
 
 		test = (struct crypto_larval *)q;
-
-		if (!strcmp(q->cra_driver_name, name))
+		if (test->adult == alg)
 			goto found;
 	}
 
-	pr_err("alg: Unexpected test result for %s: %d\n", name, err);
+	pr_err("alg: Unexpected test result for %s: %d\n", alg->cra_driver_name, err);
 	up_write(&crypto_alg_sem);
 	return;
 
 found:
 	q->cra_flags |= CRYPTO_ALG_DEAD;
-	alg = test->adult;
 
 	if (crypto_is_dead(alg))
 		goto complete;
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 31df14e37a3e..2599c54a49ff 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -172,7 +172,7 @@ static int cryptomgr_test(void *data)
 	err = alg_test(alg, alg->cra_driver_name, alg->cra_name,
 		alg->cra_flags, CRYPTO_ALG_TESTED);
 
-	crypto_alg_tested(alg->cra_driver_name, err);
+	crypto_alg_tested(alg, err);
 
 	crypto_mod_put(alg);
 	module_put_and_kthread_exit(0);
diff --git a/crypto/internal.h b/crypto/internal.h
index 702934c719ef..1000ce8de06c 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -114,7 +114,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_schedule_test(struct crypto_larval *larval);
-void crypto_alg_tested(const char *name, int err);
+void crypto_alg_tested(struct crypto_alg *alg, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
-- 
2.39.3

