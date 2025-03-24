Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B8E19C542;
	Mon, 24 Mar 2025 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742810704; cv=none; b=qCv108Rz9tRkSvnWWrcKBy4IY8gsGJ5oeqUyYazpctbmHQOU/BvJ4NUyXNTZzlicGiBCScgzBOtemyIUa+o3CtFBRSes1XDHdYgqYkBWLdzDgW27hwyrRHSWI07n5AWM2HSMlDEI9ExcOFZGMPRwoU6Q5ra0COjcLUBHiLQc3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742810704; c=relaxed/simple;
	bh=tNOm5hOjvPzNWfk+4Iv721Nq70pxqeHMCyvaJ26k7v8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=bbaHYM/k8NegRmMwSIPZl7SeM+Bfcm+N7dTw7pXAyBVKnlPCXehQkKdCKU0QEJS4zKC3DZi7u/+y7vMV/2yrXZqJLBv4y6Fef8OaPog5miDFhEq88+/UysssUYAX2JtDUkAH7WtZuKD5574mTn7EXxOB3W/hBv76dNDjAhB8q8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P69y5i/c; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P69y5i/c"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O82Mcm028022;
	Mon, 24 Mar 2025 10:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=F9EaT/qVYsHJtqpBrLrOIziNMenO6NJPwjuVQz/h3lw=; b=P69y5i/czaez
	ft17xsMEsLTXR26fzCo4/0jXP3gmD9k3QnJO78EWLZWOsNNKpB4ls09Yo0UHApa0
	lUKWKIksP6j/YepZ5J/P5ii4EWNGDLsQTPwj6i/DOLVUGgJKRfPgkNCp3QpLrfYD
	7gWdoyISx5OlQ4vs54kmRZ+rYua5JgS3F4SfaN/K2wz8vS/+xsDeG79zI5xVoNJw
	agMsfUXtEJLkTHz/av6vTaBiTSOCGGViE9r967sSIj0nGmc+QvL1c4FZL1ttChmH
	2q8XGg15TJxaUtzbLlyuQoC01ahTLpx+lxibih53F/9w0U5/LHKQyj2NOQthtO84
	GyFUS7yi5A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45jkqp3xnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 10:04:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52O7031X030352;
	Mon, 24 Mar 2025 10:04:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45j7ht5v32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 10:04:58 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52OA4ven57541092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 10:04:57 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 580D458056;
	Mon, 24 Mar 2025 10:04:57 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24C4758063;
	Mon, 24 Mar 2025 10:04:57 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Mar 2025 10:04:57 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 24 Mar 2025 11:04:56 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: s390 hmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <Z-AJFwndherQBH2W@gondor.apana.org.au>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
Message-ID: <1aa33386ca1c39438fd17ea651a21903@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ws17yETRShJz3hHrGZcRTIIwVQZZRcuN
X-Proofpoint-ORIG-GUID: ws17yETRShJz3hHrGZcRTIIwVQZZRcuN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=985 clxscore=1015 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503240072

On 2025-03-23 14:13, Herbert Xu wrote:
> Hi Harald:
> 
> I'm working on making the export format of hash algorithms compatible
> so that you can switch between implementations seamlessly.
> 
> I've got a question about the s390 hmac implementation.  How does
> the hardware tell if it's the first update (where the cv from the
> param block contains undefined state) or not? Is it a bit in
> s390_kmac_gr0 or is it the imbl?
> 
> Thanks,

Hi Herbert

that is the ikp bit in the s390_kmac_gr0 struct:

union s390_kmac_gr0 {
	unsigned long reg;
	struct {
		unsigned long		: 48;
		unsigned long ikp	:  1;
		unsigned long iimp	:  1;
		unsigned long ccup	:  1;
		unsigned long		:  6;
		unsigned long fc	:  7;
	};
};

It needs to be initial 0 and the firmware sets it to 1 with
the inner key padding and the hashing done.

Holger's implementation in hmac_s390.c of the clear key hmac
holds this gr0 value as part of the running hash context:

struct s390_kmac_sha2_ctx {
	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + MAX_BLOCK_SIZE];
	union s390_kmac_gr0 gr0;
	u8 buf[MAX_BLOCK_SIZE];
	unsigned int buflen;
};
