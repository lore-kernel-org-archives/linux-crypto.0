Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7555A2FF65F;
	Wed, 10 Jun 2026 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781103147; cv=none; b=O/3EgsogLNUhPj/AlBhbehMlzXx4qqys3FK4e86D0xagI/3l7xoeytNdcU5r/tTJ5Rd/8wN0ZTna9EJx7+ni8l/A0ZydTUkCIXt3Z57nGMC99jN2zb8GBNocqDACQ30AnU5vfJZk0YHpnNbB4AFU5RnXuBBuWfHEm4z8d/3SoGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781103147; c=relaxed/simple;
	bh=xHfLm9I4RA6ubLiG+A3XoegRNCKQfmliym3JV7gg0lI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JpJsOElNxgg1FXupvdYfhDq6HlYXrZk/TeL6EII/exX6YlI6AQ+b/PZtnKvlqxZjhhuaamUfcPGVhDyDLkrwCcuKm+aDkDWPPR/N2/NhFnK7a8291RcsYYbpMwLU+P1qIjrkHyNnQxs2/xM7gDldAWMP/fqSthchOwJbILRitO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GBKNBUqt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GBKNBUqt"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ACqEQg1423793;
	Wed, 10 Jun 2026 14:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BbJHu6
	5M2hHSbbeV7Z6OhH8/1xyqpTY5Bh85Z8+dsNk=; b=GBKNBUqtdkoKGetve7kPON
	HM5/X0bxUWDjZa5Okv0qOejAvUiQMbMvCV8OdUF2jRoAwxrfvmDdQnoNVXIZgFd1
	0nMo8jOGasTVAZKz91G2as1w3KegxscRc+tOjD6MWhJB5whnLu8AN91D4S2GxPf1
	4B0z3sEbM7fHE2ypyA2OnWdlvXmf2IAh8JrRBpkM9rXYUCI4L2AEssnKDrj8br8N
	013Zis+p7yeqbh/w2qdvpJvDMe1U+hbMdP5A6XATnnuxBya2lItq+M6zztsnWoCh
	TP6lXItCFuJLldSh9haILQbuYP6K+HNmrTBydiwziUhJ3D3kqAZOK/Wuq7Kar3/Q
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4em9ye99bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 14:52:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65AEnrH5008270;
	Wed, 10 Jun 2026 14:52:15 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4emych6yut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 14:52:15 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65AEqFaV25887266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 14:52:15 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E89C95805A;
	Wed, 10 Jun 2026 14:52:14 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A6A058054;
	Wed, 10 Jun 2026 14:52:14 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Jun 2026 14:52:14 +0000 (GMT)
Message-ID: <af632d11-baea-4314-ac17-d81502240a5c@linux.ibm.com>
Date: Wed, 10 Jun 2026 10:52:13 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Fabian <fabianblatter09@gmail.com>
Cc: lukas@wunner.de, ignat@linux.win, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260607112435.42804-1-fabianblatter09@gmail.com>
 <bd992448-8ded-46f8-bf91-97792b9a11ad@linux.ibm.com>
 <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDE0MCBTYWx0ZWRfX7UoEN2LiBcIa
 b7RRQXBs1Da/HbAzgAw49RB6y3XZbdQJv1kOBqANDCte4ZM3ULCrd2dt1Ll/Tvm2dAz7mX2W6wD
 e6gBdSUW6T66HWgmTqbAyzmCtmCvrZ0Rk6BTbVwJNtYovz/YQssKFYesRFLIK+qcouv3Cmax5sD
 m1UfSfOikjzL3kZikNs2oc4t4ynjusjDzdH2bebZjFCDARF3AHRWUzQ8TCTsBZ53PGYmPxjijjK
 HcMLpCC/oTI2qmiGfib1Skf0XwTCFoTgA0dDbeMa35tD9OFHktLSGKjICdd6z8RcrnkiIpM/Q7y
 P3XI5/P6bTvCqIE6p4ThBQFn0w3QtBinX/1mqjIehvkbOouExoMh/fC+rdfpGW+mJLDSanOXEKq
 ApXDlzCTDyYtREosiYk4/nyh1aYn+y85oXysayiHeorgCqYK/5DVo482lG/geQqGVksu+ID1lXx
 TlT3fA8eQ6/fWp2TljA==
X-Authority-Analysis: v=2.4 cv=QKhYgALL c=1 sm=1 tr=0 ts=6a297a20 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=NW2m22wWZeAhEb69OCsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ircuum0IqjRgJp8R1zkfhAjjiGu537h1
X-Proofpoint-ORIG-GUID: 7Zio-7W09IQrhS1JQqgpILU7eB0IJ5i6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100140



On 6/9/26 4:51 PM, Fabian wrote:
> On Tue, 9 Jun 2026 at 20:58, Stefan Berger <stefanb@linux.ibm.com> wrote:
>>
>>
>>
>> On 6/7/26 7:24 AM, Fabian Blatter wrote:
>>> Replace the software carry flag emulation with compiler builtins.
>>>
>>> Even the newest compilers struggle with taking advantage of the
>>> hardware carry flag. Compiler builtins allow the compiler to
>>> much more easily achieve this while still remaining constant-time.
>>
>> It looks like you made vli_usub and vli_uadd constant-time now because
>> otherwise the loops could be ended early once borrow == 0 or carry == 0
>> respectively. Are all the other functions that operate on the private
>> keys constant-time?
>>
> 
> Thanks for the reply,
> 
> My primary goal with this patch was performance optimization.
> I did not add early exiting because the original version didn't either.
> 
> To answer your question: No, some other functions in ecc.c
> are not constant-time. For example, vli_is_zero and vli_cmp both
> contain early exits.
 > > My patch does remove the branches in the inner loop,
> however, the original ones were already constant-time in practice,
> because the compiler replaces the branches with cmov's.
 > > I am happy to make any changes to this patch if you like.

ecrdsa calls ecc_is_pubkey_valid_partial -> vli_mod_square_fast -> 
vli_mmod_fast and then may call vli_usub or vli_uadd via 
vli_mmod_special2 or vli_mmod_barret.

ecc_point_mult operates on a private key and will call vli_mmod_fast and 
for some non-NIST keys it may call either one of vli_usub or vli_uadd 
via vli_mmod_special2 or vli_mmod_barret.

Due to the private key operations it's probably better to keep the 
functions constant-time for now.

> I could also look into making `vli_cmp` and `vli_is_zero`,
> or others constant-time in a future patch.

I wonder whether it would be practical to suffix constant-time functions 
with _ct so that it becomes visible whether the call paths of functions 
operation on private keys only call _ct functions? Sometimes one could 
optimize functions shared by private and public key operations for 
performance -- call them with 'bool ct' in this case and suffix them 
with _oct (o=optimized + ct) indicating that they support both variants?

