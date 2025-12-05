Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4EB21D59C;
	Fri,  5 Dec 2025 01:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764897999; cv=none; b=E+FwyVHgvddMPOn3Mm7Tp8Jw9fXb3iVPgZbEE2sGThTFrpzO5n7jFV2LzfyqEoC5kLxB7keiBvWOEdpryT0NmcbEw+5Rad2Y0mwD30aTcIPQvnbCrJkbwyMWJjCskeUCUr09bT0uYvBuJfX9xqRsjfKbS0y+XGlNeSPcXJFFyJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764897999; c=relaxed/simple;
	bh=dYFVY1W8xezOWNlrej3gf62Lec4ECkhuGlReX0UCR84=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=S4SDkHXQ07pcsWLxtreyIXUMmjix+xiYCnKfJLzHXJLqhGEv3Xo3viXivy8k38whzMk9DmasP4SQykdh0Y9riAlv2r+hLAsLmC5QYcP3uodxp4aufcq6GXym51z0jTiJkJmOwg1tNznJv0/lFCFvNq00awrK/VjDLgV/AcKzp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxf9PJNDJpLj8rAA--.27075S3;
	Fri, 05 Dec 2025 09:26:33 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxusC9NDJp9KZFAQ--.31789S3;
	Fri, 05 Dec 2025 09:26:24 +0800 (CST)
Subject: Re: [PATCH v2 6/9] crypto: virtio: Add req_data with structure
 virtio_crypto_sym_request
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
 <eperezma@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112227.2659404-7-maobibo@loongson.cn>
 <20251204074310-mutt-send-email-mst@kernel.org>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <1d946b10-a1d3-afa0-8f33-029cb5a9828a@loongson.cn>
Date: Fri, 5 Dec 2025 09:23:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251204074310-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxusC9NDJp9KZFAQ--.31789S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXw1rCryxtFWrtw45Zr13Awc_yoW5WF17pF
	Z0vrWFyryUJr9rGa4rtF1rWFyFya9F9w17KFW8Xw13GrnIvF1Iqr17A340vFsFyF18Gr48
	Jr48Zr1qqFnruFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4Xo7DUUUU



On 2025/12/4 下午8:46, Michael S. Tsirkin wrote:
> On Thu, Dec 04, 2025 at 07:22:23PM +0800, Bibo Mao wrote:
>> With normal encrypt/decrypt workflow, req_data with struct type
>> virtio_crypto_op_data_req will be allocated. Here put req_data in
>> virtio_crypto_sym_request, it is pre-allocated when encrypt/decrypt
>> interface is called.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   drivers/crypto/virtio/virtio_crypto_core.c          |  3 ++-
>>   drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 12 +++---------
>>   2 files changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
>> index ccc6b5c1b24b..e60ad1d94e7f 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_core.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
>> @@ -17,7 +17,8 @@ void
>>   virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
>>   {
>>   	if (vc_req) {
>> -		kfree_sensitive(vc_req->req_data);
>> +		if (vc_req->req_data)
>> +			kfree_sensitive(vc_req->req_data);
> 
> kfree of NULL is a nop, why make this change?
Will keep it unchanged in next version.

> 
>>   		kfree(vc_req->sgs);
>>   	}
>>   }
>> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> index 7b3f21a40d78..a7c7c726e6d9 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
>> @@ -26,6 +26,7 @@ struct virtio_crypto_skcipher_ctx {
>>   
>>   struct virtio_crypto_sym_request {
>>   	struct virtio_crypto_request base;
>> +	struct virtio_crypto_op_data_req req_data;
>>   
>>   	/* Cipher or aead */
>>   	uint32_t type;
>> @@ -350,14 +351,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>>   	if (!sgs)
>>   		return -ENOMEM;
>>   
>> -	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
>> -				dev_to_node(&vcrypto->vdev->dev));
>> -	if (!req_data) {
>> -		kfree(sgs);
>> -		return -ENOMEM;
>> -	}
>> -
>> -	vc_req->req_data = req_data;
>> +	req_data = &vc_sym_req->req_data;
>> +	vc_req->req_data = NULL;
>>   	vc_sym_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
>>   	/* Head of operation */
>>   	if (vc_sym_req->encrypt) {
>> @@ -450,7 +445,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>>   free_iv:
>>   	kfree_sensitive(iv);
>>   free:
>> -	kfree_sensitive(req_data);
> 
> 
> So the request is no longer erased with memset on error. Is that not
> a problem?
I do not know why req_data is sensitive data here, it is only control 
command, key and IV data is not in req_data.

Regards
Bibo Mao
> 
>>   	kfree(sgs);
>>   	return err;
>>   }
>> -- 
>> 2.39.3
> 

