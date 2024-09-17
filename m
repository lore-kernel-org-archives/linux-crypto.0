Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECA44D8D1;
	Tue, 17 Sep 2024 07:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726558604; cv=none; b=tRZFJqMF7or97l5815t3BUVLY7DhU6jS9y9bSc45ER5Jtn/K58IxbG7McR8/581Mz2eKJ99WtXwR24whw6TuJbLcVXE6lJCsnr3Y4nWtWI4XXshMC2kTs6WRq8nVF3Oj2FpFF8aClABc5hshBQuYUv9KY7uCI75nR4C7etz7yzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726558604; c=relaxed/simple;
	bh=ZvststBDAzTHIhX0h7AH2KRGVYGernVM/0s6mCT1r6g=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=fE+40Wz+c+D41T4mWmoAR5qzJ9dPdoUiGx/nL2ueA6vLwMo31PqqFqgsQCZmYwqo841p7eGd/T0P7sJV7hkfJA7Z/yk+u8xJSs5/CxPELLX7jMS4pxOHRNCkcY+y5IQnagJBxz7+J8OfXiWIxwyqmVukWfLwncW3TGbNNC/rC+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CPZRlveS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CPZRlveS"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GIUxrI031821;
	Tue, 17 Sep 2024 07:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:to:cc:from:subject:content-type
	:content-transfer-encoding:mime-version; s=pp1; bh=2DogmGh6kwn1d
	gJk2669uYJrka5rDIow0bRTDo8Agho=; b=CPZRlveSFCCMlhKGa2C5GQGcFdly0
	Gc3Ho9mwsyq+LYR24Fazkd8sqkUIi6dc0mPDTLYsBbidAoAVscJZgnXvx371Fvrg
	ne+K3+BFWJ6OixFrK9kAytyJt7yFUZmqHgvPG6okD66oaQiHIp821VoJxi1vEZBL
	gajR9sjDUNymQv7nBrs7ElQnMUrXXWwUPnZsF80Rv87vTvJs6425jbQhbUZAR6Pk
	AZphgahi7vuHzQFJ3ho+KVkXM0Q6tSimF1tYoLA8RiQDUurgifejGdy+VlyRAMlt
	IZ0fZ05GL5JPqV0TDkhpvt0eb2mRTjJFz7z9HYYtx0ZugFq85dvzEXmhQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3uj6j28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 07:31:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48H6nwZ6031056;
	Tue, 17 Sep 2024 07:31:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41npan3mmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 07:31:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48H7VUWh33227518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 07:31:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77F762004D;
	Tue, 17 Sep 2024 07:31:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48C3C20040;
	Tue, 17 Sep 2024 07:31:30 +0000 (GMT)
Received: from [9.171.174.109] (unknown [9.171.174.109])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Sep 2024 07:31:30 +0000 (GMT)
Message-ID: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>
Date: Tue, 17 Sep 2024 09:31:30 +0200
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: linux-next/crypto: Problem with loading paes_s390x kernel cipher
 since commit "crypto: api - Fix generic algorithm self-test races"
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A4eKHrsgjXpTm9FkPfaIa1SP8ygEFbFg
X-Proofpoint-GUID: A4eKHrsgjXpTm9FkPfaIa1SP8ygEFbFg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 14 URL's were un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_02,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409170053

Hi Herbert,

we noticed a failure on linux-next in our CI that came in within the last few days.
We do a relatively simple command to open a dm-crypt device using the s390x specific PAES kernel cipher:

# cryptsetup plainOpen --key-file /sys/devices/virtual/misc/pkey/protkey/protkey_aes_128 --key-size 640 --cipher paes-cbc-plain64  /dev/loop0 enc-loop

This fails when the paes_s390x kernel module has not yet been loaded with the following:

device-mapper: reload ioctl on enc-loop (251:23) failed: No such file or directory

and the following on syslog:

kernel: device-mapper: table: 251:23: crypt: Error allocating crypto tfm (-ENOENT)
kernel: device-mapper: ioctl: error adding target to table

After that, the paes_s390x kernel module has been loaded, all self-tests have passed, and retrying the same command works fine.
So the problem only happens when dm-crypt is requesting the paes cipher, and it is not yet available.
This does trigger the paes_s390x kernel module to be loaded (it has an MODULE_ALIAS_CRYPTO("paes") included), but allocating the tfm fails anyway.

I can easily trigger the problem again by removing the paes_s390x kernel module via rmmod. After that the above command fails again.

I looked at the recent commits for the crypto sub-directory and reverted some of them to see if it makes a difference.

Reverting "crypto: testmgr - Hide ENOENT errors" (4eded6d14f5b7bb857b68872970a40cf3105c015) does not make a difference.

When reverting "crypto: algboss - Pass instance creation error up" (795f85fca229a88543a0a706039f901106bf11c1) it still fails, but it behaves differently.
It now times out after a while instead of failing right away:

# cryptsetup plainOpen --key-file /sys/devices/virtual/misc/pkey/protkey/protkey_aes_128 --key-size 640 --cipher paes-cbc-plain64  /dev/loop0 enc-loop
device-mapper: reload ioctl on enc-loop (251:0) failed: Connection timed out

Syslog:

kernel: device-mapper: table: 251:0: crypt: Error allocating crypto tfm (-ETIMEDOUT)
kernel: device-mapper: ioctl: error adding target to table

Finally, when I also revert "crypto: api - Fix generic algorithm self-test races" (e7a4142b35ce489fc8908d75596c51549711ade0) it starts to work again.

Not sure if the paes_s390x kernel module is doing something special which makes it fail with your changes, or what else is causing this.
Anyway, this looks like a regression caused by these recent commits.

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

