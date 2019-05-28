Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727B6C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25CDA21734
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559062552;
	bh=2OhEdCRqao+EZByRf7YXUoYt0lfpmeKn8PPsYafN/G8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sTzNlf0wQ2/ouifn8BMW8bBPeg7+e2NcBh7Q4eYBbDMi20ru8WOwPBbPhKh5wDw7R
	 g2NBQmGywH5PuZbCH/y7UdSRusD3RvrYi9iqKVoH3Cu1kxq1thNbkzffF+lE4KfWtn
	 NlshkwSoHHuaZSQ8Ff09QOUvOIPnmBh8W0hN/uKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfE1Qzv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 12:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfE1Qzv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 12:55:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50E9721721;
        Tue, 28 May 2019 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559062550;
        bh=2OhEdCRqao+EZByRf7YXUoYt0lfpmeKn8PPsYafN/G8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RmiSO2kbTI1xVF/hT63m/zxBcNOOLejJYSko6WSpvGBuPJ31As0Yw8E8mt4gFPxID
         ZfaaAXzndjAQ9P/1nndvfZxBQse47XHLSeGio/zA5/JwrXIGPkL4BVEOGbhbX7L1NN
         u2+OnbkzZiqBFL7tuCWYkryCcwQpFuul2Pr0f3oU=
Date:   Tue, 28 May 2019 09:55:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH v2] crypto: xxhash - Implement xxhash support
Message-ID: <20190528165548.GC739@sol.localdomain>
References: <20190528121451.5954-1-nborisov@suse.com>
 <20190528152248.GB739@sol.localdomain>
 <e7f5ac70-ff22-4471-2682-52c8cd246bf0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7f5ac70-ff22-4471-2682-52c8cd246bf0@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 28, 2019 at 07:49:58PM +0300, Nikolay Borisov wrote:
> 
> 
> On 28.05.19 г. 18:22 ч., Eric Biggers wrote:
> > On Tue, May 28, 2019 at 03:14:51PM +0300, Nikolay Borisov wrote:
> >> xxhash is currently implemented as a self-contained module in /lib.
> >> This patch enables that module to be used as part of the generic kernel
> >> crypto framework. It adds a simple wrapper to the 64bit version.
> >>
> > 
> > Thanks, this looks a lot better.  A couple minor comments below.
> > 
> >> +static int xxhash64_init(struct shash_desc *desc)
> >> +{
> >> +	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
> >> +	struct xxhash64_desc_ctx *dctx = shash_desc_ctx(desc);
> >> +
> >> +	xxh64_reset(&dctx->xxhstate, tctx->seed);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
> >> +			 unsigned int keylen)
> >> +{
> >> +	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(tfm);
> >> +
> >> +	if (keylen != sizeof(tctx->seed)) {
> >> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> >> +		return -EINVAL;
> >> +	}
> >> +	tctx->seed = get_unaligned_le64(key);
> >> +	return 0;
> >> +}
> > 
> > Can you please move xxhash64_setkey() to before xxhash64_init() to match the
> > order in which the functions get called?
> > 
> > Sometimes people get confused and think that crypto_shash_init() comes before
> > crypto_shash_setkey(), so it's helpful to keep definitions in order.
> > 
> >> +module_init(xxhash_mod_init);
> > 
> > Can you change this to subsys_initcall?  We're using subsys_initcall for the
> > generic implementations of crypto algorithms now, so that when other
> > implementations (e.g. assembly language implementations) are added, the crypto
> > self-tests can compare them to the generic implementations.
> 
> Will fix those but wanted to ask you whether it's really necessary to
> use get_unaligned in setkey given generic code guarantees the buffer is
> going to be aligned. E.g. wouldn't cpu_to_le64(*(u64 *)key)) be
> "cheaper"? In any case this is a minor point but just want to be sure I
> have correctly understood the generic code?

The generic code only aligns the buffer to the .cra_alignmask set in the
shash_alg, which in this case is 0, so the buffer is not aligned.

I don't recommend setting an alignmask, since it's more efficient to use the
unaligned access helpers.  The code in lib/xxhash.c already uses them.

- Eric
