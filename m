Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F161523E34C;
	Wed,  2 Apr 2025 13:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743600697; cv=none; b=nwCz6+mlDFSmRTeqqmZWaxr26vwboX8MM2Rk1+sbh7N9nlTapmRRfX4zOiNhPGg6Vc6jgKa3ee3sYNGoibmEmwRCyIdHmo4VBxhqAnM+cBNCF6buWWI54Jz1ybrX8K0kdTfJz8pkJgrlVgVG4IlWjDpNYe5CncGaAzWnszRIjfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743600697; c=relaxed/simple;
	bh=xpGMji0YZmUXXHAPeUj9m6SFNLOshUfsUcIsr8DGjDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iZEWUZnp8XapQJEiVvdCnw+vGNu+hAZ/lXUJmTtbzeoMH8DWIb4+qjABdu6ZxICRj/sbNE2XPN9J0mVkkGw3u7m5/nbI8w4bliK2H4TXGhRQjixfpQDc6vqRsqAJtDVzO3xUB8rrX2gU/3xhZ9SmN8ifzyT+uzDs7cixh8mhAaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=X8d7ecwP; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="X8d7ecwP"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 532DVT4D3970940
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 2 Apr 2025 08:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743600689;
	bh=1Sbk3WYt97BLD57wNauxaWmXUwdOVCVaTQXaTrqR47I=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=X8d7ecwPSlAJazla41Z2AAm/SUqFX4/DEhZd+RDXMxnzyM9fz+vsrUyM+5HPafsv+
	 B/3rBFL6eypylGDWL1sH/FJFhHrJVf1fqoTikD45R/V+7SPdMHqYEKmcBQBmk8a2fR
	 Vv831rCo0X3GM27UfMx1bLtRXygaCp+YIXoS3m2g=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 532DVTwR091719;
	Wed, 2 Apr 2025 08:31:29 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 2
 Apr 2025 08:31:29 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 2 Apr 2025 08:31:29 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 532DVQIE059761;
	Wed, 2 Apr 2025 08:31:27 -0500
Message-ID: <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
Date: Wed, 2 Apr 2025 19:01:25 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512 in
 DTHE V2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert

On 02/03/25 13:39, Herbert Xu wrote:
> On Tue, Feb 18, 2025 at 04:19:42PM +0530, T Pratham wrote:
>> +struct dthe_hash_ctx {
>> +	enum dthe_hash_algSel mode;
>> +	u16 block_size;
>> +	u8 digest_size;
>> +	u8 phash_available;
>> +	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
> Is this format identical to the software sha512 hash? If so please
> make the export/import functions translate to and from struct
> sha512_state.
>
> That way we can export and resume using the software sha512 in case
> something goes wrong (e.g., memory allocation failure).
>
> Ditto with all the other hash algorithms.
>
> Thanks,

I noticed that you are making changes to the export format of hash
algorithms (s390 hmac
<https://lore.kernel.org/linux-crypto/Z-AJFwndherQBH2W@gondor.apana.org.au/#r>,
caam hashing
<https://lore.kernel.org/linux-crypto/Z-AJx1oPRE2_X1GE@gondor.apana.org.au/#r>).
I was in process of finalizing my driver for a v2 and had some queries
about the above feedback from you.

In my dthe_hash_ctx struct below:

+struct dthe_hash_ctx { + enum dthe_hash_algSel mode; + u16 block_size;
+ u8 digest_size; + u8 phash_available; + u32 phash[SHA512_DIGEST_SIZE /
sizeof(u32)]; + u32 phash_size; + u32 digestcnt; + u8
data_buf[SHA512_BLOCK_SIZE]; + u8 buflen; + struct completion
hash_compl; +};

You are correct in the sense that the format is /mostly/ identical to
struct sha512_state. phash[], data_buf[] and digestcnt are same as in
sha512_state. Rest of the members I can reinitialize at import. The only
one which stores some kind of state is *buflen*, which requires its
value to be restored while importing. The current driver implementation
processes input in multiples of block size and stores the remainder data
in data_buf[] if the input is not a multiple of block size. buflen has
the length of data in data_buf[].

How are you planning to restore such states in import if the export is
to be made compatible with sha512_state? Do you have any pointers for me
on how to change the import/export before sending the next revision of
my driver?

Regards
T Pratham <t-pratham@ti.com>

