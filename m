Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCDC288C2F
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 12:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755088633; cv=none; b=ZkyCvpaAZ6RmbUcqOtCcl3oPJh2FEC5af84FVu8Thpktca50WhYJNYlm09IPLOFlartW5faMV+VSReT+LbVPROm1TnUzpss1YqMIPOTMlIn7l20Fk97YK6BZjWWh2kqABUoReglxRzg9DAqvRCQ7msEFI5KMpiHyy/C3VJzvrJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755088633; c=relaxed/simple;
	bh=ccUz1ORbTN7uTtSDHocXGT5xK68Kmc5zn8kSf9y/g6o=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=powWKLBi4uY1abjv9fu6iMsgO0PR1arcs3mGN9udKe8GOUfppRRZmt4j2iB/+QYGWCDDReSxJmw5ijU02ojMwOWVDSx8CTNEwwEZCFDnHKLr2be6AjVjfKiQx8RLAiD7glJ1SAsdm73SEcfgnLB98TB93/rNZ0TtpR+wnkl1Ihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VziJcmUh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VziJcmUh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQEcw029447;
	Wed, 13 Aug 2025 12:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:subject:to; s=pp1; bh=kowftNiLn9DdQTff4Y9snVqDq2Uxet+UyN6qjzMit
	RI=; b=VziJcmUhlINgPJglGwMnTOWZrPoDxhOTToZa6f8YcAz1lT6XSO42njqW8
	qWrpwoPC2yH2IrJifpzj8PtCNgnm3S5pRq1o2HlYnRAjp1MvImZO86FVMQ7KMLaa
	NRjFNzG5oEwOpfX9SnKNdBQzm6LxrGurkc05AbvHiFAOTmoGo0FFRTi4eW2bORiS
	n8aAtT+OHiKYrVK7T8dteyToMF97cLkAv6F2vU9//g0w8zxADBF0HWglktGSOFiM
	xbbJfbbpZeZkWkHzyqq/kINiaA76HmmKLRjS+nvqGWts2/qFHSV4JDYISJWAMMZQ
	tY9pV4y4ZD8vidApyOGn6CffuHD9g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudce2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 12:37:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D8TYQi025667;
	Wed, 13 Aug 2025 12:37:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ejvmf0dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 12:37:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DCb3cj52363754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 12:37:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 323B720043;
	Wed, 13 Aug 2025 12:37:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C3B020040;
	Wed, 13 Aug 2025 12:37:03 +0000 (GMT)
Received: from localhost (unknown [9.155.200.179])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 12:37:03 +0000 (GMT)
From: Alexander Egorenkov <egorenar@linux.ibm.com>
To: jstancek@redhat.com
Cc: herbert@gondor.apana.org.au, jforbes@redhat.com, jstancek@redhat.com,
        linux-crypto@vger.kernel.org, lukas@wunner.de
Subject: Re: [bug] pkcs1(rsa-generic,sha256) sign test and RSA selftest
 failures, possibly related to sig_alg backend changes
In-Reply-To: <87plczcttb.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Date: Wed, 13 Aug 2025 14:37:02 +0200
Message-ID: <87v7mrfle9.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX+mb4uWfO1qA9
 XZslhmokdiKa90e6rQinbBuGAuZsCbd8eLSltMJCAosULa7FoLEwRbJ+g+7XTfNVxMndI0K9OA1
 gdH/ZihezW34sintkjyjdttoVaZ5Q8LmMbou4rdFqvZkLn4iOG4ABKdSGW0tMKJ7Fmo8F0uRaST
 oi6AKQRLUp5A/UY5zfCzVz4i6Ywa8Rjcui356Ev0UflTBXN9SA51ucEy8uGthBWNjsb1trOlE5X
 BtCmQyKjMmOVzgG/K4GyCXcu+zK7pJmwL8zuhOmwi6DhR99EMUEaKMd1LHVz3RkPtt48EUTJEGa
 eRSgxQzkH5bOy8ulwmjKV/Wle06ZszciRIXJHGyjqpjckcBAU+zVOPo45LItukSpd8x2uOp6UZs
 XJUauJyD
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689c86f1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=vTr9H3xdAAAA:8 a=N0GSqBzKHisfYO05WboA:9
X-Proofpoint-GUID: yZZFsDKWHprHdH1abotU7fQJ3hxvnjY1
X-Proofpoint-ORIG-GUID: yZZFsDKWHprHdH1abotU7fQJ3hxvnjY1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224


Okay, i identified the code which is at fault, and it is indeed
Fedora's kernel fault. And it explains why PKCS1's sign callback returns -ENOSYS.

https://src.fedoraproject.org/rpms/kernel/blob/f42/f/patch-6.15-redhat.patch#_510

But why was this change made ?
All signing callbacks seem to be overrided with sig_prepare_alg() for some reason.
We would like to use PKCS1 signing algorithm provided by kernel. 

Regards
Alex
