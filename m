Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA35B3CBE69;
	Fri, 14 Aug 2026 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717338; cv=none; b=Uc7qjtG/dl0CAc8jtwLmHILFD+a6OBpA6WZZ4ZosTkMCCB9FOy/0+JhvTiYExCHvOIMzSSf9zinTpcEZ/wK2VOQ/eHqt3U4jE+V+aEj7yxlQKx8jHmn5uQSTSYZkfeV/mNqy0dmB4eQhxxP86zsjPBkzVakA4LBOXpMRXhmfpro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717338; c=relaxed/simple;
	bh=AuT4kG+JRCReG08hIpRRd0XaRdsTUlVudGAlkk30xJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=it+x/3mk8UMwLwTikpl4GjoWHKUvwXfFvCl1LSUm1Ulj+jAgJvQUOrEKEYyq5kbEzwLHrRTP9VHI31dGFG/CZRCYllOHaaPRIFKlYuMYS3IswleTwlkihJV5siPCqqT1ofoUEmEovHpNfb4xnc+aR4Uc2UTpRSCeCAM1cFKWX/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ATnzvvzm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ATnzvvzm"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5hBc230234;
	Fri, 14 Aug 2026 14:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vYK126AgMjw8fldJsoA4wmKNQ5MhmSxuCageiXlMp
	7A=; b=ATnzvvzmagckDW72oQJ/a3GKsjcz9MDLpo9/AhrF7NtG+PeyacbZW/wHE
	L+m9HY6N77WPOP8Gd3RdGcRYwTzjpSETgmzO50q6QWZ2B203QuVNe8nust/0a6/V
	XbIyYv2IdX9MmTOi5RhTgBnctM75jnYXl0PMCu+pJyVlml0FNLIcaIbR5r8SV1sy
	eL/X0bgxsOm4Ehd8lAQE+FoLcNS1GaFWWyBo4CPiGtBj/vRGO+Nk8XAVI/igO3KO
	1xPE/iEiRXM+DxoYYgHCzHtdr/wkPcnUYIXc8M3TJiknjsq0IXOF2L7UKR5J/XEp
	kfkZFWxr+f0AqPjrMqatGMfkc72KQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb245c0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEBgpm018550;
	Fri, 14 Aug 2026 14:22:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsk7k38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EEM0Ww26673818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:22:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B492005A;
	Fri, 14 Aug 2026 14:22:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99B452004B;
	Fri, 14 Aug 2026 14:22:00 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:22:00 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 0/3] Fixes and rework for paes_s390
Date: Fri, 14 Aug 2026 16:21:57 +0200
Message-ID: <20260814142200.65821-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7f248d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=lHN3Zz1D3HwQsxywWf0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX+CFy3JUtT3S/
 Lc5FzSRx5pmEU51p+L3sGyjKbVcA8ST2iVNyNDSrwzXtyVSI6Jh82QT/pK6/pb2Y66a/xhfB61K
 oz0zvKTqyyn1eZciplNzdbBi+to43ELPFAh6KGffoHdOFfVEi/GOTbd8faSNfnn0sRx6KqlS001
 cxKYsUjedoZW0FilZ3IyCT00JXGdLxIMdh8FKixkLRy803hVEJTYorSndnSX4zSPwZ7dIpVkJii
 oviFk4v7Z5ynbjgoixXR1c1mluO2EdtKnpoiz7+xc+kxFfw3N9KzqjmPNzOloU2GrGvam7QxjZ8
 kFltZ2ICuyVfeYj7GYBHyV5iz/N5a66kh8t8WtE8lcm4LphLTV3HsIkVJoJpW/lkPwStSaRwtIR
 xwnTDJ09y1PjugRih4Ui0Za9PWJGz7R6NxI1IJEVfw/o1oPsBN7LZXwATiviDdc6gUhKimcx5mn
 DlHCsvmt9UCexfH/CtQ==
X-Proofpoint-ORIG-GUID: 7_1JxbugTR65XaQjh6taz_f5wR1cuB7E
X-Proofpoint-GUID: 7_1JxbugTR65XaQjh6taz_f5wR1cuB7E
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX5Csc7en7YDIp
 E8TA/BhSyPM2ieQ5tIJeWCUHFL4SCrSnheD7Xl5+HtnnEhxnOpmZVX9O+znJVvR3hqrKW6vLB4c
 rHQvydxkyxwaKfJihdcWgfSRjscvbvo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140107

Fix and rework some issues around arch/s390/paes_s390.c:

- Fix skcipher_walk return code handling in paes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in PAES CTR
  Surprisingly clang code analysis is able to deal with semaphores and
  thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.

For more details please see patch headers.

Changelog:

v1: initial version - however, all these patches are follow up patches
    from a similar patch queue for aes_s390.c

Harald Freudenberger (3):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms
  s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
  s390/crypto: Fix use of mutex in atomic context in PAES

 arch/s390/crypto/paes_s390.c | 56 ++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 19 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.43.0

