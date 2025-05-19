Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D3287519;
	Mon, 19 May 2025 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747672851; cv=none; b=K9jgNFW+mbDHefljzL7AhR7q0ybprFVa6CQ+YXvuIAljTmxafaKxSQCGsTNFelukU6DDLUf38+DomolB/oRo5P2vGjvxb5BigIaOp3EMJlSRAuSTG2OGmkNmYxDEmCc+kJSw4Q4ZHI39chSKn872a+MZN5XcCzaO8WA6+NPqets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747672851; c=relaxed/simple;
	bh=N8a+GbLz48jGPo1BCxokbBw2OHevnUXImEU16lJD6kU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iuC/jRGuZfSnZuUcE9Atmh+0wzLjgILFpVqr28vXKLJuUtKVDInTFKdD4YLlRW43a23ALfCuhiKCYfIdw9n8AaGdzvE/90qvtGfM4L3mofs46ibaOeEBwxohaJ1tBXgMhGlvO5iS22dWpD+Dv3qrmHmyNN/QybmFdZA7iDAW+3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aQk0CJqW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aQk0CJqW"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JFQ8Ik031367;
	Mon, 19 May 2025 16:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=01QrtR
	jE/pe9tb4EmbAneXhZYGd7NOQzCVcinuNEoyQ=; b=aQk0CJqWNu9isVwe2vgjEX
	sqTKe9Aeaussw7RnDsb0QPJqLjy3JpUqfQXSMfhgHAifxf1W9j4qz0MdUYgQI6L2
	nx3Rhc91z5uCUWMcOsn+r9rso0X7HXu+ZEjEuYdVzoyKeRFV7kbNdh+QqbektJV6
	S/LbVgqA/ZaTDVtkJS+ds+KBxlXVdjOgfnltBSmwwqbLboifRq/I0cQg72nGeiDM
	8G0eSr8xspBUINs+j7EBLbWlZl7lXMdV4u2nEoMGgyr36+FM82sdO1XovsLauOxs
	sve6ByPFd+hxDjC7ScvbOtMM83Ckc0ifT2lJrW3coWQQMBMJ0GtZDg1U8W++Otqg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qn68mvur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 16:40:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JF145H005297;
	Mon, 19 May 2025 16:40:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46q69m7eqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 16:40:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JGehfI46334404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 16:40:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4FC620194;
	Mon, 19 May 2025 16:10:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C7D220193;
	Mon, 19 May 2025 16:10:50 +0000 (GMT)
Received: from [9.87.157.62] (unknown [9.87.157.62])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 16:10:50 +0000 (GMT)
Message-ID: <856561b7-3547-4fd9-8fc3-a8462cffee07@linux.ibm.com>
Date: Mon, 19 May 2025 18:10:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: s390/hmac - Extend hash length counters to
 128 bits
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
 <cd23dee0d92e06f5b8d489b321dacb5dc4597376.1745916278.git.herbert@gondor.apana.org.au>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <cd23dee0d92e06f5b8d489b321dacb5dc4597376.1745916278.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hQvnMmDLH6SWOEcEhO6_azgMEfhw0wMj
X-Proofpoint-GUID: hQvnMmDLH6SWOEcEhO6_azgMEfhw0wMj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDE1NSBTYWx0ZWRfXx1/HoAp8i5th radIzwSfSDrJDbiKJNZXaHvMlsmB1EX3wMyXJcZBTGBF/oGcSpOkG7CPkP2Mk6RkoxE55+n9pje 75wzvzpIlnRB/uO2aiswdeGU/uTx6KJwECpuOhkfX/j4KjbvHhVaCCan6YPvdM3ED10+8vY1CLs
 HyAsSYCBiBtPN5ldQMpFSM0sWsZovdDI/89fRtUZeOGFOF00jnrr/F/JwZbR2P9E2CGWer51hoe f4a1dqheIM9zWfqPcPlQXqZ025hqbhUF6oaDSkS5Dv7nflxZ5r1wqkPiL2uKyBWkz5rLtTQIaaC fM5yWNMUESWeO2j0TNnNt1YBZaGPYoPWBhvwVxHzpnNL0D5dF5NxOL9JT1udpKOpHVlg3Rh15BZ
 bmbOpzlZPiGEeHQZTpRKGK04PIqOQCXvQFQfNJ+1fj6t+BHiCKw9UvbfsGvpizXNGSFzDQbA
X-Authority-Analysis: v=2.4 cv=CN4qXQrD c=1 sm=1 tr=0 ts=682b5f0e cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=FNyBlpCuAAAA:8 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_07,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 mlxlogscore=775 priorityscore=1501 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190155

On 29/04/2025 10:49, Herbert Xu wrote:
> As sha512 requires 128-bit counters, extend the hash length counters
> to that length.  Previously they were just 32 bits which means that
> a >4G sha256 hash would be incorrect.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Look good to me.
Tested-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

