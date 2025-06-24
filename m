Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB41B87D9
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765146; cv=none; b=sDAvkxuuyCLIMOGdHT7CfT1MlPWD/UZY20WITLUkuqSZLt+77XbDzJ/FtYfHJOS9d2yQfCdHdBBZl1LLkKbjTTl0+vMPDZFVY4rrH6w8Mpdy4aI6yZHHOFIr28HUCWwEv+DXPn0dXpojRWu8Rlo3hLsRd7v9qtkXHnwhs7+FMi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765146; c=relaxed/simple;
	bh=Fy/w/QAe7D+PrAigHGIwbRljUXqkmfJ27h7dF/KoXg4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FaNTOBRp0k3BXVcsVsESVoVjtREM2st31Ura6sWPekd+F6SvIQU3bKntGuqkEjNRAhwQuekKB8g3hjqTWmAUhr8mVrbiglnUss4gbkxBKFA4A3xLKfglx6OVbuLYntf14HJwbhwize2dQ4J5lqFTU1Kie/LN6A57Cjpsq27EAbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eTu7AHlG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eTu7AHlG"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O6pAe6017031;
	Tue, 24 Jun 2025 11:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=CU9U4SKUYmLCdFibYQK7Al/K9uNL
	+QybsxGO043DhAk=; b=eTu7AHlGj0/6OxtGupoaIPKI01eOyeJ+mJOwG8006yjr
	SzGvmldLr3XWU+y+hmg7aDFWTjAqXStLpAhsAD1ZftqBTN52O0gQg6cnv7pEGrmo
	0PRM9j+hjN1m9csX+fshAjqaulDveHWsh8uUS0PzZwi7U2zeegTeEnbI022PAwz/
	fzTMYzcEIlOIzJ6X4TFX7MLk++WIstFoDIJIKdfvZqYzx+VCQS+2Qp1kFYOkl8Rl
	rw6Xk0DJxTMLvq8nKQm4Cr5JrkBqwet2CMlEd0UXBLFFLj20EelhBziUlS5UXEjV
	QM7G4jL04gZX0cmArkEwt3dCMa2wNJ9RdwCydDENaA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dk63r5gx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 11:38:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55OAirAD002467;
	Tue, 24 Jun 2025 11:38:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e8jm3mg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 11:38:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55OBctNl51052860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 11:38:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 304D820049;
	Tue, 24 Jun 2025 11:38:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CBBD20040;
	Tue, 24 Jun 2025 11:38:55 +0000 (GMT)
Received: from [9.111.221.43] (unknown [9.111.221.43])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Jun 2025 11:38:54 +0000 (GMT)
Message-ID: <9e33c893-2466-4d4e-afb1-966334e451a2@linux.ibm.com>
Date: Tue, 24 Jun 2025 13:38:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: CI: another regression on linux-next with s390 sha384/sha512
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA5NSBTYWx0ZWRfX0dU4kIYoX1ct FEN8rlHWHfssU3HpgTdvwMqA8UWJ24Gbd/Mp7JhWfgoBJNfuf2I3CgDuAYbQKwL06jBR5AFk83k rYlOmYaIkxtEh78RiibiXErKNtQQDkYRo9Kk1VzcV23dQopOU3q3Zdn2dZcnNv2GgRxPC/bglPF
 1Mj1H2BokSKNxxUSPsPB1izEBIaE8syZm4NtbmOjbFXWG0fBrV1y7vua9F6xtqThAoW6CBnNT7X QSijRJf9baLd0WNxc1UZXfgjXMU0MybZ8E/d4hItssas5wG+2ip/EW3Fz1MDhqqcExukIUz3MWb DYGmifD0BK1Z54uh+bgfPksAkIVfFeblCeIm10+FY6FhBaaxilpfvsYwCEinXnKrRL+ZYVTal9t
 0c6LPkFNeJeZUzWDk1MEPhJr25UYoQLKnQbGnw+GhkuB+zapgnMugePbyvvg+XHAGJZAwaKz
X-Proofpoint-ORIG-GUID: KoNnX-oL0otn86jkEQtAWuk5ATuSNE3v
X-Proofpoint-GUID: KoNnX-oL0otn86jkEQtAWuk5ATuSNE3v
X-Authority-Analysis: v=2.4 cv=BfvY0qt2 c=1 sm=1 tr=0 ts=685a8e53 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=b18jdZ5K8X_WDl4z2j8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506240095

Hi Herber, Eric,

in last nights CI run a new regression was found that I guess is related to the movent of sha512 to the library.
However it behaves different now with sha384/sha512 compared with sha224/sha256 (which has been moved to the library earlier)....

First of all sha512_s390.ko is no longer there. I guess that intended.

However, /proc/crypto does show

   name         : sha256
   driver       : sha256-s390
   module       : kernel

and

   name         : sha224
   driver       : sha224-s390
   module       : kernel

but no -s390 driver for sha512 and sha384. It only shows 

   name         : sha512
   driver       : sha512-lib
   module       : kernel

and 

   name         : sha384
   driver       : sha384-lib
   module       : kernel

The -lib variants are also shown for sha224 and sha256, but those also have the s390 variants.

So it looks like the s390 optimized sha384 and sha512 are now missing ? 

Similar, the -generic variants are only available for sha256 and sha224, but not for sha384 and sha512:

   name         : sha256
   driver       : sha256-generic
   module       : kernel

Can this please be fixed? We really want to keep the s390 optimized versions of all digests! 

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

