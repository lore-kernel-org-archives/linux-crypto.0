Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA16919E971
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749122805; cv=none; b=WjvZmAIlg5NqjLcCSP0DRMviYKAPfYTwlW2vyzNpXBampbCPVdx8AdiOgnmVOtiGDLyrVBoaMspqTjwvVf7QlvbFUoF/grEL/6EsVsoBTNKSMg5sUYnga3quYXqe29oOzO4bVjMHsyNfs9oLjsXHh2E5ggUwlfGo5jy/Q+mQhP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749122805; c=relaxed/simple;
	bh=y1LIejWfv33dpQTZWJ52uy0c8lDTnU39PfnRvm4vzGY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Oe1N6B+UzHAhhKOLhHgbuAj3K0SL+jict5p43BzOGVBrbUPIHoRwZRXsMun4V3i8ww4zafEtiNVVCVqCeA7VH8CLdH0M5FjPhDt4k6Mv68i2QV4vferFwJeeQgtBkfCb9mYVbBZC2nj9n210/XnK6vaZojOH50wiQyoTwLSUhXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M1rFsXAP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M1rFsXAP"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5557TGr9030925;
	Thu, 5 Jun 2025 11:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=G3JXl6F2hPjVYW8hkI+IZoII4jtN
	pRxAPqG5LtGJTvQ=; b=M1rFsXAPXN0QtNQpEh7sC5lbSUtA54AIXyvO49hbQeWp
	qLnBJi1ZfqyP1xQakTOrmK/Mf5EgjAYd+VefKAOrCfO+kQlo08YyRSoR0/L3w8kW
	3wxcxkgKlrhY1FUFzHkBOM+Mzw1ggmfjfI5iqx/FDK9VxlFHUwpGHLUlhKz9xHbb
	GkYYOqcJB3R1qcA1aInstzuC91PobGGx+ABlGuPFYIbPOp0M6qR78NUdwUPSLeBN
	qqYBEhhgSMvERcn1PFQJddrjDx8xR7YOsEsRCXMk5tqzanmQoq2y8Hr28OYHsMh+
	OFZOrjCyMcPip47R7VrkH9GpQUBk2QlzIMNsZJCe3A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf00b7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 11:26:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5558cx3E031636;
	Thu, 5 Jun 2025 11:26:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470cg04js7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 11:26:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555BQXq119661300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 11:26:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77ADA20043;
	Thu,  5 Jun 2025 11:26:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B342004B;
	Thu,  5 Jun 2025 11:26:33 +0000 (GMT)
Received: from [9.152.222.57] (unknown [9.152.222.57])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 11:26:33 +0000 (GMT)
Message-ID: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
Date: Thu, 5 Jun 2025 13:26:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, ebiggers@kernel.org, freude@linux.ibm.com,
        dengler@linux.ibm.com
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: CI: Another strange crypto message in syslog
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ILvoA2cNzEtzwKw-fDVg8fcAC2WGf0uv
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=68417eee cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=WBDv6BFkB0FwB3k-DwAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ILvoA2cNzEtzwKw-fDVg8fcAC2WGf0uv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA5NiBTYWx0ZWRfX15mFycqT5twF aO/hksRjfFG8ovyzV9z6cEkXkPf0X7uhkDtOx0apxk8oQoUh1zNM8e1O7ufTxwzYhx5kok22ENJ znAgYAZqFeKZi8txd4A4qX3UJVOQJULC8uSULCYX2I9Y3xlAyeUsz2DjFbkFvpjFHpXvjD0aOQW
 HiXyWys+2eZThQUhN3727+RYe8yDst7OJPghPWlzqA3xqMmVwLbdS/gZNEAmL2wWo+KP2jAfYkp Y1vF+Z4Nb+K0VgV02+e7l4I/Z8JZaYETar8KXYNqvvww+RA5EKQNDocyquqieURCMZDBvpV6xpn 4AnpqmPMDUl2vgMZzy1f/yz6z1VT4dIzShDfOOVcdM6NW14DenPVn8Wr2fgYQNM94RznaeV1O74
 0agE3OsyT2wW4KjIW857fLYImZRtEzbHd70xFVFycu/D7Hr9ooKh/3XCisWYVguIHRtOzjPG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050096

Hi Herbert,

we see the following error messages in syslog on the current next kernel: 

Jun 05 13:15:20 a35lp62.lnxne.boe kernel: basic hdkf test(hmac(sha256)): failed to allocate transform: -2     
Jun 05 13:15:20 a35lp62.lnxne.boe kernel: alg: full crypto tests enabled.  This is intended for developer use only.

The first one seem to be failure, but I can't tell where..... I don't see any other typical selftest failure messages.
-1 is ENOENT. It might be related to the recent changes with sha256 being now in a library...

The second one is probably because the full selftests are now enabled by default. Does it make sense to output this message now anymore at all? 

Kind regards,
Ingo

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

