Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E141C6D;
	Sun, 22 Sep 2024 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727038492; cv=none; b=NJu/bxm5na5ULchCMNKWC7R3j8mJT+k/pKqUHNJYvUTTGAbpFB7/K/V5hhMbbuaG0D5gP+k6Jsg34xyHwq28Of17sR09sATvLe3AurFrV9BVMqFVtFrhuml9ZDqnpRPOxn9IC+Rq70/f95QzFW3PoOXEoIN4e+Vtv2R6mfhqH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727038492; c=relaxed/simple;
	bh=CVh7N1YlbzxKEaaUtsDgOkSHfpFQMRKGkpac58HmX24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HE+wGbzgBVBE93yLQsfAzGF60M0MgTrfS0VpGr4tWmLECjSOCB0lF2i4ve9//G07QmIIfl7CiRs8nTd7HWJBbw/RKdCZLugkckyN2nFw8PCnCzdVB95bfPzH+Yl9Q0Q3elPSPWSa9e3C3ehtKjK3ebf9lDnqs/tNH9NsRJ+I0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DsLE08ok; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DsLE08ok"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48MIlQHO025857;
	Sun, 22 Sep 2024 20:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=S
	XtEovATvwsh/6WdQwPpFVGwM2WcxRBkXVMZxUz43oA=; b=DsLE08okN6xtCTybL
	ITkxg4h6eiu2/Lf+ziNTb5OkC0H7uDYhsz87HeJg4jhsaZqhTDrHWCAeMsiWrY0t
	2H9G6hNnrShe/XGl6kqOpsrowbe97+wj05z9ThJN0CpnrYLt7CpTEoPxB7uWiGhw
	h2yqZCY/A3/hsr+Y2z/ftVUPVmy5Frfk6MkQcJE/FqPzf9f9DLILnIVL56nT7iw9
	7qUKUL1TIF8Vaay5869EUpF2zXidZBGAZa2vWUyVy975iQv7BEmb1uR5yVw2gxKn
	B0PTwz4OQGyUQjofKxGmuLJ2s+2CG/XtYgZnS4kLBHYkoD/akMMbjmOH8AHnTQJn
	BiM3w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snt0yydv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Sep 2024 20:49:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48MG63vu008684;
	Sun, 22 Sep 2024 20:49:22 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41t8v0uejw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Sep 2024 20:49:22 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48MKnLci22807128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Sep 2024 20:49:21 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3533358056;
	Sun, 22 Sep 2024 20:49:21 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAB8F58045;
	Sun, 22 Sep 2024 20:49:20 +0000 (GMT)
Received: from [9.61.255.78] (unknown [9.61.255.78])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 22 Sep 2024 20:49:20 +0000 (GMT)
Message-ID: <4dbb0949-02a9-4f52-b9c5-5939d9004455@linux.ibm.com>
Date: Sun, 22 Sep 2024 15:49:20 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto: Removing CRYPTO_AES_GCM_P10.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240919113637.144343-1-dtsen@linux.ibm.com>
 <Zu6SeXGNAqzVJuPS@gondor.apana.org.au>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <Zu6SeXGNAqzVJuPS@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8WOwtgfHcfk_26zwTLDhRuQUOaJF18-m
X-Proofpoint-GUID: 8WOwtgfHcfk_26zwTLDhRuQUOaJF18-m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-22_20,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=850
 priorityscore=1501 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409220159

Thanks Herbert.

-Danny

On 9/21/24 4:31 AM, Herbert Xu wrote:
> On Thu, Sep 19, 2024 at 07:36:37AM -0400, Danny Tsen wrote:
>> Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
>> Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.
>>
>> Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
>> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
>> Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
>>
>> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
>> ---
>>   arch/powerpc/crypto/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
> Patch applied.  Thanks.
