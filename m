From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 26 Sep 2017 21:28:53 +0200
Message-ID: <20170926192853.qe6boek63huc7hce@kozik-lap>
References: <CGME20170915175007eucas1p2912e7a9e1b44e976f96a53d8c8e442ec@eucas1p2.samsung.com>
 <ee7efd48-434b-e07f-b391-9ceeee980e3e@partner.samsung.com>
 <20170919190341.5vi5icaxnmynywre@kozik-lap>
 <8924d30c-6581-28f3-c223-c2a24c491887@partner.samsung.com>
 <20170925182713.ti4esyznyrjr7xh7@kozik-lap>
 <fe4298c9-4f90-b027-9351-a40837b909c4@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36661 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935225AbdIZT25 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 15:28:57 -0400
Content-Disposition: inline
In-Reply-To: <fe4298c9-4f90-b027-9351-a40837b909c4@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 26, 2017 at 05:54:42PM +0200, Kamil Konieczny wrote:
> On 25.09.2017 20:27, Krzysztof Kozlowski wrote:
> [...]
> >>>> +	struct tasklet_struct		hash_tasklet;
> >>>> +	u8				xmit_buf[BUFLEN] SSS_ALIGNED;
> >>>> +
> >>>> +	unsigned long			hash_flags;
> >>>
> >>> This should be probably DECLARE_BITMAP.
> >>
> >> I do not get it, it is used for bits HASH_FLAGS_... and is not HW related.
> >> This will grow this patch even longer.
> > 
> > Why longer? Only declaration changes, rest should be the same.
> > Just instead of playing with bits over unsigned long explicitly use a
> > type for that purpose - DECLARE_BITMAP.
> 
> It will make code ugly, using &dev->hash_flags[0] instead of &dev->hash_flags.

Wait, all the set_bit and clear_bit should be even simpler:
	-set_bit(HASH_FLAGS_DMA_READY, &dev->hash_flags);
	+set_bit(HASH_FLAGS_DMA_READY, dev->hash_flags);
This looks actually better..

> I have 9 bits used, and I will not anticipate it grow above 64.

You mean 32.

> If you insist, I can add DECLARE_BITMAP and rewrite all calls to _bits()
> functions.

Actually not, I do not insist. Just for me it makes the code simpler
(lack of "&" operand) and more robust as you explicitly declare number
of used bits (instead of assumption that your data type on given
compiler matches the amount of flags). Both arguments are not that
important.


> [...]
> >>>> +	struct samsung_aes_variant	*pdata;
> >>>
> >>> This should be const as pdata should not be modified.
> >>
> >> You are right, and I do not modify _offsets parts, but only hash
> >> functions pointers and hash array size. It is made non-const due
> >> to keeping it in the place, and not moving struct samsung_aes_variant
> >> below hash functions definitions.
> >>
> >> If I need to keep them const, then I will move whole part below, just
> >> before _probe, so I can properly set hash_algs_info and
> >> hash_algs_size (and again, small change, but bigger patch).
> >>
> >> I can do this, if you think it is safer to have them const.
> > 
> > I see, you are modifiying the variant->hash_algs_info and
> > variant->hash_algs_size. However all of them should be static const as
> > this is not a dynamic data. It does not depend on any runtime
> > conditions, except of course choosing the variant itself.
> 
> You are right, I will make samsung_aes_variant const again.
> 
> [...]
> >>>> +/**
> >>>> + * s5p_hash_finish_req - finish request
> >>>> + * @req:	AHASH request
> >>>> + * @err:	error
> >>>> + *
> >>>> + * Clear flags, free memory,
> >>>> + * if FINAL then read output into ctx->digest,
> >>>> + * call completetion
> >>>> + */
> >>>> +static void s5p_hash_finish_req(struct ahash_request *req, int err)
> >>>> +{
> >>>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
> >>>> +	struct s5p_aes_dev *dd = ctx->dd;
> >>>> +
> >>>> +	if (test_bit(HASH_FLAGS_SGS_COPIED, &dd->hash_flags))
> >>>> +		free_pages((unsigned long)sg_virt(ctx->sg),
> >>>> +			   get_order(ctx->sg->length));
> >>>> +
> >>>> +	if (test_bit(HASH_FLAGS_SGS_ALLOCED, &dd->hash_flags))
> >>>> +		kfree(ctx->sg);
> >>>> +
> >>>> +	ctx->sg = NULL;
> >>>> +
> >>>> +	dd->hash_flags &= ~(BIT(HASH_FLAGS_SGS_ALLOCED) |
> >>>> +			    BIT(HASH_FLAGS_SGS_COPIED));
> >>>> +
> >>>> +	if (!err && !test_bit(HASH_FLAGS_ERROR, &ctx->flags)) {
> >>>> +		s5p_hash_read_msg(req);
> >>>> +		if (test_bit(HASH_FLAGS_FINAL, &dd->hash_flags))
> >>>> +			err = s5p_hash_finish(req);
> >>>> +	} else {
> >>>> +		ctx->flags |= BIT(HASH_FLAGS_ERROR);
> >>>> +	}
> >>>> +
> >>>> +	/* atomic operation is not needed here */
> >>>
> >>> Ok, but why?
> >>>
> >>
> >> Good question, I frankly copy&paste this. The hash vars in s5p_aes_dev
> >> are no longer used as all transfers ended, we have req context here
> >> so after complete we can work on next request,
> >> and clearing bit HASH_FLAGS_BUSY allows this.
> > 
> > I think you need them. Here and few lines before. In
> > s5p_hash_handle_queue() you use spin-lock because it might be executed
> > multiple times. Having that assumption (multiple calls to
> > s5p_hash_handle_queue()) you can have:
> > 
> > Thread #1:                     Thread #2
> >  s5p_hash_finish_req()         s5p_hash_handle_queue()
> >  dd->hash_flags &= ...
> >    which equals to:
> 
> somewhere here will be (in Thread #2):
> 			if(test_bit(HASH_FLAGS_BUSY,dd->hash_flags)) {
> 					unlock, return; }

Right, good point! The HASH_FLAGS_BUSY bit is cleared only in
s5p_hash_finish_req() which will be executed only if the bit was set
(checked with test_bits()). This should be then put next to the sentence
"atomics are not needed here".

> 
> >    tmp = dd->hash_flags;
> >    tmp &= ~(BIT...)
> >                                  set_bit(HASH_FLAGS_BUSY, &dd->hash_flags);
> >    dd->hash_flags = tmp
> > 
> > Which means that in last assignment you effectively lost the
> > HASH_FLAGS_BUSY bit.
> > 
> > In general, you need to use atomics (or locks) everywhere, unless you
> > are 100% sure that given lockless section cannot be executed with other
> > code which uses locks.  Otherwise the atomics/locks become uneffective.
> 
> I can add spinlock as I am not 100% sure if below is true:
> 
> HASH_FLAGS_BUSY is protected by order of instructions and by test_bit.

In SMP code, one should not expect too much of order. :)
For sections not guarded by barriers (thus also locks) compiler can
re-order a lot. CPU can re-order even more. Although these
test_bit() and clear_bit() are atomic operations but they do not provide
barriers so they can be re-ordered.

> First, this bit is set only in one place, in s5p_hash_handle_queue() and cleared 
> also only in one place, s5p_hash_finish_req().
> 
> In function s5p_hash_handle_queue(), after spinlock, bit HASH_FLAGS_BUSY
> is tested and if set, there is unlock and exit, and the flow reaches next
> instructions only when this bit was not set. Setting bit is in the same spinlock
> section, so as you write, concurrent calls to s5p_hash_handle_queue are
> protected by spinlock.

Yes, but on the other hand writing the HASH_FLAGS_BUSY bit in
s5p_hash_finish_req() is not protected anyhow and it will be called on
different CPU in different thread (through tasklet). Although
s5p_hash_finish_req() is called only after checking the bits... but it
is I think unusual pattern (in s5p_hash_tasklet_cb()):
 - test_bit(hash_flags)
 - non-atomic write to hash_flags
 - test_bit(hash_flags)



Best regards,
Krzysztof
