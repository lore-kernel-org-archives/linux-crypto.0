Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 567452D46B1;
	Tue,  9 Dec 2025 02:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765247350; cv=none; b=N/dqCpbN7LPBRif3VJOcOiOGSGTlHqWbK/cZulkuneXpsI/r/t9Txn81SwcqXmZYw3b8LF3JQLrHGkE77Pi2AXZzL6ZviFJz043NcZbN9SRBuqK8UUAZadEMPPX1AdZknM9ZmXvNrigNI7ttZaKmBVlCgtxQZSovqWR68xVmXDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765247350; c=relaxed/simple;
	bh=+KL9fTpXu7Z2+XIHxUTheNx7elf32qY3ioCOHY97eeA=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dbD26xOkh7K1pOFsuXCmmXt1Cr9CLR5dRcWbR/GrPJT+MoqW3V2aP+DK8c+z9eks7b4hmJwpLV5kNpgw94JwJskOPrLu4E1uZmG+0A1eBP9xw180Gv9OgCeX3f3/4NRNtS5W9cfuq/NvSAei4flq9RQhk1TfS698YgxgTf6AFVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxbb9yiTdpXYMsAA--.29204S3;
	Tue, 09 Dec 2025 10:29:06 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxocJwiTdpIUJHAQ--.54594S3;
	Tue, 09 Dec 2025 10:29:06 +0800 (CST)
Subject: Re: [PATCH v3 01/10] crypto: virtio: Add spinlock protection with
 virtqueue notification
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
 <eperezma@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 wangyangxin <wangyangxin1@huawei.com>
Cc: virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251209015951.4174743-1-maobibo@loongson.cn>
 <20251209015951.4174743-2-maobibo@loongson.cn>
Message-ID: <832af71e-c4a1-6745-bae0-ba77f8a66142@loongson.cn>
Date: Tue, 9 Dec 2025 10:26:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251209015951.4174743-2-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocJwiTdpIUJHAQ--.54594S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZF1ktw4UKw1UtFW7WFykJFc_yoW8tr47pF
	WDJFWYyrWUXrW8KayxJF18WFWUu3srury7ZrWxWayDGwn0yF1kWry7Ary09F42yF1rtF47
	JrZ5A3s0qF9ruagCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4SoGDUUUU

oops, the cover letter is missing again since I forgot to add 
linux-kernel@vger.kernel.org in cc list manually and command 
"scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats" has 
no any effect on cover letter :(

please ignore this patch set.

Regards
Bibo Mao

On 2025/12/9 上午9:59, Bibo Mao wrote:
> When VM boots with one virtio-crypto PCI device and builtin backend,
> run openssl benchmark command with multiple processes, such as
>    openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32
> 
> openssl processes will hangup and there is error reported like this:
>   virtio_crypto virtio0: dataq.0:id 3 is not a head!
> 
> It seems that the data virtqueue need protection when it is handled
> for virtio done notification. If the spinlock protection is added
> in virtcrypto_done_task(), openssl benchmark with multiple processes
> works well.
> 
> Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   drivers/crypto/virtio/virtio_crypto_core.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index 3d241446099c..ccc6b5c1b24b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -75,15 +75,20 @@ static void virtcrypto_done_task(unsigned long data)
>   	struct data_queue *data_vq = (struct data_queue *)data;
>   	struct virtqueue *vq = data_vq->vq;
>   	struct virtio_crypto_request *vc_req;
> +	unsigned long flags;
>   	unsigned int len;
>   
> +	spin_lock_irqsave(&data_vq->lock, flags);
>   	do {
>   		virtqueue_disable_cb(vq);
>   		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
> +			spin_unlock_irqrestore(&data_vq->lock, flags);
>   			if (vc_req->alg_cb)
>   				vc_req->alg_cb(vc_req, len);
> +			spin_lock_irqsave(&data_vq->lock, flags);
>   		}
>   	} while (!virtqueue_enable_cb(vq));
> +	spin_unlock_irqrestore(&data_vq->lock, flags);
>   }
>   
>   static void virtcrypto_dataq_callback(struct virtqueue *vq)
> 

