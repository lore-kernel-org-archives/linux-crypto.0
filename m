Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C228FFEE;
	Thu, 26 Jun 2025 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750946111; cv=none; b=TriONpS+F4E0s4+tPS9FhpU0XYO/yTegdWFtsFFRCAKQmF6G5usoCdwYHyZ7X8Iqke/9emf6sHygLEabzxXODbH8yeqeGiqbjzzO9HRgAe9Nj2yLETI16xjOhtRa3Yqrsqu6tx4ItNoi6H4qeu2aW+MEXluaYusuI4t6KHiNKD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750946111; c=relaxed/simple;
	bh=j3SIJ3jwyvOUr835TAi2zHcTBQbFQUaiH6SzThFvG+Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=R7KKFRBS/nQjojL5fMM3dBvIwFgbyPmkalRWIduWNHX6FUhGHVCTCvfTXJJ3yNW2xr46c2LU8/6F31D6i6+joG5ERLV+9Wy/Vui31shqAW0TSl6vYxO+mXfUR8bcyp36PB5uNTLkM5k6Io0XSUzbCtNWcR+wdKEBQ9qsOTwrrak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JNCq8d9t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JNCq8d9t"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QDRCul023970;
	Thu, 26 Jun 2025 13:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=Q1W3KEoUepJKWyu/Rav+OY+TinV9
	DbB5FGKKSkiu1lQ=; b=JNCq8d9tIbDKcD7zw/ZzLHl4xgVr4fdL5n8eMRunttEm
	3NmgOmo4E4tAbBy/D3YnBpfrzYU04WlNHn8ny0ey+usyV+WqDeO3xmunPOYkvhNo
	IXS7Bt3aRU4eVj/dJ82pTGdujl8OZ2BGJFGMC/sf1uE7F+WV6JkYsbhqop4PUeoy
	eAXaJWbketkgox413AjNeTeIPCAl18C/Vc74Uu8SR2kBGUll5BQlzt6lSDiEJJuz
	j75AYWieoR90iJWmKMO4UKbbjsSAK9iY8YerzliXy7WfIan4/A4pBg3unqPM1aGJ
	ss8+skx5/QjjHViWumPOri62Eq1R+aFu/Ac2Zt0v0A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47h73k04qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Jun 2025 13:55:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55QCOpSD006329;
	Thu, 26 Jun 2025 13:55:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e82pf7yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Jun 2025 13:55:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55QDsxqH44499450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 13:54:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80E2E20043;
	Thu, 26 Jun 2025 13:54:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63B0C20040;
	Thu, 26 Jun 2025 13:54:59 +0000 (GMT)
Received: from [9.152.222.112] (unknown [9.152.222.112])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Jun 2025 13:54:59 +0000 (GMT)
Message-ID: <12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com>
Date: Thu, 26 Jun 2025 15:54:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Syzbot finding: invalid-load in arch/s390/crypto/sha_common.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MGmnLCG0Lb0c7Urc59CfY-RBVQNaUBXR
X-Proofpoint-GUID: MGmnLCG0Lb0c7Urc59CfY-RBVQNaUBXR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDExNiBTYWx0ZWRfX4MgkF+3BnT0k t1NW5vtcAhOLltVntTkRXIXnsl++UYZfpl5ikTfeK79rerfKA2CybPPeSY8CbDeTl6/3d2KwarZ 2Vk8nNzbGX42/Ndg4emzbftcklS6lb3CRhYu3w0vCQKsbEJf2D1UVVRUfnY7OBEPp9ouSrmOdup
 svrpUwNmMXdbx5U4byF4hVKAEKp2Kdgi+Xvs9S5ls/vsyWi62tdvZ18rT0idna/FfyA9Fzk3H7H tGLde/B7PGv/KpxZzGU4m1NlJ6K6G9+WKeTfw0r71LeNOZklZcZoXpG7FGo9LDXJFNRSPLHD4ha oMHXUcNfZw2eJQpf/LiDYbRUFJro+pW2WKsxLr4F2hDfdzhkONP+HrwX5ZYq5QQot5vREJ/I17+
 kJmcNmsNeJyB1HTq+dW/RpIOj4Tw4qZcTsYReGeY+vfaX/IuXLg2rtZpZ9pK9QrbRawrBqig
X-Authority-Analysis: v=2.4 cv=Aovu3P9P c=1 sm=1 tr=0 ts=685d5139 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=thq5atkPxQpse1b1m10A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_06,2025-06-26_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506260116

Hi Eric, Herbert,

There is a Syzbot finding in arch/s390/crypto/sha_common.c.
Yes that's s390 specific code, but I guess its due to the recent changes in the digest code....

Seems that field first_message_part (bool) of struct s390_sha_ctx has an invalid value when s390_sha_update_blocks() gets called.
No idea why it could have an invalid value, I only see it being set to 0 or 1. Maybe ctx is pointing to an entirely wrong context in that call chain (bad pointer)? 

Does this ring a bell for you? 

Status: reporting: reported C repro on 2025/06/09 15:22
Reported-by: syzbotz+cb049f03e0851197b31a@linux.ibm.com
First crash: 16d, last: now

------------[ cut here ]------------
UBSAN: invalid-load in arch/s390/crypto/sha_common.c:26:11
load of value 219 is not a valid value for type 'bool' (aka '_Bool')
CPU: 3 UID: 0 PID: 425 Comm: syz-executor420 Not tainted 6.16.0-rc3-syzkaller-11626-g336ad76bd370 #0 PREEMPT(full) 
Hardware name: IBM 3931 A01 701 (KVM/Linux)
Call Trace:
 [<00026a33d504f4ee>] dump_stack_lvl+0x14e/0x1c0 lib/dump_stack.c:120 
 [<00026a33d501fce0>] ubsan_epilogue+0x20/0x50 lib/ubsan.c:233 
 [<00026a33d852b4cc>] __ubsan_handle_load_invalid_value+0xcc/0xe0 lib/ubsan.c:527 
 [<00026a33d51d0d6e>] s390_sha_update_blocks+0x2ae/0x310 arch/s390/crypto/sha_common.c:26 
 [<00026a33d7de95c4>] crypto_shash_finup+0x424/0x720 crypto/shash.c:152 
 [<00026a33d7e06022>] crypto_shash_update include/crypto/hash.h:992 [inline] 
 [<00026a33d7e06022>] hmac_setkey+0x5c2/0x7a0 crypto/hmac.c:73 
 [<00026a33d7de8e1c>] crypto_shash_setkey+0x8c/0x1f0 crypto/shash.c:56 
 [<00026a33d7dee7c2>] hkdf_extract+0x42/0xa0 crypto/hkdf.c:50 
 [<00026a33d5fd5c16>] fscrypt_init_hkdf+0x146/0x280 fs/crypto/hkdf.c:73 
 [<00026a33d5fd9dbe>] fscrypt_get_test_dummy_key_identifier+0xfe/0x1f0 fs/crypto/keyring.c:845 
 [<00026a33d5fe617a>] fscrypt_parse_test_dummy_encryption+0x4fa/0x720 fs/crypto/policy.c:827 
 [<00026a33d634d0b6>] ext4_parse_test_dummy_encryption+0x36/0xe0 fs/ext4/super.c:2071 
 [<00026a33d6348fbe>] ext4_parse_param+0xe7e/0x2130 fs/ext4/super.c:2314 
 [<00026a33d5f4a896>] vfs_parse_fs_param+0x216/0x510 fs/fs_context.c:146 
 [<00026a33d5f4b23a>] vfs_parse_fs_string fs/fs_context.c:188 [inline] 
 [<00026a33d5f4b23a>] vfs_parse_monolithic_sep fs/fs_context.c:230 [inline] 
 [<00026a33d5f4b23a>] generic_parse_monolithic+0x24a/0x2f0 fs/fs_context.c:258 
 [<00026a33d5ed4d88>] do_new_mount+0x248/0xab0 fs/namespace.c:3881 
 [<00026a33d5ed3450>] path_mount+0x680/0x1180 fs/namespace.c:4209 
 [<00026a33d5ed8606>] do_mount fs/namespace.c:4222 [inline] 
 [<00026a33d5ed8606>] __do_sys_mount fs/namespace.c:4433 [inline] 
 [<00026a33d5ed8606>] __se_sys_mount fs/namespace.c:4410 [inline] 
 [<00026a33d5ed8606>] __s390x_sys_mount+0x5c6/0x6e0 fs/namespace.c:4410 
 [<00026a33db0a14f2>] __do_syscall+0x122/0x230 arch/s390/kernel/syscall.c:125 
 [<00026a33db0c521e>] system_call+0x6e/0x90 arch/s390/kernel/entry.S:261 
---[ end trace ]---



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

