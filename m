Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7059C3806A9
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074504; cv=none; b=rztiBhu8iC8XjLBTPflIZaWX4fIRjvVlWlp/UABqVqV5IVL3a/IwN4WfqSn/xR/N9qMKw2jTKz3fOTh48wJkbgNb/sBP2In6eUsZnuvOvLmuxs3E92g8ApogTts0vYX13jPokNeSVYG/Gjs+KFkMk+QV9Zqf5XmmH8x1+k+736Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074504; c=relaxed/simple;
	bh=ldRb32vodyMS4gcRAQveDYmFMRJituF0w9eDXM8hS58=;
	h=Content-Type:Message-Id:Mime-Version:References:To:Date:
	 In-Reply-To:Cc:From:Subject; b=oSjGuEYVItPiLV+I77rv8hBuBOcvA1UTvyBTXo3JGuTXkDU0pPW+Nr5qLAc3pL/ORzaTuEpnoaIPt7DR5htLBws+5CZ50GbgsqImK/9l4EdZ9H9misjcijWUdV/51ZE0LHOpvr8zdmSaSZ99WLMV0Tn/L96tnvS0yPIz1331QnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cqokO5oe; arc=none smtp.client-ip=118.26.132.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cqokO5oe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1772074380; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/aahbQNUcNs90GoUA49w+yF608Y2SbN20WMhGOsT/Ls=;
 b=cqokO5oeXlDHjSw9FSBnGrx+XVDzNsrYTxWIUgHSHjnYOZeCeEXGUUeYxmrm7tmUoXoZiH
 Daz0nW8SldqrDfBfuUYhxZIjPW7vbjBDOBROkiPveGhftHzpadOASnNfGT4tCbg8DH2wGz
 T92pSOrjYc+9pdXeoeCn24R6ibBwLAI1Hio0v6ch01+0dV1CfaMLOd8djhg7oaYdi5pjZ7
 OZf/VO9l2fY1pJzq2WuiTmUFrPQcxozxqIp2ztFlglkwY78PGuwVqMrnIME/qWr5X6SeIv
 Xglg4D303eSkFUAPz1UJ6JZTlcA66B11gWRuSLcZRFlfzo828cq8h+eBZ1dTLw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2699fb58a+3ccd08+vger.kernel.org+zhouchuyi@bytedance.com>
X-Original-From: Chuyi Zhou <zhouchuyi@bytedance.com>
User-Agent: Mozilla Thunderbird
Message-Id: <a952838d-5b55-433b-9980-35191ddc62de@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210153922.3435735-1-zhouchuyi@bytedance.com> <aZ-trNKwNEribGQU@dmjordan-vm.corpdevsubnet.oravirtteamphx.oraclevcn.com>
To: "Daniel Jordan" <daniel.m.jordan@oracle.com>
Date: Thu, 26 Feb 2026 10:52:46 +0800
In-Reply-To: <aZ-trNKwNEribGQU@dmjordan-vm.corpdevsubnet.oravirtteamphx.oraclevcn.com>
Cc: <herbert@gondor.apana.org.au>, <steffen.klassert@secunet.com>, 
	<linux-crypto@vger.kernel.org>
From: "Chuyi Zhou" <zhouchuyi@bytedance.com>
Subject: Re: [PATCH] padata: Remove cpu online check from cpu add and removal

Hi Daniel,

=E5=9C=A8 2026/2/26 10:25, Daniel Jordan =E5=86=99=E9=81=93:
> Hi Chuyi,
>=20
> A couple of nitpicks I didn't notice the first time around.
>=20
> On Tue, Feb 10, 2026 at 11:39:22PM +0800, Chuyi Zhou wrote:
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index aa66d91e20f9..53ce56053dd3 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -732,15 +732,11 @@ EXPORT_SYMBOL(padata_set_cpumask);
>>  =20
>>   static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
>>   {
>> -	int err =3D 0;
>> -
>> -	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
>> -		err =3D padata_replace(pinst);
>> +	int err =3D padata_replace(pinst);
>>  =20
>> -		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
>> -		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>> -			__padata_start(pinst);
>> -	}
>> +	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
>> +		padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>=20
> Above line is more readable when it doesn't start in the same column as..=
.
>=20
>> +		__padata_start(pinst);
>=20
> ...this line.
>=20
>>  =20
>>   	return err;
>>   }
>> @@ -749,13 +745,11 @@ static int __padata_remove_cpu(struct padata_insta=
nce *pinst, int cpu)
>>   {
>>   	int err =3D 0;
>=20
> Setting err to 0 is unnecessary now.
>=20
>> -	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
>> -		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
>> -		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>> -			__padata_stop(pinst);
>> +	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
>> +		!padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>> +		__padata_stop(pinst);
>>  =20
>> -		err =3D padata_replace(pinst);
>> -	}
>> +	err =3D padata_replace(pinst);
>>  =20
>>   	return err;
>>   }
>=20
> Actually err can just go away entirely.


Thanks for your review!

I will update in the next version.
