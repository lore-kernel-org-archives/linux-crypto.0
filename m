Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9D834CDD;
	Sat,  7 Mar 2026 06:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772865079; cv=none; b=POIGqMrYqJhCcjvmvQTz/NSi0KnfVl9GHVqiN8ABRZEGay6PYquFwO9uSq9khDlOFAJXYpE1jgrrIA+jsw4fh2647olEImUfyy1SRbCpcNKEJBYtggTwMp8Lv0OoMf8QPpTHtH+y43zwWZJlKqhNaXry3T9g7FhD7C6BtSlaAbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772865079; c=relaxed/simple;
	bh=hlHvTiRKNlb3RxD5d0e5z+aoxD6okBVY09sv35Uxd0A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q6iHi8iiP6Hp35eCatFkwjZd1F8N+bS+6jQarusESnGPV9XABFOCHNLILC5hWhkKVP2Eg0EqKzooc3D8SxqwqsCV3ae8YSWWdBQMgwKgxt0xq0KRaP709Ngp7dViSlS/F9x+b9yQa8tJKoK1e0aBLMYk796PuGuSP741G+Ft2Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8BxUcAxxqtpZ2wYAA--.13630S3;
	Sat, 07 Mar 2026 14:31:13 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJAxVcAuxqtpYfFPAA--.23506S2;
	Sat, 07 Mar 2026 14:31:12 +0800 (CST)
Subject: Re: [PATCH] mfd: loongson-se: Add multi-node support
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260226102225.19516-1-zhaoqunqin@loongson.cn>
 <20260306133558.GL183676@google.com>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <d2e0c03d-717e-bae2-9066-0d8f84fdeca3@loongson.cn>
Date: Sat, 7 Mar 2026 14:29:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260306133558.GL183676@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJAxVcAuxqtpYfFPAA--.23506S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxJw45JF18Gr4rCr48Xry5trc_yoWrAF4Dpr
	WDCayYkF4UGry7CwsYv390kr1avrWrtrZrC397tF4fAas0qrn3Wry5KFy5WF4rCFWUJF40
	vrW8WFZ5uF40qFgCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25Ef
	UUUUU


在 2026/3/6 下午9:35, Lee Jones 写道:
> On Thu, 26 Feb 2026, Qunqin Zhao wrote:
>
>> On the Loongson platform, each node is equipped with a security engine
>> device. However, due to a hardware flaw, only the device on node 0 can
>> trigger interrupts. Therefore, interrupts from other nodes are forwarded
>> by node 0. We need to check in the interrupt handler of node 0 whether
>> this interrupt is intended for other nodes.
>>
>> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
>> ---
>>   drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
>>   include/linux/mfd/loongson-se.h |  3 +++
>>   2 files changed, 35 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
>> index 3902ba377..40e18c212 100644
>> --- a/drivers/mfd/loongson-se.c
>> +++ b/drivers/mfd/loongson-se.c
>> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
>>   	u32 info[7];
>>   };
>>   
>> +static DECLARE_COMPLETION(node0);
Devices on non-zero nodes rely on the device on node 0, so they need to 
wait for the device on node 0 to complete initialization.
>> +static struct loongson_se *se_node[SE_MAX_NODES];

I need to iterate through all devices in interrupt context, so I use a 
global variable to track them.


Could I ask if there might be a more suitable method?

Thanks,

Qunqin

> Really not keen on global variables.
>
> Why are they _needed_?
>
>>   static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>   {
>>   	u32 status;
>> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
>>   static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>   {
>>   	struct loongson_se *se = dev_id;
>> -	u32 int_status;
>> -	int id;
>> +	u32 int_status, node_irq = 0;
>> +	int id, node;
>>   
>>   	spin_lock(&se->dev_lock);
>>   
>> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>   		writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
>>   	}
>>   
>> +	if (int_status & SE_INT_OTHER_NODE) {
>> +		int_status &= ~SE_INT_OTHER_NODE;
>> +		node_irq = 1;
>> +	}
>> +
>>   	/* For engines */
>>   	while (int_status) {
>>   		id = __ffs(int_status);
>> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>   
>>   	spin_unlock(&se->dev_lock);
>>   
>> +	if (node_irq) {
>> +		writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
>> +		for (node = 1; node < SE_MAX_NODES; node++) {
>> +			if (se_node[node])
>> +				se_irq_handler(irq, se_node[node]);
>> +		}
>> +	}
>> +
>>   	return IRQ_HANDLED;
>>   }
>>   
>> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>>   	struct loongson_se *se;
>>   	int nr_irq, irq, err, i;
>>   	dma_addr_t paddr;
>> +	int node = dev_to_node(dev);
>>   
>>   	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>>   	if (!se)
>> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_device *pdev)
>>   
>>   	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>>   
>> -	nr_irq = platform_irq_count(pdev);
>> -	if (nr_irq <= 0)
>> -		return -ENODEV;
>> +	if (node == 0 || node == NUMA_NO_NODE) {
>> +		nr_irq = platform_irq_count(pdev);
>> +		if (nr_irq <= 0)
>> +			return -ENODEV;
>> +	} else {
>> +		/* Only the device on node 0 can trigger interrupts */
>> +		nr_irq = 0;
>> +		wait_for_completion_interruptible(&node0);
>> +		se_node[node] = se;
>> +	}
>>   
>>   	for (i = 0; i < nr_irq; i++) {
>>   		irq = platform_get_irq(pdev, i);
>> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_device *pdev)
>>   	if (err)
>>   		return err;
>>   
>> -	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
>> +	complete_all(&node0);
>> +
>> +	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>>   				    ARRAY_SIZE(engines), NULL, 0, NULL);
>>   }
>>   
>> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
>> index 07afa0c25..a80e06eb0 100644
>> --- a/include/linux/mfd/loongson-se.h
>> +++ b/include/linux/mfd/loongson-se.h
>> @@ -20,6 +20,9 @@
>>   
>>   #define SE_INT_ALL			0xffffffff
>>   #define SE_INT_CONTROLLER		BIT(0)
>> +#define SE_INT_OTHER_NODE		BIT(31)
>> +
>> +#define SE_MAX_NODES			8
>>   
>>   #define SE_ENGINE_MAX			16
>>   #define SE_ENGINE_RNG			1
>> -- 
>> 2.47.2
>>

