Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B1C26ADD;
	Sun, 26 Jan 2025 04:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737865615; cv=none; b=JcaqxwpwW/usptXjYXqBDZYVUS3PY+U0KosIaEEYbuZjLC+WTAZb0EjcfQ+7BWiwt/Rw9ey8cHst7cdZavdlV0gx2O+T7U6chTzqtp02Pr7azejPLAGP1Au4/KfwuEbfjVQjlDyOOAJIdCEVRbc3Ar2npxTN+ROFS0n/+F3wCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737865615; c=relaxed/simple;
	bh=2WWxadxOpy+V8YBIupHOiBuQFFba5Q0KmSR3GVcy5TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvcmFnDrL7yikB5zZpu8zkS+ZAzmjSf2SqSDpAxNo6EGsiiIU7XmXeEH4nEfsdvMB2P+eLLLNhBIlR5yH34KeKI1OPmhHjhWJmEqjFWdHLQT8EDh0OMZjyszF9WdmtZViQICBhMt7tREPJK+HxPkyr3ZSP5+RY/hfOZjvpBpBoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=inxhmB7Z; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="inxhmB7Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1737865602; bh=2WWxadxOpy+V8YBIupHOiBuQFFba5Q0KmSR3GVcy5TY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=inxhmB7ZfDV3pBV3xQxdJIRxXq2vojtV8aEjUBD/A9mf9i4RLCNC9jIjlSRMk6ExQ
	 59Y23qmEKs+Ln4LRsww3Y9Pepp2ixqTxCEJaw7+Ys8I0LTlFGxDFPNLGW9pstB5vPl
	 bGiy+EHtmVAZO6qW4cHuVCql/ClZmF11YZ54VCGw=
Received: from [IPV6:240e:388:8d02:a200:799b:c189:73a3:70e9] (unknown [IPv6:240e:388:8d02:a200:799b:c189:73a3:70e9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 35F63600CE;
	Sun, 26 Jan 2025 12:26:42 +0800 (CST)
Message-ID: <d0e9c27c-078f-4126-adbc-3503791af43d@xen0n.name>
Date: Sun, 26 Jan 2025 12:26:41 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson 6000SE
 SDF
To: Xi Ruoyao <xry111@xry111.site>, "Zheng, Yaofei" <Yaofei.Zheng@dell.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 "David S . Miller" <davem@davemloft.net>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "derek.kiernan@amd.com" <derek.kiernan@amd.com>,
 "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
 Yinggang Gu <guyinggang@loongson.cn>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
 <2025011407-muppet-hurricane-196f@gregkh>
 <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>
 <2025011527-antacid-spilt-cbef@gregkh>
 <SA3PR19MB73993DCBDE9117AA1E77C127F9192@SA3PR19MB7399.namprd19.prod.outlook.com>
 <d56121dc6c6953d4f052be5da5203a4e28676b4e.camel@xry111.site>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <d56121dc6c6953d4f052be5da5203a4e28676b4e.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 1/15/25 19:13, Xi Ruoyao wrote:
> On Wed, 2025-01-15 at 10:39 +0000, Zheng, Yaofei wrote:
>>
>> Internal Use - Confidential
>>> On Wed, Jan 15, 2025 at 10:58:52AM +0800, Qunqin Zhao wrote:
>>>>
>>>> 在 2025/1/14 下午9:21, Greg Kroah-Hartman 写道:
>>>>> On Tue, Jan 14, 2025 at 06:43:24PM +0800, Xi Ruoyao wrote:
>>>>>> On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
>>>>>>> On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
>>>>>>>> Loongson Secure Device Function device supports the functions
>>>>>>>> specified in "GB/T 36322-2018". This driver is only
>>>>>>>> responsible for sending user data to SDF devices or returning SDF device data to users.
>>>>>>> I haven't been able to find a public version of the standard
>>>>>> A public copy is available at
>>>>>> https://openstd.samr.gov.cn/bzgk/gb/ne
>>>>>> wGbInfo?hcno=69E793FE1769D120C82F78447802E14F__;!!LpKI!g7kUt84vOxl
>>>>>> 65EbgAJzXoupsM5Bx3FjUDPnKHaEw5RUoyUouS6IwCerRSZ7MIWi0Bw5WHaM2YP7pZ
>>>>>> IcYiDQOLf3F$ [openstd[.]samr[.]gov[.]cn], pressing the blue
>>>>>> "online preview" button, enter a captcha and you can see it.  But the copy is in Chinese, and there's an explicit notice saying translating this copy is forbidden, so I cannot translate it for you either.
>>>>>>
>>>>>>> but
>>>>>>> from the table of contents it sounds like this is a standard for
>>>>>>> cryptographic functions that would otherwise be implemented by a
>>>>>>> driver in drivers/crypto/ so it can use the normal abstractions
>>>>>>> for both userspace and in-kernel users.
>>>>>>>
>>>>>>> Is there some reason this doesn't work?
>>>>>> I'm not an lawyer but I guess contributing code for that may have
>>>>>> some "cryptography code export rule compliance" issue.
>>>>> Issue with what?  And why?  It's enabling the functionality of the
>>>>> hardware either way, so the same rules should apply no matter where
>>>>> the driver ends up in or what apis it is written against, right?
>>>>
>>>> SDF and tpm2.0 are both  "library specifications",  which means that
>>>>
>>>> it supports a wide variety of functions not only cryptographic
>>>> functions,
>>>>
>>>> but unlike tpm2.0, SDF is only used in China.
>>>>
>>>> You can refer to the tpm2.0 specification:
>>>> https://trustedcomputinggroup.org/resource
>>>> /tpm-library-specification/__;!!LpKI!g7kUt84vOxl65EbgAJzXoupsM5Bx3FjUD
>>>> PnKHaEw5RUoyUouS6IwCerRSZ7MIWi0Bw5WHaM2YP7pZIcYiCFoP-hu$
>>>> [trustedcomputinggroup[.]org]
>>>
>>> So this is an accelerator device somehow?  If it provides crypto functions, it must follow the crypto api, you can't just provide a "raw"
>>> char device node for it as that's not going to be portable at all.
>>> Please fit it into the proper kernel subsystem for the proper user/kernel api needed to drive this hardware.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Hi Qunqin and Ruoyao,
>>
>> "GB/T 36322-2018" is just a chinese national standard, not ISO standard, not an
>> enforced one, "T" repensts "推荐" which means "recommend". From what I understand
>>   it defined series of C API for cryptography devices after reading the standard.
>> Linux kernel have user space socket interface using type AF_ALG, and out of tree
>>   driver "Cryptodev". From my view: "GB/T 36322-2018" can be user space library
>> using socket interface, just like openssl, if must do it char dev way, do it out
>>   of tree, and reuse kernel space crypto API.
> 
> Figure 1 of the section 6.1 says the GB/T 36322 interface is between
> "cryptography device" and "generic cryptography service and cryptography
> device management."  IMO in a Linux (or any monolithic-kernel) system at
> least "cryptography device management" is the job of the kernel, thus
> exposing the GB/T 36322 interface directly to the userspace seems not a
> good idea.
> 

I've also taken a look at the standard text. The majority of it is the 
SDF API definition which is in C and with all identifiers in English, so 
even non-speakers of Chinese can probably understand much of it.

But I tend to agree that the SDF API is abstract enough that it does not 
matter whether it's directly exposed by kernel UAPI or not; while I'm 
not familiar with the Linux crypto subsystem either, it seems entirely 
appropriate for the kernel driver to expose the standard crypto API, and 
for the SDF API to reside in a user-space shim. This way we could have 
non-SDF-aware applications transparently make use of the Loongson HW 
capability, and also have non-Loongson crypto HW available through the 
same SDF interface (should some board designer choose to do so).

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/
