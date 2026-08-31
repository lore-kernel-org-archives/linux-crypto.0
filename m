Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA63DB64D;
	Mon, 31 Aug 2026 08:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165474; cv=none; b=uiFrsMaow4gx1nFp8EEU2+G3MXFGYfKLcmbUyTlj27D3iNzBCchgRNfs26RRF9IBTOpMicvZwyU1vTYCH2iXO2vAFmI7sqEvPHmOHT+W7XQj/mESkZk+VrQPgwApYoUiYiFAE/SBFIKBxnREXzULMXXZN4tCXHGY2iW9mZr3thY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165474; c=relaxed/simple;
	bh=G7ZywpBC+75zh+zL73aef0FOPrqV9wIkpyMSjzs4DV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHMKQp/BD7ToSTpQmkIm1mBSk9hTk2Ep2AgybeHniCiPHwetFRqd+tEYEyzS7q1u10TZXWG6AUTCcgam6MrlFVzuYhHOJYoWYBWjQq5lX6yrtUCsxJUhymIVyJ4cXv0YDk6O3ub6Qrhv/hF77wmTJWjuZf1T0DcNAoHBC3Wl7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pWGpX7kd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pWGpX7kd"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82VHj3960350;
	Mon, 31 Aug 2026 08:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fxMCve/s4aIGx1NOC
	V5XdP0EX1ukXa9oguWTujuNyFY=; b=pWGpX7kd2X1VRVAXCvmqeIFPWdrIVFbzN
	X7KGPyspaES62Zz8RbjUch0nAAEPK/noVC88ll3Gcs0cT8U/J99SkS8xqMFpZReS
	tNWy/KKqCa+Dx+4YmLlffeKclZLk6hQTz1jvR0xupkStxkYLxlL30jWGKS9IrBRh
	qfCmIehHCpq1X71oOEwf+uQN6VBgsCDOyDlLcxX+4j6qoLMG+4T77J8QyNhEG/87
	UK3TAGX70+xA5DHaUUndf2MSPrVBcFrZD3XGsM1gn6UhhuRL+cxeILlZmbJIliWb
	KJZRYlEh0JmGBwDa7c0HBWNUB2a2Nq6cCAG0wm8pQub+HmRJmgpsg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq3r037b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QK70009978;
	Mon, 31 Aug 2026 08:37:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcarjvvgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8bZLs47383036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:37:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBD382004D;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CCA62004F;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v5 0/3] Fixes and rework for aes_s390
Date: Mon, 31 Aug 2026 10:37:32 +0200
Message-ID: <20260831083735.3625-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083735.3625-1-freude@linux.ibm.com>
References: <20260831083735.3625-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EIc2FVZC c=1 sm=1 tr=0 ts=6a953d54 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=ThbNtLrIaRZL5PN1bA0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXxM1j2mF5/pSR
 Gj6CAZZnvf0ht9hPknXnk7m7IWPmr76kvPBc32GuzvDEspsZdcVcwCmjToQJyJAeJVMwx4yv8TG
 dtwLw6Ct0OS1cxJadKoyrnbi5Gg1osqDUgPTb4t+Il3+fhmyRsBIiGOp+ESNSuH5F509b7YSA4+
 Er8vQQliAvMdFFSCL8K97s8Jb8iiz5frpFAt3iKoT9/o7O9iwIpFwkhcUfjXPu2YmkT4eVo862m
 6JpkYe7usuvc0S0hs3PnXSZx7eu2BovRR6WM5LmcB6Oo0+DPK7U5uAAN1TKq1XzdWghyBYw4rg2
 7CfO2Pghl65KgVHEDGws3z5h/EXMOTkn0pj15s/07wdwAcinSLfU9bc6NtxgOK7cT1zhgbTTR2F
 N1xkRXh6oHJ/3u8fkrkonzfvdsVmqiuarjHcr1zKt3cvm1RObZkUDW8bkNU95wwcd6zdjsJZ76o
 1w4aXQwa2WThOjjOzqQ==
X-Proofpoint-GUID: irOZnBW_WKDhb_YrpMmjriqpU_i8cvGy
X-Proofpoint-ORIG-GUID: irOZnBW_WKDhb_YrpMmjriqpU_i8cvGy
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX32AKG5RNh7XC
 dSN4FmFWGx5Isk2Ek+m7k1fufmJnq5CzTboOCodo+Zswl7epB4xG3YU10xjZo3X0S0/vuF+6T8W
 vMnk6aHujqsmYY5XXIVdRH9JzjyV1MQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

Fix and rework some issues around arch/s390/aes_s390.c:

- Fix skcipher_walk return code handling in aes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in AES CTR

For more details please see patch headers.

Changelog:

v1: initial version
v2: Fix missing scrub on a temp buffer used to process left over bytes
    in CTR mode.
v3: - Yet another buffer scrubbing was missing. Added to the 2nd 
      patch and rephrased commit header.
    - Added patch to fix one warning with context analysis regarding
      the handling of a mutex with the AES CTR implementation.
v4: - Sashiko found yet another buffer which was not scrubbed.
    - New patch #3 which shifts from using a mutex to using a
      semaphore in AES CTR as this algorithm may be invoked in
      atomic/interrupt context.
    - With the shift to a semaphore now clang is able to do the
      context analysis. So the patch from v3 which reworked the CTR
      implementation is not needed any more. Note that paes still has
      the issue with clang context analysis, but this will be
      addressed in another patch series.
v5: - Added R-Bs
    - Reworked the mutex to semaphore patch to also cover the need to
      get rid of the conditional locking.

Harald Freudenberger (3):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
    algorithm
  s390/crypto: Fix use of mutex in atomic context

 arch/s390/crypto/aes_s390.c | 87 +++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 32 deletions(-)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
--
2.43.0

