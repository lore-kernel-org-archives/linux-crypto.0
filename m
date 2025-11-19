Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363124293C
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 04:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763527698; cv=none; b=FTkaJ4bplk75Dvtq6KmbCJn3lw5h/Y3yDhTqRCCBQKw/CnTy8/LjTfAp5To8ey26dYmJXV7zMHKeb/WOmhMPXp0/QfIMt0v8yV+pvzI8dpYRQTVhK+y/aWkzRv1DYuFg2GKGzVgOTn43CcPqjWnIdzttD+9P3cEQ6zocEMF5EOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763527698; c=relaxed/simple;
	bh=dcFK95FpJ2wMf+Lav4AyTqxYmfR8aNHynkBneD65okw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDOMsKrQte00cGH1LAWVBOpaPvHz1pajjbxn/GflWSOoLNOsjnN5obWoRcTkVs2w09QGEv/ENSUw5SZuFtIHDTUzf7zLUdOTPIuGnpYKvDNEjbCO+mmZKQX0yLYelThvXqgBJNhdcIyA6DZCGECURVQqsJ9+JECg3gF51ieZqUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=dRt8ZPmK; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="dRt8ZPmK"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id LWixvPsbUv724La6zvyJZD; Wed, 19 Nov 2025 04:48:09 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id La6yvmUfA5gYLLa6zvX3a1; Wed, 19 Nov 2025 04:48:09 +0000
X-Authority-Analysis: v=2.4 cv=RubFLDmK c=1 sm=1 tr=0 ts=691d4c09
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4DtsFWJC70/ZxGj2xnZlig==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=FNyBlpCuAAAA:8 a=YypKmbBTrR_Cc7_ztO0A:9 a=QEXdDO2ut3YA:10
 a=RlW-AWeGUCXs_Nkyno-6:22 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SJijPNvHMzmT1QgOFCUxZj5jR0vgwz4FEve7AiL2/xk=; b=dRt8ZPmKb525jVTFuUALaDSNUp
	7in23S8V/agXQmQ8Hi1kzV0763cPo9qy8RA6x0ZsCSp/0v9eON9eYyLextsJUWOelyxlLMlv7CuRl
	J3nqqvdCLWkF5WLeD+mKSyQ00ykMb5JMmjqAlDNJZzPhKJTDoX4J1+geXRogz65DYAwcJlDrhzAK2
	NLB0K1+9EW6puj0x8OXO+solZFF1igEZ7Y1xOduMBeSAQDWMLfsQ1v1y6OIsBSVagbCNDpHLJhdqb
	1wHTSZYpDGRAPMnjRbb2IMua7rfXutKf81fnO7K1dTVw2y+yJGoddFiOjVB/tH29IdFqi0RvX/3L3
	88/9RzSA==;
Received: from softbank126126126075.bbtec.net ([126.126.126.75]:42132 helo=[10.221.86.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vLa6x-00000003mmW-2OwD;
	Tue, 18 Nov 2025 22:48:08 -0600
Message-ID: <587146e5-08fe-4983-b432-de600d700b14@embeddedor.com>
Date: Wed, 19 Nov 2025 13:47:50 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] crypto: drbg - Delete unused ctx from struct sdesc
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Stephan Mueller <smueller@chronox.de>
References: <aRHCKMGDbWkXIY8f@kspp> <aR1JvnpTBomcKAMZ@gondor.apana.org.au>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aR1JvnpTBomcKAMZ@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 126.126.126.75
X-Source-L: No
X-Exim-ID: 1vLa6x-00000003mmW-2OwD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: softbank126126126075.bbtec.net ([10.221.86.44]) [126.126.126.75]:42132
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBKsVVWd3+CaJG5vNh5k7vgncQF5iJGM9ahV4hSChQm8Aid/MOL2Am45I0zKIZn8+EZNXCVpRIwTDh7obROJ+7yHskpUekViFZdBKS0YqWTCTj598+F0
 q3WSxHAEHHwgKyyvZmBIrOHoUsQducZ8S/Cotpz+1KPeEaHa81Dzlh9yeLXLZRXFXwLXLwml2NwBezMNFDneYug7o4I2mS/vHUL24K7MBu5pKnQRPWawoZbj



On 11/19/25 13:38, Herbert Xu wrote:
> On Mon, Nov 10, 2025 at 07:44:56PM +0900, Gustavo A. R. Silva wrote:
>>
>> diff --git a/crypto/drbg.c b/crypto/drbg.c
>> index 511a27c91813..e9f9775c237f 100644
>> --- a/crypto/drbg.c
>> +++ b/crypto/drbg.c
>> @@ -1442,9 +1442,12 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
>>   
>>   #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
>>   struct sdesc {
>> -	struct shash_desc shash;
>> -	char ctx[];
>> +	/* Must be last as it ends in a flexible-array member. */
>> +	TRAILING_OVERLAP(struct shash_desc, shash, __ctx,
>> +		char ctx[];
>> +	);
>>   };
>> +static_assert(offsetof(struct sdesc, shash.__ctx) == offsetof(struct sdesc, ctx));
> 
> This isn't even used.  Just delete it:

Awesome. :)

Thanks!
-Gustavo

> 
> ---8<---
> The ctx array in struct sdesc is never used.  Delete it as it's
> bogus since the previous member ends with a flexible array.
> 
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 511a27c91813..1d433dae9955 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1443,7 +1443,6 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
>   #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
>   struct sdesc {
>   	struct shash_desc shash;
> -	char ctx[];
>   };
>   
>   static int drbg_init_hash_kernel(struct drbg_state *drbg)

