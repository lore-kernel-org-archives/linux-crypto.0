Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A9A28853A
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 12:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544474; cv=none; b=Qt7FrCOlRXLSvE2SzKBlw6ZgGS+jgIXeNQDkGvf8ERbIBJFqSUOH+g9Yi9SkCDTnXN7FEkqQL6/Pzt+fkYMx5744mEh1rlLr9DKVfzRdfjdiwC+zpX9NRBTZwUwKzJZ+XrXbN753woNxg1Sw7sgcFwbbF+KrIDL86n+dkEeiCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544474; c=relaxed/simple;
	bh=Hw6QYq/NIiWwmiC4bIjPNdVMwXUbpQraGdfNw4RFsnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kc3dx+7urFQJcpAjw4JohMdu6k83kcyZygj9BlOe3oxXqWlMMVUPopBtWW9NbkufU5c3+xJflNokJSbVkwwf7Eln2D8eaPXGRZU/nT6WUM0dJSzi8J83cKAd6TEeRpGygS7E8OElL8YMUktEW0cF1BpYt4mUG5cns7aHLEUISrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZbkmtCwg; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZbkmtCwg"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58MCYPPF781577;
	Mon, 22 Sep 2025 07:34:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1758544465;
	bh=Bvl6wqnmSssYyYv/sCT+T5ixvEAb4NryoWTKTMCmszc=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=ZbkmtCwgWmdvPBhbW3l/gUDO6+jdLSUcknp969Ur64Q4bG1+tAQZY6Z6BwNlJoqFo
	 dm6o+jPTMF6lUkiLxGxRjJQbtWPIi4BlIxJCeVjjEyzIAtZAtmiWDERb9cubrPA10C
	 C+Xh9HzuqMAzg3rTgyg4NiqjudfqLn9Buldr8Wyk=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58MCYPvv1983087
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Mon, 22 Sep 2025 07:34:25 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Mon, 22
 Sep 2025 07:34:25 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 22 Sep 2025 07:34:25 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58MCYNeb2775685;
	Mon, 22 Sep 2025 07:34:24 -0500
Message-ID: <47902488-06ea-473a-92a2-20d5af885018@ti.com>
Date: Mon, 22 Sep 2025 18:04:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A question on crypto_engine and a possible bug
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <55446d58-0ca7-4d1c-9e9c-4fcbf8dcda1f@ti.com>
 <aMotp5meAdEtqr9R@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aMotp5meAdEtqr9R@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 17/09/25 09:10, Herbert Xu wrote:
> On Sat, Sep 13, 2025 at 02:48:11PM +0530, T Pratham wrote:
>>
>> So, the do_one_op function registered by the user in *_engine_alg, what is
>> it supposed to return? Seeing the int return type, I assumed it should be
>> 0 for success and error codes if any failure occurs (-EINVAL, -ENOMEM,
>> etc. for appropriate failure). Before returning from this function,
>> we also call crypto_finalize_*_request, and pass the return error code
>> to this as well. So do we return the same error code at both places?
> 
> The do_one_op return value is used to represent errors that occur
> before or during the submission of the request to hardware, e.g.,
> the hardware queue was full.
> 
> If you return an error via do_one_op, then the crypto_engine will
> carry out the completion for you.
> 
> If you returned zero from do_one_op, then the request is yours and
> yours only and you must finalize the request when it is complete,
> with either 0 or an error value.
> 
> Cheers,

Thanks for the response. I'll take care of this in future.

-- 
Regards
T Pratham <t-pratham@ti.com>
