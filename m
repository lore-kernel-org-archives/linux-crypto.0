Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D162629D;
	Wed, 30 Jul 2025 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863119; cv=none; b=StFSxUVn8XW3sdaixHhf1q7sFcaDN4B8zj5PEscPHPMGop0NRLQhJ1HJlUgfaJ2V13JDyP42AHTsCPeTbvRvDTT3rH9Lf6P0LcQH14ylvOhPlSDtolUUBlG71Xx62YNcxGp3X42UAuPJG1KLImF7kZcI3oDZJEs8WXh60hL2y/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863119; c=relaxed/simple;
	bh=dt5meZlOcTvoFbO4Nniwx5pDCDPc3TkjwQhGDUqKbS0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=GmfRw66+2o7/3RYsyZpysE8bKau2ud/QXBIm8EwLu/kgRaJAgO5Sa0VpBavxEu/w6AQmESekOy6YZUFx5xrFeDMkXHHSUNnNRsut9Wk85rghcOxlDaDRpAII+mHBetIQRgo9P1MujxyyeYycJ/LcwudFd33CCZPfs9xVZtaCtpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OGJEaZ5o; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OGJEaZ5o"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56TNRQbP002388;
	Wed, 30 Jul 2025 08:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=fOR6Df8QyJUVNwoZEexND9pHQ/iT
	ju8S36UK/nNGAVs=; b=OGJEaZ5oHRw7zI7Szbre/kj9ffVeLshlyAWab9kFaiX1
	uPx0/K4AQ5PJxiLzy37wfiRL7TFwN20xLNvi8QrXL8c+wPu+bkOKvsWnbrIU6PPI
	bpSvdXmG139aI6C6o4lj500yqAmgSdUbZElDC0rSJ9K+l95AKq2O6gT/KR2rKkR3
	xr49ye2ahdF6D9tOCuRvrq5GzQ1V3S0IJcjdDxVL20rXKgzP117x9ozxFgobocXe
	LZjvZf5PRTagGriBOM0RT68OwbNZhk3g8m7G387ubu7vxRk9dwz30f3bTTw2b0AB
	ScjfVMO4z+KXRWUDiX7JglU2/bhWTlzEhnnG3FM6bg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 486c6hsj3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:11:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56U55sjQ018307;
	Wed, 30 Jul 2025 08:11:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abp6h3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:11:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56U8BmEC30605970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 08:11:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F9FA20043;
	Wed, 30 Jul 2025 08:11:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC63020040;
	Wed, 30 Jul 2025 08:11:47 +0000 (GMT)
Received: from [9.111.163.152] (unknown [9.111.163.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Jul 2025 08:11:47 +0000 (GMT)
Message-ID: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>
Date: Wed, 30 Jul 2025 10:11:47 +0200
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
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Regression: hmac(sha3-224) is missing in newer kernels on s390?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kkhR1VY_dZQozCuj044Wqa3ZQoBgWZ2s
X-Authority-Analysis: v=2.4 cv=Mbtsu4/f c=1 sm=1 tr=0 ts=6889d3c9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=HW0AOBefY15EsoRd7_8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: kkhR1VY_dZQozCuj044Wqa3ZQoBgWZ2s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA1MyBTYWx0ZWRfX3MpCCVL+kXSj
 CPCI6qDi0HAUwlk53U5Jmt/14n4iEvt0ajoMKtJtIO5t3jIpGyUeE0gikPBFjHq2zqptpXzAld1
 GA9eV23w2fFf5hA4tIvvukfCXWutsot7I8INBO4xitLcuMMGbsgdKM3yUM7zi3Wb86TtZx3nqBa
 2vOYVBlxyj6yZmwS4PuWmWYU4mziAWjYrMldrTYiWg7WTtrIH3brPJ5/KvOYSx3IacWYmPMrce+
 IW1iZ4veqqD3hSmpb6Gh7MY5/MoKaCgaWGpr75vXN3yNHJNgfb2PPC4SvzYXoVFscT0fkdJPk2+
 wvASNGuIVTVKvwJIMMKEwd9t6y7cCtEB+jQwgRSLdl+g9mcFetBPryrzRkhuJJsN4dQvTI8eeeJ
 49nEp4DWnMqFu9f7Bme7HWL4PNLdX0bURzkuZHub9uviedCq8H2xwrbglnawByrfPshAouhT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_03,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 mlxlogscore=848
 lowpriorityscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507300053

Hi Eric, Herbert,

I just noticed that the algorithm 'hmac(sha3-224)' is not supported anymore.
This is at least on yesterday's 6.17 as well as on linux-next.
On earlier kernels 'hmac(sha3-224)' was available. I don't exactly know when it started to be missing. 
I can't tell if the same is true on other archs. 

'sha3-224' as digest is there, but 'hmac(sha3-224)' is not. All the other sha3 and all sha2 variants are there as well (digest and hmac).

# grep "sha3-" /proc/crypto
name         : hmac(sha3-512)
driver       : hmac(sha3-512-s390)
name         : hmac(sha3-384)
driver       : hmac(sha3-384-s390)
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

On a 6.11 kernel:

# grep "sha3-" /proc/crypto
name         : sha3-384
driver       : sha3-384-s390
name         : sha3-512
driver       : sha3-512-s390
name         : sha3-224           <---- its there
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

