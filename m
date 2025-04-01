Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3842054E9;
	Tue,  1 Apr 2025 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743519057; cv=none; b=IUqeDo8iutiI/8FXga/ioykhiD8n3mM5a0SrsqujZ61pA7fTfonf4r91hOClQHLrKaqILaDwgzUxHVrhC8PlXyUmxRuqKtPpPpJNQwI0lQXrvXIq4QH6SLwDXBn1FE2ytnarHqd6cerIu9JSbsA6HKk9mTsmV5j5hgw7cX9zPuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743519057; c=relaxed/simple;
	bh=icvXYfnf6+mik10xHakNJ+KnH+6vJYfQ/YrHCfuR0q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W77qfgCDPiLBrGsi0+dHvQMnF2ko/LJncEH66dJYjwUDOlepu1lGhHs8/JJ7B6LTGUzhuMdheH45NNLNxf8ZlSynSe7xHezc00lZrHotE52lgCXegAtsEL4BnoEXiWRWaXI5ezUVfsV3QS4+JcwAj4qgkLc2IEAJAMmVhxJMKXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bEjCfON0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bEjCfON0"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 531CSpqE028472;
	Tue, 1 Apr 2025 14:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PuoIDNSfeSca8qyur
	PJiLdmFx539ShNpd7aUUNhZVRQ=; b=bEjCfON0HNAFYzIv42Fh41ywkDwwWz0jQ
	F/pzDnQmqkQPA1vvTu8ztywbC/M9aIon9I+lZA1xnr45BdjLQ69Te7iJfD5rLuw0
	qaimPZOByXz5T7QU+nNCvqw4Vys+LcnUj7BbSEO//qigpw/5UC7daJk8obIP9vcS
	FT8eWY4jVZM1P534WclbyL6ccWfgCAuxBf+h4mBQgUeDNnJnG0uYzppLyTi+Ff0R
	uVOWu24PGlSqet2dLJRzlClEqxECcyGkiXkZlsbY5wdrjSZQGW7RJRYz/+E5qCnz
	EuMQD4aZU0tyALt2Kjs8xtyZjvkFRsutaw9p8l7syyg7KydObsHOQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45rg67gsgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 531BPT5Z019742;
	Tue, 1 Apr 2025 14:50:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45pu6t37fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 531Eomms46465444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Apr 2025 14:50:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E24620043;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E04E2004D;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
Received: from funtu2.boeblingen.de.ibm.com (unknown [9.152.224.229])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 1/3] s390/cpacf: Rework cpacf_pcc() to return condition code
Date: Tue,  1 Apr 2025 16:50:46 +0200
Message-ID: <20250401145048.52564-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401145048.52564-1-freude@linux.ibm.com>
References: <20250401145048.52564-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0s_iTfAYMVnqzmgZPAUCroCJAqX1d0IV
X-Proofpoint-GUID: 0s_iTfAYMVnqzmgZPAUCroCJAqX1d0IV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_05,2025-04-01_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=676
 suspectscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504010090

Some of the pcc sub-functions have a protected key as
input and thus may run into the situation that this
key may be invalid for example due to live guest migration
to another physical hardware.

Rework the inline assembler function cpacf_pcc() to
return the condition code (cc) as return value:
  0 - cc code 0 (normal completion)
  1 - cc code 1 (prot key wkvp mismatch or src op out of range)
  2 - cc code 2 (something invalid, scalar multiply infinity, ...)
Note that cc 3 (partial completion) is handled within the asm code
and never returned.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 59ab1192e2d5..54cb97603ec0 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -649,18 +649,30 @@ static inline void cpacf_trng(u8 *ucbuf, unsigned long ucbuf_len,
  *		 instruction
  * @func: the function code passed to PCC; see CPACF_KM_xxx defines
  * @param: address of parameter block; see POP for details on each func
+ *
+ * Returns the condition code, this is
+ * 0 - cc code 0 (normal completion)
+ * 1 - cc code 1 (protected key wkvp mismatch or src operand out of range)
+ * 2 - cc code 2 (something invalid, scalar multiply infinity, ...)
+ * Condition code 3 (partial completion) is handled within the asm code
+ * and never returned.
  */
-static inline void cpacf_pcc(unsigned long func, void *param)
+static inline int cpacf_pcc(unsigned long func, void *param)
 {
+	int cc;
+
 	asm volatile(
 		"	lgr	0,%[fc]\n"
 		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,0,0\n" /* PCC opcode */
 		"	brc	1,0b\n" /* handle partial completion */
-		:
+		CC_IPM(cc)
+		: CC_OUT(cc, cc)
 		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
 		  [opc] "i" (CPACF_PCC)
-		: "cc", "memory", "0", "1");
+		: CC_CLOBBER_LIST("memory", "0", "1"));
+
+	return CC_TRANSFORM(cc);
 }
 
 /**
-- 
2.43.0

