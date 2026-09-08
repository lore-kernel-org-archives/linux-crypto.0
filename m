Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A14255F2C;
	Tue,  8 Sep 2026 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831174; cv=none; b=sxV8v6qUMixF5QFfAdI5WeFpnfDb1ezEWaT5cedCV80nuboPsW5xYGuurbQuM1RbAKQszkpiNUhTK/qyHJQE48OIs56GCNcRb8OVqvqnRQ+gT1c+1RAo45s8J/sZT3mHcwlp8d8pPbpdsZ5xC7t6EHS5QBpxWn7womTsQ3OgywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831174; c=relaxed/simple;
	bh=ZoRBNYjnw+uMyi83yVcHKmcKEgh+q+93564/c876kOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VXTth4ZIKf5TORUdWzrutuMmLncucoyyxdCKqpzYz3tzBbBVEn8WFlDCuNqVv74VcxH16Db8JGPbaJqUA8uSZFPcZlqHHaVbaSkmvr9WEBNcP61BiHYitDcOQtGVpm9uS6vifz07cKTW8mQ4MT8RBmXVoVGwgyolVmGoFB8X26c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Ax39K6ZZ9qbaQJAA--.27349S3;
	Tue, 08 Sep 2026 09:32:42 +0800 (CST)
Received: from [10.20.42.102] (unknown [10.20.42.102])
	by front1 (Coremail) with SMTP id qMiowJDxxMywZZ9qyOIcAA--.34568S2;
	Tue, 08 Sep 2026 09:32:34 +0800 (CST)
Message-ID: <75e2a59d-e636-4d7e-be66-f4b365a7d956@loongson.cn>
Date: Tue, 8 Sep 2026 09:29:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Huacai Chen <chenhuacai@kernel.org>, Qunqin Zhao <zhaoqunqin@163.com>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-crypto@vger.kernel.org, mfd@lists.linux.dev
References: <20260907023827.14905-1-zhaoqunqin@163.com>
 <20260907023827.14905-3-zhaoqunqin@163.com>
 <CAAhV-H6M+MKs+YYB9dKofVi56wKSoY1y9KYWP9wJfjz=cK9waw@mail.gmail.com>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <CAAhV-H6M+MKs+YYB9dKofVi56wKSoY1y9KYWP9wJfjz=cK9waw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxxMywZZ9qyOIcAA--.34568S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Kr1DGryDJF1DCr4UtF13Awc_yoWDZFWrpF
	WDCa1Ykrs8Xr48CwsIqr90vFyayr95trnrCws3ta1xArykt3s5WFW5KFyUWa93urWUtF1I
	vFWkGFs3ua4rC3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=


在 2026/9/7 22:12, Huacai Chen 写道:
> Hi, Qunqin,
>
> On Mon, Sep 7, 2026 at 10:38 AM Qunqin Zhao <zhaoqunqin@163.com> wrote:
>> From: Qunqin Zhao <zhaoqunqin@loongson.cn>
>>
>> Address multiple historical driver issues discovered by the Sashiko
>> Automation system within the loongson_se_probe() initialization flow
>> and the driver's interrupt service routines [1].
>>
>> - Add an explicit bounds check in se_irq_handler() before accessing
>>   the engines array to prevent an out-of-bounds memory access.
>>
>> - Switch from devm_kmalloc() to devm_kzalloc() and explicitly
>>   initialize all engine completion structures in probe() to avoid a
>>   kernel panic from complete() dereferencing a NULL wait head when a
>>   spurious interrupt fires before child drivers call
>>   loongson_se_init_engine().
>>
>> - Serialize command submission with a new poll_lock spinlock and
>>   protect the completion reset with the interrupt lock.  Before
>>   issuing a command, mask the target interrupt, clear any pending
>>   status, and reinitialize the completion under dev_lock, then
>>   re-enable the interrupt after the command has been triggered.  This
>>   closes the race where a stale interrupt from a previously
>>   interrupted command could complete the current command's
>>   completion.  The spin_lock_irq() around the 10 ms poll is dropped so
>>   interrupts are not disabled for the full busy-wait.
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
>>  drivers/mfd/loongson-se.c       | 90 +++++++++++++++++++++++++++++----
>>  include/linux/mfd/loongson-se.h |  1 +
>>  2 files changed, 82 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
>> index 7f552a8ee..1d332c418 100644
>> --- a/drivers/mfd/loongson-se.c
>> +++ b/drivers/mfd/loongson-se.c
>> @@ -23,6 +23,8 @@
>>  struct loongson_se {
>>         void __iomem *base;
>>         spinlock_t dev_lock;
>> +       /* Synchronizes command submission between users of different engines */
>> +       spinlock_t poll_lock;
> Can't we reuse dev_lock?
>
> Huacai
>
>>         struct completion cmd_completion;
>>
>>         void *dmam_base;
>> @@ -42,7 +44,7 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>         u32 status;
>>         int err;
>>
>> -       spin_lock_irq(&se->dev_lock);
>> +       spin_lock(&se->poll_lock);

dev_lock may be taken in IRQ handler. Without interrupt masking, 
deadlock could occur.

Thanks,

Qunqin

>>
>>         /* Notify the controller that the engine needs to be started */
>>         writel(int_bit, se->base + SE_L2SINT_SET);
>> @@ -52,17 +54,48 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>                                                 !(status & int_bit),
>>                                                 1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
>>
>> -       spin_unlock_irq(&se->dev_lock);
>> +       /*
>> +        * Re-enable the interrupt that loongson_se_reinit_completion() masked.
>> +        * The hardware guarantees that once the interrupt is re-enabled, only
>> +        * interrupts for the command just issued can arrive, so a stale
>> +        * interrupt from a previously interrupted command can never complete
>> +        * this command's completion.
>> +        */
>> +       writel(int_bit | readl(se->base + SE_S2LINT_EN), se->base + SE_S2LINT_EN);
>> +
>> +       spin_unlock(&se->poll_lock);
>>
>>         return err;
>>  }
>>
>> +/*
>> + * Prepare a completion for a new command: mask the corresponding interrupt,
>> + * clear any pending interrupt status, and reset the completion.  This runs
>> + * under dev_lock so that the IRQ handler cannot race with it.  The interrupt
>> + * is re-enabled in loongson_se_poll() after the command has been issued.
>> + */
>> +static void loongson_se_reinit_completion(struct loongson_se *se,
>> +                                         struct completion *completion, u32 int_bit)
>> +{
>> +       spin_lock_irq(&se->dev_lock);
>> +
>> +       writel(readl(se->base + SE_S2LINT_EN) & ~int_bit, se->base + SE_S2LINT_EN);
>> +
>> +       writel(int_bit, se->base + SE_S2LINT_CL);
>> +
>> +       reinit_completion(completion);
>> +
>> +       spin_unlock_irq(&se->dev_lock);
>> +}
>> +
>>  static int loongson_se_send_controller_cmd(struct loongson_se *se,
>>                                            struct loongson_se_controller_cmd *cmd)
>>  {
>>         u32 *send_cmd = (u32 *)cmd;
>>         int err, i;
>>
>> +       loongson_se_reinit_completion(se, &se->cmd_completion, SE_INT_CONTROLLER);
>> +
>>         for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
>>                 writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
>>
>> @@ -75,12 +108,16 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
>>
>>  int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>>  {
>> +       int err;
>> +
>> +       loongson_se_reinit_completion(engine->se, &engine->completion, BIT(engine->id));
>> +
>>         /*
>>          * After engine initialization, the controller already knows
>>          * where to obtain engine commands from. Now all we need to
>>          * do is notify the controller that the engine needs to be started.
>>          */
>> -       int err = loongson_se_poll(engine->se, BIT(engine->id));
>> +       err = loongson_se_poll(engine->se, BIT(engine->id));
>>
>>         if (err)
>>                 return err;
>> @@ -93,7 +130,7 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>>  {
>>         struct loongson_se *se = dev_get_drvdata(dev);
>>         struct loongson_se_engine *engine = &se->engines[id];
>> -       struct loongson_se_controller_cmd cmd;
>> +       struct loongson_se_controller_cmd cmd = {0};
>>
>>         engine->se = se;
>>         engine->id = id;
>> @@ -155,7 +192,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>         /* For engines */
>>         while (int_status) {
>>                 id = __ffs(int_status);
>> -               complete(&se->engines[id].completion);
>> +               if (id < SE_ENGINE_MAX)
>> +                       complete(&se->engines[id].completion);
>>                 int_status &= ~BIT(id);
>>                 writel(BIT(id), se->base + SE_S2LINT_CL);
>>         }
>> @@ -167,7 +205,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>
>>  static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
>>  {
>> -       struct loongson_se_controller_cmd cmd;
>> +       struct loongson_se_controller_cmd cmd = {0};
>>         int err;
>>
>>         cmd.command_id = SE_CMD_START;
>> @@ -188,6 +226,17 @@ static const struct mfd_cell engines[] = {
>>         { .name = "tpm_loongson" },
>>  };
>>
>> +static void loongson_se_stop(void *data)
>> +{
>> +       struct loongson_se *se = data;
>> +       struct loongson_se_controller_cmd cmd = {0};
>> +
>> +       cmd.command_id = SE_CMD_STOP;
>> +       loongson_se_send_controller_cmd(se, &cmd);
>> +
>> +       writel(0, se->base + SE_S2LINT_EN);
>> +}
>> +
>>  static int loongson_se_probe(struct platform_device *pdev)
>>  {
>>         struct device *dev = &pdev->dev;
>> @@ -195,19 +244,34 @@ static int loongson_se_probe(struct platform_device *pdev)
>>         int nr_irq, irq, err, i;
>>         dma_addr_t paddr;
>>
>> -       se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>> +       se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
>>         if (!se)
>>                 return -ENOMEM;
>>
>>         dev_set_drvdata(dev, se);
>>         init_completion(&se->cmd_completion);
>>         spin_lock_init(&se->dev_lock);
>> +       spin_lock_init(&se->poll_lock);
>>         mutex_init(&se->engine_init_lock);
>>
>> +       for (i = 0; i < SE_ENGINE_MAX; i++)
>> +               init_completion(&se->engines[i].completion);
>> +
>>         dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>>         if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
>>                 return -ENODEV;
>>
>> +       /*
>> +        * Engine 0 does not exist and its data buffer is reused as the command
>> +        * buffer for the other engines.  The command buffers of all engines
>> +        * therefore must fit within engine 0's data region, i.e.
>> +        * dmam_size / SE_ENGINE_MAX >= SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE.
>> +        * Enforce this to keep each engine's data and command buffers from
>> +        * overlapping.
>> +        */
>> +       if ((se->dmam_size / SE_ENGINE_MAX) < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
>> +               return -EINVAL;
>> +
>>         se->dmam_base = dmam_alloc_coherent(dev, se->dmam_size, &paddr, GFP_KERNEL);
>>         if (!se->dmam_base)
>>                 return -ENOMEM;
>> @@ -217,20 +281,28 @@ static int loongson_se_probe(struct platform_device *pdev)
>>                 return PTR_ERR(se->base);
>>
>>         nr_irq = platform_irq_count(pdev);
>> -       if (nr_irq <= 0)
>> +       if (nr_irq == 0)
>>                 return -ENODEV;
>> +       if (nr_irq < 0)
>> +               return nr_irq;
>>
>>         writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
>>
>>         for (i = 0; i < nr_irq; i++) {
>>                 irq = platform_get_irq(pdev, i);
>>                 err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
>> -               if (err)
>> +               if (err) {
>>                         dev_err(dev, "failed to request IRQ: %d\n", irq);
>> +                       return err;
>> +               }
>>         }
>>
>>         writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>>
>> +       err = devm_add_action_or_reset(dev, loongson_se_stop, se);
>> +       if (err)
>> +               return err;
>> +
>>         err = loongson_se_init(se, paddr, se->dmam_size);
>>         if (err)
>>                 return err;
>> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
>> index 07afa0c25..8237ccab7 100644
>> --- a/include/linux/mfd/loongson-se.h
>> +++ b/include/linux/mfd/loongson-se.h
>> @@ -9,6 +9,7 @@
>>  #define SE_SEND_CMD_REG_LEN            0x8
>>  /* Controller command ID */
>>  #define SE_CMD_START                   0x0
>> +#define SE_CMD_STOP                    0x1
>>  #define SE_CMD_SET_DMA                 0x3
>>  #define SE_CMD_SET_ENGINE_CMDBUF       0x4
>>
>> --
>> 2.47.2
>>

