Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C002340A926;
	Tue, 11 Aug 2026 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438260; cv=none; b=HRz0zSYqSSMpo1FYXfe3nGxvVehWHTbu47pPSqMiXtCMAQNIv5jPRjcwIQgdIxJFIFaGHWCDWebhNLep0Mhmu6kbfo30EykTG1SNsxHf9nD9NG+7HIpMWYHXZ1AlE2+DqUju7/rr57Me9De2LD7hXszGzukaGg3KhlY/8CmCEB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438260; c=relaxed/simple;
	bh=OzfoWx59Sh5alXuApFlGqWZOD+6/KWFqSzvZVJA+6hQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dyCmu9oEvFfANoyM1zTdwnx8GHlf+W1ib3kT+T0RyCM61yepbtleZT2+sdXBUxDZX+Dnb6d9gPprZ5sVCxc/AEwNrVzWPi0zx2T3YbBDWCUnsft8TCLoWv5dBPadwizJYht3Zk8lIrZvOLipEtuATTzUhtOYAUaRe3GHS+ygTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Qlx8AGFO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qlx8AGFO"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AN1hV02878931;
	Tue, 11 Aug 2026 08:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MBLxhA
	WN6jRs7iSG2ZUzMsV3wieWVxJ2orxaAKtwrHk=; b=Qlx8AGFObEa0HXhPcikmJ0
	qiK7n3lg5QAZ4ZAsfTK+1q7J7p5h3bgDT9TrrACvOLKSpK0r9bS7BxyUfD+F608c
	j9VMRVyEvt2AuxhkQhNDnGbH/8vFbTTfqPA+3t637Jbc2bA/pxL17HprkZ5N3hQb
	nQeEelNh+7MHErYsGIEWvNONgMKfFHfCcMLt/tch+tzRZg7dzyc28OouBjnoyJ97
	gSQC1HwJv96vrHPloXbvIGKSYo31casn8OH/Vz6tJFoSklrYW1/LfSY08ODr3Y4d
	XXJDaQNd1HQRCbR522DnAqEpyk7jgsT1RoJolrPmBAjHAolG+ic2i1TVSjKFL33w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvp2ug64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 08:50:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67B8fFNS019237;
	Tue, 11 Aug 2026 08:50:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxf5w0bmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 08:50:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67B8oq5C51118384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 08:50:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE8012004B;
	Tue, 11 Aug 2026 08:50:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 833EF20049;
	Tue, 11 Aug 2026 08:50:52 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 08:50:52 +0000 (GMT)
Message-ID: <ed1b9f2c-f61b-4430-a50b-be295296d408@linux.ibm.com>
Date: Tue, 11 Aug 2026 10:50:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] s390/crypto: Explicit scrub temp buffer in PAES
 ctr mode algorithm
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260805155458.14925-1-freude@linux.ibm.com>
 <20260805155458.14925-3-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260805155458.14925-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AMtp2X5w c=1 sm=1 tr=0 ts=6a7ae271 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=8hl5nwy26ca8sagq5EEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: MJ1bL9UIuj8-1OZ9ai258yW6WLE5OZTr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA3MCBTYWx0ZWRfX0gjzJt/c2emB
 T+arQiKxV5l2SDcKF//5JfZ0t3KPTZnzl5hWoUJPXkbm1pkKhYbHmo+p8UMYa8nBBeoPYY62FuS
 +797GlmA8oMjXPzhyxF2te8P87lEO35LY/VsGLtwUZBSIyWpJOpRSpZEZ4WRx59NdU42XTXi3IJ
 6creUs8faixijBz4OLz67gduWBkcctt5J0dbvWbAoRi6HhiC2Ruv9WfxeynAnX8UGuRURTrxJMa
 5AiKuY4i/12dUhqH/+ooaDKHBlZm+x5PsQLMhmh1y99KqQJN4Oz/Yb7XznVDpIEHVY7uVDzmHr3
 qwYWbxWk5vILBdNWYO97i25ppJPyY3QhmhK8ZlPMie4o6rQVFYfrVEkObDJOYwQOJBSnH/x7V/G
 UlQijZk2JXAWviXUDB748NvKwnY6ksVXcaiceOLTwG0S9ME0ge9h2jFDmimaExRSFRLpgEqf7bp
 LungDRSCEYG6mgqpaoA==
X-Proofpoint-ORIG-GUID: MJ1bL9UIuj8-1OZ9ai258yW6WLE5OZTr
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA3MCBTYWx0ZWRfX0a22x4dXVUG7
 VvFcER7urK/OkX7dwyxirV+zJJKboWK+zbwLTQrMmtZlOiRFgBVKT8GQpJ30/RUdDdH+GVL50Sp
 r6GYSxo7+nMEA+pTbDVM22WQ8aqwMM0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110070

On 8/5/26 17:54, Harald Freudenberger wrote:
> In function ctr_paes_do_crypt() there is a buffer used to process
> remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
> thus could lead to expose of unwanted data.
> 
> On exit of the function unconditionally scrub this buffer to avoid
> exposure of maybe sensitive data.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+

I would've preferred the scrub buf only if it is used. But your solution
is also ok for me.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

