Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F9F298CB1
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 12:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749559053; cv=none; b=URZjenPIeDJR9/at4rRtbsvXKIK6Wvxhkt1sf7iR21/ybzUzej8G4R+3ToHozUcY5FVvsUOO3NW6J8dCQQxbrH8CTvJZkUgJdfMO3fFWDNFwP6EH5VqBk1vR8xopolhjRwwMDV3jTPVt3EXsktC0Ab1k42Ovb20eFH4U+QBW2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749559053; c=relaxed/simple;
	bh=ZcEhrgMhE7NTsUQib/yV+rSwyvjiLTa6R/gpG5JjouM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzlP7GRpkCVp8QTejnDBa/h0mGMmMzqaMAycRsHRDyw1fBRgyoE7PjeB/w50TJJ5h2rHPLNf6rPDIjAdTko2mqrOs642z9MbUomU0tfxfEybhk05hw3oDEs6+uvtDbywrSKHPAgeiHVq2KEzwWtDSNYgOwoq2jvyJGB405k6yhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GxgwfAts; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GxgwfAts"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55A9wDCX027642;
	Tue, 10 Jun 2025 12:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0ujY3M
	KE4iUOIxF9NWDvPVDFS4q2pmilMgOnRHaEcd4=; b=GxgwfAtsQi9lQX9R/vPhsE
	XeD5NjwuUWoOidSYEgMNmXRf841NCEWLIogcuXceU0c7B0jgZNRaRy0UT//ZyVrQ
	xT5QX2zDtFSFhfunbQqxwhmR5QCAUZnETGjIJf5bwzcDax1RUAbo6qQQOWj6qI95
	j895QVW3T0UmpL0wwPc2agKn6XwgrBwuP2Xz6uf5bMBJYqXbSKNl144w4ltQyBM2
	GWGwXgOwwVulQO4mT9RroEySUFNaWuxh0N3IatbvKRTBIZ2NriassldJkHQ03AHL
	NA/quzk6nQk7DFi/goWpqRsf1dVZJ9qBagCiiaG9X9ZiOZGFTYstQdk3R0aT5cwQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4m3bn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Jun 2025 12:37:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55A98G67014908;
	Tue, 10 Jun 2025 12:37:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4750rp2bge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Jun 2025 12:37:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55ACbJQQ43450720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 12:37:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0D6120043;
	Tue, 10 Jun 2025 12:37:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE04F20040;
	Tue, 10 Jun 2025 12:37:19 +0000 (GMT)
Received: from [9.111.152.178] (unknown [9.111.152.178])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Jun 2025 12:37:19 +0000 (GMT)
Message-ID: <8bf5f1b2-db97-4923-aab0-0d2a8b269221@linux.ibm.com>
Date: Tue, 10 Jun 2025 14:37:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CI: Another strange crypto message in syslog
To: Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, freude@linux.ibm.com, dengler@linux.ibm.com
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
 <20250605142641.GA1248@sol>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20250605142641.GA1248@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Y4X4sgeN c=1 sm=1 tr=0 ts=68482705 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=BascJXSDbS2ylCxpsY0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-GUID: -XB_HE0Cxv1xRAlwsErzwt7lM9sp1Wq0
X-Proofpoint-ORIG-GUID: -XB_HE0Cxv1xRAlwsErzwt7lM9sp1Wq0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDA5NiBTYWx0ZWRfXwv4PtOOtslS7 LyjEz4OiMOjETU2Ijkaj9PYvHrPrTYVuNJkkRuwWu/2ePC4AGRD3gZZDfdfnNmhw/4PKvcu2HHt bjlgyLw6zRrf8IJ2IKwG2cjbPI1ZLP56G7pKEaQOJOFm8Y9+CaU/jvDxMK7ouO4KjUKGpThol9M
 57moEn4bcnR0xJ9k7zrt9tQrR5Wg9tm/sp+UEf3oDyYZoghLwCwmCLY8jV8MaUqXWDW5VSG/8Hl nX897itIvauMe5PI6BiJTlKkpb9hwprQ813kkQ+iSzBJ5Zy8/x56H+t2gUR0LMG/hxaDAX8Kt+e Xr0Inx4MHYOR9RFPZSBgZAPqM9DJAjUAg2mSaybr5Pnk5J0RoSyGHTlMkBvsTEcOGuBoKA7Py6f
 iV43JrAl1xR56Psej4sXcXR+WAv2bkkhIXp1mf56hSUoW/rAUn00mz80HyKg9C5GGjnREgWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_04,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506100096

On 05.06.2025 16:26, Eric Biggers wrote:
> No, it's from the following commit:
> 
>     commit ef93f1562803cd7bb8159e3abedaf7f47dce4e35
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Wed Apr 30 16:17:02 2025 +0800
> 
>         Revert "crypto: run initcalls for generic implementations earlier"
> 
> That moved the crypto_shash support for hmac and sha256 from subsys_initcall to
> module_init, which put at the same level as crypto_hkdf_module_init which
> depends on it.
> 
> I guess we just move crypto_hkdf_module_init to late_initcall for now.

It still fails the same way in a current next kernel. Will there be a fix for it any time soon?

BTW: I guess there is a typo:
	"basic hdkf test(hmac(sha256)): failed to allocate transform: -2"
should probably read:
	"basic hkdf ..."
All the code around this string is about HKDF (HMAC Key Derivation Function), not HDKF.

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
