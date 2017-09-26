From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 26 Sep 2017 17:54:42 +0200
Message-ID: <fe4298c9-4f90-b027-9351-a40837b909c4@partner.samsung.com>
References: <CGME20170915175007eucas1p2912e7a9e1b44e976f96a53d8c8e442ec@eucas1p2.samsung.com>
        <ee7efd48-434b-e07f-b391-9ceeee980e3e@partner.samsung.com>
        <20170919190341.5vi5icaxnmynywre@kozik-lap>
        <8924d30c-6581-28f3-c223-c2a24c491887@partner.samsung.com>
        <20170925182713.ti4esyznyrjr7xh7@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170925182713.ti4esyznyrjr7xh7@kozik-lap>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25.09.2017 20:27, Krzysztof Kozlowski wrote:
> On Fri, Sep 22, 2017 at 08:00:17PM +0200, Kamil Konieczny wrote:
>> On 19.09.2017 21:03, Krzysztof Kozlowski wrote:
>>> On Fri, Sep 15, 2017 at 07:50:06PM +0200, Kamil Konieczny wrote:
> 
> (...)
> 
>>>> +
>>>> +/* HASH flags */
>>>
>>> All defines below have "HASH_FLAGS" prefix... so actually useful would
>>> be to explain also what is a hash flag.
>>
>> These are bit numbers used by device driver, setting in dev->hash_flags,
>> used with set_bit(), clear_bit() or test_bit(), and with macro BIT(),
>> to keep device state BUSY or FREE, or to signal state from irq_handler
>> to hash_tasklet.
> 
> Then add something similar as comment to the code.

OK.

[...]
>>>>   * @lock:	Lock for protecting both access to device hardware registers
>>>> - *		and fields related to current request (including the busy field).
>>>> + *		and fields related to current request (including the busy
>>>> + *		field).
>>>> + * @res:	Resources for hash.
>>>> + * @io_hash_base: Per-variant offset for HASH block IO memory.
>>>> + * @hash_lock:	Lock for protecting hash_req and other HASH variables.
>>>
>>> I must admit that I do not see how it protects the hash_req. The
>>> hash_req looks untouched (not read, not modified) during this lock
>>> critical section. Can you share some more thoughts about it?
>>
>> It protects dev->hash_queue and dev->hash_flags
>> in begin of function s5p_hash_handle_queue.
>>
>> After dequeue non-null request, bit HASH_BUSY is set in dd->hash_flags,
>> and this bit protects dd->hash_req and other fields. From there device
>> works with dd->hash_req until finish in irq_handler and hash_tasklet.
> 
> Few thoughts here:
> 1. Other accesses to HASH_BUSY bit of hash_flags are not protected with
>    lock and you are using set_bit/clear_bit which are atomic operations,
>    so from this perspective it does not protect hash_flags.
> 2. This means the only field protected here is hash_queue so I guess you
>    expect possibility of multiple concurrent calls to s5p_hash_handle_queue().
>    This makes sense but then description has to be updated.

OK, I will update it.
Other bits in dev->hash_flags can be set and cleared only in BUSY state.

[...]
>>>> +	struct tasklet_struct		hash_tasklet;
>>>> +	u8				xmit_buf[BUFLEN] SSS_ALIGNED;
>>>> +
>>>> +	unsigned long			hash_flags;
>>>
>>> This should be probably DECLARE_BITMAP.
>>
>> I do not get it, it is used for bits HASH_FLAGS_... and is not HW related.
>> This will grow this patch even longer.
> 
> Why longer? Only declaration changes, rest should be the same.
> Just instead of playing with bits over unsigned long explicitly use a
> type for that purpose - DECLARE_BITMAP.

It will make code ugly, using &dev->hash_flags[0] instead of &dev->hash_flags.
I have 9 bits used, and I will not anticipate it grow above 64.
If you insist, I can add DECLARE_BITMAP and rewrite all calls to _bits()
functions.

[...]
>>>> +	struct samsung_aes_variant	*pdata;
>>>
>>> This should be const as pdata should not be modified.
>>
>> You are right, and I do not modify _offsets parts, but only hash
>> functions pointers and hash array size. It is made non-const due
>> to keeping it in the place, and not moving struct samsung_aes_variant
>> below hash functions definitions.
>>
>> If I need to keep them const, then I will move whole part below, just
>> before _probe, so I can properly set hash_algs_info and
>> hash_algs_size (and again, small change, but bigger patch).
>>
>> I can do this, if you think it is safer to have them const.
> 
> I see, you are modifiying the variant->hash_algs_info and
> variant->hash_algs_size. However all of them should be static const as
> this is not a dynamic data. It does not depend on any runtime
> conditions, except of course choosing the variant itself.

You are right, I will make samsung_aes_variant const again.

[...]
>>>> +/**
>>>> + * s5p_hash_finish_req - finish request
>>>> + * @req:	AHASH request
>>>> + * @err:	error
>>>> + *
>>>> + * Clear flags, free memory,
>>>> + * if FINAL then read output into ctx->digest,
>>>> + * call completetion
>>>> + */
>>>> +static void s5p_hash_finish_req(struct ahash_request *req, int err)
>>>> +{
>>>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>>>> +	struct s5p_aes_dev *dd = ctx->dd;
>>>> +
>>>> +	if (test_bit(HASH_FLAGS_SGS_COPIED, &dd->hash_flags))
>>>> +		free_pages((unsigned long)sg_virt(ctx->sg),
>>>> +			   get_order(ctx->sg->length));
>>>> +
>>>> +	if (test_bit(HASH_FLAGS_SGS_ALLOCED, &dd->hash_flags))
>>>> +		kfree(ctx->sg);
>>>> +
>>>> +	ctx->sg = NULL;
>>>> +
>>>> +	dd->hash_flags &= ~(BIT(HASH_FLAGS_SGS_ALLOCED) |
>>>> +			    BIT(HASH_FLAGS_SGS_COPIED));
>>>> +
>>>> +	if (!err && !test_bit(HASH_FLAGS_ERROR, &ctx->flags)) {
>>>> +		s5p_hash_read_msg(req);
>>>> +		if (test_bit(HASH_FLAGS_FINAL, &dd->hash_flags))
>>>> +			err = s5p_hash_finish(req);
>>>> +	} else {
>>>> +		ctx->flags |= BIT(HASH_FLAGS_ERROR);
>>>> +	}
>>>> +
>>>> +	/* atomic operation is not needed here */
>>>
>>> Ok, but why?
>>>
>>
>> Good question, I frankly copy&paste this. The hash vars in s5p_aes_dev
>> are no longer used as all transfers ended, we have req context here
>> so after complete we can work on next request,
>> and clearing bit HASH_FLAGS_BUSY allows this.
> 
> I think you need them. Here and few lines before. In
> s5p_hash_handle_queue() you use spin-lock because it might be executed
> multiple times. Having that assumption (multiple calls to
> s5p_hash_handle_queue()) you can have:
> 
> Thread #1:                     Thread #2
>  s5p_hash_finish_req()         s5p_hash_handle_queue()
>  dd->hash_flags &= ...
>    which equals to:

somewhere here will be (in Thread #2):
			if(test_bit(HASH_FLAGS_BUSY,dd->hash_flags)) {
					unlock, return; }

>    tmp = dd->hash_flags;
>    tmp &= ~(BIT...)
>                                  set_bit(HASH_FLAGS_BUSY, &dd->hash_flags);
>    dd->hash_flags = tmp
> 
> Which means that in last assignment you effectively lost the
> HASH_FLAGS_BUSY bit.
> 
> In general, you need to use atomics (or locks) everywhere, unless you
> are 100% sure that given lockless section cannot be executed with other
> code which uses locks.  Otherwise the atomics/locks become uneffective.

I can add spinlock as I am not 100% sure if below is true:

HASH_FLAGS_BUSY is protected by order of instructions and by test_bit.
First, this bit is set only in one place, in s5p_hash_handle_queue() and cleared 
also only in one place, s5p_hash_finish_req().

In function s5p_hash_handle_queue(), after spinlock, bit HASH_FLAGS_BUSY
is tested and if set, there is unlock and exit, and the flow reaches next
instructions only when this bit was not set. Setting bit is in the same spinlock
section, so as you write, concurrent calls to s5p_hash_handle_queue are
protected by spinlock.

[...]
>>>> + */
>>>> +static struct sss_hash_algs_info exynos_hash_algs_info[] = {
>>>
>>> Can it be const?
>>>
>>
>> They can, but for this I must move aes variant structures and _variant function
>> before _probe.
> 
> Ok, move them, maybe in different patch in that case since this is just
> re-order and this commit is pretty big already.

There are some fields set in this struct before HASH algorithm registration
(in _probe()). I will try to avoid aes code moves.

[...]

>>> Run checkpatch.
>>>
>>
>> Can you write more ? What options I should use ?
>> I ran and it gives zero errors, one warn about __attribute__(aligned()),
>> and one about Kconfig change (description len too low).
> 
> Oh, my bad, I thought it would complain about comment coding style.
> There should be opening /* before any text:
> /*
>  * this is
>  * long comment
>  */
> 
> But anyway you can run it with --strict and fix the minor issues for new
> code (like "Alignment should match open parenthesis", "Please use a
> blank line after"). These are not critical but for new code they are
> welcomed, I think.

Thank you, I will add this option to my process.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
