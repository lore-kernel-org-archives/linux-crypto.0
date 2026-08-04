Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614643F4845;
	Tue,  4 Aug 2026 02:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809400; cv=none; b=TqkzBrM0LlNpnZxaWfiN/YEUbYO+UlpUGiQQb81frN5a7mzyZ/NpkZJt9U07R8VdidzquHjcfr9XDbXYQfTRjkx0EdTC9rsR3FQ/QvgLQmoD14ti4i7w/T5t74eZKb1nF1a/PKBATS/G8nw85oQkgKpjkXnF8XFoapJlTAqF3i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809400; c=relaxed/simple;
	bh=u5Ja+CHHZJ/8T4aR6tPegJuCK+NMk1q4ttSifbJa7Ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dMowGUN8N4tgMOmA8zPVqsHS913Hdnho56yATVxAU/TqnzXnmS0Iuaz1PHHDvu2/lenHWvWGMlBaWIjv8M+Oq9VDDPm5i1KYnPJwLw4Tm99JPii6JLHqiKiw7YI8JB8593R10qnRkfrsHHB2wTbk7kg18rE3PVy1xdcerfRJZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8BxJOjsSXFqfiMKAA--.10125S3;
	Tue, 04 Aug 2026 10:09:48 +0800 (CST)
Received: from [10.20.42.102] (unknown [10.20.42.102])
	by front1 (Coremail) with SMTP id qMiowJBxEuTsSXFqI+IiAA--.57305S2;
	Tue, 04 Aug 2026 10:09:48 +0800 (CST)
Message-ID: <b284a9a5-6f71-46c7-80f1-ed15276330da@loongson.cn>
Date: Tue, 4 Aug 2026 10:08:59 +0800
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
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxEuTsSXFqI+IiAA--.57305S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jr17WF4UuF4UCr47ArWDGFX_yoWfZw4kpF
	WDuayYkr4jqr48uwsIq398ua4av3s5trZrCanaqF4xAFyDJr95WFy5tFyUurWrCrWDtF1I
	qFWkGFs3u3WrA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	kF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
	MxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
	JVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2pnQUUUUU


在 2026/8/3 16:01, Huacai Chen 写道:
> Hi, Qunqin,
>
> On Thu, Jul 30, 2026 at 4:41 PM Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>> Address multiple historical driver issues discovered by the Sashiko
>> Automation system within the loongson_se_probe() initialization flow
>> and the driver's interrupt service routines [1].
>>
>> - Add an explicit bounds check in se_irq_handler() before accessing
>>    the engines array to prevent out-of-bounds memory writes.
>>
>> - Switch from devm_kmalloc() to devm_kzalloc() and explicitly
>>    initialize all engine completion structures in probe() to avoid a
>>    kernel panic from complete() dereferencing a NULL wait head when a
>>    spurious interrupt fires before child drivers call
>>    loongson_se_init_engine().
>>
>> - Replace engine_init_lock with a broader cmd_lock mutex that
>>    serializes all command submissions, and move the lock into
>>    loongson_se_send_controller_cmd() and
>>    loongson_se_send_engine_cmd() to cover the full register write +
>>    poll + wait sequence.
>>
>> - Drop the spin_lock_irq from loongson_se_poll() so that interrupts
>>    are not disabled for up to 10 ms during the poll.  Keep the
>>    readl_relaxed_poll_timeout_atomic() busy-wait to avoid scheduling
>>    latency for fast hardware completions.
>>
>> - Add reinit_completion() to loongson_se_send_controller_cmd() and
>>    loongson_se_send_engine_cmd() before waiting to prevent stale
>>    completions from falsely returning success after a signal
>>    interruption.
>>
>> - Fix EPROBE_DEFER handling: propagate the error directly from
>>    platform_irq_count() instead of overwriting it with ENODEV so that
>>    probe deferral works when the interrupt provider is not yet ready.
>>
>> - Validate dmam_size from firmware against the minimum required size
>>    to prevent command buffers from pointing outside the allocated
>>    DMA region.
>>
>> - Return the error code from devm_request_irq() instead of silently
>>    continuing to prevent an indefinite hang.
>>
>> - Disable hardware interrupts in the probe error path when
>>    loongson_se_init() fails to prevent an unhandled interrupt storm.
>>
>> - Add a loongson_se_stop() cleanup handler registered with
>>    devm_add_action_or_reset() to send SE_CMD_STOP to the controller
>>    and mask all interrupts during device removal.  Using devres
>>    ensures that child MFD devices are unbound before the controller
>>    is stopped.  The STOP command uses a non-interruptible wait to
>>    avoid leaving hardware running while DMA buffers are freed.
>>
>> - Zero-initialize the local controller command structure in
>>    loongson_se_init() to prevent uninitialized stack memory from
>>    being written to device registers.
>>
>> - Add the SE_CMD_STOP command definition.
>>
>> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
>> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
>> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
>> ---
>>   drivers/mfd/loongson-se.c       | 87 ++++++++++++++++++++++++++-------
>>   include/linux/mfd/loongson-se.h |  1 +
>>   2 files changed, 69 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
>> index 7f552a8ee6..2c8afad1b0 100644
>> --- a/drivers/mfd/loongson-se.c
>> +++ b/drivers/mfd/loongson-se.c
>> @@ -28,7 +28,7 @@ struct loongson_se {
>>          void *dmam_base;
>>          int dmam_size;
>>
>> -       struct mutex engine_init_lock;
>> +       struct mutex cmd_lock;
>>          struct loongson_se_engine engines[SE_ENGINE_MAX];
>>   };
>>
>> @@ -42,8 +42,6 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>          u32 status;
>>          int err;
>>
>> -       spin_lock_irq(&se->dev_lock);
> You said you don't want to disable irq here, but I think the spinlock
> is still needed. That means you should use spin_lock/spin_unlock to
> replace spin_lock_irq/spin_unlock_irq.
Since loongson_se_poll always executes in the thread context, is it 
better to use mutex_lock(
mutex_lock(&se->cmd_lock)  outside of loongson_se_poll) for 
synchronization?
>
>> -
>>          /* Notify the controller that the engine needs to be started */
>>          writel(int_bit, se->base + SE_L2SINT_SET);
>>
>> @@ -52,8 +50,6 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>>                                                  !(status & int_bit),
>>                                                  1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
>>
>> -       spin_unlock_irq(&se->dev_lock);
>> -
>>          return err;
>>   }
>>
>> @@ -63,24 +59,40 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
>>          u32 *send_cmd = (u32 *)cmd;
>>          int err, i;
>>
>> +       mutex_lock(&se->cmd_lock);
>> +
>> +       reinit_completion(&se->cmd_completion);
>> +
>>          for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
>>                  writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
>>
>>          err = loongson_se_poll(se, SE_INT_CONTROLLER);
>>          if (err)
>> -               return err;
>> +               goto out;
>> +
>> +       err = wait_for_completion_interruptible(&se->cmd_completion);
>>
>> -       return wait_for_completion_interruptible(&se->cmd_completion);
>> +out:
>> +       mutex_unlock(&se->cmd_lock);
>> +       return err;
>>   }
>>
>>   int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>>   {
>> +       int err;
>> +
>> +       mutex_lock(&engine->se->cmd_lock);
>> +
>> +       reinit_completion(&engine->completion);
>> +
>>          /*
>>           * After engine initialization, the controller already knows
>>           * where to obtain engine commands from. Now all we need to
>>           * do is notify the controller that the engine needs to be started.
>>           */
>> -       int err = loongson_se_poll(engine->se, BIT(engine->id));
>> +       err = loongson_se_poll(engine->se, BIT(engine->id));
>> +
>> +       mutex_unlock(&engine->se->cmd_lock);
>>
>>          if (err)
>>                  return err;
>> @@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>>
>>          engine->se = se;
>>          engine->id = id;
>> -       init_completion(&engine->completion);
>> +       reinit_completion(&engine->completion);
> I'm not sure, but I think loongson_se_init_engine() is only called at
> init, so we need init_completion here.

To prevent an spurious interrupt from completing an uninitialized object,
all objects have already been fully initialized with init_completion during the probe stage.

>
> Huacai
>
>>          /* Divide DMA memory equally among all engines */
>>          engine->buffer_size = se->dmam_size / SE_ENGINE_MAX;
>> @@ -113,8 +125,6 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>>          engine->command = se->dmam_base + id * (2 * SE_ENGINE_CMD_SIZE);
>>          engine->command_ret = engine->command + SE_ENGINE_CMD_SIZE;
>>
>> -       mutex_lock(&se->engine_init_lock);
>> -
>>          /* Tell the controller where to find engine command */
>>          cmd.command_id = SE_CMD_SET_ENGINE_CMDBUF;
>>          cmd.info[0] = id;
>> @@ -124,8 +134,6 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>>          if (loongson_se_send_controller_cmd(se, &cmd))
>>                  engine = NULL;
>>
>> -       mutex_unlock(&se->engine_init_lock);
>> -
>>          return engine;
>>   }
>>   EXPORT_SYMBOL_GPL(loongson_se_init_engine);
>> @@ -155,7 +163,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>          /* For engines */
>>          while (int_status) {
>>                  id = __ffs(int_status);
>> -               complete(&se->engines[id].completion);
>> +               if (id < SE_ENGINE_MAX)
>> +                       complete(&se->engines[id].completion);
>>                  int_status &= ~BIT(id);
>>                  writel(BIT(id), se->base + SE_S2LINT_CL);
>>          }
>> @@ -167,7 +176,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>>
>>   static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
>>   {
>> -       struct loongson_se_controller_cmd cmd;
>> +       struct loongson_se_controller_cmd cmd = {0};
>>          int err;
>>
>>          cmd.command_id = SE_CMD_START;
>> @@ -188,6 +197,30 @@ static const struct mfd_cell engines[] = {
>>          { .name = "tpm_loongson" },
>>   };
>>
>> +static void loongson_se_stop(void *data)
>> +{
>> +       struct loongson_se *se = data;
>> +       struct loongson_se_controller_cmd cmd = {0};
>> +       u32 *send_cmd = (u32 *)&cmd;
>> +       int i;
>> +
>> +       mutex_lock(&se->cmd_lock);
>> +
>> +       cmd.command_id = SE_CMD_STOP;
>> +
>> +       reinit_completion(&se->cmd_completion);
>> +
>> +       for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
>> +               writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
>> +
>> +       if (!loongson_se_poll(se, SE_INT_CONTROLLER))
>> +               wait_for_completion(&se->cmd_completion);
>> +
>> +       writel(0, se->base + SE_S2LINT_EN);
>> +
>> +       mutex_unlock(&se->cmd_lock);
>> +}
>> +
>>   static int loongson_se_probe(struct platform_device *pdev)
>>   {
>>          struct device *dev = &pdev->dev;
>> @@ -195,19 +228,25 @@ static int loongson_se_probe(struct platform_device *pdev)
>>          int nr_irq, irq, err, i;
>>          dma_addr_t paddr;
>>
>> -       se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>> +       se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
>>          if (!se)
>>                  return -ENOMEM;
>>
>>          dev_set_drvdata(dev, se);
>>          init_completion(&se->cmd_completion);
>>          spin_lock_init(&se->dev_lock);
>> -       mutex_init(&se->engine_init_lock);
>> +       mutex_init(&se->cmd_lock);
>> +
>> +       for (i = 0; i < SE_ENGINE_MAX; i++)
>> +               init_completion(&se->engines[i].completion);
Thanks

