From: Sebastian Andrzej Siewior <arm-kernel@breakpoint.cc>
Subject: Re: [WIP/RFC] crypto: add support for Orion5X crypto engine
Date: Wed, 18 Mar 2009 22:57:34 +0100
Message-ID: <20090318215734.GA1473@Chamillionaire.breakpoint.cc>
References: <20090317215844.GA23739@Chamillionaire.breakpoint.cc> <20090317224243.GA6290@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33526 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124AbZCRV5j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2009 17:57:39 -0400
Content-Disposition: inline
In-Reply-To: <20090317224243.GA6290@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Evgeniy Polyakov | 2009-03-18 01:42:43 [+0300]:

>Hi.
Hi Evgeniy,

>On Tue, Mar 17, 2009 at 10:58:44PM +0100, Sebastian Andrzej Siewior (arm-kernel@ml.breakpoint.cc) wrote:
>> +struct crypto_priv {
>
>Please use less generic names over the file.
will do.

>> +	void __iomem *reg;
>> +	void __iomem *sram;
>> +	int irq;
>> +	struct task_struct *queue_th;
>> +
>> +	spinlock_t lock;
>> +	struct crypto_queue queue;
>> +	enum engine_status eng_st;
>> +	struct ablkcipher_request *cur_req;
>> +	struct req_progress p;
>> +};
>> +
>> +static struct crypto_priv *cpg;
>> +
>
>This rises several questions: why some of its fields are accessed under
>the lock and others are modified without. Some of them are only used in
>the kernel thread, while others are used in request context.
>Please document locking bits in the code.
Will do. Right now, I could switch to the _bh spinlock since it is only
required to access the queue. Earlier I planned to enqueue the first
request directly on the hw but then I got into the scatter walk.....


>> +static void reg_write(void __iomem *mem, u32 val)
>> +{
>> +	__raw_writel(val, mem);
>> +}
>> +
>> +static u32 reg_read(void __iomem *mem)
>> +{
>> +	return __raw_readl(mem);
>> +}
>> +
>
>Seems like you do not like underscores otherwise you would use those
>functions directly.
Yes, I could do so. I wasn't sure whether those are the correct
functions to access the memory. If there were for some reason I could
replace them in one place. I switch to __.

>> +
>> +#define MAX_REQ_SIZE	(8000)
>> +
>
>Parentheses are not needed.
yup.

>> +irqreturn_t crypto_int(int irq, void *priv)
>> +{
>> +//	struct crypto_priv *cp = priv;
>> +	u32 val;
>> +
>> +	val = reg_read(cpg->reg + SEC_ACCEL_INT_STATUS);
>> +	reg_write(cpg->reg + SEC_ACCEL_INT_MASK, 0);
>
>Why do you ack interrupt before checking if interrupt belongs to
>this driver?
I don't know. I better fix this.

>> +	if (!(val & SEC_INT_ACCEL0_DONE))
>> +		return IRQ_NONE;
>> +
>> +	BUG_ON(cpg->eng_st != engine_busy);
>> +	cpg->eng_st = engine_w_dequeue;
>> +	wake_up_process(cpg->queue_th);
>> +	return IRQ_HANDLED;
>> +}
>
>-- 
>	Evgeniy Polyakov

Thanks for looking over.

Sebastian
