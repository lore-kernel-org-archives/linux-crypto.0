Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4944A26A0B1
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 08:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747644220; cv=none; b=gNAwcbsAcdso+WQPgn2j7rLZubNrCALRu8uFZqqw9qcm1rxmO5PXzLNfx1tW/BtfXgSqhIPhowQrdWxzvb4Iy82apgKq+sc2M35vfz1um2wgMfGWSRsu/440nSFQeFAS8QYkH3BK9sBBJjgAHOgZW3gZpbdacObGR4r3cjqPwM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747644220; c=relaxed/simple;
	bh=IW4Vk8QJSn08z1gg2R7zLooo3+S/atQ7u0Ph8ZgP8tk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqiSVO6IiAeaZ3jBelVT+gX0J4nphO0/3pjXbgKjFKXr3uCP8w28cJ+sFZaf4fdcOcQhzDgkO877eyzgHdSeTi67GJ+6DIGs/e8ztQ5zJIrUjkDZzt6srtLh1woqHX6IYHaoRxiMbrjUbPfyWwhvJ3K4yhHLTKzt6mRmIwQL+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LohkLxOg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LohkLxOg"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J8Xt5Q024046;
	Mon, 19 May 2025 08:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/JiLu3
	XD6Ug+1lidZSIygwn/+4sHmbTRIuTw3jXCeS0=; b=LohkLxOg38UuKxv+j8PE3R
	Y9Yjd/YL8bX3A0wUHr139TxGMJF1n8lWo2dzXX+cqyz6TtxkM3L8n/sXp8KQzISK
	gp+2MRnzNDI2fOXBseUsbmZMF3KflL3ulAKnUfz2sg/7GN+N8XiN9z/1BQsiOpF3
	itrFnFNng/qOkGcVCY0RdoSe4qM9TmhuAcg+AIrwEH1yEF+P7GbqooSV+R6M4iar
	rSEbkMxHk0Y3xpTemDu9+hOmFOSfEQbetfPNgrrgfE4MoR40+PM4OjNHPaonwGgG
	tkwqJd3ZB43tzFjFdXYsgpl9DNs4JytgU9bW9kKgC6jnZhM6uRnKc4rWbzFV67nA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qn68jkse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:43:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54J80BRk015851;
	Mon, 19 May 2025 08:43:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q7g25er3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:43:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54J8hUd855640424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 08:43:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B62520063;
	Mon, 19 May 2025 08:43:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 680CF20049;
	Mon, 19 May 2025 08:43:30 +0000 (GMT)
Received: from [9.111.147.66] (unknown [9.111.147.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 08:43:30 +0000 (GMT)
Message-ID: <cf467fd7-fa25-4ac0-9570-a5f0e20d1fbb@linux.ibm.com>
Date: Mon, 19 May 2025 10:43:29 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sporadic errors with alg selftest on next kernel.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
 <aCrtDPVJwK6SAN6b@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aCrtDPVJwK6SAN6b@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NwLU1Uh17RRIsoZoQN74nZd_ffqNHZVq
X-Proofpoint-GUID: NwLU1Uh17RRIsoZoQN74nZd_ffqNHZVq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDA4MSBTYWx0ZWRfX6faede+PVgO5 XypS1T5UrfxCDbGvT5wfAarVmK5d1a6Dm9kLn0EkVW4IprLL3Npq8o+Ss8FA0PWUOuP6Q7umIxo ierlOAYn1OKj5OjwdnVjeDLNljB6KuVLV2q1EaVA3TrigA+PI413Gcq9XZry9ei1RNMez495ryA
 RVbsqjs63YDuIH/Rhr3FcXygkrkGqnjtUYuGqvRR9dyp8kyNEK3wz+VXZiEVKAUQhns0D37g2l8 Mu111964OwpjCcAy+1aFV9AYyyMFN485c2jFIPrqyXFy+Nj6/RnEzikLPTfSc7ihfjv4TprAwoz NjWpgrY4kRlbYa9irW7W9cSDiyK1Gd01zGJ/EbLUZ20361hivOMzo8DTjIEOEoOnau06uQec5kc
 MEE4zHXARbpuYlHy4RlesIdM+QSM/71UEgPnIg9LRONo+SNjbohOwVkge7isMPaU4gTvgCG7
X-Authority-Analysis: v=2.4 cv=CN4qXQrD c=1 sm=1 tr=0 ts=682aef37 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=AaljaXIuQACWuIYb_ykA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190081

On 19.05.2025 10:34, Herbert Xu wrote:
> On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
>>
>> We did not see these kind of errors since long time, and still don't see them on kernels other than next. 
> 
> Could you check whether the CI runs have the extra testing enabled
> for non-next kernels? If they actually had extra tests enabled before
> the current next kernel then that would be surprising.

No we do not explicitly enable the extra tests, neither on non-next kernels, nor on next kernels.

So it can very well be that enabling the extra tests by default now triggers the failures to show up. 

> 
> Cheers,


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
