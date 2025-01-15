Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511CA22B8C2;
	Wed, 15 Jan 2025 03:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736910023; cv=none; b=AuDPACjSBmySZjkNQ/a8jCsOck60wkcm5YBLE5n3eIQDDelTxLThEJ7p24e64mjYVCuza7dfmgo0Ym7EuguNEtlHUd4QT5bsvTUw/spANCzhcTGPWEyJJicPg0SM/JvcTDVrsotW4ITiBDF3RJHvwvT8QQs+a3Ebhs2d+BjdoOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736910023; c=relaxed/simple;
	bh=0inU6x9OEOlhOKqEGeSMD92WMNoNKj52lO6z/J3YNOo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=j92qo5EljGSIonrBqgjWCpZBtZ16k+DA0gVI7XUhdVXkQr2B8rV4zzZOqJh8LV7kzwJmoH6o5oiEQjYBcZyrP5bDqEM9B7ysbsLIjgKaPLn4iJJ2BGFQZVQee81Xagse6+qfvWQRWoJJas/+37H13v0/e+qB7fTSEht1rcnP1Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8BxPOLCJIdnGqpjAA--.3095S3;
	Wed, 15 Jan 2025 11:00:18 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowMAxz8e9JIdnxQwjAA--.18926S2;
	Wed, 15 Jan 2025 11:00:15 +0800 (CST)
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson 6000SE
 SDF
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Xi Ruoyao <xry111@xry111.site>, Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 "derek.kiernan@amd.com" <derek.kiernan@amd.com>,
 "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
 Yinggang Gu <guyinggang@loongson.cn>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
 <2025011407-muppet-hurricane-196f@gregkh>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>
Date: Wed, 15 Jan 2025 10:58:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2025011407-muppet-hurricane-196f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMAxz8e9JIdnxQwjAA--.18926S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ww1fury7GF4DWr1UKF13KFX_yoW8CFy7pa
	13GF1IkFyUtr43Cr4vvw4rAr1Ikws3tF9xt34rAwsrZ39Iyrn5KFWIkryYva17Zr10kwnF
	vay0va47u3WDZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
	I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==


在 2025/1/14 下午9:21, Greg Kroah-Hartman 写道:
> On Tue, Jan 14, 2025 at 06:43:24PM +0800, Xi Ruoyao wrote:
>> On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
>>> On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
>>>> Loongson Secure Device Function device supports the functions specified
>>>> in "GB/T 36322-2018". This driver is only responsible for sending user
>>>> data to SDF devices or returning SDF device data to users.
>>> I haven't been able to find a public version of the standard
>> A public copy is available at
>> https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=69E793FE1769D120C82F78447802E14F,
>> pressing the blue "online preview" button, enter a captcha and you can
>> see it.  But the copy is in Chinese, and there's an explicit notice
>> saying translating this copy is forbidden, so I cannot translate it for
>> you either.
>>
>>> but
>>> from the table of contents it sounds like this is a standard for
>>> cryptographic functions that would otherwise be implemented by a
>>> driver in drivers/crypto/ so it can use the normal abstractions
>>> for both userspace and in-kernel users.
>>>
>>> Is there some reason this doesn't work?
>> I'm not an lawyer but I guess contributing code for that may have some
>> "cryptography code export rule compliance" issue.
> Issue with what?  And why?  It's enabling the functionality of the
> hardware either way, so the same rules should apply no matter where the
> driver ends up in or what apis it is written against, right?

SDF and tpm2.0 are both  "library specifications",  which means that

it supports a wide variety of functions not only cryptographic functions,

but unlike tpm2.0, SDF is only used in China.

You can refer to the tpm2.0 specification: 
https://trustedcomputinggroup.org/resource/tpm-library-specification/


Best regards,

Qunqin.

>
> thanks,
>
> greg k-h

