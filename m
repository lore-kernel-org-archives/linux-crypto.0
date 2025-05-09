Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956CF28ECF1;
	Fri,  9 May 2025 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786259; cv=none; b=Ag/CG4CK5gQvsNahHwUixuigl2SLtlser2WOkXazvaFJKdLhT2bO8qSqQMMIwtBm1qiegcaSQej7gfXe7OTqYl5OZ9EPvQzM9oYzri1hx3gO+00PlsAOaocCjwrJ3LX+CbV/EeVpENKUxc08ogwYvO0yZZ4aq9E8ZpvyLVXtqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786259; c=relaxed/simple;
	bh=w2aWgUhrNQ5FGWAqyRn8akhGfsPYV6X6wYXpafDvaBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chiXSoE2ya+PxNaqFU8fRvu/2/NVV+4u4rWpJ9/vOTiYmNL8bVJnK0NC5f8OwvGAfTJB2+gr07nrN7n5T/LvIV6K+qZ6SPCaz+MV/rfzo5OwPf5jeyb0lqtHE45TEE3ohrHCUbX5sr8hoy+bLf4vxRH24WfWjvuZEQOHUp+ZbOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s7QES+KG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s7QES+KG"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5494Bvco017190;
	Fri, 9 May 2025 10:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6UpFWORUw3W7kX4Ik
	08GHcJZL/3DTBhhEf8Ja31wSNw=; b=s7QES+KGiUe2Gr2JB1khsI/wHQ6Jrs0Q2
	+7WpyKwBWLLCsBayy9WMdtoNbYjgyYnv2xT1nd20+wfLk4tlzP2GSuw7wMTA+QYC
	WV/l4PoTdBPt2SOHZOHKnadE8++9voCSZ/g9TJDTO0VewAw+Z2g/vRdfaqBFUSO3
	MNinY7fkso9kWaVnREJyBqNPoQLjxMhviCU/XRYNZRY7cPbIGwj0C1+l8msVSV1G
	RshzXYZWFOVjSXNhoUYT/UDF+ag/ZOzd5PmUKTrcoctTkj7L07JNUw9+E57FSL8o
	D59pUTEkG73LThshrDoIOuLMCl0v/kivIyZivMHpK5dR+VTqgqOkQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46h46ku96t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54991mgw002734;
	Fri, 9 May 2025 10:24:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46dxfpaues-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 549AO3PV49283424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 May 2025 10:24:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D05520040;
	Fri,  9 May 2025 10:24:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5E0D2004E;
	Fri,  9 May 2025 10:24:02 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.70.163])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 May 2025 10:24:02 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 1/3] s390/cpacf: Rework cpacf_pcc() to return condition code
Date: Fri,  9 May 2025 12:24:00 +0200
Message-ID: <20250509102402.27287-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250509102402.27287-1-freude@linux.ibm.com>
References: <20250509102402.27287-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LaM86ifi c=1 sm=1 tr=0 ts=681dd7c8 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=qASoqWdS5SWMYHgLSAQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA5NyBTYWx0ZWRfX4xsR1rl6dKoS Vc6B7dqTH6oF6OWozySdFKRSEcX9yOhQSM8eX+AZYdB7cESZ/icfTr6VUxVRILVZh0tDGqgyDB8 T3VsZuS/X/KyaagdJvduzZUVCN71mVMUSCjRlg9vufbv9vZpgPMK+/QBuXLebTpwXrNDO9xYtD8
 U1DLUDIiUpozF8vpPkCKnhKf0tE70m2eWvllWKpMfWta5MYgGbYZF9e0kjpxuR89YNUpZa7AnSS ttW+ETdHQTo67oKTz/L7yOtaJUslS/v5Jh9XAYP4LfYp7VG0iQmhIW5Yp3k1X6yj8xH7rzQvivN fyGAyBOXQyoVQ949T1pa3ldCf7HVJ0C5KNEE78A0xLfxQUNiqSUMRPnwN6Ny6UapjDBKynuo3SV
 mfE0B9yHdZtqas190WAr5duIRv41uWmUDphJOSyjprHD5wPLbOCCymrqTufSUAFuRC5abred
X-Proofpoint-ORIG-GUID: ZhQVFHWklYe5BGg8Q-ZIms2vcgBm81pg
X-Proofpoint-GUID: ZhQVFHWklYe5BGg8Q-ZIms2vcgBm81pg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0
 mlxlogscore=675 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090097

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
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
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

