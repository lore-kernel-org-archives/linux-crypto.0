Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54F7153824;
	Mon,  9 Dec 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733764189; cv=none; b=HAoJcLqgpeibif2T6LvuVC3BLKfx6DLMiLOleN/SUhP3p4U/mGGoi7fBoOcVc8vXMca67XZw0BGfvBj8LGQbu5DjiT8fgqJOipVqGyhOm2oSETrZ1Gow75AZGfvnLus1fXmrt/kd8uoc4jmJuP/nWtg+rKDO9Tp2S0U/DsrH318=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733764189; c=relaxed/simple;
	bh=8iquvnUkd9mP4mKjGeYUDFGaekxyJt58LmMb3jCLRVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PshNiuXH19F7ey7dRsEoyPD4gyMZL5STlxKrDVJLXTkkVKjIreOR7zuEIDQ+TP8BA1YgMB9q9EO7ndFezyAWAjyrcObw+60IPlwxEQeikRW8TQoQEKrg7vQMXlsp7kXI8jCCalohqvmAt3dke2qUf08G5NUcfc8JWrTVQ4zYRZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c8tcSSnb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c8tcSSnb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B979qZ4010147;
	Mon, 9 Dec 2024 17:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rMahfs
	J3Td/fA/su6e+zy+RqUg85gmTe63WrocDNYQA=; b=c8tcSSnbC4oixmLo3beeTC
	5WdeCy+2nFSesl7zrq1+HnYexo7xVD7/PLN9RMGsGf+r+jxHZtQFiEczDqYeQkEC
	VKX9izErbxQteIAIjSVYheb00T1Ph7w+cfcjnmqgg3LEFDZMipcRH+H0rkBAOqeV
	rMpI28w0W+kpRbyfvDBWh6yp6NixSB/Qy8K0xtPu10R1P7f6ZyW7ZDl2bk1f5bhn
	FlXQ6O5qhLfHSWmiZGrj5/BQpWtJmnWlviNbJ/NA4dTUsAw3hTwA8VaQWJqdPTQR
	EkB3nzDOVaDp8h3rjrURaTPQtYzOvJ+clV79vOSSby3LG2pAoRBW/cgmaJK8D8yg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbsq201p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 17:09:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B9H9c6H020243;
	Mon, 9 Dec 2024 17:09:38 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbsq201k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 17:09:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9DMeGV017052;
	Mon, 9 Dec 2024 17:09:37 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xysbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 17:09:37 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B9H9aaJ15729334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 17:09:36 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60C4C58050;
	Mon,  9 Dec 2024 17:09:36 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0397658045;
	Mon,  9 Dec 2024 17:09:32 +0000 (GMT)
Received: from [9.171.71.154] (unknown [9.171.71.154])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 17:09:31 +0000 (GMT)
Message-ID: <9ff492c6-3824-475b-a9f6-415205920e56@linux.ibm.com>
Date: Mon, 9 Dec 2024 22:39:30 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org,
        yury.norov@gmail.com, kees@kernel.org, gustavoars@kernel.org,
        nathan@kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, gjoyce@ibm.com,
        linux-crypto@vger.kernel.org, linux@weissschuh.net
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <2024120938-kilogram-granite-9a53@gregkh>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <2024120938-kilogram-granite-9a53@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TYWUT8BCbKkWFLaib6iQnNNPXRiI7WoG
X-Proofpoint-GUID: OKI2mjy4yZ_rEQP27m87msTHWMF76Mkr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090132



On 12/9/24 12:15, Greg Kroah-Hartman wrote:
> On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> As this is different, my Ack does not still stand, sorry :(
> 
>> +# Currently, disable -Wstringop-overread for gcc-13+ and FORTIFY_SOURCE globally.
>> +config GCC13_NO_STRINGOP_OVERREAD
>> +	def_bool y
> 
> I hit this with gcc 14, it's not just a gcc 13 issue.
> 
>> +config CC_NO_STRINGOP_OVERREAD
>> +	bool
>> +	default y if CC_IS_GCC && GCC_VERSION >= 130000 && GCC13_NO_STRINGOP_OVERREAD && FORTIFY_SOURCE
> 
> Ok, I see you enabled this for more than 13, but why call it "13"?
Yeah I'd change it to GCC_NO_STRINGOP_OVERREAD.
> 
>> +
>>  #
>>  # For architectures that know their GCC __int128 support is sound
>>  #
>> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
>> index 1d13cecc7cc7..1abd41269fd0 100644
>> --- a/scripts/Makefile.extrawarn
>> +++ b/scripts/Makefile.extrawarn
>> @@ -27,6 +27,7 @@ endif
>>  KBUILD_CPPFLAGS-$(CONFIG_WERROR) += -Werror
>>  KBUILD_CPPFLAGS += $(KBUILD_CPPFLAGS-y)
>>  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
>> +KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERREAD) += -Wno-stringop-overread
> 
> I don't want this disabled for all files in the kernel, we only have one
> that this is a problem for.  I think you disable this, the whole fortify
> logic is disabled which is not the goal, why not just force the fortify
> feature OFF if we have a "bad compiler" that can not support it?
> 
okay so that means you recommend to disable FORTIFY_SOURCE for gcc-13+ instead 
of disabling -Wstringop-overread globally?

> So no, I don't think this is the correct solution here, sorry.
> 
> And it's odd that we are the only 2 people hitting it, has everyone else
> just given up on gcc and moved on to using clang?
I guess that developers are either using Clang or they haven't enabled CONFIG_FORTIFY_SOURCE 
if they're using gcc-13+.

Thanks,
--Nilay
