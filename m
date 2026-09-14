Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808553FC5A1;
	Mon, 14 Sep 2026 08:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374141; cv=none; b=soN1g+9JBLCe16M2YKeLViuceL49uYNAIN9VWrdrNlQVFJwkunn08oOL8OS6tYS64IStZJBnrU7+Weu20gLSVxd9L23jqUk6cZas4PFu2gqKTqyhstbSo5M92Z9ygDzt6AbbJTXMdWCKrO39i134uk73b5ZUbosq0MaAIRJXr7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374141; c=relaxed/simple;
	bh=2x6G8Wp4QYVbrbwa17mOv38gkQwWsBwXD/mF/pokOYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMZDurMxV8ESoZx+xFXC9okp79sFwCSctQ3h7C/ubzUa5czzxV/+kA+qtA0hk+BLuTvI3OTgSr2yi5kLnrKLLm2/65zKS6voTR/b+V/xVnqf/A8Ey+hD/z60L9pwU6KLMMbDfEuPct0QIs0OGfzD8aKnq8SkYQj7SugDyZUt1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Axj9G4rqdq1bsLAA--.34152S3;
	Mon, 14 Sep 2026 16:22:16 +0800 (CST)
Received: from [10.20.42.102] (unknown [10.20.42.102])
	by front1 (Coremail) with SMTP id qMiowJCxPs+zrqdqWIYgAA--.4475S2;
	Mon, 14 Sep 2026 16:22:14 +0800 (CST)
Message-ID: <4ca28c4a-1a4d-4f12-b9c0-10f092e93a66@loongson.cn>
Date: Mon, 14 Sep 2026 16:19:31 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Huacai Chen <chenhuacai@kernel.org>, Qunqin Zhao <zhaoqunqin@163.com>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-crypto@vger.kernel.org, mfd@lists.linux.dev
References: <20260911090256.7834-1-zhaoqunqin@163.com>
 <20260911090256.7834-3-zhaoqunqin@163.com>
 <CAAhV-H4VEtZJAoYBz24=ab37fdpLL_kSS92vxMn61Rcq0C33aQ@mail.gmail.com>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <CAAhV-H4VEtZJAoYBz24=ab37fdpLL_kSS92vxMn61Rcq0C33aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPs+zrqdqWIYgAA--.4475S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxtFW5Cr17CrW8ur48WFWDKFX_yoW7Wr4DpF
	Waka1Ykr4DJr4xuwnxX3W5uFya9395tr1UCa93tayUAr9Fyrn5WFy3KFyUua9rurWxtF12
	qFWktFZ5uas8AagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkU
	UUUU=


在 2026/9/14 15:36, Huacai Chen 写道:
> Hi, Qunqin,
>
> On Fri, Sep 11, 2026 at 5:03 PM Qunqin Zhao <zhaoqunqin@163.com> wrote:
>> From: Qunqin Zhao <zhaoqunqin@loongson.cn>
>>
>> Address multiple historical driver issues discovered by the Sashiko
>> Automation system within the loongson_se_probe() initialization flow
>> and the driver's interrupt service routines [1].
>>
>> - Add an explicit bounds check in se_irq_handler() before accessing
>>   the engines array to prevent an out-of-bounds memory access.
>>
>> - Validate the id argument in loongson_se_init_engine() and reject
>>   engine 0, whose data buffer is reused for the command buffers of all
>>   other engines, to prevent out-of-bounds accesses and overlapping DMA
>>   buffers.
>>
>> - Switch from devm_kmalloc() to devm_kzalloc() and initialize all
>>   engine completion structures in probe(), dropping the redundant
>>   init_completion() in loongson_se_init_engine().
>>
>> - Introduce loongson_se_reinit_completion() to mask the target
>>   interrupt, clear any pending status, and reset the completion under
>>   dev_lock before a command is issued, then re-enable the interrupt
>>   under the same lock after the command has been triggered.  This
>>   closes the race where a stale interrupt from a previously
>>   interrupted command could complete the current command's completion.
>>   A new poll_lock serializes the trigger and poll busy-wait so
>>   interrupts are not disabled for up to 10 ms.
> The locking of this driver is more and more complicated, I doubt
> whether AI's review is really correct here. For me, the existing
> locking code is just fine and simple.

I'm not sure  whether disabling interrupts for 10 ms will cause kernel damage.

Or keep the current lock and fix it if we actually run into problems? 

After all, this extreme case will not occur. In practical tests, polling 

averages only a few microseconds, with the worst case under 1 ms.

Thanks.

>
> Huacai
>
>> - Wait for controller command completion with a bounded
>>   non-interruptible wait so a pending signal cannot leave the
>>   controller running while its DMA buffers are being torn down, and a
>>   wedged controller cannot hang the kernel indefinitely.
>>
>> - Fix EPROBE_DEFER handling: propagate the error directly from
>>   platform_irq_count() instead of overwriting it with ENODEV so that
>>   probe deferral works when the interrupt provider is not yet ready.
>>
>> - Validate dmam_size from firmware against the minimum required size
>>   to keep the command buffers of all engines within engine 0's data
>>   region and prevent overlapping DMA buffers.
>>
>> - Return the error code from devm_request_irq() instead of silently
>>   continuing to prevent an indefinite hang.
>>
>> - Add a loongson_se_stop() cleanup handler registered with
>>   devm_add_action_or_reset() before loongson_se_init() so that a
>>   failed init still stops the controller and masks all interrupts via
>>   devres, preventing DMA access to freed memory.
>>
>> - Zero-initialize the local controller command structures in
>>   loongson_se_init() and loongson_se_init_engine() to prevent
>>   uninitialized stack data from being written to device registers.
>>
>> - Add the SE_CMD_STOP command definition.
>>
>> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
>> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
>> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
>> ---
>>  drivers/mfd/loongson-se.c       | 112 ++++++++++++++++++++++++++++----
>>  include/linux/mfd/loongson-se.h |   1 +
>>  2 files changed, 102 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
>> index 7f552a8ee..18075d4fa 100644
>> --- a/drivers/mfd/loongson-se.c
>> +++ b/drivers/mfd/loongson-se.c
>> @@ -23,6 +23,8 @@
>>  struct loongson_se {
>>         void __iomem *base;
>>         spinlock_t dev_lock;
>> +       /* Synchronizes command submission between users of different engines */
>> +       spinlock_t poll_lock;
>>         struct completion cmd_completion;
>>
>>         void *dmam_base;
>> @@ -42,7 +44,7 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>         u32 status;
>>         int err;
>>
>> -       spin_lock_irq(&se->dev_lock);
>> +       spin_lock(&se->poll_lock);
>>
>>         /* Notify the controller that the engine needs to be started */
>>         writel(int_bit, se->base + SE_L2SINT_SET);
>> @@ -52,17 +54,51 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>                                                 !(status & int_bit),
>>                                                 1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
>>
>> +       spin_unlock(&se->poll_lock);
>> +
>> +       spin_lock_irq(&se->dev_lock);
>> +       /*
>> +        * Re-enable the interrupt that loongson_se_reinit_completion() masked.
>> +        * The hardware guarantees that once the interrupt is re-enabled, only
>> +        * interrupts for the command just issued can arrive, so a stale
>> +        * interrupt from a previously interrupted command can never complete
>> +        * this command's completion.
>> +        */
>> +       writel(int_bit | readl(se->base + SE_S2LINT_EN), se->base + SE_S2LINT_EN);
>> +
>>         spin_unlock_irq(&se->dev_lock);
>>
>>         return err;
>>  }
>>

