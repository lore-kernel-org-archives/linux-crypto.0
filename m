Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C753334D398;
	Thu,  9 Apr 2026 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775718534; cv=none; b=MOVvgR1VZwB9PUcYpfdy5F+GBxJoIZaFhhOG0km2TfkGHvXsICvB+Ozipro89OYtfwUzVcHF5YfiOKbRYDVxMirNkuBmGCUtl+GoWJj2/PLItg/BCtLDcynkHdbFvSxK63NuyZ64wIkxYNq2NQsc0fndCpNTODjlSzEDRFI0S7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775718534; c=relaxed/simple;
	bh=AmuY6DBnv9LZ4ZZy4W4moJekCn/VxjkdbOEWZh/bS6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPOIdqtfsNreaPWJHyckBjctbJlJnesjGeUeaSZeZRQ/CeQmYy/ssKDhcpft3a/Q4rCY599l3uSVjYlIYVvqv4j1NzD57okt25Tj9o1B2L6TVth9YKRwUm1xwKiE9ygviJQy9DzoiOIGly8mfNWGEwcu6q94AdC6TZ2DUCIABb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YPL/DY4T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YPL/DY4T"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638II5ni2332011;
	Thu, 9 Apr 2026 07:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3eea49
	f7/uNX7wJ5BEjkvwzTtPsBCQMN1xZFbJM6Z50=; b=YPL/DY4TPWI1hBYUO7wZMo
	9kUWKD+ceMCvfGI9k3fiW29UJhORgbX9QkidAnm7wvlSOVBheIiA+L63z70z8w7F
	vSDSBglfGECSzKQzgTMq+L426dHFZy1FSbzndVfSGKwg2r56wbWLLFdIKNCa6KJq
	uQ6jbewvAAOweF8o1U8pAA2TZxWOoEA+G+iqIfCBaAZnAdgDbsB5DSGjI0+s8ZrX
	Z3M3ms0kR/yxRcVpkzPE80TtIK3TT934KfzL7jpTW0jFd3hDY1p1TI+CZ4fJgpXr
	K3rkQr6rG5YUKqhk3E5OcTv3cH55Pio5GCRQoyyG5ZPs5aS05z3PY1MC5GVaSpLQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kjwe9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 07:08:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63926vPo014375;
	Thu, 9 Apr 2026 07:08:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg4tka4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 07:08:33 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63978Vu043057538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 07:08:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A842620040;
	Thu,  9 Apr 2026 07:08:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 805132004D;
	Thu,  9 Apr 2026 07:08:31 +0000 (GMT)
Received: from [9.52.215.116] (unknown [9.52.215.116])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 07:08:31 +0000 (GMT)
Message-ID: <09684f23-8937-4fed-b88a-361c9ccef04c@linux.ibm.com>
Date: Thu, 9 Apr 2026 09:08:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20260326201246.57544-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA1OSBTYWx0ZWRfXyMBunoHGiVE/
 mfNuqcRwWbZUI+Q3si+QifssSFIkivctWOYDl6xF5+//1dcNtvu+hgcPCvlN1QFX+0VWWDYz5+9
 KdW+Y5fWkPEiz8Ad1X0gGqCMMusyWquFbT1hnVIw+sKmzzMnicwHwhg0U6Zn2lYBf404HQwXoZh
 my3wEA/dZovWiiC61jh3h/LOL6ddQ+EmSOIuiezCJi3wdq5GVF18D3Px9ZbnU3n8m/ITF3MppOj
 jSEEYJibwO1cfIN8AMJZrIUI9alt5ufgKconQqAhhme3x8/baKOFfLf8z/M3n4QWmuQSohSlmu1
 hYwGjSvbvpIlCrEyY7s48icnC2Alw5THNIFQA/a5AwuFYXOByupzutxEaphC8LF90rb4faldmXi
 sF+l3v4aWrXJahPeTzGdTjb3mc5ww+570QffDNma5SDvEVS3R7fvVplfHMEcVYJPpFrKyyAtRcj
 e/q7C3X91zi12fN8H5A==
X-Proofpoint-ORIG-GUID: -T92ounT2WIPDRxQ7iWYv3zxFYhzvz49
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d75072 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: -T92ounT2WIPDRxQ7iWYv3zxFYhzvz49
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_02,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090059

On 26/03/2026 21:12, Eric Biggers wrote:
> Since DES and Triple DES are obsolete, there is very little point in
> maintining architecture-optimized code for them.  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

