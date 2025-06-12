Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258821A3154;
	Thu, 12 Jun 2025 05:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749707375; cv=none; b=TS9u9fX4OMNre1eKOAaWc7E6EEwBQEKrDXD6pi4QiErxUv2pSk5WD00v/3pVzUTAMH9zfp5Py11zQt5m1Sv6TcvBNDTa8ztL+UBh3ggytbwzDeb4/z0lfec/SmarrzlxleUA0QVQX8NEka6x3cWaWwGFa0grEhbeWBJu1DD7HOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749707375; c=relaxed/simple;
	bh=oeDseZ1YruLWRioQVS3zDkAVsr+7kPiWpSRYhiOD97o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UZ0fBuRP9dTQF+o8HE2z1JDgqk50tl+8m65vT3NDmFuXhYvrcAT3+FammJbq3RDAYokv3+aWS27/XbRzQ6doG0ozTz+UTSGbvh1fAQtipYtjUwvQP6ijlgU93UlhweKpk5ZRLBRX5P/usk2Mr0lyiotJJfyzdgNIsmaYUIci/bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=kSZHA9eb; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="kSZHA9eb"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 55C5nRUp2782013;
	Thu, 12 Jun 2025 00:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1749707367;
	bh=wQ6UkrjNlmGOI532P0hm6reVg7bumxMRL0dV7Vudxcc=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=kSZHA9ebgObsjXOQo1VGDu0Ugbd4T3XbRfKSQwTdtMx7Ies2RVBjaYD6lMYWudeOf
	 AUUKqZC4OH8ZDNphsjuRSuFhA1Z+JdG5cMo+ZkJSE8zT1gMT1TzFLUkJyQjuQ4+Fwx
	 I1p058KD5ndbggcvKmYyAlHazvU4ts8jBxvMzZiY=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 55C5nR251566750
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Thu, 12 Jun 2025 00:49:27 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 12
 Jun 2025 00:49:26 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 12 Jun 2025 00:49:26 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 55C5nNSu1494290;
	Thu, 12 Jun 2025 00:49:24 -0500
Message-ID: <b31e87f3-92b1-45fd-be62-48eccc4f0a4c@ti.com>
Date: Thu, 12 Jun 2025 11:19:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri
	<praneeth@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250603124217.957116-3-t-pratham@ti.com>
 <aElNLaBWM56vyFC6@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aElNLaBWM56vyFC6@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 11/06/25 15:02, Herbert Xu wrote:
> On Tue, Jun 03, 2025 at 06:07:29PM +0530, T Pratham wrote:
>>
>> +static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
>> +{
>> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
>> +
>> +	ctx->keylen = 0;
>> +}
> 
> This is pointless.  Just get rid of the exit_tfm function.
> 
> Cheers,

Okay. I was under the impression that init and exit functions were mandatory. Seems like they are not. I'll remove this function.

Regards
T Pratham <t-pratham@ti.com>
