Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3071B294A16;
	Wed, 30 Jul 2025 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753875009; cv=none; b=lO/c3rvrIZKp7Yxxq2nKQOC17ozz4BAfbM49/FBsZefyJ+3S0ICIDaVQ9V4VUd0t9wgkxAp+fmHsSxLmqONdLXBdKBxHRQt5/PedBwP6TlMF0fa26XUVP9A7zW3oTJV1L3V2Z2WsCVTIYrsY9siY2odHafgiedx24lV8FhzlYvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753875009; c=relaxed/simple;
	bh=xc0QrAtrIkODFX0KKeZyCAiJCw/q7Qb+BPaSb6W7Zuo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JLlr+Iah/OGXiPqQeuZHzdGZ/YTPcDgspBKVMHR25CrfBsbFTQwriWxrhPBVwDTQHsAlsA++x+pbzkXwVvlyGCAJSLRxRdJMtBbMuwvBQNx6iJ5v+EdaXy809qR3aeNoITK148tsmkchOPA/N6sNSXihqoZ+DTWJIrJGYRm+h/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bG6hEZxD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bG6hEZxD"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U1YT4I002109;
	Wed, 30 Jul 2025 11:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sH3EeC
	pd5ZKrNo1ChmW+p/BObTLWQTyJ7xIhr/CjDBQ=; b=bG6hEZxDGYAgtIeG2aECtZ
	jeFudc9RFdL1lBCCae8y8eGPeE2zC5N13g0zKeXndZ4iUMk1TWMOGhPv0u/nk2lx
	x0PPk2uAfAftyykiLhmuOGXFeX0Wz3UlbjPfVYqcaiwo56rRiuN42JExnkfy7EZk
	OXGWvtdB4r1cE0qQryUd+qa7IuCnkjER/2KMLQJ2oFhIcKUiVGvZFs1xHbOwbTUB
	0oMzlx3e3LOgK0JouEwBSIor9Fq2ap9lYOtozlHxPaM6nq8lDUyyBRNc3mOhX+Fv
	0DrXqb8qXwUHmJ/1rzGgoM1wdc+rDcbnTaqurnJIGCdHaZWJTiB07bfJm6YSWksg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 486c6htcct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 11:29:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56UBNapu006192;
	Wed, 30 Jul 2025 11:29:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 485bjm6ykt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 11:29:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56UBTs4e55640534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 11:29:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A7A120043;
	Wed, 30 Jul 2025 11:29:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6311220040;
	Wed, 30 Jul 2025 11:29:54 +0000 (GMT)
Received: from [9.111.163.152] (unknown [9.111.163.152])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Jul 2025 11:29:54 +0000 (GMT)
Message-ID: <735996d1-41dd-414e-a567-4cb473151297@linux.ibm.com>
Date: Wed, 30 Jul 2025 13:29:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression: hmac(sha3-224) is missing in newer kernels on s390?
From: Ingo Franzki <ifranzki@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
References: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mtp_nqipb0SE3yRhrqwhYKwvc_vDJ5tu
X-Authority-Analysis: v=2.4 cv=Mbtsu4/f c=1 sm=1 tr=0 ts=688a0237 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=BascJXSDbS2ylCxpsY0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Mtp_nqipb0SE3yRhrqwhYKwvc_vDJ5tu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA4MCBTYWx0ZWRfXwPXgBYKPFqlW
 8XXKAhUqY4oAHVcVtzCIPTeZ/f4OvzjIjd/wNi2PU4jAaDC+l24MdGaTW+CvW+fvMDdXek7qjCE
 o4y1N6T542A6+BK27mVdq2mHab6cFPk79m5OTXq/oKTX0eRJlBm2VRXAgHmYiGims85DNrgfXF6
 kC0z8c1qhQwrZcnyKd2ehC2NFkUTmDSi9X0HTvw5UqD7KWwujsx5Pye01bd8/uO9DTLGJ9RP+oR
 JvloaS5Hp25d7/zVnu/Gh2mnTty4HtqpRzbB0icMHfQZ1qNkfX/jANpsVU3SnVAiW+FWV495UbZ
 mK33c2ZpOWa7o8HXWtylzz0dhApUWlg90PrQCgC/OLtMuocqyu/kzSPRURebXLFGx5dRSkAsanH
 gs18AOAE7CFECbPJFSjKIfr4VZMYvytiZU2qbSWup/bzuEebUh2LqjF1fGTJR8F1MVUNTfHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 mlxlogscore=747
 lowpriorityscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507300080

On 30.07.2025 10:11, Ingo Franzki wrote:

> On a 6.11 kernel:

This must of course be:

On a 6.11 kernel:

# grep sha3- /proc/crypto
name         : hmac(sha3-512)
driver       : hmac(sha3-512-s390)
name         : hmac(sha3-384)
driver       : hmac(sha3-384-s390)
name         : hmac(sha3-224)        <--- its here
driver       : hmac(sha3-224-s390)
name         : hmac(sha3-256)
driver       : hmac(sha3-256-s390)
name         : sha3-384
driver       : sha3-384-s390
name         : sha3-512
driver       : sha3-512-s390
name         : sha3-224
driver       : sha3-224-s390
name         : sha3-256
driver       : sha3-256-s390
name         : sha3-512
driver       : sha3-512-generic
name         : sha3-384
driver       : sha3-384-generic
name         : sha3-256
driver       : sha3-256-generic
name         : sha3-224
driver       : sha3-224-generic


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
