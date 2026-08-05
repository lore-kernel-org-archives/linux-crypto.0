Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36053F8EA7;
	Wed,  5 Aug 2026 09:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922997; cv=none; b=CYqrZzwxcLaoUc2IeCpF4UPY/3a2PrLbDdry6q3FQYxNY+GtMZjrebuHynreBbOPX/XN2p9LcbXRYi3Idw8PFnEOOenajp3yZSKuY3Pfrvk1c0vtU3XijT9GQIbrcAXxpGaDzHO7p+nDk+IStt080vjZusjqPIVOB8sZS+BmxZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922997; c=relaxed/simple;
	bh=PZ9qpgLXeYgqdznCFDrzlwXU084N8JPofmf+Oikc1Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QocXWrXuKbD3tkhBrWU7K2h/AlhUO6rnodNrV/vavTDrEPEid4cyYt1A16wiBvLFl1l+UKWKIkPprXc9mlJ6kbwWfKPfCjKPxoWqedwGdPHD5glwFfv1BD6To3YYHnzxc8n1kqhgweeW/xTWHTCBd9nCRYsZp5tZgHeHIjPSufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8DxWqGvBXNqkJoKAA--.11289S3;
	Wed, 05 Aug 2026 17:43:11 +0800 (CST)
Received: from [10.20.42.102] (unknown [10.20.42.102])
	by front1 (Coremail) with SMTP id qMiowJBxb8etBXNqA5UkAA--.3824S2;
	Wed, 05 Aug 2026 17:43:11 +0800 (CST)
Message-ID: <917e48ca-d0dc-4cb6-9399-4f5b9102c0a2@loongson.cn>
Date: Wed, 5 Aug 2026 17:42:20 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Huacai Chen <chenhuacai@kernel.org>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-crypto@vger.kernel.org
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn>
 <20260730082608.1929-3-zhaoqunqin@loongson.cn>
 <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com>
 <b284a9a5-6f71-46c7-80f1-ed15276330da@loongson.cn>
 <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxb8etBXNqA5UkAA--.3824S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7CFy3uF17tw1UAFW3WF4rJFc_yoW8Aw15pF
	WDG3W3CF4UXr4vkwnxX34jkF12v3sYgrZrC3Z5tF18AFykKrnaqryYqr4Uu3yUCw4vqF1I
	qF4DKFWfu3WrC3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-UUUUU


在 2026/8/4 22:29, Huacai Chen 写道:
> On Tue, Aug 4, 2026 at 10:09 AM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>
>> 在 2026/8/3 16:01, Huacai Chen 写道:
>>> Hi, Qunqin,
>>>
>>> On Thu, Jul 30, 2026 at 4:41 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>>>    int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>>>    {
>>> +       int err;
>>> +
>>> +       mutex_lock(&engine->se->cmd_lock);
>>> +
>>> +       reinit_completion(&engine->completion);
>>> +
>>>           /*
>>>            * After engine initialization, the controller already knows
>>>            * where to obtain engine commands from. Now all we need to
>>>            * do is notify the controller that the engine needs to be started.
>>>            */
>>> -       int err = loongson_se_poll(engine->se, BIT(engine->id));
>>> +       err = loongson_se_poll(engine->se, BIT(engine->id));
>>> +
>>> +       mutex_unlock(&engine->se->cmd_lock);
>>>
>>>           if (err)
>>>                   return err;
>>> @@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>>>
>>>           engine->se = se;
>>>           engine->id = id;
>>> -       init_completion(&engine->completion);
>>> +       reinit_completion(&engine->completion);
>>> I'm not sure, but I think loongson_se_init_engine() is only called at
>>> init, so we need init_completion here.
>> To prevent an spurious interrupt from completing an uninitialized object,
>> all objects have already been fully initialized with init_completion during the probe stage.
> In my opinion, if a function can be called multiple times, we need
> reinit_completion(), if it is only called for probe, we need
> init_completion(), and loongson_se_init_engine() looks like the later
> case.

I'm not sure. If init_completion twice works too, let's go with 
init_completion then.

Thanks

>
> Huacai
>

