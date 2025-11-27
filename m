Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECB0253F05;
	Thu, 27 Nov 2025 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764236484; cv=none; b=IpUPO7IdWS91MU3+d2sDF9Rkr7P8AmYavwtJ74wHhaDxvRKDtvM6DrFuOzAQ4ByY3xHufhhpPlMSvuUo13NIclvV1QIfcR66f4GtEGI0KP9yatKhcKCd5b0IjYplfA3huxh1c6KNT0nmdmYSV8s2XmYhADItxsxIjtwX4FUFwhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764236484; c=relaxed/simple;
	bh=x31Xr9++Jq6DWL01JKwF+pXdVIA4O5YCgTFhor8E9Pc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DMrqweBO8At9+ufqtQNdHhMh9C9B1LQi/1xoTsBonTpvPivwC/0b6h6k7OBI6KF2FKYbJoXqNRnG+Nmk7bbr2iwRzIeY006adp1m5KeLM+s4RLMHfgPGURM2pI4tAKu8KYFmuPdrEXZq5JQcS+N+PTu5QcmAXwqEL/D1K3A7MLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axz7+4HChpqbAoAA--.19797S3;
	Thu, 27 Nov 2025 17:41:12 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxQMKxHChpBORAAQ--.36258S3;
	Thu, 27 Nov 2025 17:41:07 +0800 (CST)
Subject: Re: virtio-crypto: Inquiry about virtio crypto
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 QEMU devel <qemu-devel@nongnu.org>
References: <d4258604-e678-f975-0733-71190cf4067d@loongson.cn>
 <027ff08db97d414da0ccc24a439e75d0@huawei.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <8b902563-4cb6-5409-4339-1afecc26803a@loongson.cn>
Date: Thu, 27 Nov 2025 17:38:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <027ff08db97d414da0ccc24a439e75d0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxQMKxHChpBORAAQ--.36258S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw4fXFWfZrW3ZFW5KrWUWrX_yoW8WFWfpa
	y3KFWFkrZ8Jr1xCa4vqFy5CFW5ZFZ8Cr13WrZrWry3CrZ8AF92vr1avr1vq3srAF1rCF1D
	Xw40qFy0kr98ZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jbDGOUUUUU=


Hi gonglei,

Sorry to bother you again.

I notice that numa node is supported with virtio-crypto device. Is there 
multiple PCIE root bridges with different numa nodes supported on some 
VM models?

I ask this question because I do not know whether it is possible to 
preallocate virtio_crypto_op_data_req buffer and IV buffer within 
structure virtio_crypto_sym_request. Only that there is no node 
information when virtio_crypto_sym_request is allocated.

Regards
Bibo Mao


On 2025/11/27 上午10:56, Gonglei (Arei) wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Bibo Mao <maobibo@loongson.cn>
>> Sent: Thursday, November 27, 2025 9:43 AM
>> To: Gonglei (Arei) <arei.gonglei@huawei.com>
>> Cc: linux-crypto@vger.kernel.org; virtualization@lists.linux.dev; linux-kernel
>> <linux-kernel@vger.kernel.org>; QEMU devel <qemu-devel@nongnu.org>
>> Subject: virtio-crypto: Inquiry about virtio crypto
>>
>> Hi gonglei,
>>
>>      I am investigating how to use HW crypto accelerator in VM. It seems that
>> virtio-crypto is one option, however only aes skcipher algo is supported and
> 
> Actually akcipher service had been supported by virtio-crypto in 2022.
> 
>> virtio-crypto device is not suggested by RHEL 10.
>>
>> https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html
>> /configuring_and_managing_linux_virtual_machines/feature-support-and-limit
>> ations-in-rhel-10-virtualization
>>
>>     I want to know what is the potential issued with virtio-crypto.
>>
> 
> This question is too big, maybe you'd better ask RHEL guys. :(
> 
> Regards,
> -Gonglei
> 
>> Regards
>> Bibo Mao
> 
> 

