Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D3230648C;
	Mon, 22 Sep 2025 12:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544904; cv=none; b=K0icEsmy4l3EBhiVlgY1E1b+fvnRiAgcqalixupw5bossJZyaW/I58IUsDwDgCzEFuNo3p0c0Xl60vQMMTiTZJgavTfqhia7DE0B+6Sh9jmne5KarkKp5xKmRhiiHu9r1R+HXUXzhL2PJ1q95s7qArI0WLVdbv8j5M2bUjJGU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544904; c=relaxed/simple;
	bh=fa8I0HJf9Hu8nlmRXZKypcgcpmA+mIVk83stAz4Ehj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QUBkMsIZGzyDSAwFXhiJJhQnz5nqq9JhGlm7R2A0yau/Xt2tjJ1J4A4YvfnIbavqXQt9gq0YdXvVs+P0vPQHLYURxKVrUc0krb1PzHs1fItmmL93hgPWHT43ml/cWmpOyHoiKkMmSQXjxhtODeM3XGO86Qw1VaxBpIjHYv/KK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cg7tjhW0; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cg7tjhW0"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58MCaZx0767870;
	Mon, 22 Sep 2025 07:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1758544596;
	bh=VqMG1tCpCdUZdT54p/gMUyDbkNMx8mDeub7N1P1QKp4=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=cg7tjhW0BShbif141QvJ/nGEjZLzhYFqOawsoLKwavBznE25mgVKATr+aN/MR9b1J
	 Taw5nRm4JvM5hMg0iAcy0gAKrawP2hfh2Bb4sM2sBq0ByxoOIUNUih/urB6a95i4Ho
	 EtEGIk1wbd1T4Cx6SH2ySDnbsHIkrtTZc+CE6zd0=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58MCaZtU879994
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Mon, 22 Sep 2025 07:36:35 -0500
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Mon, 22
 Sep 2025 07:36:35 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 22 Sep 2025 07:36:35 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58MCaWFW2515847;
	Mon, 22 Sep 2025 07:36:32 -0500
Message-ID: <c0196ac6-af65-48c1-bc5a-ca430dff0a5a@ti.com>
Date: Mon, 22 Sep 2025 18:06:31 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] crypto: ti: Add support for AES-XTS in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20250910100742.3747614-1-t-pratham@ti.com>
 <20250910100742.3747614-2-t-pratham@ti.com>
 <aM6ZNMR0CtDj01Iu@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aM6ZNMR0CtDj01Iu@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 20/09/25 17:38, Herbert Xu wrote:
> On Wed, Sep 10, 2025 at 02:46:53PM +0530, T Pratham wrote:
>>
>> @@ -397,7 +446,29 @@ static struct skcipher_engine_alg cipher_algs[] = {
>>  			.cra_module		= THIS_MODULE,
>>  		},
>>  		.op.do_one_request = dthe_aes_run,
>> -	} /* CBC AES */
>> +	}, /* CBC AES */
>> +	{
>> +		.base.init			= dthe_cipher_init_tfm,
>> +		.base.setkey			= dthe_aes_xts_setkey,
>> +		.base.encrypt			= dthe_aes_encrypt,
>> +		.base.decrypt			= dthe_aes_decrypt,
>> +		.base.min_keysize		= AES_MIN_KEY_SIZE * 2,
>> +		.base.max_keysize		= AES_MAX_KEY_SIZE * 2,
>> +		.base.ivsize			= AES_IV_SIZE,
>> +		.base.base = {
>> +			.cra_name		= "xts(aes)",
>> +			.cra_driver_name	= "xts-aes-dthev2",
>> +			.cra_priority		= 299,
>> +			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
>> +						  CRYPTO_ALG_KERN_DRIVER_ONLY,
> 
> I think it's missing CRYPTO_ALG_ASYNC.
> 
> The existing algorithms seem to be missing this bit too so we
> should fix that first.
> 
> Thanks,

Oh. Thanks for pointing this out. 
This series had a few more issues with some of the algorithms, so I was about to send another revision anyway. I'll also correct this. And also fix the existing algorithms as well.

-- 
Regards
T Pratham <t-pratham@ti.com>
