Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8B6101C8;
	Wed, 15 May 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715778266; cv=none; b=Q+Bj7MtzHcqkpw4F/7lQ0XS2vdSbe1ALXEqF8boyNqppttaUv4RKke9Dc+SOwSdJBoMr1VkXG51iEiF1mLhmkqiNhmfNHXnAy5GzULiaBn8METUstnDiWpJ4yzIegSYnnhqCpzbcwHpaLUjtf0gfIAAYUh1T2po/mE1PR7r19cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715778266; c=relaxed/simple;
	bh=Om6cqCC78ki1iXt3GHwSrwlt5X2WL23hIYafmIbP5xk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U4fnOvJRyeuH2ttfOSIWUGHcb/+mX7m/2nR2Lh84dT8+1U6vRiB3sQuZWawtql/wkmw8PelyUvsCOyctvY15RfQT3gJyTRKd8polkdEUlO73SQf110BRl06mSgaMStQSEH77QIJDdnXkWbuMLd6tmSrSi0N6miiUYxc7rVaXbmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WSAgRBnB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WSAgRBnB"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44FCxiQd023495;
	Wed, 15 May 2024 13:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ukmz9/zkyZaW6AiPM2qsUMqAdqSkOsXVQ3brcJOi5FM=;
 b=WSAgRBnBW7Con8Hrsplh8PAjRRKOLM56i3bly0NvxypJP+d3x36uirEJ615A+uF7yTmU
 qQ29zG6kBx+ePL48kqJ3L8q5BVm04rx/rrY5CBvARObON4RAgl0cD6D9ant95S1/vYLU
 UX9fiWWkC/4+32/Y3uamcuN+TRUdYJ1RPAyShgN+hU8MM0Sul9edx+ez8gOEmwO0Jk9A
 UjKVEnW72Orx8cF3ulLlZU4B3X8IIcCQesjQMWFu01Fkw7B6nPQ2C6/t9HoaxBONa13p
 IsM9jOVnmhF2QVz3UkwweyfGpsafF5CpKw8EkqR1rfr6UjmZpSbLm87wyXiqbtBiZCP1 Rg== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4vn705dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 13:04:09 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44FCMK8s005986;
	Wed, 15 May 2024 13:04:09 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2mgmkmpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 13:04:09 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44FD45FV15663622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:04:07 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FFCB5805C;
	Wed, 15 May 2024 13:04:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B1D85806D;
	Wed, 15 May 2024 13:04:04 +0000 (GMT)
Received: from [9.67.88.41] (unknown [9.67.88.41])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 May 2024 13:04:04 +0000 (GMT)
Message-ID: <db1e4dfc-04db-4f75-afc1-962d69fe39a8@linux.ibm.com>
Date: Wed, 15 May 2024 08:04:03 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Andy Polyakov <appro@cryptogams.org>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com>
 <db513fd8-4723-4b4c-bc14-7da7222617b3@cryptogams.org>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <db513fd8-4723-4b4c-bc14-7da7222617b3@cryptogams.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JFmpnHQoMDSLCzgcPJgxv6_JHlWo-5Br
X-Proofpoint-ORIG-GUID: JFmpnHQoMDSLCzgcPJgxv6_JHlWo-5Br
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_06,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150091

See inline.

On 5/15/24 4:06 AM, Andy Polyakov wrote:
> Hi,
>
>> +SYM_FUNC_START(x25519_fe51_sqr_times)
>> ...
>> +
>> +.Lsqr_times_loop:
>> ...
>> +
>> +    std    9,16(3)
>> +    std    10,24(3)
>> +    std    11,32(3)
>> +    std    7,0(3)
>> +    std    8,8(3)
>> +    bdnz    .Lsqr_times_loop
>
> I see no reason for why the stores can't be moved outside the loop in 
> question.
>
Yeah.  I'll fix it.


>> +SYM_FUNC_START(x25519_fe51_frombytes)
>> +.align    5
>> +
>> +    li    12, -1
>> +    srdi    12, 12, 13    # 0x7ffffffffffff
>> +
>> +    ld    5, 0(4)
>> +    ld    6, 8(4)
>> +    ld    7, 16(4)
>> +    ld    8, 24(4)
>
> Is there actual guarantee that the byte input is 64-bit aligned? While 
> it is true that processor is obliged to handle misaligned loads and 
> stores by the ISA specification, them being inefficient doesn't go 
> against it. Most notably inefficiency is likely to be noted at the 
> page boundaries. What I'm trying to say is that it would be more 
> appropriate to avoid the unaligned loads (and stores).

Good point.  Maybe I can handle it with 64-bit aligned for the input.

Thanks.


>
> Cheers.
>
