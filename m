Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF341F3FC8;
	Tue, 29 Apr 2025 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745928274; cv=none; b=WZewW4nTHDACy7NIKPLWQDoGV1lV55PcG7d32pPbS7XcgNjdyRW3UC4/ZXLXcUwgp2THFITmWgXjDcXAfps+Hm3DyvV3wdOIl+dEvf/r4VMWl2UzoI+bpqT768s7Y1hhM+uo/t1GjIaymgIahiFTfvzLRJiqf4c8fZFKQAKjIig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745928274; c=relaxed/simple;
	bh=1TjoT5qfEmJRpfcaxR9aIFmERf07YaQAjsOV0XV5Nc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hmteeY3DPykHnvNHhQ7SII/7s28UWwM7UqHSpDmDwp22haH2cMJ3gm6X7AS7ntzf8Jb2/X0WdvlukRfLsvscnFMjdv/QlETK7LNsTPYoQzza1W80Y4oKIKNP2ibmLZWRfvssWFmdLQeS+FJR0alBAmHTycObeQCm1US/qosHkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=t46rUMLa; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="t46rUMLa"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53TC4LEg3075773
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 07:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1745928261;
	bh=UsgObZcraiB7Ioinl9l+ywg+X6K7yu8lVafI++/eN9I=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=t46rUMLaLhEcI1DEtX6zQxjfzZR2STckX75McEeezKBZFhqZiDdGiZeSVsQpYMh/N
	 tkgMZsQjMJGVrhX0JyMN/2naAibkIkqVp8MVeNvjPkwml+3HMThK8ZjvQR4qTQuxYd
	 e6Caw0J6K9mMhq/awpttZYxogTCPNrDPviZANwJw=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53TC4LPe063443
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 29 Apr 2025 07:04:21 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 29
 Apr 2025 07:04:21 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 29 Apr 2025 07:04:21 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53TC4IbZ052806;
	Tue, 29 Apr 2025 07:04:19 -0500
Message-ID: <a0a6f359-27c8-4381-8619-d4aa2cd186fc@ti.com>
Date: Tue, 29 Apr 2025 17:34:18 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: s390/hmac - Use generic hash export format
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
CC: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler
	<dengler@linux.ibm.com>, <linux-s390@vger.kernel.org>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
 <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 29/04/25 14:19, Herbert Xu wrote:
> [...]
> +
> +static int s390_hmac_export_sha256(struct shash_desc *desc, void *out)
> +{
> +	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
> +	u64 total = ctx->buflen[0];
> +	union {
> +		u8 *u8;
> +		u64 *u64;
> +	} p = { .u8 = out };
> +	unsigned int remain;
> +	u64 hashed;
> +	int err = 0;
> +
> +	hashed = round_down(total, SHA256_BLOCK_SIZE);
> +	remain = total - hashed;
> +
> +	if (!hashed)
> +		err = s390_hmac_export_zero(desc, out);
> +	else
> +		memcpy(p.u8, ctx->param, SHA256_DIGEST_SIZE);
> +
> +	p.u8 += SHA256_DIGEST_SIZE;
> +	put_unaligned(total, p.u64++);
> +
> +	memcpy(p.u8, ctx->buf, remain);
> +
> +	return err;
> +}
Why do pointer increment with different types through a union which is un-intuitive to understand and prone to easy errors in future. It is easy to mix up the layout of the data being stored. Why not just typecast void * to a struct exposing different fields? Same with sha512.
> +
> + [...]
> +
> +static int s390_hmac_export_sha512(struct shash_desc *desc, void *out)
> +{
> +	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
> +	u64 total_hi = ctx->buflen[1];
> +	u64 total = ctx->buflen[0];
Can use uniform naming here. total_hi and total_lo.

Regards
T Pratham <t-pratham@ti.com>

