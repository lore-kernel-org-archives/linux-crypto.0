Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A522426F2BE;
	Thu, 22 Jan 2026 03:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769053402; cv=none; b=F1WnYT8/qqqy3wwjohaG1dBg49AVbuOq+sEhh7+omzcc5ebNCZQX4OK2Yx20dFYykghKt53v8YdzsZa/PUD041BKkuvH7KfMMyU9l3gu8jnfOb8sCZCqyYXg6PXUAXpojec5YNg1YDDDqdE+vJfYQZ0qScaC8cd+RUZIh4hoqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769053402; c=relaxed/simple;
	bh=vmSlIxhLonT129nAIEJ07kIPjUtYbMA3s2ccdXE+GBw=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u3AfAprc2QM8G/wE5/Eo1VloGYnU6AbetDevj/8BdpS3cILBH8qlVm3dL98eYmf1HnjIr/MCc+tcl27hblNxOlrq/pvPwlso/eAlhsMZzz734o7ViqCeca6UqiWtomjh5mrWXRIzN86ZxJfUpksZq/qu7w2Vw+Jo6okFhQPlNdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dx_8PTnHFpGmgLAA--.37546S3;
	Thu, 22 Jan 2026 11:43:15 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxPMLPnHFpWpkqAA--.18178S3;
	Thu, 22 Jan 2026 11:43:13 +0800 (CST)
Subject: Re: [PATCH v5 0/3] crypto: virtio: Some bugfix and enhancement
From: Bibo Mao <maobibo@loongson.cn>
To: =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, wangyangxin
 <wangyangxin1@huawei.com>, virtualization@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260113030556.3522533-1-maobibo@loongson.cn>
Message-ID: <40a4eddf-6e5f-7853-1afa-dbdca1418890@loongson.cn>
Date: Thu, 22 Jan 2026 11:40:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260113030556.3522533-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPMLPnHFpWpkqAA--.18178S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7AryrXrWDXr45Jw15ZrWxXwc_yoW8CrykpF
	Z8tFZYy3y8Gr1Ika4xJa48KryxCa9xGry3Kr4xW348Crn0vF97XrW2ka1UuFW7JFn5Gasr
	JFWkXr10qF1DuagCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUU
	U==

ping ...

On 2026/1/13 上午11:05, Bibo Mao wrote:
> There is problem when multiple processes add encrypt/decrypt requests
> with virtio crypto device and spinlock is missing with command response
> handling. Also there is duplicated virtqueue_kick() without lock hold.
> 
> Here these two issues are fixed, also there is code cleanup, such as use
> logical numa id rather than physical package id when checking matched
> virtio device with current CPU.
> 
> ---
> v4 ... v5:
>    1. Only add bugfix patches and remove code cleanup patches.
> 
> v3 ... v4:
>    1. Remove patch 10 which adds ECB AES algo, since application and qemu
>       backend emulation is not ready for ECB AES algo.
>    2. Add Cc stable tag with patch 2 which removes duplicated
>       virtqueue_kick() without lock hold.
> 
> v2 ... v3:
>    1. Remove NULL checking with req_data where kfree() is called, since
>       NULL pointer is workable with kfree() API.
>    2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
>       are sensitive data, memzero_explicit() is used even on error path
>       handling.
>    3. Remove duplicated virtqueue_kick() in new patch 2, since it is
>       already called in previous __virtio_crypto_skcipher_do_req().
> 
> v1 ... v2:
>    1. Add Fixes tag with patch 1.
>    2. Add new patch 2 - patch 9 to add ecb aes algo support.
> ---
> Bibo Mao (3):
>    crypto: virtio: Add spinlock protection with virtqueue notification
>    crypto: virtio: Remove duplicated virtqueue_kick in
>      virtio_crypto_skcipher_crypt_req
>    crypto: virtio: Replace package id with numa node id
> 
>   drivers/crypto/virtio/virtio_crypto_common.h        | 2 +-
>   drivers/crypto/virtio/virtio_crypto_core.c          | 5 +++++
>   drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 2 --
>   3 files changed, 6 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 9c7ef209cd0f7c1a92ed61eed3e835d6e4abc66c
> 

