Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0639CCFD;
	Mon, 17 Aug 2026 07:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786952122; cv=none; b=u0KQp/q4JYwSCqTTLgTCfAhT2Th+n0ZKp9SKFiMKhBFXokt9rao6C70CSmYK6lcK4u3p3vK687mcMm3YLN6KB9j1u4Jj8QSz+iwufvMHwV6O9pulLlAvVTICQsBjNy/u6MEQfutLrEjaXGXHnyBZEj+A6iDxxNAwjG+YnKGfGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786952122; c=relaxed/simple;
	bh=5vbeY0mbpFpNKkWFJ9hNdzWcg3Oj0MUXiHzXO9QncKc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=FII8l+lDXblr/NpPo7hn3AWqVE374oFAq1sIxt334YeX/9Fcl640qhdFRGvcbYGHGf+OyJIoJJSMtIyl+Revoy6KvOUE1AUh9gcbls2PHbGIrRRzNAPq23rO5b+rxGvjs1ypfkHBlKfMD8uygzCQ/ZKAGmkBXq6wZbMtG5FUfLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sAl4HkrD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sAl4HkrD"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLWFpa3685640;
	Mon, 17 Aug 2026 07:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=IjmGaT5RplUtKzXJdtauv0pXlgxnSgWPVJ31zpzpfMQ=; b=sAl4HkrDcQTs
	K7QJUI+dqbWdcyc05wlNEKcT+UClE2WQ1loekg1JuM2MfWUZBArSJ+5GX7YG1LcT
	vYOU7IPXyX+uL0b4eTN62KZUZXX/4vbSInztoyiPXV9ELVOkyuWzQz1eGK93mIWg
	gIcYhD5WWDd6Ga4TobcbhQ1kW7j9uBz1RX2VEUp/9pbLNcGG5LO7wBQKw9K6O6wG
	Up58eVCfcjFBz68TWctq2E16rXy+p8IRLBsZWAzri7NRkzX84P0tFiAPZZetskoy
	gHmM3VsQYE847WdXTlDKZo4Vj7w3W3G6sFr42ztoCeOKwsJZxbIJDwqFlrpTM5Zt
	UYAe2ZpiMg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3gx5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 07:35:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67H7QKw8032353;
	Mon, 17 Aug 2026 07:35:16 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y4mak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 07:35:16 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67H7ZFv533358434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 07:35:15 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 490BC58059;
	Mon, 17 Aug 2026 07:35:15 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6521658053;
	Mon, 17 Aug 2026 07:35:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 07:35:14 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 09:35:13 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Heiko Carstens <hca@linux.ibm.com>,
        Holger Dengler
 <dengler@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <an-56jLbR6bfPwvk@gondor.apana.org.au>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
 <an-56jLbR6bfPwvk@gondor.apana.org.au>
Message-ID: <3e82cddea4a64cbc4b02c3a017d1afa7@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nngj9clPQRRJYXzP50wPRtUiav4zHx-_
X-Proofpoint-ORIG-GUID: nngj9clPQRRJYXzP50wPRtUiav4zHx-_
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA1NSBTYWx0ZWRfX9kjbxcQAwbIE
 7p4TJ6jHGAE3gJoAVf18jTkIdiXVADnPhaqGZfHioaFEe+IoMuWSFl88EQ2o4mpOFWuyz13Q68e
 is+VbTJktLCjDh3SdZcoJThumzc3kUo=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a82b9b5 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=HCDunGb_p82Y6W5z8UgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA1NSBTYWx0ZWRfX+xs/+Z0R/2ox
 8GJeMqzVhk8t7OYVoO26qeeGvRkB1JykbUq5PTRtyQ6u4UTDgexJBpMBMhnRdJYG63Q7f9esTuQ
 +XJd7kYzPfjxjHQz8XQqHIfQ+KRD8ToGo8MNtLQ83wIBXdxCbwUjRhbWSzd2YOgYHqwDv9Zx4u2
 Bpy0zXqIFB4bcrCXrRFcGGO4HdbdBzOg38KliDreRFJoWWlZQZGzWKdkn1NMRE06UcnvoGTM8Bp
 oVOUhlEtaJvU9PVIV3J8kNF21z4RvplNyEAOhg2lWtVk6P7D5hsu88Aso3IzvlTGkQxPtrxUXlW
 xYO/K1Ge33qYmdFNuZZ1fCSi324il27lZ5XJ+/hJbuOg5GS8nt1OgGrtYkpOg/k1PV2lowyl6Kw
 vDXGJRcOq5sfdu/TU0cKU4iTlAkEMsFKmzDrjVFuqx6orgqR5jfl7niTdLyZf4aQII3dVAaryR4
 5jSvAw9dLY1hyptnIIw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170055

On 2026-08-15 02:59, Herbert Xu wrote:
> On Tue, Aug 04, 2026 at 01:37:33PM +0200, Heiko Carstens wrote:
>> Enable CONTEXT_ANALYSYS for s390's crypto code.
>> 
>> Static code checking for acquiring and releasing locks used to be done
>> with sparse. That was removed with [1] and replaced with a clang based
>> approach [2]. The new approach requires that each subsystem needs to 
>> be
>> explicitly enabled for checking.
>> 
>> Do that for s390's crypto code. In order to avoid false positives the
>> code has to be slightly reworked, since conditionally acquiring and
>> releasing locks does not work with the checker (besides that this is
>> sub optimal coding style).
>> 
>> [1] 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
>> [2] 3269701cb256 ("compiler-context-analysis: Add infrastructure for 
>> Context Analysis with Clang")
>> 
>> Note:
>> 
>> - "Pre-existing issues" reported by AI will not be addressed in the
>>   context of this series
>> 
>> Heiko Carstens (3):
>>   s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
>>   s390/crypto: Rework ctr_paes_do_crypt() to remove conditional 
>> locking
>>   s390/crypto: Enable CONTEXT_ANALYSIS
>> 
>>  arch/s390/crypto/Makefile    |   2 +
>>  arch/s390/crypto/aes_s390.c  |  54 +++++++++++-------
>>  arch/s390/crypto/paes_s390.c | 104 
>> ++++++++++++++++++++---------------
>>  3 files changed, 97 insertions(+), 63 deletions(-)
> 
> I presume this is going through the s390 tree?
> 
> Cheers,

We can do this via s390 subsystem. I anyway wanted to suggest this.
Thanks
