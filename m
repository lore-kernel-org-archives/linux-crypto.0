Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6E22264B0;
	Thu, 27 Nov 2025 03:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764213135; cv=none; b=fLi2KPd5YQ2i1A8LJvCFq6X2MYFWNx7VojgOuQRLw5pnaUcakcbl1naPHWL60gp2fwZIQbPv94+TuihQeEDjNufD24b09Pb/a9m3CzYuYlIma8cYHo4VZj4G+j7+Toi6AmeMAiXusbwwTAbkRuW966lOqfAUyerHN3wlQYkXWXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764213135; c=relaxed/simple;
	bh=1jAV7+0GeJ1ZlQyWeJPPO6FPTp5rm5uEz0i5yZRIQvk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=odlmcxLiXolH+PjtIg1niWv84bjZ5/Ooz8YO77tFyktSK02U2SiB1QeVCFPJghjNaJNCLWUCg8e9U1iaJPM7/Ox5382hQTh4NbknAuPQ2gAz83FY+9xU9Mq3SRKz1Z4BP9XN8M6Ok3wDZvMwNszSSLBv6hsKe0dcxBiaAGQSRqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxLvCHwSdpz5coAA--.21924S3;
	Thu, 27 Nov 2025 11:12:07 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxaMCBwSdpGJ9AAQ--.19477S3;
	Thu, 27 Nov 2025 11:12:04 +0800 (CST)
Subject: Re: virtio-crypto: Inquiry about virtio crypto
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 QEMU devel <qemu-devel@nongnu.org>
References: <d4258604-e678-f975-0733-71190cf4067d@loongson.cn>
 <027ff08db97d414da0ccc24a439e75d0@huawei.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <42d33127-59dc-5f82-8fa8-6b154cde6dc6@loongson.cn>
Date: Thu, 27 Nov 2025 11:09:35 +0800
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
X-CM-TRANSID:qMiowJDxaMCBwSdpGJ9AAQ--.19477S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cr1xCr1fuw4xGr4DAF4fWFX_yoW8Gr1xpF
	93GFWFkayDGr1fCa4ktFy3CFW5Xa98CF13GrZrX348Gr98Cry8Kr12vr1jq3sxJF1rKF1q
	qw4IgF10kr98ZFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4U
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8P5r7UUUUU==



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
I am studying virtio-crypto and want to add sm4 algo with skcipher on 
it. Hope to get some guidances and work together on it in future :)

Regards
Bibo Mao
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

