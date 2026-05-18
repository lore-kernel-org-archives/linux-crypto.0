Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2ED1E0DE8;
	Mon, 18 May 2026 03:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779074564; cv=none; b=fE6h/k2makYzxJyoSQ/1AUWLASPvYu1sU0O+rKGIyXMFk/OqJXr7v0wYSviBKUNZvyL22DnshiXcR4R3irTxwazkBYcIexhUC4Jghjt+CBy3LoVYzYuniF2eFdovkuRRE4RqT+aub3K12QhLatW5i7Jxx5Z+CI4aOJjfrZ9EBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779074564; c=relaxed/simple;
	bh=JK4lPmltdTsT+s3XhDbrcCUWatFSapgCQymC9G3Xgu4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oRzBdraw6EThgj/r2eBT3W+X2Wwu/OTacUtB+Y5mCTnadD0TbBXr9AlKiEsTDuCqt55ICZ/TFIb5WYZIUqIqwHD7thYheckWp94yKBjH2xI5ypsxJxv2O6rS9hZNWQOLghATjYBXO81D4PldMg7UhIuBoS/GBCTDfvFn93UDEvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8DxsOr+hQpqebEKAA--.31861S3;
	Mon, 18 May 2026 11:22:38 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJBxZcD+hQpq+SuGAA--.50034S2;
	Mon, 18 May 2026 11:22:38 +0800 (CST)
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-crypto@vger.kernel.org, Xi Ruoyao <xry111@xry111.site>
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
 <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
 <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn>
 <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
 <9fd34867-9b1d-e097-f800-875efc6c44bd@loongson.cn>
 <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <9a72d879-b4c6-a42f-1d05-086a73f86afe@loongson.cn>
Date: Mon, 18 May 2026 11:17:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxZcD+hQpq+SuGAA--.50034S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZFyxGw1rAFykAr17GrWUWrX_yoW5JFyfpF
	W5AFnxKrsFgrWYkwn2qw18CF1YyrsxtF45W3s3Jry29a4v9r15CrWUtFW5WFnxury8J3W0
	vrW2qr13WF4jqagCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-e5UU
	UUU==


在 2026/4/27 下午6:02, Huacai Chen 写道:
> On Mon, Apr 27, 2026 at 5:52 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>
>> 在 2026/4/27 下午5:37, Huacai Chen 写道:
>>> On Mon, Apr 27, 2026 at 5:24 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>>> 在 2026/4/27 下午5:02, Huacai Chen 写道:
>>>>> Hi, Qunqin,
>>>>>
>>>>> On Mon, Apr 27, 2026 at 4:55 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>>>>> On the Loongson platform, each node is equipped with a security engine
>>>>>> device. However, due to a hardware flaw, only the device on node 0 can
>>>>>> trigger interrupts. Therefore, interrupts from other nodes are forwarded
>>>>>> by node 0. We need to check in the interrupt handler of node 0 whether
>>>>>> this interrupt is intended for other nodes.
>>>>> Multi-node or multi-package? In my opinion SE has no relationship with
>>>>> NUMA node, so maybe package?
>>>> Here is the output of lscpu from my machine:
>>>>
>>>> [loongson@localhost ~]$ lscpu
>>>> Architecture:          loongarch64
>>>>      CPU op-mode(s):      32-bit, 64-bit
>>>>      Address sizes:       48 bits physical, 48 bits virtual
>>>>      Byte Order:          Little Endian
>>>> CPU(s):                128
>>>>      On-line CPU(s) list: 0-127
>>>> Model name:            Loongson-3C6000/D
>>>>      CPU family:          Loongson-64bit
>>>>      Model:               0x11
>>>>      Thread(s) per core:  2
>>>>      Core(s) per socket:  32
>>>>      Socket(s):           2
>>>>      BogoMIPS:            4200.00
>>>>      Flags:               cpucfg lam ual fpu lsx lasx crc32 complex crypto
>>>> lvz lbt_x86 lbt_arm lbt_mips
>>>> Caches (sum of all):
>>>>      L1d:                 4 MiB (64 instances)
>>>>      L1i:                 4 MiB (64 instances)
>>>>      L2:                  16 MiB (64 instances)
>>>>      L3:                  128 MiB (4 instances)
>>>> NUMA:
>>>>      NUMA node(s):        4
>>>>      NUMA node0 CPU(s):   0-31
>>>>      NUMA node1 CPU(s):   32-63
>>>>      NUMA node2 CPU(s):   64-95
>>>>      NUMA node3 CPU(s):   96-127
>>>>
>>>> There are four SE devices in my system, one for each NUMA node.
>>> For Loongson-3C6000 node is the same as package. You should consider
>>> Loongson-3C5000L, one package contains four nodes.
>> I am not familiar with the SE-related components on the 3C5000L, and
>> this driver is not compatible with the 5000 series.
> Whether it is compatible to Loongson-3C5000L is not important. The
> importance is package is not always equal to node, and we should
> consider whether SE is per-node or per-package.

Hi, huacai

After consulting with  hardware team, I learned that while the 3C5000L
has four SE devices, only one is utilized due to interrupt constraints.

Thanks,

Qunqin

>
> Huacai
>

