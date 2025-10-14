Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA8D2F99A5;
	Tue, 14 Oct 2025 10:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760438597; cv=none; b=m/zTkWNwEWrIwdUOxnjlx24yfyrVsbaTXf04XnvnxBRtvxk5T302c596sO6n7wo7b6ZN/ZGsKk8AQCcySZwc5KQrJA63vMwe+Agl3HVEfJKLcGozP/JuR5rnfb39dh582j4giW16GnSu7xcAexUI8QXzKQz+6bLNa45t5heks68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760438597; c=relaxed/simple;
	bh=ReS8qeSjosbnwNTYbA/8IcpVnhkJMqzRKVM+2bSyIE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D00SdRDdpklF2TFDiCwST4U+U8Hk/17PQOWJSUqzTHJ7ZSviXW91AzfEHI0PH2TaxXIG9+mOaIr4Ov0BAKcgas3FigBCN9HOlZdIJrVRcPxqqEeusjR13EFoGisULgqSjyB0DFVLScPQTPM2bJ5Ns7LEl3u1CjEfXv2j8ImkO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vk6CxZ0D; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vk6CxZ0D"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E4Rhij020942;
	Tue, 14 Oct 2025 10:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7QNyi5
	uiysfWYMNg8InQgBcvH4YRxu8C5V0H7sl+8/U=; b=Vk6CxZ0DVZO/kiPaj/iCg2
	PZa5z/FEll+jLdVoVmoCS4RFIopMsCdCFKibBCRTABbO1hxtAVQHYPJGO/Me/19C
	GbVZyxG3opk+fhnimErI2GaSxfYNNYLdUULUF69ydKIah/EYbWBjdVAx3mFDGtPi
	wGpGdkkcvtUNV0UT1uHCDllxYYLyRdcFUTIzWh0MWJs5dbFvBhAqA1gNzBQVwn/a
	aQH3uHiXRgnD+dKXCNOSoRen9XSrN4+RZiGbpy4+Y5GjUj8qKPvH931QHaM6I1/b
	ANhoH2icYC3KvYmiXkHzwz4MF5dGoGg1YKMQvO53+61C0mjot59pn79FIfWCXCvw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8p35s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:43:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59E7kbdB016705;
	Tue, 14 Oct 2025 10:43:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r32jtbs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:43:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EAh6E946596594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 10:43:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE7DF20077;
	Tue, 14 Oct 2025 10:43:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B692E20076;
	Tue, 14 Oct 2025 10:43:06 +0000 (GMT)
Received: from [9.111.132.230] (unknown [9.111.132.230])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 10:43:06 +0000 (GMT)
Message-ID: <45643b1e-907c-4ea5-8e41-a5419433953c@linux.ibm.com>
Date: Tue, 14 Oct 2025 12:43:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes
 value
To: freude@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, mpatocka@redhat.com,
        ifranzki@linux.ibm.com
References: <20251009160110.12829-1-freude@linux.ibm.com>
 <c0daf049-3b57-40ed-b212-807fd76ed079@linux.ibm.com>
 <f72fb028d4d1ddf5d1e5fae5b362ce3a@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <f72fb028d4d1ddf5d1e5fae5b362ce3a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LIEM2PJXpnQIWmFhvpuHSS1lsohntNiR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMSBTYWx0ZWRfXxnZeFOsFa1a3
 r3t3vT3PUmWTiHQcWI9S8w420lML0Nj/ujll+a6+BQbaxjWhoCWtVfNJ0zr7YLb11tQZpV7/QHR
 JVdeEBh8Fpp9sODjOUDC/DIaFap0sktpY7lLfzfLjQUb8ojfbxOIqyHHCOAfDyw0n1sAlLsJ6jF
 l2SLFnAy0w6js8os+nsEyGv1QHkh9s1tD/DYjI5sQUHliJIV+3wwAg25xSuNquB/3a+g5bhaFW2
 usL2JBvw3FE/3Zy7eNyYVlGF5JTGbqZbNvi2qT10tCLgXm/iyLtKB76ji2cjH5Pmoo1RpNsYDrY
 SWydERwDcFjhmLjt4CflLEbiFEd9ZAUsTKnJ2KkRkwlG9aYfeVLlKvUFaT0IVvDgkHNZW0nKUqW
 TdBOvlFUKjalrQW7Cd3eI8H1NX2Ojg==
X-Proofpoint-GUID: LIEM2PJXpnQIWmFhvpuHSS1lsohntNiR
X-Authority-Analysis: v=2.4 cv=QZ5rf8bv c=1 sm=1 tr=0 ts=68ee293f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110011

On 14/10/2025 12:31, Harald Freudenberger wrote:
> On 2025-10-14 11:19, Holger Dengler wrote:
>> On 09/10/2025 18:01, Harald Freudenberger wrote:
[...]>>> +enum async_op {
>>> +    OP_NOP = 0,
>>
>> The async_op element in struct phmac_req_ctx is implicitly initialized
>> with OP_NOP. Only the functions update, final and finup will set
>> another (valid) operation.  Can it ever happen, that do_one_request()
>> is called *before* any of update, final or finup is called? If this is
>> a valid case, the OP_NOP should be handled correctly in
>> do_one_request(), otherwise we get a -ENOTSUPP (see my comment to
>> phmac_do_one_request()).
>>
>> If do_one_request() is never called before update/finup/final(), no
>> change is required.
>>
> 
> Well, do_one_request() is only called via a postponed request pushed
> from one of the "front" functions (init/update/final/finup/digest) to
> the engine instance. So a request is always first seen by these
> functions and these have a chance to update the async_op field.

Ok, then you can leave it that way.

[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

