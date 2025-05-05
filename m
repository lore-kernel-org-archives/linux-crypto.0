Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7969E1FF60E
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449557; cv=none; b=SLYIQGkA9cur1Fh4eQUeDdyd2Gx/3qKSu8d515vyHauA7cJR9FF5v0O5DBrx+tHuOF14xLn6Qk8jSPushdgZVye6/AzmpJzyvOxW3gtdOWZKVyzWadYnEl6YAbIRlQoxClQ4gIJtqCs/QeCDJlN+L9aD0fuiphYsAxeUizB3E9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449557; c=relaxed/simple;
	bh=VVJPCLBXPKuDZgfijk5Z9PD8hVF5UPOlxRvtNV2ywcw=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=OwebZPMAQ/lOM3thi8H/DqgY+7rIICLydw7LmeVDkAKJRPGcN90tKz3tXwvWnlGftSK+O/kqpMF6f5T0E7n3hiedjPKNyQMnMGkDOmF/UvqVUGbzBYv+2soPjyJfUa2ILNHSL15uKd97Ka+Wi+ze22eiWN0DprMq7WbnnxjNDuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nx0bC9vE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nx0bC9vE"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 544LiCxq009912;
	Mon, 5 May 2025 12:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:reply-to:subject:to; s=pp1; bh=J7dw3XiHYEtL+dQ/wOJ
	oTH/cBeg8i6RBk5Jf++of3RY=; b=nx0bC9vEXqAIx9Dn5fBy/Z8+jwGeO08vOQN
	NjxJcYoi07W3zNbj7O2mhfoJsOmfhBcYBKCC7lB0kVkH+QulbGTEbDmqk4NPO1q6
	WNccgiTrNxRhOQf0+lPGmQqKPstBog/9DxTayVavGUq9bEwQxtUF/btqRK/3aMgZ
	q9As8JlyYK1eiykIRx2TMKTyHqgEX0sjMORyOKDyIhzzSVpq2O4KfnQ4WuXoo4yD
	1f4KUa1a/lL6oEIfJFOnwJzePjvZjbsS1DcqfBAjP+V71DaCZOcqKFHn8zeyut6P
	PuB/uYbYDQbpcFgk1FBPbpC/13VfqiBZBA1WoyiNkjB7sehkJKw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46egcv2w4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 12:52:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 545C0WF5025798;
	Mon, 5 May 2025 12:52:32 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46dwuypcq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 12:52:32 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 545CqV2r22676130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 May 2025 12:52:31 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 385E758054;
	Mon,  5 May 2025 12:52:31 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD3C858045;
	Mon,  5 May 2025 12:52:30 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 May 2025 12:52:30 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 05 May 2025 14:52:30 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
Subject: s390: Still CI failures in linux-next kernel
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
Message-ID: <e00c4e69cbb3f78221e1975b6f9ebf16@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 49rdrTvL6OCxZuGdUAlei3C0dFBA3J1P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDEyMSBTYWx0ZWRfX2jbwZz6Yallv 70RpLn2NyDm9JO5J+AOwYDvxo7d9n8ZXSPE0d+Dc9cQz1xJpbotIDl3BDVKaGH3X+iJXAc3TNaG HFlH3Gdyx+7VjG+mdTMms2kN3xELme4gutWW8yYJ7WNgKGDiPxecNFnWN4eS1gBjEB0D+7JQ6ia
 2pfBNLoG4I+UtT5aMiiwr+7mecV4zRBwaamUTI75WwYMbJn9G7ebO9XIzZiujqOXtsgy5X3GyhF tyvFv1Q6dnS3MIMqw0I0KWZnvVyd+pB2QvvQknAAHrep1H8qBZ0jUK2Woo2C3Ie8izX4mqmvqtN X8tpBLaB7HvClax18fXwwk0trOma6NM2+oZUSwcQ8y3HKP07c2MpwTJZJf6DgMCGqm32vxqtPVm
 uIGqDMoKdMeQ0WxJ4u6c5Tne0BEhwMgp8hw+L4zkSykM9cYIo7K9JJQ6GnxWBbKj0SMykC9o
X-Authority-Analysis: v=2.4 cv=O7k5vA9W c=1 sm=1 tr=0 ts=6818b491 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=7c5RAtW7rWw1o0h8nkIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 49rdrTvL6OCxZuGdUAlei3C0dFBA3J1P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_05,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=578
 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505050121

Hello Herbert
with the latest fix still the CI complains about the sha384 algorithm.
Looks like you forget to adapt the init for sha384, with the following
hunk all works fine:

diff --git a/arch/s390/crypto/sha512_s390.c 
b/arch/s390/crypto/sha512_s390.c
index 14818fcc9cd4..fa6a3a0dba57 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -86,15 +86,16 @@ static int sha384_init(struct shash_desc *desc)
  {
         struct s390_sha_ctx *ctx = shash_desc_ctx(desc);

-       *(__u64 *)&ctx->state[0] = SHA384_H0;
-       *(__u64 *)&ctx->state[2] = SHA384_H1;
-       *(__u64 *)&ctx->state[4] = SHA384_H2;
-       *(__u64 *)&ctx->state[6] = SHA384_H3;
-       *(__u64 *)&ctx->state[8] = SHA384_H4;
-       *(__u64 *)&ctx->state[10] = SHA384_H5;
-       *(__u64 *)&ctx->state[12] = SHA384_H6;
-       *(__u64 *)&ctx->state[14] = SHA384_H7;
+       ctx->sha512.state[0] = SHA384_H0;
+       ctx->sha512.state[1] = SHA384_H1;
+       ctx->sha512.state[2] = SHA384_H2;
+       ctx->sha512.state[3] = SHA384_H3;
+       ctx->sha512.state[4] = SHA384_H4;
+       ctx->sha512.state[5] = SHA384_H5;
+       ctx->sha512.state[6] = SHA384_H6;
+       ctx->sha512.state[7] = SHA384_H7;
         ctx->count = 0;
+       ctx->sha512.count_hi = 0;
         ctx->func = CPACF_KIMD_SHA_512;

         return 0;

Thanks and have a nice day
Harald Freudenberger
