Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A3B67D;
	Fri, 13 Sep 2024 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726237021; cv=none; b=G6G52OmoSR3E5rc1okCdmi3oEoHx3Zv1j12KS+yja+/Si0IGUrdQG6roWlBTNtm6XilPN5T+e2JobvyMsNMpbeivjtJ+EuvXk8/Jrkg0SD1hAoH7GCj8JabnQRRgwHIwWfz+l4i/vRsdscQmAAWRO11guZ2TNsxA7LhVUMsJT+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726237021; c=relaxed/simple;
	bh=QU6uT6lAbpe0mepp8W6skjQzIgbhyf8e5y0ReybLeM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1r3Fng7ABa/2PxakzQb8oMZSsb1JTheWX2bVZE3Jbo4Z4nKfh/vBiTd6sMnCNruwEji62KOYBWl5OOmJjW9qtHMxTNCpfCfPA9f378SnTNEW0mAjmp3sglDcVjcfKgShWuDU9zHUrVXGNoJSEK8kTBRat+WTOFJRX/HfeSUIO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l5imSffl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l5imSffl"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DC5MjG017225;
	Fri, 13 Sep 2024 14:16:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=tpg4DzrCNwpPwgcofK+9l7FLwHa
	1nwvoUf9a1kt2Kb8=; b=l5imSffld8j+g1Z9M4Q3uNp7dZ34JVfQ00MEo94giN/
	OhoC/v8oXODtCVsfDMcbxlrHZlNpcwC+OesjCgDZNZDIz4pMI/5Ce2a901Z4nBTB
	BCVcn0Ugj6jvX8mjDIn49SoI98qMXh3jExe37VjhF6bFGBGdxayB0re+aXxlmGL+
	a2ZJpsDzo6bKAxjARjy2Y0O/Hf7vypMYaSpHv5j2lKwt3fS3NoOZC/lQKpPstdS9
	ipJH9QbyGQWBmNbt1u7zTj7sY3kuB6sfGZ4wLkelYihhx4m+nwF3LUakap/bu/z0
	uxpT6ahiYMX0QzB2FZMJ9+B51sw+SngllixjCCwbc7Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41geg029hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:16:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DCYDXr010811;
	Fri, 13 Sep 2024 14:16:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb7292g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:16:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DEGr4d54985174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 14:16:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E68A2004D;
	Fri, 13 Sep 2024 14:16:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 148CF2004B;
	Fri, 13 Sep 2024 14:16:53 +0000 (GMT)
Received: from osiris (unknown [9.171.6.86])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Sep 2024 14:16:53 +0000 (GMT)
Date: Fri, 13 Sep 2024 16:16:51 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <20240913141651.30385-A-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRD58DrEzzcXKZg@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuRD58DrEzzcXKZg@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wmfrrqZXSmg1WQ-jA4kMAlgLuLh273a9
X-Proofpoint-ORIG-GUID: wmfrrqZXSmg1WQ-jA4kMAlgLuLh273a9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=498 priorityscore=1501
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130098

On Fri, Sep 13, 2024 at 03:53:43PM +0200, Jason A. Donenfeld wrote:
> On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> 
> I'd be curious to see the results of ./vdso_test_getrandom bench-single
> and such.

It looks like this with two layers of hypervisors in between, but that
shouldn't matter too much for this type of workload:

$ ./vdso_test_getrandom bench-single
   vdso: 25000000 times in 0.493703559 seconds
   libc: 25000000 times in 6.371764073 seconds
syscall: 25000000 times in 6.584025337 seconds
