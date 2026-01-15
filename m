Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F4B1EF09B;
	Thu, 15 Jan 2026 18:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500833; cv=none; b=A1z/9+AyvfCFGzsGNDDxKDHcjhc5c3ejX2HNvB351qsI0cFlTm/MjBueJcth8Aw2LkYdSE0Xx9lWNkZSNVz4vQMt0qfO5omOMSslSr/vY4YIE3IGbMzFlsxoRmoVQrOV9Q5KkTGPOQHhHomXjdsETKBT41MjSQzyjwnyvtMIZ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500833; c=relaxed/simple;
	bh=Bwo0TTwoNywWieE6ug3goQFnzE+gFqTJG6ics6+E0Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iNdeWgxGZ5qTwLGuHzunS2Oxp7sqBI5N/71qxiywNNQliixm7bUwYDDuACC0OIJrwrOIX0zeckF4lli1OB8exgrHcybDlWQwz2kfOvT8Q6mjEPM2X3Ie+xpi5we/wws3oNurkFRjwcizpwLgKAuIjU7Pl417sz3JICSlvlNw1+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h5Iey/j/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h5Iey/j/"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBBJwT025903;
	Thu, 15 Jan 2026 18:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5qCT7/
	BSGETEs1EOsuylie58EqwjvC/TDAkidaUnH/c=; b=h5Iey/j/OTLcLWtJ/8H0cZ
	ooR46umZlCfM2GYXKxDUWN5ItaTVJ5FBcBtj4rE3BjJGqIGkG8pcxp88AuSpl/7e
	qzgOba/bKweJE2HgKw3qsUo0RErJR/lXg8IfwlDB0z+RxfoE2kZQXFAOZp5OXpf1
	BsGBfgLJ07qj7kOGgx9izrh206C3ePkUTe4PkIA3QWoMHD+2jVz7ueT4lF/9IiCm
	NtCBJ5qbJV9uH88EeeA9aQJoEEItQpeNf9KIZ4eHH3DSd3oQ8YoHNmom8WwNKizH
	B/d5s8m5VysFg+3R4XSIO/2GlM0UENBvYV/x9APWqVbiBmODIe58Uvy9z2WHHjlQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bpja4mnhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:13:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FGCDd1031255;
	Thu, 15 Jan 2026 18:13:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm3t21bdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:13:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FIDd4f53084480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:13:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1855C20043;
	Thu, 15 Jan 2026 18:13:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEB7E20040;
	Thu, 15 Jan 2026 18:13:38 +0000 (GMT)
Received: from [9.111.195.181] (unknown [9.111.195.181])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 18:13:38 +0000 (GMT)
Message-ID: <c96389f8-8778-4d37-8210-362f2f2e4591@linux.ibm.com>
Date: Thu, 15 Jan 2026 19:13:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] lib/crypto: tests: Add KUnit tests for AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260112192035.10427-35-ebiggers@kernel.org>
 <20260114153138.4896-1-dengler@linux.ibm.com>
 <20260114153138.4896-2-dengler@linux.ibm.com>
 <20260114230430.GB1449008@google.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20260114230430.GB1449008@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDEzNyBTYWx0ZWRfX1t++ErAT0Wrk
 +eYAZc5IgXpcYvVPHl7Exau2HNZfACe21EER/BrV931rzed47nb3GHJAZspgc7Yk7PE6icMOcFf
 ItXK5aVlX3CEasxPdzkPl8D2HPfwVrq0Q3w0t4OtgJtqpl00Dna5sOEr5F8jXRRFBIv8SBZ3mnR
 Uehvushfv4NCScQC/nSXWgQQv6Z7zQW8vRRnh/O9h84RDQmxnR6lUQwZoSGiEt4kFGoHmQ0nYlp
 gSbZAY6acc/1DWAWvIoDlNSYugnAfxKSd6JjJMnUxcM3tUj4BFqELNOvwZQodtfu33g5aOYiSMS
 fQ+2XtLXJwmgjjsLqDSBCyf0+yXWyCn4HMo4atCAYvZ/5lvCps2N/CDn0SV4KNxpOVL2e2s16qz
 cnMZTmZ8dVBZqu5DNH64xIjhsi0fQgF4Ls3qaCvvX1Puz8il9+fbf4PudkSTHrkcIFTkVueni2X
 CwWsVhYrFb3kfMJyFZA==
X-Proofpoint-ORIG-GUID: Ei18YDzyiDNGYGUOpQdELUwgLW0DtBri
X-Proofpoint-GUID: Ei18YDzyiDNGYGUOpQdELUwgLW0DtBri
X-Authority-Analysis: v=2.4 cv=U4afzOru c=1 sm=1 tr=0 ts=69692e55 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150137

On 15/01/2026 00:04, Eric Biggers wrote:
> Thanks for writing this!

Thanks for your feedback. I'll send new version with all the changes.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

