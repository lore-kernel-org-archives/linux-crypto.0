Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8927F241CA0;
	Thu,  3 Apr 2025 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743668939; cv=none; b=Kdtjd0sGSwvaVfDYF9PdnGgzl+3ADKdVOnFGB/LSvia0IihcLPgJ7SiByrD9wSTvGToe/EluZA3a+w2Lsmpo5KCnMIDZNjqIw1tmCuJEdZlGouLR0Cy40/ntqgBid1YRyvCkLbbVl8I0Laf/n/4aqTOAR1ms64eI2oVLD9YamsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743668939; c=relaxed/simple;
	bh=5kg6MD3nj0ohpaJDH609Gk9VsSrlSJjglviZAc+FxdM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=S2BO1RfOzJOCfhzszoBcZsMpAM+XRJ19PeZVOiWjIV1tjAbmZOUpZTsCy/flWOUgDDkStyddkVZ1d8cqDUJCxtYRPYwuLrzBv0EQX0eEGPiQH5wE65n5nIj1dQZgYiDGg5fCW1vlzla1q1LGtdxm/+MXwRHfcy7hxB09gNt88LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=YL/rs92E; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="YL/rs92E"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 5338SpqO4158497
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Apr 2025 03:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743668931;
	bh=M0TpbzeGdF6pMQfqxvB4s130TjuGSPYhHFX+qsY8DBE=;
	h=Date:Subject:From:To:CC:References:In-Reply-To;
	b=YL/rs92EvS/D7C96FT2KyYOdobBV3w3Y4ouWfdRgdMHkR+YprR+10JQnUux69bTCf
	 TWSZmhw1UA7IMD/G+YS9M+4memZ0Bon1uEgt2NNlksgj7StUYivuK84pHeLukKCMrd
	 LnPz28Hdj4SkXmVdu69KeFYsbise6XCBeZbfMvRY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 5338SpQ9033456
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 3 Apr 2025 03:28:51 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 3
 Apr 2025 03:28:51 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 3 Apr 2025 03:28:51 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 5338Slil049858;
	Thu, 3 Apr 2025 03:28:48 -0500
Message-ID: <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
Date: Thu, 3 Apr 2025 13:58:47 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512 in
 DTHE V2 driver
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
Content-Language: en-US
In-Reply-To: <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert

On 02/04/25 19:01, T Pratham wrote:
> Hi Herbert
>
> On 02/03/25 13:39, Herbert Xu wrote:
>> On Tue, Feb 18, 2025 at 04:19:42PM +0530, T Pratham wrote:
>>> +struct dthe_hash_ctx {
>>> +	enum dthe_hash_algSel mode;
>>> +	u16 block_size;
>>> +	u8 digest_size;
>>> +	u8 phash_available;
>>> +	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
>> Is this format identical to the software sha512 hash? If so please
>> make the export/import functions translate to and from struct
>> sha512_state.
>>
>> That way we can export and resume using the software sha512 in case
>> something goes wrong (e.g., memory allocation failure).
>>
>> Ditto with all the other hash algorithms.
>>
>> Thanks,
> [...]
>
> You are correct in the sense that the format is /mostly/ identical to
> struct sha512_state. phash[], data_buf[] and digestcnt are same as in
> sha512_state. Rest of the members I can reinitialize at import. The only
> one which stores some kind of state is *buflen*, which requires its
> value to be restored while importing. The current driver implementation
> processes input in multiples of block size and stores the remainder data
> in data_buf[] if the input is not a multiple of block size. buflen has
> the length of data in data_buf[].
>
> [...]
>
I'm so sorry, for it slipped out of my mind that `u8 phash_available`
also needs to be restored at import. It's just stores a boolean 0/1. How
to go about handling this?
Thanks for your help.

Regards
T Pratham <t-pratham@ti.com>

