Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BEC393DE6;
	Wed,  5 Aug 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941598; cv=none; b=sz3l6wCHItMVsVbFwF49EOv8VHc6GmH20gqsMZfVlDztMDFvBvkWPLTqTjblLY7SmX90Lt+3dHc9tsRp+aCgNvAOr5Ap+XUcwvL6kMUf2HoAZVNKuCJvE1ou7aSca7ASxRT2LMfKeT9OqKnU/Oi2VB4s1XRdPAOBSEK3E42NtMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941598; c=relaxed/simple;
	bh=2O8azP1jH0LIZ4QthGJg9zfZ2J1oY2G4y8qA/bRt3G4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IBG7f51GtM3h+WsXsVYN6WnzWQaSdH5U49bmxwjgAqIOOSvj+oHmzDHfBs2SQL9uNCH8GQ6XiGCYUuTfzdqE6Ztzqy4KZGE2WfNtucTJPkV4JavYXbh1/ZvsI+uKgsq4Dh7H9xt1ES04iJeOSdkqxn9mX1PhpauIRYu4jABG8c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XK74j9di; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XK74j9di"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675CHda53725283;
	Wed, 5 Aug 2026 14:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=W2qGd8Jmzj2Hi62kZ3Yc8qZ5aH3zqfIuGqEdgHZpm
	Ww=; b=XK74j9di8YI0X4b704bBInlrwXtK0X+3bt14TPB3iqDyA3HDGJtjKi/Vm
	hmvDiUC+X3TI2gjUYawP+Lyv7uHxtsbTxH7FWCIvR+ECpWwJ8u+NoJRIfwf1WqFY
	JEjgxNC2M0dwsiLS38hxF+wsIVqGFRUAiU2scq0LTd7CmhyVQ9vVFUeQAVJjU/av
	qZlY3SV0tnQMp0jvRmkhiBXCcxZiWL64oeTktVorpU9C2dDt09GbGLcneXApgoOe
	qss/puqBNRso6wWwS4laUfPFC6+kYJ9tUF0NkeWJYRT4BkbykJnPuFtUp6JbJNZ7
	PVMkX3JcVUUfhx8gexl3C5H0uWiiw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67huc3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 14:53:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675EfIvl011488;
	Wed, 5 Aug 2026 14:53:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw744k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 14:53:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675ErAQo32833890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 14:53:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F1672004B;
	Wed,  5 Aug 2026 14:53:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A59520040;
	Wed,  5 Aug 2026 14:53:10 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 14:53:10 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 0/1] Fix skcipher_walk return code handling in aes_s390
Date: Wed,  5 Aug 2026 16:53:09 +0200
Message-ID: <20260805145310.13130-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyMCBTYWx0ZWRfX8yrA+P8RgvKG
 in+5k3HdQUX4HwkxFCevsFPd2pnldTWtGIhSkeSPfvS+DEF8wnyakFqlSHr7/QgY6HK6hutDtgF
 qRwKSoa+ie+RD5KbxtR2/2xW0VMPNXA=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a734e5b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=s5IaBbAnHO2ZuBJA9J8A:9 a=zgiPjhLxNE0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyMCBTYWx0ZWRfX166GKBRNcFjM
 XV/ODPKQy2p5x6LiW2jD7uhdXz+4nLWgfXbbvh8l1mA1fg7gG0zwFdazSoXVd8EQI+QWDKlDktx
 GpOTd5WYreYi1TA9wPjfuPBXtwtrjwJ1L5svNRwc7IoGErbCXGuYtmaAV66wQMExnn+dDosY+jh
 +aJtKH5jBVRX/27dsCr+OjSisDTl3uk2L4eD1v7RStwXtts3HbiM8YhJq6Mp+SuRp1eo4E0tm8D
 WfSvsPXwMDixPNVOlIyTl/EAe8IAQ8/ETXUVD7c7VyikyMYW2aJw92UqVZpT9nTMB30SqWg8xxD
 pYKyG62y9SqXE1XFxeIxfsYBI9UVIYJGud/5RlOHa6kKyTK/fkTGB+KOs4hxRQJlM7Ti9QKzzY8
 irkZ0i5rZJxTUnIuKR5e/Sy50o++h/sm+pjRDKhLEj4S8k9QiyJ6OSkBC5wjcEIkk7X6fnlP+Bl
 G9n4qPURWCAj+DIqVlg==
X-Proofpoint-ORIG-GUID: mJDej5bRt67O_3NSFqthwwr6PxITdneq
X-Proofpoint-GUID: mJDej5bRt67O_3NSFqthwwr6PxITdneq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050120

The return codes from skcipher_walk_virt() were not properly checked
before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
If skcipher_walk_virt() fails, the walk structure may be in an undefined
state, and attempting to process data could lead to incorrect behavior
or accessing uninitialized memory.

Add proper return code checking to ensure correct handling of the walk
initialization and walk advance and eventually return to the caller
with that return code.

Changelog:

v1: initial version

Harald Freudenberger (1):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390

 arch/s390/crypto/aes_s390.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--
2.43.0

