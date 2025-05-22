Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52228A700
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747923251; cv=none; b=uygFej7FpxSITm6JzZxO9OOLJLafPbIlyviTN8qqQAWHHxQ7ngX3T18DU6lyxCng5FiSDP8Kwer+g/nnCJo/i57LZ6vaxzUvEX2eUywhpGs7WnoNtl8hM3YQubIbWovifgRRF56vG7rN1++HJC/Xn5IgiU669qx1eB9Eav9SAGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747923251; c=relaxed/simple;
	bh=LCjia3429e3NBLI5YgSlbSvKjKWk3dUZmKCdGedC7qc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=GILfRIQjGEuZGwScg18dg5wox9NDqJGFyJ6feg8xj+aa4yEeehakTtJH8L2FDdydvefXgeNKMjdu7GCIWHt6jyHcJgEvsKQMM9MKq5FZQRmvxGh1oWImfKE9m2p2Ku7sGlOF19bE6CRDPuJlGfUevyyzaDQFys+HYZEM8HG6daQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bgiKnS0p; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bgiKnS0p"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9EsIb020858;
	Thu, 22 May 2025 14:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=ay/TcD5DoB41BdflfUBWQGtAzmud
	y5GqBLJ/lsKvXYs=; b=bgiKnS0ppdPoTMzhOBFtOw/beAFWhCoJyncbarHciCnT
	4SMIunGYhK9oMLgB2jqpPqVwonACgkuMpTZOFNt/x+CgPKDFhzmb8amrzv64XTom
	aR7MM/Bcp5p+HMUDIYXth3c+xNnX1w14Yt1uyH6v7o6Q31p+1BUr2ZuPaIpnT65Y
	TurKjTTuk7tnSK4ZKdVcG+5LvmhiMAUKjZFilSN77t9YJs1dTgS12hi9uzgRzhPi
	cNXnVytHnZSG7LB5nrzvUYrrJBbeAgW9eHk42ND1xHifB/ddxEggXDcFaXl69BX8
	6lev09oQHW9cnRKPi/VwAqypcvtAr4HGl+4ZOzxW0Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t14jhdme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:14:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDvbpC032076;
	Thu, 22 May 2025 14:14:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmhru6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 14:14:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MEDxUi34341458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 14:13:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC9F520043;
	Thu, 22 May 2025 14:13:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAF9220040;
	Thu, 22 May 2025 14:13:58 +0000 (GMT)
Received: from [9.152.222.45] (unknown [9.152.222.45])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 14:13:58 +0000 (GMT)
Message-ID: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
Date: Thu, 22 May 2025 16:13:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: CI: Selftest failures of s390 SHA3 and HMAC on next kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1-vJ0Z0hwbN7Hm-ez9O5iJ4evl4QRZpV
X-Authority-Analysis: v=2.4 cv=XOkwSRhE c=1 sm=1 tr=0 ts=682f312b cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=3eKdDGRy1uvjnzN2MNkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDE0MyBTYWx0ZWRfXwz3/bsKBs/qu u22hHGXg+yMQp03L26I1jpZ+6ZMFR9pjwOgO+ldxZM96dpJ0jpcEp9Rdx+y6HqXYcv637umXq7M SLZLnli2Y8hXGgIslP+FMOOm3rqXJES6USJTfZeyA8vTPyL0n0uH9NcpubKIbjQ8+JiI34WWTyB
 85nBWHDmtDoXJXJ8hRwas5GpEriD25j8SZ1OPTlUT+dvRxtWcMg1EP4h0ysbeAfAiUnZNOxiB4a a2u9dJMIiovL87XVIAHgUi4IMmNtSJgfpAA3oGJH7kliHaERJ+8/4WkX9G8OUUCus8JUjiIKZST MmI00TnAjh5a4p80LrNIeM7pRkez7UwX2oNnhUFoNFvqkrmb17bo/mdo7lSi6Ib/6njUaqQ1n3W
 d1QH9PZORDyExJXC5LAyBQpPIL74Q2WiUt9l5LAFr01C7mVILOlZoHLmEKr+5M/mQvctADiI
X-Proofpoint-GUID: 1-vJ0Z0hwbN7Hm-ez9O5iJ4evl4QRZpV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_07,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=850 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220143

Hi Herbert,

in tonight's CI run the self-tests of the s390x kernel ciphers for SHA-3 and HMAC (with SHA-2) started to fail on the next kernel.
This must be something the came into the next kernel just recently (yesterday). It did not fail before tonight.

Affected modules: sha3_512_s390, sha3_256_s390, and hmac_s390.
Not affected are: sha512_s390 and sha1_s390. 
sha256/sha224 no longer exist as module, probably due to the move to be a library now. 
All SHA-2 digest self-tests pass, but strangely, the HMAC with SHA-2 self-tests fail....

May 22 15:58:54 b3545036.lnxne.boe kernel: alg: ahash: hmac_s390_sha224 test failed (wrong result) on test vector "random: psize=0 ksize=131", cfg="random: may_sleep use_final src_divs=[<reimport>100.0%@+172] dst_divs=[89.63%@+2522, 8.1%@+19, 2.36%@+3988]"
May 22 15:58:54 b3545036.lnxne.boe kernel: alg: self-tests for hmac(sha224) using hmac_s390_sha224 failed (rc=-22)

May 22 15:58:54 b3545036.lnxne.boe kernel: alg: ahash: hmac_s390_sha256 test failed (wrong result) on test vector "random: psize=512 ksize=80", cfg="random: may_sleep use_final src_divs=[100.0%@+4080] iv_offset=88 key_offset=98"
May 22 15:58:54 b3545036.lnxne.boe kernel: alg: self-tests for hmac(sha256) using hmac_s390_sha256 failed (rc=-22)

May 22 15:58:54 b3545036.lnxne.boe kernel: alg: ahash: hmac_s390_sha384 test failed (wrong result) on test vector "random: psize=64 ksize=131", cfg="random: use_final nosimd src_divs=[90.40%@+29, 9.60%@+3750] iv_offset=111 key_offset=9"
May 22 15:58:54 b3545036.lnxne.boe kernel: alg: self-tests for hmac(sha384) using hmac_s390_sha384 failed (rc=-22)

May 22 15:58:54 b3545036.lnxne.boe kernel: alg: ahash: hmac_s390_sha512 test failed (wrong result) on test vector "random: psize=1556 ksize=7", cfg="random: use_final nosimd src_divs=[<reimport,nosimd>100.0%@+10] iv_offset=15"
May 22 15:58:54 b3545036.lnxne.boe kernel: alg: self-tests for hmac(sha512) using hmac_s390_sha512 failed (rc=-22)

May 22 15:59:44 b3545036.lnxne.boe kernel: alg: ahash: sha3-224-s390 test failed (wrong result) on test vector "random: psize=388 ksize=0", cfg="random: may_sleep use_final src_divs=[<flush>100.0%@+2585] key_offset=82"
May 22 15:59:44 b3545036.lnxne.boe kernel: alg: self-tests for sha3-224 using sha3-224-s390 failed (rc=-22)

May 22 15:59:44 b3545036.lnxne.boe kernel: alg: ahash: sha3-256-s390 test failed (wrong result) on test vector "random: psize=512 ksize=0", cfg="random: inplace_two_sglists use_final src_divs=[<reimport>89.54%@+3198, 5.23%@+5, 5.23%@+974] key_offset=46"
May 22 15:59:44 b3545036.lnxne.boe kernel: alg: self-tests for sha3-256 using sha3-256-s390 failed (rc=-22)

May 22 16:00:13 b3545036.lnxne.boe kernel: alg: ahash: sha3-384-s390 test failed (wrong result) on test vector "random: psize=2667 ksize=0", cfg="random: may_sleep use_final src_divs=[<flush>100.0%@+15] dst_divs=[100.0%@+275]"
May 22 16:00:13 b3545036.lnxne.boe kernel: alg: self-tests for sha3-384 using sha3-384-s390 failed (rc=-22)

May 22 16:00:13 b3545036.lnxne.boe kernel: alg: ahash: sha3-512-s390 test failed (wrong result) on test vector "random: psize=983 ksize=0", cfg="random: inplace_two_sglists use_final nosimd src_divs=[<flush>100.0%@+4]"
May 22 16:00:13 b3545036.lnxne.boe kernel: alg: self-tests for sha3-512 using sha3-512-s390 failed (rc=-22)

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

