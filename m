Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF8828314E;
	Thu,  4 Sep 2025 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001377; cv=none; b=C0smmi+dokqUCD3oWxo0gysu1UN3tYK3L+oxuWmN5T6mQflfZG1OudlxXQVox03AsF7t+a9yWXlNli7Whr9kCo851aPziY+/WDyeVIQ/z1JIpORrbCnYXjvsG2dXH3qDlzfdNpGnDMMoasS/E6QJRtTg3E2JIWNMlp+ayruCmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001377; c=relaxed/simple;
	bh=kRguSyTy6p6vDyElJDkYGwIZhh4PvcWhYho8EG0TaSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jterFaHSnRdVT4R7Ck3k/anoaYgg3/RXyaiWCMH2q+x39fiQx2Tn27/Ofh/Q0ETVobD8A98bldcaJVISKEZVXM5OgRjoQJCYHJ3AP9iBEALoy4t5s41VS0zYHRJp++klkkwlv/RyT4CcCyCwRwbP8XhXOx+08xpuEMuOPTQiTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pd8y/Jpe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pd8y/Jpe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fje8f006294;
	Thu, 4 Sep 2025 15:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=+5oQL
	hiTQyXwVeZi9TnrXv10ncGU1rSggn+s8YfbYmk=; b=pd8y/JpeWP/Vg55sztxXk
	I8E9pixJ5Jog0Yviv6uBNI7Tc2NrNU7tHGw5xBfC9cCAzI/sJIBbNNnTc/4u7mHu
	OzodbafkG9TKddZmF2ZXMO7W9tjrvwKkDuvzargU+oHlL7mWMfTAcZHInMdL8bAo
	mMJEbIjtMeSrHcLzWE8JaI6STZQn1cF9hBWHtAspl0K0j+MVo1AuDlj+/K0/N6GS
	/ZYPslwdUkohyafERGxoLyAIcivAwxP9MONudl7bBvTFJclwH55Q72EE6Mvmb+OU
	x6mO7lQd01JqFa2NRqp4MGdAq09zPmO2o058tA/rkuBrlFJVuqcLfZtUhmUscqcv
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd0206-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedo3040082;
	Thu, 4 Sep 2025 15:55:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtm82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx52000707;
	Thu, 4 Sep 2025 15:55:33 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-9;
	Thu, 04 Sep 2025 15:55:33 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 008/104] arch/x86/boot/string.h: override memmove()/strlen()
Date: Thu,  4 Sep 2025 17:50:40 +0200
Message-Id: <20250904155216.460962-9-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfXwgFt1PDD2cUo
 JpCFv5h1govAcoHYLsgs0TIFi+ewzG6gL2sMvkbDe1/POwbakcc6+yV1C/gpQbqwuU/N56/uXD5
 I+PgVI96W8GXyoeY3CA41YtwSrvG6hoUf6m+ogusdkKSgEvWlAc+O1I4k5jznTALImiS2+mjklS
 1wGf3KhbY4F41fW81W//PuzHX6z5fDhNAiM7tPJQ2cjjvXuK5S24/RX5nhZ++ElOwojHkQSPTIf
 4w9pB1d60+pnv3muJAYq480Ih8Nj4zy3pyLcrvRezexUTtb3jSJtu42pMR8r8KYyGsUkFlmRkIc
 sNmovxnwP5lnjloh1ybjDT6AWMKm4QXRNiMB3tZ7dvExcSARIPB05q+JPZgvzShM6Wy4oBQsyAQ
 H85MGlHUVS9ikfvJCd/LyuVGBSsOrw==
X-Proofpoint-GUID: bVKXUfMxT6UxCJXj4PZSD14BU2nvqdUT
X-Proofpoint-ORIG-GUID: bVKXUfMxT6UxCJXj4PZSD14BU2nvqdUT
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b677 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8
 a=oGMlB6cnAAAA:8 a=yPCof4ZbAAAA:8 a=KKjx7Jt0W1jpihBkqf8A:9
 a=NdAtdrkLVvyUPsUoGJp4:22 cc=ntf awl=host:12068

arch/x86/boot/string.h defines string functions used by
arch/x86/purgatory/purgatory.c. Other headers used by this file may
pull in existing definitions of memmove() and strlen(), so extend the
overrides to these macros/functions as well.

(This is needed as purgatory uses crypto functions which pull in other
headers that I am changing in this patch series and causing errors.)

We might consider simply moving all of this into purgatory.c after all
the #includes to avoid similar issues in the future.

Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 arch/x86/boot/string.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
index a5b05ebc037d..ac25100183bc 100644
--- a/arch/x86/boot/string.h
+++ b/arch/x86/boot/string.h
@@ -4,6 +4,7 @@
 
 /* Undef any of these macros coming from string_32.h. */
 #undef memcpy
+#undef memmove
 #undef memset
 #undef memcmp
 
@@ -15,9 +16,12 @@ int bcmp(const void *s1, const void *s2, size_t len);
 
 /* Access builtin version by default. */
 #define memcpy(d,s,l) __builtin_memcpy(d,s,l)
+#define memmove(d,s,l) __builtin_memmove(d,s,l)
 #define memset(d,c,l) __builtin_memset(d,c,l)
 #define memcmp	__builtin_memcmp
 
+#undef strlen
+
 extern int strcmp(const char *str1, const char *str2);
 extern int strncmp(const char *cs, const char *ct, size_t count);
 extern size_t strlen(const char *s);
-- 
2.39.3

