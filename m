Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146B913F00F;
	Wed, 15 May 2024 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715781534; cv=none; b=Nmqo8obTccoNNg9cBsIEKomaVhFWPOz12s46TQXqxIAyVIRf8n2B+tQUUeXyRBy615cxtQyamy3CunE1VMl7dbJTDyhmv6lOxMCqxTU78ihtSlCi8kOcLeEZL8A8VQyOn9mpJkxjVOyBmtJFF7HhmrJ9RsGo1MsQESONstjPji4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715781534; c=relaxed/simple;
	bh=qJbRaR6NkJBfjzwKxbQqvsyLU2P2MTCvM6hGxUt4TRc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jjDWi85DHNx1l7wE7X49t9NdMKYjhLe1Wlm25wTobBvGIHkJJ+jf9pHVXcG8vQJIAhx4yiiRpqiSbsVU+m5/Bz/CoYBU18HZEQFG26jlXiwMutLq9NTcgq5xx7LvNL2qwg2+Jvy5CR+RTewlXPguUxB9kFRBYfQKcKjGl9Buyc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bz+kHhm3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bz+kHhm3"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44FDfX0D023613;
	Wed, 15 May 2024 13:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zPt37DEPyt+WFz7Qhwmd8YhDjXwM3w+eiE4uQ3f7kEo=;
 b=Bz+kHhm3r5w7i5M7D6850hAvlijpvflEnP5mI80VknGWmLmmIInb5x+cK7USTNKL9hPp
 a7PZm/6lcCD5DQQvRBpx8/xSZsdcgbx28GYScE8FuLiiEX+CcCaqUOmkGH5hvjxtoLQO
 36P94EjSxJlhXPq9qQXedalcm3SrFWk/VLNuj1V6QcDxAyjueYTZWcrq9A2TGNrZxu1y
 sn7PKD4Q3I0FEyPaZbe5lgHstr2o3BqGISaUbo+3NS32edWv6y4MTv7JArTYnM7rubD5
 Mjp8VeUFjmGAvVXFn6661X6R6RbWg6PH/jPO4G09q54xYtR0UfHCqeisUYefFA6l/ieR aA== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4x5681nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 13:58:37 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44FAiFlv018764;
	Wed, 15 May 2024 13:58:36 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y2k0tm50m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 13:58:36 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44FDwXnp44499700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:58:35 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18E845806A;
	Wed, 15 May 2024 13:58:33 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBA5F58068;
	Wed, 15 May 2024 13:58:31 +0000 (GMT)
Received: from [9.67.88.41] (unknown [9.67.88.41])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 May 2024 13:58:31 +0000 (GMT)
Message-ID: <7859e867-ddf4-494f-8ddb-2949aafbb40a@linux.ibm.com>
Date: Wed, 15 May 2024 08:58:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] crypto: X25519 core functions for ppc64le
To: Andy Polyakov <appro@cryptogams.org>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-3-dtsen@linux.ibm.com>
 <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
 <7eb6bf4b-5510-48fe-aa6c-ac5207d5a2c1@cryptogams.org>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <7eb6bf4b-5510-48fe-aa6c-ac5207d5a2c1@cryptogams.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 44D4IcrovAzxQUN07xlYZFX7Nka1sESy
X-Proofpoint-GUID: 44D4IcrovAzxQUN07xlYZFX7Nka1sESy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=945
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150098

Hi Andy,

Thanks for the info.  I should be able to do it.  I was hoping an 
assembly guru like you can show me some tricks here if there is :)

Thanks.

-Danny

On 5/15/24 8:33 AM, Andy Polyakov wrote:
>>> +static void cswap(fe51 p, fe51 q, unsigned int bit)
>>> +{
>>> +    u64 t, i;
>>> +    u64 c = 0 - (u64) bit;
>>> +
>>> +    for (i = 0; i < 5; ++i) {
>>> +        t = c & (p[i] ^ q[i]);
>>> +        p[i] ^= t;
>>> +        q[i] ^= t;
>>> +    }
>>> +}
>>
>> The "c" in cswap stands for "constant-time," and the problem is that 
>> contemporary compilers have exhibited the ability to produce 
>> non-constant-time machine code as result of compilation of the above 
>> kind of technique. The outcome is platform-specific and ironically 
>> some of PPC code generators were observed to generate "most" 
>> non-constant-time code. "Most" in sense that execution time 
>> variations would be most easy to catch.
>
> Just to substantiate the point, consider 
> https://godbolt.org/z/faYnEcPT7, and note the conditional branch in 
> the middle of the loop, which flies in the face of constant-time-ness. 
> In case you object 'bit &= 1' on line 7 in the C code. Indeed, if you 
> comment it out, the generated code will be fine. But the point is that 
> the compiler is capable of and was in fact observed to figure out that 
> the caller passes either one or zero and generate the machine code in 
> the assembly window. In other words 'bit &= 1' is just a reflection of 
> what the caller does.
>
>> ... the permanent solution is to do it in assembly. I can put 
>> together something...
>
> Though you should be able to do this just as well :-) So should I or 
> would you?
>
> Cheers.
>
