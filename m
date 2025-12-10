Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6B2D27E;
	Wed, 10 Dec 2025 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765329790; cv=none; b=j3fRid3l4PoobNFNQ1US+QVYE4yi1rCr2XeC0Ogyk3qJ+dslafolevtik+99UpcDNtiGTDvlywQ+w6qpu9xsbb7WUD6/+odYEKhAVkbJsTpNgG5JNY4SSYfHsgiPHG3mcMHQNcxj1sV02W0hFEADqkb5H/vGByVCmfezhxkaoXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765329790; c=relaxed/simple;
	bh=Qv8YDGmmLNOkB0lVK0IzQRVilt9yUNepwbuNtrvlqyY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BbC6pGSzx3dn90Urk6+7w9WDjx+CkKbyknwg5P0qsbzq7sqPJ13y2Q+BR3qeSjK8nU2GS+3q8ORHCAehUxf1DBJzJfA3nOZ9dA9wtNRQw8zT2WGcigD8tvY6i1lFKErgBC+AI2N2rImpYxCDV1sjIZffZT67469LFhV0OOmQox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxTNJuyzhp6twsAA--.26154S3;
	Wed, 10 Dec 2025 09:22:54 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxicBqyzhppaFHAQ--.37056S3;
	Wed, 10 Dec 2025 09:22:52 +0800 (CST)
Subject: Re: [PATCH v3 02/10] crypto: virtio: Remove duplicated virtqueue_kick
 in virtio_crypto_skcipher_crypt_req
To: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251209015951.4174743-1-maobibo@loongson.cn>
 <20251209015951.4174743-3-maobibo@loongson.cn>
 <CACGkMEs8E9DYzmZ8k4fH7h=fxC07wMsHizyDAE3wiKmQhkW3Uw@mail.gmail.com>
 <CACGkMEviPVi+nJvS6rU55vF8xk08kAkr6ja0tYZp3BHJK=LtJQ@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <f56218d3-b1c2-5ff8-a0c2-33683c3caef8@loongson.cn>
Date: Wed, 10 Dec 2025 09:20:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CACGkMEviPVi+nJvS6rU55vF8xk08kAkr6ja0tYZp3BHJK=LtJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxicBqyzhppaFHAQ--.37056S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7Xw1rKryrKF13KF45Kr15GFX_yoW3uwbEqr
	sFkwsY9w1kGrn7AF4qvFZxJrn2g3W8AF98tw4UX3WSqas8GanxWFn2grn7Gr13JFWxCrn0
	kws3t34rCw129osvyTuYvTs0mTUanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbDkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
	I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==



On 2025/12/9 下午12:32, Jason Wang wrote:
> On Tue, Dec 9, 2025 at 12:31 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Tue, Dec 9, 2025 at 10:00 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>
>>> With function virtio_crypto_skcipher_crypt_req(), there is already
>>> virtqueue_kick() call with spinlock held in funtion
>>
>> A typo should be "function".
Good catch, will correct this.
>>
>>> __virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
>>> function call here.
>>>
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> Btw.
> 
> I think this probably deserved a stable tag as well as the
> virtqueue_kick is not synchronized here?
sure, will do in next version.

Regards
Bibo Mao
> 
>>
>> Thanks
> 
> Thanks
> 

