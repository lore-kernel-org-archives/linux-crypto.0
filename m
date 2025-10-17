Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61B72C08CE;
	Fri, 17 Oct 2025 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760719413; cv=none; b=tw88VtSnN7TWih0Cghrf8zxWwzkGJLnoJ4gklJ5J5b7fgDvdVI5zcx3kiIodoTyEC01pGIUp8w0eJhoUXKLGexsAxOZUPf01hmxvf+cpPKAc3A4PhOGO/gTD7UbiyT6pg9BariyWujLGPEtRTE1NpEGOTaLuoIz12nfP6fZzwbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760719413; c=relaxed/simple;
	bh=gp5HyTgsHyFmfnF6hdUrKz5gfsHMR9+I91SzhNTG9hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lti2lwELpDa2fqIoTCntCcxZHKbFTHza6qb2kjYu/AZaNjAhzV41ZkUzmZ/vfB6tuS8BzUqO5SFSMKZznwvcsDudgAIlXKhlcrPIn9AFKNktX3E01CW2JJ3C+Ot8k3sbEVPi6rZ/xFdwioKWgMziPQhAjgGu8Had6WyRegBhPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cPub76OH; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cPub76OH"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59HGhMsa319088;
	Fri, 17 Oct 2025 11:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1760719402;
	bh=eviPgkXhGssPXTl5A+LvFuwYCmWSA2helRRT7n9ZZ/U=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=cPub76OHc19+gUbA5l1uytsQo+Areo+ZpBOqJKogg1ydUFyMxFgGPsKdPOQogO/a0
	 P1r7UJ1YYmZ4KVd1GvbcTn1gE9BIp5cGj0AJ09lIlXUjNT3cqKy31GiNzoL3e/4DqV
	 2kUVN9Z3EMO30Py9JyDut3vg59KnL6c6SLW8qXg4=
Received: from DLEE212.ent.ti.com (dlee212.ent.ti.com [157.170.170.114])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59HGhMcS2932206
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Oct 2025 11:43:22 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Oct
 2025 11:43:21 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:43:21 -0500
Received: from [10.249.132.21] ([10.249.132.21])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59HGh9Hh1591946;
	Fri, 17 Oct 2025 11:43:12 -0500
Message-ID: <07032efd-52a2-44e1-89bd-81602be9eb32@ti.com>
Date: Fri, 17 Oct 2025 22:13:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] crypto: ti - Add support for AES-XTS in DTHEv2
 driver
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
References: <20251009111727.911738-1-t-pratham@ti.com>
 <20251009111727.911738-2-t-pratham@ti.com>
 <aPHW_zyWwA36Usy1@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aPHW_zyWwA36Usy1@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 17-10-2025 11:11, Herbert Xu wrote:
> On Thu, Oct 09, 2025 at 04:11:31PM +0530, T Pratham wrote:
>>
>> +static int dthe_cipher_xts_init_tfm(struct crypto_skcipher *tfm)
>> +{
>> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
>> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
>> +
>> +	ctx->dev_data = dev_data;
>> +	ctx->keylen = 0;
>> +
>> +	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
> 
> Just use the name "xts(aes)" directly.

Ah, right. This can be simplified.>
>> +	ctx->skcipher_fb = crypto_alloc_skcipher(alg_name, 0,
>> +						 CRYPTO_ALG_NEED_FALLBACK);
> 
> You should allocate a fallback that is synchronous only.  Then you
> can store the sub-request on the stack with SYNC_SKCIPHER_REQUEST_ON_STACK.
> Otherwise the sub-request reqsize may overflow your request object.

Understood. Will correct this.>
> Cheers,

---
Regards
T Pratham <t-pratham@ti.com>

