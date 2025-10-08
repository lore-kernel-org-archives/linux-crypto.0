Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF425A642;
	Wed,  8 Oct 2025 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759917995; cv=none; b=KZ1JROKUVm8RmNpqiNHmuVjCmcP+FIg9n9Kl3hnYX0K5eON7HdRLBaoQcYW42cdUqP5KUC28bi0sPPMrajtTFUsQoDUilFisscm+uZRhfuToqp4GacpUQprGvm33NMdKT7twhWWN7sqV7qEA2Z1fSRlGYqGZvxG6NUR/e7a5oKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759917995; c=relaxed/simple;
	bh=IpTDSGi+U/6yVHzaqXgawVr4MhzhK/8BtNKXbNFOBhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OpeTveXr9CdevKfY6zY3JAWKZVhowfRs++6Ga2ogP6WhKx7FxZAhCyJ8MqXsvIjpdqhLnHZmhexEYbDozRU7kySEszDsjXq8s1tZUXplLgncVZPFS5F1iMgqVB1+P17NC5jF9UeU8G8vj/J2wgVkATcVgUdW9kxGBKo1c09CjMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=SUUYx/if; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="SUUYx/if"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 598A6SR3275495;
	Wed, 8 Oct 2025 05:06:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1759917988;
	bh=/wsiKhWmVlt+wgkqRbRt+n5+sDIrvDvxgkpWZ7Y3ItA=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=SUUYx/ifSLvyXXJD8NCFTRu4gAsCQ2uizJFCNAJL2BQyRbO0w9NPUGBWz/7qRJZxw
	 aoFiM6JaWbsxjh/wri738fEexvC9fS57YbgOJq2K4pWWqewP1GdcaD2YbNpYLKS8GV
	 aX2kB/0vx+fY00xvq56dawusupXuPpOYKotIGfcU=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 598A6SZF1378273
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 8 Oct 2025 05:06:28 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 8
 Oct 2025 05:06:27 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 8 Oct 2025 05:06:28 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 598A6OZi2606900;
	Wed, 8 Oct 2025 05:06:25 -0500
Message-ID: <ae7bafa8-600b-4d4d-9937-1084cbc7e0f4@ti.com>
Date: Wed, 8 Oct 2025 15:36:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: api - fix reqsize handling for skciphers and
 aeads
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi
	<s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        Vishal
 Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251007141852.726540-1-t-pratham@ti.com>
 <aOYdodeILYU2_Pjq@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aOYdodeILYU2_Pjq@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 08/10/25 13:45, Herbert Xu wrote:
> On Tue, Oct 07, 2025 at 07:27:51PM +0530, T Pratham wrote:
>> Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
>> introduced cra_reqsize field in crypto_alg struct to replace type
>> specific reqsize fields. It looks like this was introduced specifically
>> for ahash and acomp from the commit description as subsequent commits
>> add necessary changes in these alg frameworks.
>>
>> However, this is being recommended for use in all crypto algs [1]
>> instead of setting reqsize using crypto_*_set_reqsize(). Using
>> cra_reqsize in skcipher and aead algorithms, hence, causes memory
>> corruptions and crashes as the underlying functions in the algorithm
>> framework have not been updated to set the reqsize properly from
>> cra_reqsize. [2]
>>
>> Add proper set_reqsize calls in the skcipher and aead init functions to
>> properly initialize reqsize for these algorithms in the framework.
>>
>> [1]: https://lore.kernel.org/linux-crypto/aCL8BxpHr5OpT04k@gondor.apana.org.au/
>> [2]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b
>>
>> Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>>
>> Found this while developing TI DTHEv2 crypto driver. I narrowed that
>> these crashes in [2] are due to some upstream change and not my code as
>> the same driver is working fine in our internal 6.12 LTS version (with
>> daily CI builds not showing any regression from crypto subsystem). The
>> *only* change is replacing crypto_skcipher_set_reqsize() with
>> cra_reqsize in algorithms as this patch was introduced after 6.12.
>>
>> Now, these crashes were not caught earlier because [3] split the
>> in-kernel self-tests into two configs (CRYPTO_SELFTESTS and
>> CRYPTO_SELFTESTS_FULL) which went unnoticed in my local development flow
>> and the CRYPTO_SELFTESTS_FULL config was not enabled till recently. [2]
>> shows after applying this patch, the driver passes all selftests
>> succssfully with CRYPTO_SELFTESTS_FULL=y.
>>
>> [3]: https://lore.kernel.org/linux-crypto/20250612174709.26990-1-ebiggers@kernel.org/
>> ---
>>  crypto/aead.c     | 1 +
>>  crypto/skcipher.c | 2 ++
>>  2 files changed, 3 insertions(+)
> 
> Thanks.  I've applied the skcipher part of your patch.
> 
> Please repost the AEAD part as a separate patch.
> 
> Cheers,

Sent.
https://lore.kernel.org/linux-crypto/20251008100117.808195-1-t-pratham@ti.com/T/#u

-- 
Regards
T Pratham <t-pratham@ti.com>
