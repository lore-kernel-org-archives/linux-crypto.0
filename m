Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB075464F;
	Fri,  5 Dec 2025 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764897710; cv=none; b=RXoIez+/jIVC58WpgaGnxpvCy3yVfBUiIHze1oHbJ6s87pHRIZ/w032B2E9/b1joV/2Vtf2Pz/enl/LKrOrr+eFiEaQ2eOv/5diZEe3/eH+NLs/TBZosWVuYPKegHARxJz9MnHw/7EysjVcag8cQMYUURu/tpTuYQWWj77WxFNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764897710; c=relaxed/simple;
	bh=YwsG+rsrE/QM63dSd55mNebPJVlyXb85SzzErly9REY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KIgCjmfN7M4jAaXUuo9m+UIU9rIW3/HOsPqLD8GyRqOuVBNhzM25ywKtL5QKJsA6ovlPN9BIo6aLgRhHXLEcRQk3mvJq2jNHUhYQxuk0lvbJAVyViLsvEP1DTSCudhY6lcmiTTd9usjDImN8alJXfySq6c+bLWcAboCtEIbKT1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxG9KpMzJpAD8rAA--.25538S3;
	Fri, 05 Dec 2025 09:21:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxzsGlMzJpwKZFAQ--.25707S3;
	Fri, 05 Dec 2025 09:21:43 +0800 (CST)
Subject: Re: [PATCH v2 7/9] crypto: virtio: Add IV buffer in structure
 virtio_crypto_sym_request
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
 <eperezma@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112502.2659544-1-maobibo@loongson.cn>
 <20251204074712-mutt-send-email-mst@kernel.org>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4cf8befc-465c-e9de-ab12-9d0d8ca40d1f@loongson.cn>
Date: Fri, 5 Dec 2025 09:19:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251204074712-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxzsGlMzJpwKZFAQ--.25707S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZFWrWw13ur45CF4xCr4DAwc_yoW5uFWDpr
	s0ka93KrW8Jr17Ga4FqF1rXa4fuFZ0v3WxWr4ruFyfGrnIvrn7Wr17CFyjvF4SyF1UGr4U
	Cr4v93yj9F1DCFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=



On 2025/12/4 下午8:48, Michael S. Tsirkin wrote:
> On Thu, Dec 04, 2025 at 07:25:02PM +0800, Bibo Mao wrote:
>> Add IV buffer in structure virtio_crypto_sym_request to avoid unnecessary
>> IV buffer allocation in encrypt/decrypt process. And IV buffer is cleared
>> when encrypt/decrypt is finished.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   .../virtio/virtio_crypto_skcipher_algs.c      | 20 +++++++------------
>>   1 file changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> index a7c7c726e6d9..c911b7ba8f13 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> @@ -30,9 +30,9 @@ struct virtio_crypto_sym_request {
>>   
>>   	/* Cipher or aead */
>>   	uint32_t type;
>> -	uint8_t *iv;
>>   	/* Encryption? */
>>   	bool encrypt;
>> +	uint8_t iv[0];
>>   };
>>   
>>   struct virtio_crypto_algo {
>> @@ -402,12 +402,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>>   	 * Avoid to do DMA from the stack, switch to using
>>   	 * dynamically-allocated for the IV
>>   	 */
>> -	iv = kzalloc_node(ivsize, GFP_ATOMIC,
>> -				dev_to_node(&vcrypto->vdev->dev));
>> -	if (!iv) {
>> -		err = -ENOMEM;
>> -		goto free;
>> -	}
>> +	iv = vc_sym_req->iv;
>>   	memcpy(iv, req->iv, ivsize);
>>   	if (!vc_sym_req->encrypt)
>>   		scatterwalk_map_and_copy(req->iv, req->src,
>> @@ -416,7 +411,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>>   
>>   	sg_init_one(&iv_sg, iv, ivsize);
>>   	sgs[num_out++] = &iv_sg;
>> -	vc_sym_req->iv = iv;
>>   
>>   	/* Source data */
>>   	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
>> @@ -438,12 +432,10 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>>   	virtqueue_kick(data_vq->vq);
>>   	spin_unlock_irqrestore(&data_vq->lock, flags);
>>   	if (unlikely(err < 0))
>> -		goto free_iv;
>> +		goto free;
>>   
>>   	return 0;
>>   
>> -free_iv:
>> -	kfree_sensitive(iv);
> 
> so iv is no longer cleared on error. problem?
yes, it is a problem, IV buffer should be cleared on error.
Will fix on next version.

Regards
Bibo Mao
> 
>>   free:
>>   	kfree(sgs);
>>   	return err;
>> @@ -501,8 +493,10 @@ static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
>>   {
>>   	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
>>   	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
>> +	int size;
>>   
>> -	crypto_skcipher_set_reqsize(tfm, sizeof(struct virtio_crypto_sym_request));
>> +	size = sizeof(struct virtio_crypto_sym_request) + crypto_skcipher_ivsize(tfm);
>> +	crypto_skcipher_set_reqsize(tfm, size);
>>   	ctx->alg = container_of(alg, struct virtio_crypto_algo, algo.base);
>>   
>>   	return 0;
>> @@ -552,7 +546,7 @@ static void virtio_crypto_skcipher_finalize_req(
>>   		scatterwalk_map_and_copy(req->iv, req->dst,
>>   					 req->cryptlen - ivsize,
>>   					 ivsize, 0);
>> -	kfree_sensitive(vc_sym_req->iv);
>> +	memzero_explicit(vc_sym_req->iv, ivsize);
>>   	virtcrypto_clear_request(&vc_sym_req->base);
>>   
>>   	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
>> -- 
>> 2.39.3
> 

