Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B52BCF5F
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 08:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745917068; cv=none; b=fAoBiqRCOlYPNgr1Xgvo8k2yijydWwuSn0Bd8UTIO5g4a1HaHp93LiK/xKES6kDwrjDywf9m9ylo4XL6+vDM10xUbzvmTnLO9bddMUeOxCb+F/G7fAiQt3dB8bZP/eYu7j6d+7mhlJx8FNDm6pAI0nm1dnqRasqjfDQ3eQfGihY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745917068; c=relaxed/simple;
	bh=QekwfPSQUfzPAsI7zbh3tQ6RgYJFgCkChQj1XZ856PA=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=WfkGYqYapKYtKO0RNaMWtXgsttlRUrME8N9sKxi3eHE72DsV7eX7G0dyDDqZ2vyV9oXZGYIjeyYLNRPQHHSgOaJuluqUze2Q3SP3aViUvWxKnnR+Ocnzjunf/ETKJonr5IWaAHnet9FbPI86McU3WoSBfmOhAjevTrkqk+v9Rio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DbKJBItq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DbKJBItq"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T4EXud028608;
	Tue, 29 Apr 2025 08:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:reply-to:subject:to; s=pp1; bh=3Xlf90PsADa9hGAwzI+
	O3dchW4Ca+HVszieSAmwzdF0=; b=DbKJBItqxs/SQiqbnpIhG3oUJWSvFZ+ppsU
	dq3NO/9WY6CgF6Tfm0eQ9J/j3qOWc7Mi6OO3BLZ1EZ/VU0kHzriM0M4hgWxZfJBN
	9CCK7lOhGjcibYZ4OT8NjWSTycaZEDMPQC/duFIWQD3y+51z12wd6wTiIa90AKHh
	AtyA5qK0DvbmNgyoEjO79t6dDOC23dCz+aXBKtiib80w+5iMRBMP+7/x9ITbtIRV
	oX1Og+sa8jAD3t6lsL3p+XaSYG3RGoTjVbG9m55zprliaSv58K0S6/AuuAAj5uWH
	WZ/sT7IuJ+AoUfhzbS00cLqWsonRd1+D8MCa/O9Ern7PvNs7frg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ah8ma8ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 08:57:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53T6APrX024679;
	Tue, 29 Apr 2025 08:57:41 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 469c1m27tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 08:57:41 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53T8vd4x6357698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 08:57:39 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55F195805D;
	Tue, 29 Apr 2025 08:57:39 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 199A958056;
	Tue, 29 Apr 2025 08:57:39 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Apr 2025 08:57:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Apr 2025 10:57:38 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Holger Dengler
 <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
Subject: s390: CI failures on all sha kernel modules on linux-next
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
Message-ID: <632df0c6adc88f82d27bbabcc3fc6d7f@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vtozriRCOrGPSOBjVTBf5C-FspA1YnX-
X-Proofpoint-GUID: vtozriRCOrGPSOBjVTBf5C-FspA1YnX-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDA2NCBTYWx0ZWRfX6DH9edC4pydq RtftBw96IWwkQNXXvjzULcvgOJYycaEMyp/25mtEIyq/UOGCdTlcnLyTfABdpNCiC8KjRvOE51p 7m8UC31h5K5JC2DyEvdtNVpnOVWkqLMIf+hCg1fKc2AP7sgQaFXseoXIoTtp1s/ia0C0pP2uCsY
 8chLRJQeyCX4F9MQgtXMHzEgXjIFk9eo2hxfCAYUvzSGeQ9XtQEn5xQ2NBk6bAI0fYqi300hxhX 4F9w5YhvlxkjheVzGN4ohNRbtEqkEEn7opr4NLqEcz4ieJgTcNHCWnRgNTGDCxGXwPPFGrV0vbB ODyf7+0HFAbVdSqTsexTnL/h12RXv2BQSIxT8mfMqOPyYIXlrEI29+bOhz/bvmyjxYkjGlhnEI5
 RQQbY5beMey2P0hc8y9zALGPJd7EcqfYpzpybkLuoE3t9mfiHEmV5fCjAn+XnYruX8PUOcJc
X-Authority-Analysis: v=2.4 cv=QNRoRhLL c=1 sm=1 tr=0 ts=68109486 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=wCzuwi-FhD5YxeNnkP4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 mlxlogscore=629 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504290064

Hello Herbert
since commit 572b5c4682c7 "crypto: s390/sha512 - Use API partial block 
handling"
all CI tests related to sha kernel modules on the next kernel fail.

Some investigations shows that modprobe fails with -EINVAL, caused
in shash.c line 477. After some reading through the commit I get the
impression that the root cause is in the sudden increase of the
alg.descsize from 213 bytes to 536 bytes. This is caused by the
modifications of the s390_sha_ctx:

...
  struct s390_sha_ctx {
  	u64 count;		/* message length in bytes */
-	u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+	union {
+		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+		struct {
+			u64 state[SHA512_DIGEST_SIZE];                  <- really big
+			u64 count_hi;
+		} sha512;
+	};
  	int func;		/* KIMD function to use */
  	bool first_message_part;
-	u8 buf[SHA_MAX_BLOCK_SIZE];
  };
...

as part of the patch. Having a close look here gives me the strong
impression that the state here is way too big and it should be:

...
  struct s390_sha_ctx {
  	u64 count;		/* message length in bytes */
-	u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+	union {
+		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+		struct {
+			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
+			u64 count_hi;
+		} sha512;
+	};
  	int func;		/* KIMD function to use */
  	bool first_message_part;
-	u8 buf[SHA_MAX_BLOCK_SIZE];
  };
...

instead. With this modifications all our sha modules do load perfect
and the CI tests succeed. Please check and maybe improve your patch.

Thanks and have a nice day
Harald Freudenberger

