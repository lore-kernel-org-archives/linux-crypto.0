Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD433ACEF5
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 18:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142389; cv=none; b=QQtcK5gQN3EQrloBezgg7Nc4wJhjKvIVilBADwtJfJ79sVBGD91L118xFdutnia5Ryps03no/BLM4h1DPRzlaI4vU33JLuEp/KY/c13FSGkH+GBIPPpRO0MD530obCDhxEPxJP1f6KF7dqF6f4W06ccyqeK1lNq1bys1ztwUqQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142389; c=relaxed/simple;
	bh=bNf00TjoAJZJdVlMQ9aKuzxEdRptTSAx+QYHiZb1oWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IIEkFZvXe+n72mSsPYDFkxXUFV47rr/1C4z366MuQCIscvzqcrhbZJfpPP3cPJDy+7YKxqohbB/Iukbk0e0Jw7Em96xt4Y/fiRHe6UwP0S+JIRpiYFOIuvK+twVJxWbLX27FFeaiFsNloh3l0VjRTEb1FVk0kbWsiS0tyIJc1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=qO1zZd+7; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="qO1zZd+7"
Received: (wp-smtpd smtp.wp.pl 17073 invoked from network); 3 Feb 2026 19:13:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770142383; bh=BoGqvRcnTC64FcOKv80aRbWtb8OlcvHAjm8/po6BCPI=;
          h=Subject:To:Cc:From;
          b=qO1zZd+7UkY5zoX0APrtpyUJjhcAK1nIHVXFKyEDek+77KiNVV2wlgPjU7Oy3tD6o
           7G3MHVg272mbX7h0fOWP5jRAmJE3f5ANpTqjxLqEIMZj0rFtFwCf6uTbxWrZA0fqU8
           0wJ8xeYtn0uQV3/81mWgM9trO+ETvVcZ3sZqPirJnsmY2YYkaGqdz3Sf1ifpKvvmKU
           3VJYm4Mm1CdQDNQ/1xbdPP613Zlz3PYsCJIbRbGgVZ/LKfkqKdTkuK13o3XArc7H1p
           N8ZKTZ4eg6xmYztK64Bt1zjQsBZuh/+l8kkgiKl4k60ZK0w6TAJs4UeoYh3yz5zG4O
           dfo6f8q9kOFVg==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <atenart@kernel.org>; 3 Feb 2026 19:13:02 +0100
Message-ID: <42a0c4c6-8b75-4aec-a8d7-6c71e0a90b9c@wp.pl>
Date: Tue, 3 Feb 2026 19:13:01 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: safexcel - Add support for
 authenc(hmac(md5),*) suites
To: Antoine Tenart <atenart@kernel.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260202202203.124015-1-olek2@wp.pl>
 <20260202202203.124015-2-olek2@wp.pl> <aYHCC-BiBKUXyUbd@kwain>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <aYHCC-BiBKUXyUbd@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: ae36728a407abd1498a8b11246497fd0
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [kSpE]                               


On 2/3/26 10:41, Antoine Tenart wrote:
> On Mon, Feb 02, 2026 at 09:21:08PM +0100, Aleksander Jan Bajkowski wrote:
>> This patch adds support for the following AEAD ciphersuites:
>> - authenc(hmac(md5),cbc(aes))
>> - authenc(hmac(md5),cbc(des)))
>> - authenc(hmac(md5),cbc(des3_ede))
>> - authenc(hmac(md5),rfc3686(ctr(aes)))
>>
>> This is enhanced version of the patch found in the mtk-openwrt-feeds repo.
> Can you say how it was tested in the commit message?

Sure. The first three algorithms were tested using the test vectors
recently sent upstream. I also tried to add test vectors for
authenc(hmac(sha*/md5),rfc3686(ctr(aes))), but I had some trouble with
the hmac results on NXP P2020. I suspect the problem may be in my 
calculations.

I'm also planning to test IPSEC between EIP93 and EIP97/197. The former
has some issues with HMAC, and in the case of the latter, there are
reports that EIP197 drops connections.

>
>> +static int safexcel_aead_md5_ctr_cra_init(struct crypto_tfm *tfm)
>> +{
>> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>> +
>> +	safexcel_aead_md5_cra_init(tfm);
>> +	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
>> +	return 0;
>> +}
>> +
>> +struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_ctr_aes = {
>> +	.type = SAFEXCEL_ALG_TYPE_AEAD,
>> +	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_MD5,
>> +	.alg.aead = {
>> +		.setkey = safexcel_aead_setkey,
>> +		.encrypt = safexcel_aead_encrypt,
>> +		.decrypt = safexcel_aead_decrypt,
>> +		.ivsize = CTR_RFC3686_IV_SIZE,
>> +		.maxauthsize = SHA1_DIGEST_SIZE,
> MD5_DIGEST_SIZE?
Indeed. A copy-paste mistake.
>
>> +		.base = {
>> +			.cra_name = "authenc(hmac(md5),rfc3686(ctr(aes)))",
>> +			.cra_driver_name = "safexcel-authenc-hmac-md5-ctr-aes",
>> +			.cra_priority = SAFEXCEL_CRA_PRIORITY,
>> +			.cra_flags = CRYPTO_ALG_ASYNC |
>> +				     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.cra_blocksize = 1,
>> +			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
>> +			.cra_alignmask = 0,
>> +			.cra_init = safexcel_aead_md5_ctr_cra_init,
>> +			.cra_exit = safexcel_aead_cra_exit,
>> +			.cra_module = THIS_MODULE,
>> +		},
>> +	},
>> +};
>> +
>>   static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
>>   {
>>   	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> Thanks!
> Antoine
