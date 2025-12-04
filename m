Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3112EA178;
	Thu,  4 Dec 2025 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764849317; cv=none; b=aOkmTw7deX9v3USvaw34zX04EmHZ75xC4dkoDGqBTxbahuSPrvLeZI4qDZWe9pVbDdvf2d/OsgGv+FmEvEqUO7AuRtALr7LXOF7AKmRLzdVx5d0ADMXlUB908Vmpv3fZr/PwJ/d8Q0jnvnCHQOOS3jQXqhdwZf+ZP23QHDHghiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764849317; c=relaxed/simple;
	bh=knj7HqTWx+35wRL4iceOrKx/Kxi98HH6ILBHP5DVjeA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=F1y2uaw7jp+ocFtuDpj2Fu6qYVE+AA7eCIHfu8y8DFesw28scQBf56EgIfdAUSygSxuUY+l+p3l5fI7nm6NvlEWuZfS10ZClGaMrbz86Dp2ArU1/Ri+MgnzoJ0wszxhOBCDov5EtJ2cPjb23TP1B/zL065HrIBHo4M3NgfU6qxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxM9CWdjFpsQsrAA--.27780S3;
	Thu, 04 Dec 2025 19:55:02 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxH8KPdjFpym1FAQ--.64190S3;
	Thu, 04 Dec 2025 19:54:57 +0800 (CST)
Subject: Re: [PATCH v2 9/9] crypto: virtio: Add ecb aes algo support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
 <eperezma@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112612.2659650-1-maobibo@loongson.cn>
 <20251204064220-mutt-send-email-mst@kernel.org>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <a3b6458d-9b36-ab11-1f95-6697d788a3de@loongson.cn>
Date: Thu, 4 Dec 2025 19:52:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251204064220-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxH8KPdjFpym1FAQ--.64190S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXF1rXrWDZF48GFyrGry8Zwc_yoWrAF15pr
	n0krZ3JryUJF17K3s5XF4rWrWrC39xCw43Jr4rWr1xGFnavrs3Wr17AryYkrsxtF1UG3W8
	Kr4kurnI9ws0kFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUU
	UUU



On 2025/12/4 下午7:43, Michael S. Tsirkin wrote:
> On Thu, Dec 04, 2025 at 07:26:11PM +0800, Bibo Mao wrote:
>> ECB AES also is added here, its ivsize is zero and name is different
>> compared with CBC AES algo.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> 
> you did not post the cover letter, so the mail thread is malformed.
Sorry for the trouble, my mail server has problem to send multiple mails 
in batch mode with git send-email command.

Please ignore it, will sent it tomorrow to avoid extra confusion, sorry 
for the noise again.

Regards
Bibo Mao
> 
>> ---
>>   .../virtio/virtio_crypto_skcipher_algs.c      | 74 +++++++++++++------
>>   1 file changed, 50 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> index b4b79121c37c..9b4ba6a6b9cf 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> @@ -559,31 +559,57 @@ static void virtio_crypto_skcipher_finalize_req(
>>   					   req, err);
>>   }
>>   
>> -static struct virtio_crypto_algo virtio_crypto_algs[] = { {
>> -	.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
>> -	.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
>> -	.algo.base = {
>> -		.base.cra_name		= "cbc(aes)",
>> -		.base.cra_driver_name	= "virtio_crypto_aes_cbc",
>> -		.base.cra_priority	= 150,
>> -		.base.cra_flags		= CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> -		.base.cra_blocksize	= AES_BLOCK_SIZE,
>> -		.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
>> -		.base.cra_module	= THIS_MODULE,
>> -		.init			= virtio_crypto_skcipher_init,
>> -		.exit			= virtio_crypto_skcipher_exit,
>> -		.setkey			= virtio_crypto_skcipher_setkey,
>> -		.decrypt		= virtio_crypto_skcipher_decrypt,
>> -		.encrypt		= virtio_crypto_skcipher_encrypt,
>> -		.min_keysize		= AES_MIN_KEY_SIZE,
>> -		.max_keysize		= AES_MAX_KEY_SIZE,
>> -		.ivsize			= AES_BLOCK_SIZE,
>> +static struct virtio_crypto_algo virtio_crypto_algs[] = {
>> +	{
>> +		.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
>> +		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
>> +		.algo.base = {
>> +			.base.cra_name		= "cbc(aes)",
>> +			.base.cra_driver_name	= "virtio_crypto_aes_cbc",
>> +			.base.cra_priority	= 150,
>> +			.base.cra_flags		= CRYPTO_ALG_ASYNC |
>> +				CRYPTO_ALG_ALLOCATES_MEMORY,
>> +			.base.cra_blocksize	= AES_BLOCK_SIZE,
>> +			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
>> +			.base.cra_module	= THIS_MODULE,
>> +			.init			= virtio_crypto_skcipher_init,
>> +			.exit			= virtio_crypto_skcipher_exit,
>> +			.setkey			= virtio_crypto_skcipher_setkey,
>> +			.decrypt		= virtio_crypto_skcipher_decrypt,
>> +			.encrypt		= virtio_crypto_skcipher_encrypt,
>> +			.min_keysize		= AES_MIN_KEY_SIZE,
>> +			.max_keysize		= AES_MAX_KEY_SIZE,
>> +			.ivsize			= AES_BLOCK_SIZE,
>> +		},
>> +		.algo.op = {
>> +			.do_one_request = virtio_crypto_skcipher_crypt_req,
>> +		},
>>   	},
>> -	.algo.op = {
>> -		.do_one_request = virtio_crypto_skcipher_crypt_req,
>> -	},
>> -} };
>> +	{
>> +		.algonum = VIRTIO_CRYPTO_CIPHER_AES_ECB,
>> +		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
>> +		.algo.base = {
>> +			.base.cra_name		= "ecb(aes)",
>> +			.base.cra_driver_name	= "virtio_crypto_aes_ecb",
>> +			.base.cra_priority	= 150,
>> +			.base.cra_flags		= CRYPTO_ALG_ASYNC |
>> +				CRYPTO_ALG_ALLOCATES_MEMORY,
>> +			.base.cra_blocksize	= AES_BLOCK_SIZE,
>> +			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
>> +			.base.cra_module	= THIS_MODULE,
>> +			.init			= virtio_crypto_skcipher_init,
>> +			.exit			= virtio_crypto_skcipher_exit,
>> +			.setkey			= virtio_crypto_skcipher_setkey,
>> +			.decrypt		= virtio_crypto_skcipher_decrypt,
>> +			.encrypt		= virtio_crypto_skcipher_encrypt,
>> +			.min_keysize		= AES_MIN_KEY_SIZE,
>> +			.max_keysize		= AES_MAX_KEY_SIZE,
>> +		},
>> +		.algo.op = {
>> +			.do_one_request = virtio_crypto_skcipher_crypt_req,
>> +		},
>> +	}
>> +};
>>   
>>   int virtio_crypto_skcipher_algs_register(struct virtio_crypto *vcrypto)
>>   {
>> -- 
>> 2.39.3

