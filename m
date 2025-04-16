Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF32222D4F9;
	Wed, 16 Apr 2025 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744792073; cv=none; b=tjPt3AJ1KE9CqM87iLd5Yskt72zFkFE05mbnzlsTv4L1RSeloByN5p4PP2LE4Fyg+vGY5UA9zT8K3lHmcaWTR7wu3gy2zISTj+Z9LJ4xJKeaNZH7VO8vlLyMP0XRyPedpVxt/2IB7y7THcKLgCSnHnzZVzZ+qqs1WUUfAoP/Jyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744792073; c=relaxed/simple;
	bh=rGLO5eSKzY7pnjLJQrXDr/atFNjayDU/ws12KMgdQ58=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cW5VN04sOwwZkpEcnkZo16AasBtbmurlD1S1/Ql7DYJMq0IaC+m1lDyjiVEQ4ndcx1qEpaQhe2r+8IVzN96CsL4xOI6vfz0ENS0AdRx1X2kdbpDNZDs3nvcr0pF+jbD07VEo0ZF4ejp8pQ7+dYaVp0/ZkdS3lTiB1cc2uHHEENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=UJKp/Xx+; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="UJKp/Xx+"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53G8RhEp277893
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 03:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744792063;
	bh=LxIK6NSu3y/xf/BzWSlA1Pf9YKlHf1cDT0+hN9cvPFg=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=UJKp/Xx+1vpSv+EUwTVmBh6X/lfT2hCzjh1hDubjiyx1NL4LQXheDnCWYvD6hBMaJ
	 DKBjvCnoYizfxDVpKiLdiyN8OLkLxmRDhTw4Z5LXSaDV1t3i/bTiyxi+3wKQiwTmJz
	 o9thBXUuaZ4oswKhU0ZAAB2JLKJ5cvHNNrLxfG0s=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53G8RhZf030220
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Apr 2025 03:27:43 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 16
 Apr 2025 03:27:43 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 16 Apr 2025 03:27:43 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53G8ReMO003541;
	Wed, 16 Apr 2025 03:27:40 -0500
Message-ID: <860d48a5-b61f-495f-86e1-ae56187a8dc8@ti.com>
Date: Wed, 16 Apr 2025 13:57:39 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20250411091321.2925308-1-t-pratham@ti.com>
 <20250411091321.2925308-3-t-pratham@ti.com>
 <Z_9WPwz-xVdVDMMw@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z_9WPwz-xVdVDMMw@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea


On 16/04/25 12:33, Herbert Xu wrote:
> On Fri, Apr 11, 2025 at 02:43:22PM +0530, T Pratham wrote:
>> +	// Need to do a timeout to ensure mutex gets unlocked if DMA callback fails for any reason
>> +	ret = wait_for_completion_timeout(&actx->aes_compl, msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
> You cannot wait here.  The preferred method of indicating completion
> is through an interrupt.  If you hardware can't do that, then you need
> to use crypto_engine and poll in that thread.
Sure, will change the strategy and update this.
>> +static int dthe_aes_crypt(struct skcipher_request *req, int enc)
>> +{
>> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
>> +
>> +	/*
>> +	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
>> +	 * If data length input is zero, no need to do any operation.
>> +	 */
>> +	if (req->cryptlen % AES_BLOCK_SIZE) {
>> +		skcipher_request_complete(req, -EINVAL);
> The completion function must not be called unless you first
> returned EINPROGRESS.
>
> PS Please set the bit KERN_DRIVER_ONLY in cra_flags.
KERN_DRIVER_ONLY bit is set.
>
> Cheers,

Thanks.

Regards
T Pratham <t-pratham@ti.com>

