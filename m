Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277927602C
	for <linux-crypto@vger.kernel.org>; Sat, 10 Jan 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768065883; cv=none; b=Vd+kKQyd2U5SanEfTmype1VxTDhOPuqxY/FjDaYDnf1ENXGtp9DfGU0hmyjuoaEt8/PzaIJ/t2lC0wQY9tmQvuwbN1GNFokaO1MGBirZ0dPxr6uJHjjoRkSMSKAru1ziNruY29eOtBHI9GBPtPvjY3nVlVG5icvZs1lRrSo0pw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768065883; c=relaxed/simple;
	bh=hPid3r49WbyqMo7HqZZ3c2+FUVb1w9OxUGh8Ees5wmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ErLZ9Ej/yb/390x9WWNsNBJestGfgOw+rhu1sWsvKCFdxTp0J8zd1aga2zYzfm06VpkGH1KZ2vukG7xOsm4wgGFTjUPSZdRc5XOyY5p8wJxJpZtVgtv85wjyhFEGWXAdXEF56IsM4u1xH7PvSJl9+W7ZZHpDKOwXw0dWztfgK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=gqyr7SJx; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="gqyr7SJx"
Received: (wp-smtpd smtp.wp.pl 11332 invoked from network); 10 Jan 2026 18:24:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1768065851; bh=y8F5hr8VnCHFkfqZ8pNiSP8rs2Iy7WXlcA7Bpa4jfjg=;
          h=Subject:To:Cc:From;
          b=gqyr7SJxsY6qnWigLTc+g6kxnCM7dd7dPVL0yMscOX9vyLYPJC2on0R0bxLgMWaUg
           u+Cur4fPH59+rDxd3KC0WLAn+Y78HcPnPzMtNpYNCs2imoLI2jLRnRNBVSHLuwBe03
           W9bKDezukXfDT7LEw7SbrJt9aIx/EFW2MzwnzHt9dPlrhRMaXCMda3rgtxkPabStD9
           TeKAvw2xWxpY7JvCNusLYE7/xHJTdfikjLMk7K1lS72bYORctjtH5FHbuKmcptC0Hz
           tWgahjblTN2kc3pjhsHsABH/BJsd4gjLvfwy8sadq1ZCUiEH9Lfop2fgD41tFSaW9O
           AHMhN7lceoSGA==
Received: from 83.5.241.112.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.5.241.112])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <atenart@kernel.org>; 10 Jan 2026 18:24:11 +0100
Message-ID: <546d3fae-15ea-4614-8bae-90e7207fb399@wp.pl>
Date: Sat, 10 Jan 2026 18:24:10 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: inside-secure/eip93 - unregister only available
 algorithm
To: Antoine Tenart <atenart@kernel.org>
Cc: ansuelsmth@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 vschagen@icloud.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251230235222.2113987-1-olek2@wp.pl> <aVvRxqB6-Fdu0MXz@kwain>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <aVvRxqB6-Fdu0MXz@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: 3366c2065982c192e93c93dd964d2451
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [8Quy]                               

Hi Antoine,

On 1/5/26 16:01, Antoine Tenart wrote:
> On Wed, Dec 31, 2025 at 12:51:57AM +0100, Aleksander Jan Bajkowski wrote:
>> EIP93 has an options register. This register indicates which crypto
>> algorithms are implemented in silicon. Supported algorithms are
>> registered on this basis. Unregister algorithms on the same basis.
>> Currently, all algorithms are unregistered, even those not supported
>> by HW. This results in panic on platforms that don't have all options
>> implemented in silicon.
>>
>> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>   .../crypto/inside-secure/eip93/eip93-main.c   | 107 ++++++++++--------
>>   1 file changed, 61 insertions(+), 46 deletions(-)
>>
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
>> index 3cdc3308dcac..dfac2b23e2d9 100644
>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
>> @@ -77,11 +77,65 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
>>   	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
>>   }
>>   
>> -static void eip93_unregister_algs(unsigned int i)
>> +static int eip93_algo_is_supported(struct eip93_alg_template *eip93_algo,
>> +				   u32 supported_algo_flags)
>> +{
>> +	u32 alg_flags = eip93_algo->flags;
>> +
>> +	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
>> +	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
>> +		return 0;
>> +
>> +	if (IS_AES(alg_flags)) {
>> +		if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
>> +			return 0;
>> +
>> +		if (!IS_HMAC(alg_flags)) {
>> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
>> +				eip93_algo->alg.skcipher.max_keysize =
>> +					AES_KEYSIZE_128;
>> +
>> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
>> +				eip93_algo->alg.skcipher.max_keysize =
>> +					AES_KEYSIZE_192;
>> +
>> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
>> +				eip93_algo->alg.skcipher.max_keysize =
>> +					AES_KEYSIZE_256;
>> +
>> +			if (IS_RFC3686(alg_flags))
>> +				eip93_algo->alg.skcipher.max_keysize +=
>> +					CTR_RFC3686_NONCE_SIZE;
> Shouldn't the keysize assignment parts be kept in eip93_register_algs as
> this has nothing to do with checking if an alg is supported and as
> there's no point setting those (again) in the unregistration path?
>
You're right. I'll fix this in v2.


Regards,
Aleksander
