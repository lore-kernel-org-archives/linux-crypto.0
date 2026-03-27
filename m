Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2CD2FF155;
	Fri, 27 Mar 2026 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774601561; cv=none; b=XTPuqTY/U1ckH0W6B0L/EHXkcUdVUR86sMHfZPtVy7UZ4IOt8EBMij2Seh+NukHkLSA0ewjxx/ihtZkb3Dc9+068aFP0lE8DPCDoH4EQugRfzxIRmKIRMTnL2/VIQySpRi0iDovtlKZnEXdnxmc1ttaRTckpiiUzhEzzbRYS5TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774601561; c=relaxed/simple;
	bh=drwVajeJ1ekQa8MZA4Mm7eL+tdksEfy/DfsHkKXzF9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUt7dLOxbCnRNFJ3oAFx7zxNH8Qxf9IfuxAR1BRgjzz1Y64y3lrxuKi/yH2eSYfKapQN9hJzwEGgqI2VjUBE96SHguGMVFV/7APVzAUCqcWNrPdt8WOl8ohgWcEGlZK3RNC6ize3CBRCbYbO+9Hln4HOB3ejhDQEsvs4ic8hezo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pfa9eqj+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pfa9eqj+"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R5IQPe124777;
	Fri, 27 Mar 2026 08:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZZz6II
	wL7AH8wdL3XqcHtiPWSlnJH/poaFJBJ0jeCQ4=; b=pfa9eqj++VQoMfBBvpZIHs
	Q1W+rDthB6r5JD2bqcPw1tQj650BIFoLVxRrXjYG/seJnmx/v7+rpfrCNub0gnCn
	GF6jxB3cTKA9SqrwwN4JgWwZqMxbu7XDupowufIPZ4F3SQwot7XDssZTSRd1uFK2
	vll/rLBalh1wVufHb5JxXDccziZZho5DZCOqwFH0cWuGWdHDDXSCz52C/hfnftvg
	V3ovUuTXxrd18PL48bcUC3qWJwky4O4ySX9KIoak1IdSUMFGaxzhF9dBBGSGMImI
	bPB2bTIQcCtjTcMO3OpeMG8QDLgbV/cZZBq4JED0QUY6JUbiG/y8ANLcjfD5WZhA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktv862k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 08:52:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R5f7R2009143;
	Fri, 27 Mar 2026 08:52:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnxs8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 08:52:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R8qWeZ59376106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 08:52:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5989D20043;
	Fri, 27 Mar 2026 08:52:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A974D20040;
	Fri, 27 Mar 2026 08:52:31 +0000 (GMT)
Received: from [9.111.129.186] (unknown [9.111.129.186])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 08:52:31 +0000 (GMT)
Message-ID: <65c3d229-57ee-4980-a13f-bc9661b4dda1@linux.ibm.com>
Date: Fri, 27 Mar 2026 09:52:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE, en-US
In-Reply-To: <20260326201246.57544-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C9kv1xhgntrj6fN5Vjn6ldIrWVEKKlgA
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c64553 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA2NCBTYWx0ZWRfX0CSKyORlz5x4
 Tm4DzJ+vaUcJYt+if12Wrb/uh1eTbLJjh705AtyR8SwXXBNa8Cl3jjlxU5wqnk1Y4zR8DGcJZNW
 IpgNd9uprG/MPxM+SzNmkCezi3jQZWvOGFdlnYTNfCW0sg/CQU11VzGN+Wfmbx/oO/5vqs3QVZk
 Rdm6PyHYWBRH4z9sD4FbO3RcuJXQU+E/s6ODZBcGyV3wsFq8Iq+8P5zFie8kuxaxiuuJRDY72qP
 kCfeRHBzONTEcYoGzNYMkfb9Lltr9RQrIZm64HJuRxgQ7p6tLZa0mQN4sbl7fFsBfvdmoPdGLin
 aZTGzPkLtSALBW7FMrzjEX5sPh5rURuOotqTSyAuTSihW6FfSroneMW2YP1AO5mL3yc+qq0zI+n
 aKjil6oFUCOzY3ZjwKT0ElYOB621HhWmw/HBbDmkawvII6xF+x/L53Vwl2kDuOn6euvPtsMgQ1Q
 EjplDl0CEkvMetEB12w==
X-Proofpoint-GUID: C9kv1xhgntrj6fN5Vjn6ldIrWVEKKlgA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270064

Hi Eric,

On 26/03/2026 21:12, Eric Biggers wrote:
> Since DES and Triple DES are obsolete, there is very little point in
> maintining architecture-optimized code for them.  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Are there plans to completely remove des/3des in-kernel crypto support from
the kernel or is it just the arch-specific code, that is removed?

In fact there are still customers using des/3des (unbelievable!), but the
valid question is, do they also using the in-kernel crypto for their
workloads. I'll try to figure that out. Unfortunately, Harald is a few days
off and I need to discuss the removal with him as well.

Regarding the testing: in our CI we're running all in-kernel crypto modules
every night, including des/3des. So there is some test coverage.

Regarding qemu: we're currently investigating if we can provide qemu-support
for the s390 crypto instructions, but, to be honest, des/3des was not on our
top-priority list until now... ;)

We'll come back to you in a week or so. I hope, that's ok...

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

