Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B0328852F;
	Mon, 19 May 2025 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747671173; cv=none; b=hT9zcbqW1uEE1feeAQusW8sLYFPLdDKAEWiURQvUxgeLewxZvYQP8tNyx5Ji/RMfP4ZuUW/ToT3lrcIyYCC5d8/aIld8Hgi7fyCnUGxVkTMPOvcwRq/HQhnq9hMjzU1ruWganNMNjnOqst/1jGpSZVrrUKa6rqNo3eJ5BRl24U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747671173; c=relaxed/simple;
	bh=0FGdQRX9yNviOG8w2LZFl68BDWbCCJVv9JvAf65PiDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KjvDcjnBvOM5nfqdYi9EyAwnEe+Meexlm9XGjTt++FqKqe5SXnDwyjkGQkeYUr0ZtCzQ6Lp/X+9CnL+hkV9IYPmMziaoweZOF2WzB+MahGBCU3Jhk1kZnM+88E4Jcg3uMLnC3HkQFLAArwQrfSHvdIskHBYeQk5hHGs8yjfjmyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M2KhjROW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M2KhjROW"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JFQLM8000802;
	Mon, 19 May 2025 16:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nqnqfE
	7gub+NUOX2zT4UR7GMAyLzSWzrgGteEK4vUZw=; b=M2KhjROWh+BYDJ9C1yd0iD
	SoHUSv2K/Tc7WzRYMa0CiPBQ95hWM3GgM20cXq3izgvem3JIRgfSlXezGWi8FQtj
	1oij6g67MxXYt3l3MbYIEjbpnj0uwvOlkrZVqZl7T/Xa7CM0as+1pBET8wKkVvBU
	48QoTwmy0OrhRec+16MuH5bfFNpJg2dljijtch38sD3LQcg5WBbkpT+EouTZj29K
	nR62ENOxgKJb0IMqVb7HebjKQsQjsKUZL0XHa1WZyizd+cfr0SR/K+q0ybxe3LFr
	/OXYxfbfx8moiw1hIOaDQC68eRL40oy+PAQTw7smFHOhq+ytxotDIRhvH4bLGEWA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46r2qhsq0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 16:12:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDMUBi028874;
	Mon, 19 May 2025 16:12:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46q55yqku0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 16:12:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JGCjB529491900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 16:12:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52201201A2;
	Mon, 19 May 2025 16:12:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0ED242019F;
	Mon, 19 May 2025 16:12:45 +0000 (GMT)
Received: from [9.87.157.62] (unknown [9.87.157.62])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 16:12:44 +0000 (GMT)
Message-ID: <a44deb14-8c48-44fc-8773-432c00bcaf06@linux.ibm.com>
Date: Mon, 19 May 2025 18:12:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] crypto: s390/hmac - Use API partial block handling
To: Herbert Xu <herbert@gondor.apana.org.au>, T Pratham <t-pratham@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
 <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
 <a0a6f359-27c8-4381-8619-d4aa2cd186fc@ti.com>
 <aBH8p-YEF3wEe4Qm@gondor.apana.org.au> <aBSJu3PTcPFNHViG@gondor.apana.org.au>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <aBSJu3PTcPFNHViG@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDE0NSBTYWx0ZWRfX041MjvNXJT+F 5ag6WvA5Cy9qrBlfpBdQCNitNqkiVevWajNMRJIQDVpWkFxeN/sPoJN9oxXPRCHAQCZhXl6yj5D mMlYKM1pVZAvUJn9EmE30Eo9Dvq/JHKTpDcIR6BoxH1O6MXZCX+FhsBHHD0iiRdqWec/jcO6sJj
 PX2dcpkndu9NArPTkj13QSlOZLbP5ET3a0XfO9Gua1wEWA7m/X5TF4yoe86ox+lh8HrZ4MIbDhN AVpoCA53cIVn8v9jx/wt41FAoDbNVusVpsRkEzVnGQyZVCll18pxe2UajEzaeLUVQsX3ihkbYd6 6dVk08RgWA5ZV0zuOPSyCXBFo8vTPH/Sya2Y9oGD4h8VJF4iKafL41Zn4/TwHZswf7HjGoMpM9m
 nT1nj4I11F/orHmlHLRa68wj1oPjXR/eXsfs3N+/wV6PG3kDyQZXMPPwlwbiu+M1zzArJamu
X-Proofpoint-ORIG-GUID: HkfdU7EHESaKEhSmEdi22nOIYypfZQrw
X-Proofpoint-GUID: HkfdU7EHESaKEhSmEdi22nOIYypfZQrw
X-Authority-Analysis: v=2.4 cv=P406hjAu c=1 sm=1 tr=0 ts=682b587f cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=FNyBlpCuAAAA:8 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=973 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190145

On 02/05/2025 11:00, Herbert Xu wrote:
> v2 fixes the export of 224 and 384.
> 
> ---8<---
> Use the Crypto API partial block handling.
> 
> Also switch to the generic export format.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This patch was also included in the test. Looks good to me.
Tested-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

