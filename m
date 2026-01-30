Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ED92E7635;
	Fri, 30 Jan 2026 10:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769770505; cv=none; b=W/icVZpe8n2vEjAaU33WcsCZRalCal/nVVcq7PKLdGSQZZgGrZmp+hIgNNSw6SFn/2VZaYkJaRkFK+svFnvmgAkQ8b2K9bEi0A+zhS3H+YtpkA/xu/8ozu3izWZUsQyD8MEybX6++ub37NfvpQDDkeb2mbRtpxuwcb6G4nN51hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769770505; c=relaxed/simple;
	bh=PfGhrwDBvnyJGSf07tST4uLH0Yc/ByVy5mKSsiaQcTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djl1Z1QDwq9CmIUGTktJncPNaukpE/Rh37gqjA+yEuc02z5Ef5QxbryxK93Y+YhX6KOvL6ylUqbPHhWPSHXuLqHfZOTcl+U5zaM/3hwt1pVBHR6A3DxQO6ngpAoN1R9wNUstcLoCoeeJu3aJZPPxiS/SpEmlrBzxTN7/5AC0qk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e63ACIJc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e63ACIJc"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60U4w8jm024677;
	Fri, 30 Jan 2026 10:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eNs2g1
	LsTZG8YiPhOaS+wm6vbiDXF600sQYW5bWT6ww=; b=e63ACIJcVHCbxLRjkVzSpo
	yaQAxbpyJ0FL85xIDS+x4pYhfKULntfG+YVNHEMGy0jwRGVWUOFhj5GT7m4pFpNO
	CdJdkIRrFlWdGhngqPRECIMchCldS5kfaSP9nrh97xeexFzIrViKArozjkDaEhDX
	44G6a77NKNjJKOYl/x5xEyCZA7z3IUyXOSNCnKNOFRzjC6udc4abai28cCTzd07c
	IlHmqD0J9WpbVujxqyw0TnVsoQfJcYYryQTrfAWXxthHYI2fWIDZPDyDc/HQYuRP
	2ucdKrbGkM2/mzMpGLrhgaOYhmgol3c4BzusqRY6d4z+8yTN5PaTuMMLPkg2oeEw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtwdce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Jan 2026 10:54:58 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60UAsvHa020435;
	Fri, 30 Jan 2026 10:54:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtwdcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Jan 2026 10:54:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60U805uS018239;
	Fri, 30 Jan 2026 10:54:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwb425mxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Jan 2026 10:54:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60UAst4448890302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 10:54:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35C4520040;
	Fri, 30 Jan 2026 10:54:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3BC72004D;
	Fri, 30 Jan 2026 10:54:54 +0000 (GMT)
Received: from [9.111.203.46] (unknown [9.111.203.46])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Jan 2026 10:54:54 +0000 (GMT)
Message-ID: <72667cb9-f30c-4a9d-97b1-355cc23d8b8e@linux.ibm.com>
Date: Fri, 30 Jan 2026 11:54:52 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260119121210.2662-1-dengler@linux.ibm.com>
 <20260119121210.2662-2-dengler@linux.ibm.com> <20260129011838.GG2024@quark>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20260129011838.GG2024@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8sU2n6PKuzjxV91B0RDJyCsSVoSXK271
X-Authority-Analysis: v=2.4 cv=Uptu9uwB c=1 sm=1 tr=0 ts=697c8e02 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Dpw4ZtHDUR9mF3UXEZMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: N13H_VHvfp7G3iTremcMJGw1rwzNj73v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDA4NyBTYWx0ZWRfX+tuN/npe6Zvn
 +ADo5fB421kj4JkVQJixRbk1VRgRECVbj9hlem8kR1X85v9UYi1eualAtSgdXrD4kXJZX6Wb+Us
 5pmoNuGYUTcgoiPkLwWOr3pNrLxMANGrAVLWlaCzgvuSGvxJOpiVEL0SjLqjEpIU26s2SRvmq52
 NUek2xMXZyeCPqpsSACvdx6YB/a6rFWnM7npC0NvE4nG+fJMAtE0YYKOo7TGNE5NR2ELMdD1WFS
 UE59PzeX8If3vGsQj8XapVTYoMfJCo2ul3MZ96yLmVKjau0rY2Z2zUtGqbkByNc8ciXl6m4YSoQ
 nG4kfCDFKSzOaP7TD8eEy7TzrxGMsTVESaYw38G9JaH0gYVa2yX2NfH/FGbiA0LFnNbaarBfFPa
 9SQtPXvmfkzvrPIvOiAqo+OtnfrlcptDHsmLpF1vmeJrkXcgdVBSYKsGsfvCjCi1re8m+vJsOYZ
 knzNdNaCC70C7aoFhZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_01,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601300087

On 29/01/2026 02:18, Eric Biggers wrote:
> "AES_BLOCK_SIZE * NSEC_PER_SEC" is missing a cast to u64, as reported by
> the kernel test robot.
> 
> But also as discussed in v1, using ktime_get_ns() to time one AES block
> en/decryption at a time doesn't really work.  Even on x86 which has a
> high precision timer, it's spending longer getting the time than doing
> the actual AES en/decryption.
> 
> You may have meant to use get_cycles() instead, which has less overhead.
> 
> However, not all architectures have a cycle counter.
> 
> So I recommend we go with the simple strategy that I suggested, and
> which v1 had.  Just the number of iterations in v1 was way too high.

Ok, I'll send a v3.

> 
> - Eric

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

