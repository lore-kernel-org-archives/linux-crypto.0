Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E010E9;
	Fri,  4 Apr 2025 10:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743761733; cv=none; b=J9VA0JC6tibe/T4UcyWz6RZkxQS1d0lHzZPhKDotge3xuZp6yAymisXZBKjMbXVVv+ql58ahGh45/umYzqTQZh6uzIQ87kkj4gPVA+AJqleI0uOiCEUaXeJxIYvkAl0KXtq5SlxhOrXuS9OsVH0hdiwORqZk7aCLeNhH5ZM9eoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743761733; c=relaxed/simple;
	bh=gyIoBt2OOL6gSzt2KTHHzziQ4yxPniRhdjUfbgCWyAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JENfMwhP5LY+6RlzziGHNrlHJ524Ojpbr52TVs03FW/PRYdLjv/dClqem3Yr2v5oFb1cOq009Kn1PmQnr7yh4/eenZI3FxWfaq+GFn4r5jPPKc1oeLl8IZF9SdCTm0EAncue2j4uJQHrPTIEA5W9sPRUrMQojfEhzQKI7r90NMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KRtSKujD; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KRtSKujD"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 534AFQj83782346
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 05:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743761726;
	bh=4uGL39H7/qKsSx6rczsc2M6MCnKlqe6F5XvSWhvhopk=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=KRtSKujDo8PNp5r3MHa/e6WUcy1L8aROtRu9bxFUuoImsmeKZ4qVHzdvBG8cBqJI0
	 76KADuuicr4p16WfFfiMV81daYAc8Zp1xjI85eoKNMNDTLbvJ34TugiTAAi5n5mYJR
	 fVGK/rtlnLuKAZqkXxYE/FyzJs4aJb8PpiUHN9rk=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 534AFQPq011469
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 4 Apr 2025 05:15:26 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 4
 Apr 2025 05:15:25 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 4 Apr 2025 05:15:25 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 534AFNGj014523;
	Fri, 4 Apr 2025 05:15:23 -0500
Message-ID: <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>
Date: Fri, 4 Apr 2025 15:45:22 +0530
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
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
 <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert

Thanks for helping out here. I modified import/export (albeit with a few
changes/quirks; discussed below) and all self-tests are passing.

On 03/04/25 14:05, Herbert Xu wrote:
> On Thu, Apr 03, 2025 at 01:58:47PM +0530, T Pratham wrote:
>> I'm so sorry, for it slipped out of my mind that `u8 phash_available`
>> also needs to be restored at import. It's just stores a boolean 0/1. How
>> to go about handling this?
> You should be able to derive that from digestcnt.  IOW if you have
> previously submitted data to the hardware, then phash is available,
> and vice versa.
I am able to derive this from digestcnt. This is working.
>
> Note that if you go down this route (which many drivers do), then
> you're going to need to initialise a zero hash partial state in
> the export function like this:
>
> static int ahash_export_zero(struct ahash_request *req, void *out)
> {
> 	HASH_FBREQ_ON_STACK(fbreq, req);
>  
> 	return crypto_ahash_init(fbreq) ?:
> 	       crypto_ahash_export(fbreq, out);
> }
Although, I was not able to quite understand what you meant to imply
from this snippet. And I was not able to find any references for
HASH_FBREQ_ON_STACK as well. Overall, it was not clear why such a fbreq
is required and where it is being used. Hence I omitted this part
completely, and still passing all tests. Would love to know if you have
any good reason to what you suggested.
> Cheers,

Another thing, the buflen variable ranges from 0 to BLOCK_SIZE, not
(BLOCK_SIZE - 1). This is being used to handle certain quirks of the
hardware together with linux crypto framework, which I am happy to
elaborate further if required. Cutting the digression short, I have to
find a workaround to comply with your import/export changes:

tl;dr: I'm storing buflen - 1 if buflen != 0. To differentiate b/w
buflen = 0 and buflen = 1 in import, I am storing a flag in buf[1] if
buflen is either 0 or 1. Code (simplified for brevity) follows.

static int dthe_sha256_export(struct ahash_request *req, void *out)
{
    [...]
    struct sha256_state *state = out;

    if (buflen > 0) {
        state->count = digestcnt + (buflen - 1);
        memcpy(state->buf, data_buf, buflen);
        if (buflen == 1)
            state->buf[1] = 1;
    } else {
        state->count = digestcnt;
        state->buf[1] = 0;
    }
    memcpy(state->state, phash, phash_size);

    return 0;
}

static int dthe_sha256_import(struct ahash_request *req, const void *in)
{
    [...]
    const struct sha256_state *state = in;

    buflen = state->count & (SHA256_BLOCK_SIZE - 1);
    digestcnt = state->count - buflen;
    if (buflen == 0) {
        if (state->buf[1])
            buflen = 1;
    } else {
        buflen++;
    }
    [...]
    memcpy(phash, state->state, phash_size);
    memcpy(data_buf, state->buf, buflen);
    phash_available = ((digestcnt) ? 1 : 0);

    return 0;
}

I'm not exactly sure what effects, in any, this would have if this is
exported to a software implementation in some extraordinary error case.
But this is what I could think of to handle my case and would like to
know if this is an issue with software implementation. I would also love
to know how you're migrating other drivers which are storing more data
in their states than the struct sha256_state /sha512_state can store.

Regards
T Pratham <t-pratham@ti.com>

