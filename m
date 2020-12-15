Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9722C4361B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 17:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6312022475
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 17:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgLOR5e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbgLOR52 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 12:57:28 -0500
Date:   Tue, 15 Dec 2020 09:56:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608055007;
        bh=OHlhOyOXULguAwQuzCFCaHRF+5UzuR2DOvXoghvhOiY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=RX4u6mQadPglJZLzhC1HeYEkdReYfMl14JOnEbwIx26l6/9Ffch9NPPVRxVaWXycP
         TGZHCHhvTxD4lFWNOcw6uRSYZvxro4g5uMIMbAx6QINqLiKkcVnQeda7LQOce+VgQK
         pA6jzWodB8zP3qtiKgiIeQJXu4EIgKV7WjC5FOzlmj/vtxaP+0wPg435KGswnVsSjt
         fCop8IhwXmaFOSiubl+p6RuUaVZQ/YNGWoyhEEWP1xCJG4Zp/7c9TQPswB0ogaP0NX
         ft//ZpyvnYuBF8LGVqIg2ocy/CybM7TfhidiOzw6+KztMH+IEYyEnrOCjZJvcGzLba
         8kenoAh7L87/w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, TimGuo-oc@zhaoxin.com,
        CooperYan@zhaoxin.com, QiyuanWang@zhaoxin.com,
        HerryYang@zhaoxin.com, CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <X9j43b+JPbUUvCrH@sol.localdomain>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <X9Ov3RWDpUik7gXo@sol.localdomain>
 <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com>
 <X9fN7mOMdn1Dxn63@sol.localdomain>
 <a95984ea-7451-78fe-88c5-b81f633fecdf@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a95984ea-7451-78fe-88c5-b81f633fecdf@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 10:15:29AM +0800, Tony W Wang-oc wrote:
> 
> On 15/12/2020 04:41, Eric Biggers wrote:
> > On Mon, Dec 14, 2020 at 10:28:19AM +0800, Tony W Wang-oc wrote:
> >> On 12/12/2020 01:43, Eric Biggers wrote:
> >>> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> >>>> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> >>>> On platforms with Zhaoxin CPUs supporting this X86 feature, When
> >>>> crc32c-intel and crc32c-generic are both registered, system will
> >>>> use crc32c-intel because its .cra_priority is greater than
> >>>> crc32c-generic. This case expect to use crc32c-generic driver for
> >>>> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> >>>> CPUs support from crc32c-intel.
> >>>>
> >>>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> >>>
> >>> Does this mean that the performance of the crc32c instruction on those CPUs is
> >>> actually slower than a regular C implementation?  That's very weird.
> >>>
> >>
> >> From the lmbench3 Create and Delete file test on those chips, I think yes.
> >>
> > 
> > Did you try measuring the performance of the hashing itself, and not some
> > higher-level filesystem operations?
> > 
> 
> Yes. Was testing on these Zhaoxin CPUs, the result is that with the same
> input value the generic C implementation takes fewer time than the
> crc32c instruction implementation.
> 

And that is really "working as intended"?  Why do these CPUs even declare that
they support the crc32c instruction, when it is so slow?

Are there any other instruction sets (AES-NI, PCLMUL, SSE, SSE2, AVX, etc.) that
these CPUs similarly declare support for but they are uselessly slow?

- Eric
