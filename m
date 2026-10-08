Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F80D443C27;
	Thu,  8 Oct 2026 10:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456772; cv=none; b=Zc+qGAfbJ098jCSlexXS/ZQqvOcXttbIIvIXnJhGDiBtkoRxC15BZMIV8SGLJjooPg24/v6PpGsBVJLPOnvmvahSE9R92KyUPLE+O9xB+5yP7S+4I0f/pd83bMYs6xMT9rWS5yq+7yxBdDXC8Hdq0RF9dHnd6T8EoQ0jnHvsyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456772; c=relaxed/simple;
	bh=G7YBsRgr85qa33RsLT0qYEHA9dUgSAjpHsBy8RolIxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDPK4DCsyrp6b/UqayYyuq8fJ+/92SPsyzAT42DvZoOqjLk4asa3gvz6dzuj8rXk2WTJ1fxxWBSeDl5WII4IJjss0xvrO9z/OAp47RIVskIbj9N/APKoEK9xlwx8sHTdB1+kIC6VCxCR3/hMNRBZKxCGCs0+Ysoy8kgY1+G/qNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tEFSQhWb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tEFSQhWb"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698AbdY71164539;
	Thu, 8 Oct 2026 10:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+mNqwD7TZS5SzyXFE
	nAlhXIptihnVt76hDDpn2Saebs=; b=tEFSQhWb/gPf02K4pL7HE7fWFuohKxIfV
	jAoaimmV//xXnNZKwIsebJay9uixo9KZg76KOcCpUepI4HqTQf1x4m6M7G2lKzLZ
	CraSj7OHnHe6RdLhpvCao9QcPCscUJftm7jCeRFuVoCgew1qOFdFiHqkL/PuEjZf
	Cbo7cglydnaxv6FGywhfI1+eCAIqCb8Mt3bDLq2BCyUW3FQ4rgU3VMRDQWTk23TF
	okAm5+jVSj1a1Thx53xlg5phodwYdiKUgqX9a+QzMySBM6qWTbO90rvREt5fHW4z
	7iiZVeoOUIjD56evMLGffz0dWOzSzJ8kZnGljse2WeDV38N6B4gCw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvu379-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 698AlVJY2101574;
	Thu, 8 Oct 2026 10:52:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5f3twsjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 698Aqhp637814668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 10:52:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C45620043;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 447492004F;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.224.94.37])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/2] s390/cpacf: Rework cpacf_kma() to return condition code
Date: Thu,  8 Oct 2026 12:52:41 +0200
Message-ID: <20261008105242.20730-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008105242.20730-1-freude@linux.ibm.com>
References: <20261008105242.20730-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dZEDFR0cqZGobOK_hWPed0OhpuKaVV3F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfX6QfmsqnX4hFc
 RgW3TSJlkCeOITOQyFs8Y8h8d8EAzM4kl0frSWbA53TTpSyE9rE+Wq3SwDnSVnlebKh/REclXIw
 veiGhqIVRX72pHXlw/VR/ArHF7MGgC/xGS532RS2trFSj7veT+xZH4kQHQe3b4hESVX4mRqGHqz
 skSaGUlWdX49vphWOTBg+Dk/qxinl6mqMjS+cC9ZzPmRnYqr0HyoMjde5ug2AKFNkh6vqw+C9Pj
 gPbF+pC9BDlC+gQxx9r7igVCRhLHZbW9nI2mOod4aAuW0Qlu2cpxAulZPRawPZ7x3VjhHm0MW6N
 MfV1DQz1z0zquCmkcA7bi/Ynt+K9rMiP/NI0OEcis5MkwJHjKp+tk9w1M+nPuIMC/v0naBNUsEr
 ZzYCao9L9sdLxHbUdHsI6hILKvk2BIC+aJPUBiv2nGkNClpcBL5krQX7q6fsXVOTJIylk9KBCju
 xNTo9jLvKmypgcJskKg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfXwFBgtpa8Ldsi
 YSfFrHG9NmKh8TGr/FW37dPJO6Sw/l3GSsXHg9AjVtH0pcRFV1TDl75DmBRlE7yUM8iiLKOLVjl
 1jmErtKWQ8+YduMdNKxrDICpWPPZntE=
X-Proofpoint-GUID: dZEDFR0cqZGobOK_hWPed0OhpuKaVV3F
X-Authority-Analysis: v=2.4 cv=FLCOVOos c=1 sm=1 tr=0 ts=6ac77601 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=uZ4CQENtAJyrMlTU58MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080042

The KMA instruction can signal a verification-pattern mismatch (CC 1)
when a protected key is used, or incomplete processing (CC 2) when a
sub-block-size chunk is submitted without the appropriate LAAD/LPC
flag. Both conditions shall be visible to the caller similar like the
other CPACF instructions.

So rework the cpacf_kma() inline function to return the condition code
instead of void. However, CC 3 (partial completion) continues to be
handled internally. Also improve the function to use the CC macros for
better readability. Additionally add an kmsan_unpoison_memory()
statement to reflect the updated memory by hardware.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 6174552d856d..00aca3194b67 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -715,12 +715,20 @@ static inline void cpacf_pckmo(long func, void *param)
  * @src_len: length of src operand in bytes
  * @aad: address of additional authenticated data memory area
  * @aad_len: length of aad operand in bytes
+ *
+ * Returns the condition code:
+ *  0 - normal completion
+ *  1 - verification-pattern mismatch
+ *  2 - incomplete processing (see POP for details)
+ * Condition code 3 (partial completion) is handled within the asm code
+ * and never returned.
  */
-static inline void cpacf_kma(unsigned long func, void *param, u8 *dest,
-			     const u8 *src, unsigned long src_len,
-			     const u8 *aad, unsigned long aad_len)
+static inline int cpacf_kma(unsigned long func, void *param, u8 *dest,
+			    const u8 *src, unsigned long src_len,
+			    const u8 *aad, unsigned long aad_len)
 {
 	union register_pair d, s, a;
+	int cc;
 
 	d.even = (unsigned long)dest;
 	s.even = (unsigned long)src;
@@ -731,12 +739,16 @@ static inline void cpacf_kma(unsigned long func, void *param, u8 *dest,
 		"	lgr	0,%[fc]\n"
 		"	lgr	1,%[pba]\n"
 		"0:	.insn	rrf,%[opc] << 16,%[dst],%[src],%[aad],0\n"
-		"	brc	1,0b"	/* handle partial completion */
-		: [dst] "+&d" (d.pair), [src] "+&d" (s.pair),
+		"	brc	1,0b\n"	/* handle partial completion */
+		CC_IPM(cc)
+		: CC_OUT(cc, cc), [dst] "+&d" (d.pair), [src] "+&d" (s.pair),
 		  [aad] "+&d" (a.pair)
 		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
 		  [opc] "i" (CPACF_KMA)
-		: "cc", "memory", "0", "1");
+		: CC_CLOBBER_LIST("memory", "0", "1"));
+
+	kmsan_unpoison_memory(dest, src_len - s.odd);
+	return CC_TRANSFORM(cc);
 }
 
 #endif	/* _ASM_S390_CPACF_H */
-- 
2.43.0

