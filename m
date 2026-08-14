Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB8D3A48E2;
	Fri, 14 Aug 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717245; cv=none; b=SNeLsrD7+sUR1EwdLb6TV7kEY9RVmZ6zUlRDwzaNOL+c63rcHqqTTvqEAQgzTi05leiH3w82GJgOVfKwvKJDgYbEY/U/MqmFYtX5j/+GEasVhFIHWS54bFVUhrEn7VoQVRiP4KYRSShsnNQsQ9I4GqCuUr22aRo26aHb0sVsL8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717245; c=relaxed/simple;
	bh=DA2wdn5ea8Ylny9hqKDCyo16BUN9OxzHzWmDKoQO2TY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TvVZbtnuvCeE86pQYHtg9vZSc+ENjePkjcy+qAT36EyT2AFNyTy2LlZFJLq65XVCbQQFb8Q3J6kw2k519Ci0IYDy9zmhhWXs/0S3ioiKFfc8r06S+4yiCyiIosPYBuT5Tl1MCnheEB74LWIAWEQZy0P0lJ3YvkOvOrjja/XVgx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D8uDB+Wo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D8uDB+Wo"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5cUK1342816;
	Fri, 14 Aug 2026 14:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=y6zrUYvRVG7UKxi0l9A3Fx9Bg5jsKL8jsjRoRMmOw
	lA=; b=D8uDB+Wo+UzvYnIILIlwTc+A5c09xA3wXt/usCAOO5polDiu0469yybDX
	ewqPp0UHIQbHJ7WTgcIAMtVgKKIB7ZJdmPasQwU6XmOQeKKh6fuEOFlZlfpePBn5
	75S41uyMmaZxeiyJkkAMh8llcGG+QNVfTlaGT7FAIuoOPO1jKcli8OJO3g+91vPO
	4ssAIHH2AZkKmzdujEGdYn/TatV9sEy7kCXm/2KPNkCXsRAiFDfSkw6gx5+/UXtE
	6axVkcVPNEQfJ1+Njg74OD6gVhYp3+R26sU/DoZiQWqbo7j0pMa3CtD7ezsA5KvI
	1/hKWjz9jbGiv4Ywy+lvHQ7CDHGug==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma5837-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:20:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEBd0r019023;
	Fri, 14 Aug 2026 14:20:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqfrgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:20:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EEKBkT52166978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:20:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C1362004F;
	Fri, 14 Aug 2026 14:20:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C2B720063;
	Fri, 14 Aug 2026 14:20:11 +0000 (GMT)
Received: from ibm.com (unknown [9.111.74.75])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:20:11 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        ifranzki@linux.ibm.com
Subject: [PATCH v1 0/1] s390/crypto: Generate iintermediate chaining value on export
Date: Fri, 14 Aug 2026 16:20:09 +0200
Message-ID: <20260814142010.259918-1-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX/iRT9Xjo6Dyx
 npaUu5i4oza/KiCRxqUFoWEzvvZWPLhOR3sorqjZIz/Ia9HuzKEg36KBdNj009lo0vOEYlkufrY
 gQ5EAr/K1GiXXWLQE/47TbCjtcOEjrua4u88Fl3nnuTRgYMqizBJ9jfbvQVkVId32AIACjKmLp6
 SHXyDbwtOQmHLTTbQdrxM9k0ytOPw2v4/tVEhnRi5piF7910D0kQmPRbzPse2i8lIONr+3+CxTY
 CUt3ng0e+eZdrtHxD3VB/YFl+96uJgSG3KUwUqKfRP4FhYYfMsnzp7A8ylDRFthZhSirSvZSuLN
 fW4McFC+Hr6uQCBuCQJG/yJDrlYtKDMWL0b4yMMflfjPdUQE7G1I7Tndgkmwn4EZJpSWwDzDq0T
 dzwiOy15cembr5j9iJaUKjbkmJcojUaB7w1XzR9ceTu4nhwF5wdhDPNrl/QWCn5yPvB9YnxJw+g
 rhxRrV5a5xw0Sc9I5Wg==
X-Proofpoint-ORIG-GUID: clnk5dZD0Jn6cJpsuNlDHDrV-1wFG_Zm
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX9152gPhL1sWn
 xYvqHnrsQSRRBxhhVQ5pUyg9livbxxKx139PsnlPkZTQohSWMnXKRTXaYKiHncAyvGnsxhTdre3
 4zSqfKKAp6p8S9kjZgFVLEiQoU4Y5qk=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7f2420 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=5ieSq8BazLGiE5CZQLsA:9
X-Proofpoint-GUID: clnk5dZD0Jn6cJpsuNlDHDrV-1wFG_Zm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140107

While exporting the state of the hmac chipher, the intermediate
chaining value (CV) has to be calculated. Calling the KIMD instruction
on s390 will generate the correct value. The code already sets the
correct function code for the instruction, but it calls the wrong
instruction (KLMD). The patch just fixes this.

This series applies on top of Linus' master branch.

Holger Dengler (1):
  s390/crypto: Generate intermediate CV for API partial block handling

 arch/s390/crypto/hmac_s390.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


base-commit: 2f1baf1fc8929e6c48370be543ad028ac7ad4131
-- 
2.55.0

