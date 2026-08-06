Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71B61F2B88;
	Thu,  6 Aug 2026 04:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991857; cv=none; b=FRYJlEJBJw6IJS5RY5CIsxTsKo5K8os71/WaPQtENUNy2Ja+EwK1iCgJJWF9ZDuAj+fm50JDXkCEKCArCi20KYeRw15b0sfonhZXGnuF7BxOFQ7EN4MlbPSsS715MpPq6hEwEhRud/27sMNWllNOFdtIBsfpgoZzKzbnIcYPXsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991857; c=relaxed/simple;
	bh=FU+3Di62lwyjd0SddJ7THLz9SpADbwqVxHcr7MlJbWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pRDBgrlARhvfswB/gBU0SxRElymdA1wboSkeFqG54kiGkkGYAQv6V8wJ7CSpWhDH5BdDJBx1LxwMGLJKjX3/xiu7wvLmSuQ8Ba8pNDzPPLmPH8FNkzLVNclbaolQedWazz/8Bj+yP/VrSwCWbzPydrOwF62VUXMPInWew7rh6n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ba5fXVSd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ba5fXVSd"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NmV40994940;
	Thu, 6 Aug 2026 04:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b1n13U
	GFrAUObYPpSI8r3zRzuAlXUPSJ5mZUfpTVTZo=; b=Ba5fXVSd2oLeaVmQ0gv+F8
	NTsUrTTPHELS+j5lXgpfhzVyt9THD+MZ6HzCuPgteA4wWbE2fT+CluSjUFOsboq7
	5es7uPd+q+wuTJu5uDH7RmahpPJaLgWgL8tFj/9YEHekOhsT/76R1/xb3Da7pTwZ
	LYUbRHZ7nhlXHRrYv9wgAUt1KRnozFXb0KS2uKRsX2oirVgApKfXayxHcj99lwYu
	AiLC4pslnsGhH2oev8EHhLTgBuFkRaU1+6nbBa8Y/tuUnTmk41/dBIFU7DNEfZ69
	S24bxtjntf9vnmPyHgh/QqK0yDqmQNKC8XfMfMjntl2q9wFy1a4GNby6mvh5p4AA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67hx43c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 04:50:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6764fWRt020685;
	Thu, 6 Aug 2026 04:50:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw9sd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 04:50:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6764onFS17170710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 04:50:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E009820040;
	Thu,  6 Aug 2026 04:50:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95792004B;
	Thu,  6 Aug 2026 04:50:49 +0000 (GMT)
Received: from [9.224.87.205] (unknown [9.224.87.205])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 04:50:49 +0000 (GMT)
Message-ID: <3aca074a-c054-4b41-a038-fd75fa228f80@linux.ibm.com>
Date: Thu, 6 Aug 2026 06:50:49 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] s390/crypto: Explicit scrub temp buffer in PAES
 ctr mode algorithm
To: Harald Freudenberger <freude@linux.ibm.com>, dengler@linux.ibm.com,
        ifranzki@linux.ibm.com
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260805155458.14925-1-freude@linux.ibm.com>
 <20260805155458.14925-3-freude@linux.ibm.com>
Content-Language: en-GB
From: Finn Callies <fcallies@linux.ibm.com>
In-Reply-To: <20260805155458.14925-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfX/mecrT7QXOat
 GwGB8/Lwv6RVLe7BXXuQySq+uIazEtOW8vqN3Vprm9bvUgaJr+iEILlNSNW7ZPZPdNIFU4/Klfr
 WKLKBb07bpUmWNT+nXN/PDGXnyl9dqE=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a7412ae cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=azT3bUf-WCAK1hEDQ0wA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfX85YFcbtuPPnE
 I1h9XrfnN06xkV5yH8FBdgn/8GwUUf5aFZi39MYiF37tHxb0Sr5/lGpbAUCE5WGm/e/KIcwi8yg
 hfQ03QQgSVCooXI1W+gdRCZyfZEA5h1MYqqf4qRao2gRlL+d5efwjXoQcs1zBbG8n3qYyM53N3x
 PSwTq06NatAZ/kQa0b4+oI9yO4f141hIf6hh+TBH+EgkLnCT7gYsf4Yw4wLIV2jVsaNJSqpWrYZ
 Z8eBBcyQ0QaT4JAqVf2B66eBN4m37szFsiRC7hUZeRM+aPW4amicbn3819rLRXmaGJKW0CTAGOR
 SWISMSYWgQMEodPko951Lu/C3ubCKnCAA5GHj83+4zsj9L7KdM52ED/Y3rXuteNbNWT4IMXVPHw
 H95FQ//3yLPgqGwM2WYlDaDwFknZdSpp52NcMXc9Dri+UPhHaypnJHbwXNOvndOg462h2hQnLR5
 WRqve9yBkO5uIvC3yXQ==
X-Proofpoint-ORIG-GUID: usgVHEM2gE8_IoWST94CCBb9Hfe-pF7E
X-Proofpoint-GUID: usgVHEM2gE8_IoWST94CCBb9Hfe-pF7E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060033



On 05.08.26 17:54, Harald Freudenberger wrote:
> In function ctr_paes_do_crypt() there is a buffer used to process
> remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
> thus could lead to expose of unwanted data.
> 
> On exit of the function unconditionally scrub this buffer to avoid
> exposure of maybe sensitive data.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+
> ---
>   arch/s390/crypto/paes_s390.c | 1 +
>   1 file changed, 1 insertion(+)
[ snip ]

LGTM
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>
