Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35783B27E9;
	Mon, 27 Apr 2026 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283525; cv=none; b=Z3QCGWPOrPJWYvjmOFXzWiHaBoPmrnG4BvX+U8OWI94bPyf6/4fTpM3pjjNAwtGJfTbJEuQZVVFvhxdRXZ8aiGx9Hbr8m3ZEXGYRYqriNiWPM78PL1D377/kFAlbXV+NJn2nf5BDkhh1PWbEEukRm52HxkLdhjjCoyuJhweW8T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283525; c=relaxed/simple;
	bh=00mpT8HPtXTujfcv34iIVVGOR7iCwjOoau8rvu9kHt0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LYyH9mlHLwJ7OLlIKBFrtmMxuojls4rMaKVwg1n56BzvPx+E1cU2EBz5zev/D3i/DMFLDhfFYEw+2du/uwyEE1oVlBkTqICLx59nJKu5Y8kUxTnjLOhjYKJdOfq/DL4hFnnzLA/o4V8RSmzCpRII4ZMYYvp9OYd2qTIMalV0090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8AxVum_Me9pX1IEAA--.8778S3;
	Mon, 27 Apr 2026 17:51:59 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJBxiuC9Me9pGah1AA--.53753S2;
	Mon, 27 Apr 2026 17:51:57 +0800 (CST)
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-crypto@vger.kernel.org
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
 <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
 <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn>
 <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <9fd34867-9b1d-e097-f800-875efc6c44bd@loongson.cn>
Date: Mon, 27 Apr 2026 17:47:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxiuC9Me9pGah1AA--.53753S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Xw4DKF17uF1fZFyDXr4fWFX_yoW7Kw4kpr
	WUAa1YkF4Utry7Cw1vqwn8KrnIyrW5trW7Wws7t3WUZa4qvrnrGFWUJFyUWFn5ZryUJF18
	ZrWUGr4fuFWrJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07URa0PUUUUU=


在 2026/4/27 下午5:37, Huacai Chen 写道:
> On Mon, Apr 27, 2026 at 5:24 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>
>> 在 2026/4/27 下午5:02, Huacai Chen 写道:
>>> Hi, Qunqin,
>>>
>>> On Mon, Apr 27, 2026 at 4:55 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>>> On the Loongson platform, each node is equipped with a security engine
>>>> device. However, due to a hardware flaw, only the device on node 0 can
>>>> trigger interrupts. Therefore, interrupts from other nodes are forwarded
>>>> by node 0. We need to check in the interrupt handler of node 0 whether
>>>> this interrupt is intended for other nodes.
>>> Multi-node or multi-package? In my opinion SE has no relationship with
>>> NUMA node, so maybe package?
>> Here is the output of lscpu from my machine:
>>
>> [loongson@localhost ~]$ lscpu
>> Architecture:          loongarch64
>>     CPU op-mode(s):      32-bit, 64-bit
>>     Address sizes:       48 bits physical, 48 bits virtual
>>     Byte Order:          Little Endian
>> CPU(s):                128
>>     On-line CPU(s) list: 0-127
>> Model name:            Loongson-3C6000/D
>>     CPU family:          Loongson-64bit
>>     Model:               0x11
>>     Thread(s) per core:  2
>>     Core(s) per socket:  32
>>     Socket(s):           2
>>     BogoMIPS:            4200.00
>>     Flags:               cpucfg lam ual fpu lsx lasx crc32 complex crypto
>> lvz lbt_x86 lbt_arm lbt_mips
>> Caches (sum of all):
>>     L1d:                 4 MiB (64 instances)
>>     L1i:                 4 MiB (64 instances)
>>     L2:                  16 MiB (64 instances)
>>     L3:                  128 MiB (4 instances)
>> NUMA:
>>     NUMA node(s):        4
>>     NUMA node0 CPU(s):   0-31
>>     NUMA node1 CPU(s):   32-63
>>     NUMA node2 CPU(s):   64-95
>>     NUMA node3 CPU(s):   96-127
>>
>> There are four SE devices in my system, one for each NUMA node.
> For Loongson-3C6000 node is the same as package. You should consider
> Loongson-3C5000L, one package contains four nodes.

I am not familiar with the SE-related components on the 3C5000L, and 
this driver is not compatible with the 5000 series.

Qunqin,

Thanks.

>
> Huacai
>
>> Qunqin,
>>
>> Thanks
>>
>>> Huacai
>>>
>>>> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
>>>> ---
>>>> Changes in v2:
>>>>           -Resending due to no feedback for one month.
>>>>           -Rebased on top of latest mainline (7.1-rc1) to ensure the patch
>>>>            applies cleanly.
>>>>           -No functional changes since the previous submission.
>>>>
>>>> Link to v1:
>>>> https://lore.kernel.org/all/20260226102225.19516-1-zhaoqunqin@loongson.cn/#t
>>>>
>>>>    drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
>>>>    include/linux/mfd/loongson-se.h |  3 +++
>>>>    2 files changed, 35 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
>>>> index 3902ba377d6..40e18c21268 100644
>>>> --- a/drivers/mfd/loongson-se.c
>>>> +++ b/drivers/mfd/loongson-se.c
>>>> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
>>>>           u32 info[7];
>>>>    };
>>>>
>>>> +static DECLARE_COMPLETION(node0);
>>>> +static struct loongson_se *se_node[SE_MAX_NODES];
>>>> +
>>>>    static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>>>    {
>>>>           u32 status;
>>>> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
>>>>    static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>>>    {
>>>>           struct loongson_se *se = dev_id;
>>>> -       u32 int_status;
>>>> -       int id;
>>>> +       u32 int_status, node_irq = 0;
>>>> +       int id, node;
>>>>
>>>>           spin_lock(&se->dev_lock);
>>>>
>>>> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>>>                   writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
>>>>           }
>>>>
>>>> +       if (int_status & SE_INT_OTHER_NODE) {
>>>> +               int_status &= ~SE_INT_OTHER_NODE;
>>>> +               node_irq = 1;
>>>> +       }
>>>> +
>>>>           /* For engines */
>>>>           while (int_status) {
>>>>                   id = __ffs(int_status);
>>>> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>>>
>>>>           spin_unlock(&se->dev_lock);
>>>>
>>>> +       if (node_irq) {
>>>> +               writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
>>>> +               for (node = 1; node < SE_MAX_NODES; node++) {
>>>> +                       if (se_node[node])
>>>> +                               se_irq_handler(irq, se_node[node]);
>>>> +               }
>>>> +       }
>>>> +
>>>>           return IRQ_HANDLED;
>>>>    }
>>>>
>>>> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>>>>           struct loongson_se *se;
>>>>           int nr_irq, irq, err, i;
>>>>           dma_addr_t paddr;
>>>> +       int node = dev_to_node(dev);
>>>>
>>>>           se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>>>>           if (!se)
>>>> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_device *pdev)
>>>>
>>>>           writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>>>>
>>>> -       nr_irq = platform_irq_count(pdev);
>>>> -       if (nr_irq <= 0)
>>>> -               return -ENODEV;
>>>> +       if (node == 0 || node == NUMA_NO_NODE) {
>>>> +               nr_irq = platform_irq_count(pdev);
>>>> +               if (nr_irq <= 0)
>>>> +                       return -ENODEV;
>>>> +       } else {
>>>> +               /* Only the device on node 0 can trigger interrupts */
>>>> +               nr_irq = 0;
>>>> +               wait_for_completion_interruptible(&node0);
>>>> +               se_node[node] = se;
>>>> +       }
>>>>
>>>>           for (i = 0; i < nr_irq; i++) {
>>>>                   irq = platform_get_irq(pdev, i);
>>>> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_device *pdev)
>>>>           if (err)
>>>>                   return err;
>>>>
>>>> -       return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
>>>> +       complete_all(&node0);
>>>> +
>>>> +       return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>>>>                                       ARRAY_SIZE(engines), NULL, 0, NULL);
>>>>    }
>>>>
>>>> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
>>>> index 07afa0c2524..a80e06eb017 100644
>>>> --- a/include/linux/mfd/loongson-se.h
>>>> +++ b/include/linux/mfd/loongson-se.h
>>>> @@ -20,6 +20,9 @@
>>>>
>>>>    #define SE_INT_ALL                     0xffffffff
>>>>    #define SE_INT_CONTROLLER              BIT(0)
>>>> +#define SE_INT_OTHER_NODE              BIT(31)
>>>> +
>>>> +#define SE_MAX_NODES                   8
>>>>
>>>>    #define SE_ENGINE_MAX                  16
>>>>    #define SE_ENGINE_RNG                  1
>>>>
>>>> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
>>>> --
>>>> 2.47.2
>>>>
>>>>
>>

