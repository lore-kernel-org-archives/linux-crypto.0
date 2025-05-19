Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F034CA31
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747642163; cv=none; b=QrsKxD4LLSqZlAjQp33ShUKDKHhsNlHPBjgYdyg02qsnr8yxQW6vJgVSo9LqTCcooB98ZcRdJP4CHlPNcg5qVI11TbN3EnEMobsVySJ+bq3rJIGj/v93sCMUfVf7tx7ND1A+71eFLq6VA79i/iTVDUR0+bQ6u+IqMnIEPt8ccHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747642163; c=relaxed/simple;
	bh=KVSB6lusF9EjstQ31cTrJJAUvz+CjAtQo8bJS2Bo8Rk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=P4J05UTBsBQCAEgINblQM9rpd59kruXl/lXDaLNqTzYLB1jIgDsMTToJQKdUEJ+fzbYhg4JUGHQhPEBU+bxFAIknK0rUEP1pstFoaIxVG3Cq2Hs9GcpRaqpknXWUZ+EknDVKa+ONf0L+UM19hbta4vhkU3HudtGVlMTz0QgWbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FKNv/+lv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FKNv/+lv"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J6IVsA003639;
	Mon, 19 May 2025 08:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=pUR/arg0QW8ZwzTLdq6NBKgFAAvY
	Jr5Qxlnv+V6kyxQ=; b=FKNv/+lvNXnD60KAAgCgvzsLHORdh5LmeglIf0ZCsAZ5
	KG5cNFgWvIwbZUkLjHHYgZwfydx2++QIcHIg7SGcdp4u4KqybYleTKuK3uJN35eD
	tLsr78dJfIOl4wtgzDiLBVFosh6voQkT7yvqX+JifPG56H0l9sMue31IUDu36nSX
	WZz1BTzWMrghh9Q4Pu6jyaSLurttRrSp8YfIdL2VPt1lweicRWqNN4W2RmT2KEcL
	a8KuyeTf8qhQlWwRBE1+0dSkFttQQT6xn6jtpiZk0Mq9NLuxCs1UNv14jgFSaooq
	ix92z/zZix2uWV+wHmEi30hWj833OkwKK+G6m+rZwQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qy8t8fej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:09:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54J7L3gY007225;
	Mon, 19 May 2025 08:09:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q70k5e35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:09:14 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54J89AI723003554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 08:09:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BACED20143;
	Mon, 19 May 2025 08:09:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 987CA20142;
	Mon, 19 May 2025 08:09:10 +0000 (GMT)
Received: from [9.111.147.66] (unknown [9.111.147.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 08:09:10 +0000 (GMT)
Message-ID: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
Date: Mon, 19 May 2025 10:09:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
From: Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Sporadic errors with alg selftest on next kernel.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tSiPzL7wViizBnHm6Fna5mtwO2ezhElm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDA3NiBTYWx0ZWRfX+XFehzYVHV4N tQg1l7K4dVu7nElXFUoa40obxJPWt239ASk4VxP1sqxws5lchWNCLtUk+9gsQ6AxQNwogHei3Z7 8+b1ft+Ta5cebX/goPHTicxuwYR9uG3b4CdfJbdS35a6Uocz5vV9CD7xLURTPlbP4RMI6MfCEKd
 u/CKAvBM0JJJLblSA7E/sESlp/xiAXNrDqN6T+zoVzfb6/DJZ++Scbj++XcrAi54lWuIF8cDL+f 222IkXm2EvaWBlUWo6inPXN7DCHqDjL46qQrSlMFe+pDdaZQ16/ORa2LhIZlgycP8/uKhjd73Dj jqRtkYlqcNElUN8AUTm86MkWjEXxWpjMPPKTUJk+Es2DnxMFX/6ZL1Re66QPwRpVhiL1LEg8nW7
 US9Gs/7ZQ0M1VdjcIjNb1F8nkTeaA3h5FMyGZgFJtiB6wXaUuGcNpDLg/7sSGyrXv7rx7xnR
X-Proofpoint-GUID: tSiPzL7wViizBnHm6Fna5mtwO2ezhElm
X-Authority-Analysis: v=2.4 cv=c7CrQQ9l c=1 sm=1 tr=0 ts=682ae72b cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=bVsWdRkyveJ70XYDkzQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190076

Hi Herbert,

besides the regression found in paes-crt on s390x (reported and analyzed by Harald already), we sporadically encounter additional strange failures in our CI on the next kernel:

During this weekend's CI run, we got the following:

    alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
    alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)

Last week, we had a similar failure:

    aes_s390: Allocating AES fallback algorithm ctr(aes) failed
    alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
    alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)

Those are only single failures, not reproducible, happen only of one system, although the same code is run on multiple systems.
So it must be some kind a race condition...

-17 is EEXIST, and from a quick look into the code this might be coming from registering an alg (e.g. __crypto_register_alg(), crypto_register_template(), af_alg_register_type(), crypto_add_alg()) when the alg is already there....
So looks like one wants to register the same alg although it was already registered concurrently? 

Note that the s390x-AES ciphers are usually added via module_cpu_feature_match() automatically.
Maybe a selftest run attempts to add them again while or during aes_s390_init() is about to add them as well?

Its hard to debug, since it only happens sporadically and can't be reproduced easily.

Any idea where this might come from? 
We did not see these kind of errors since long time, and still don't see them on kernels other than next. 

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

