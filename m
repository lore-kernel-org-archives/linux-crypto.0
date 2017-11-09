From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/8] staging: ccree: use more readable func names
Date: Thu, 9 Nov 2017 08:26:21 +0200
Message-ID: <CAOtvUMdeNC3iQ9Bd8-CjMEk3sKkdrOCb_qM+Q6X8Sgi5tJ+3XA@mail.gmail.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-3-git-send-email-gilad@benyossef.com> <20171107103010.pgmgmmsjhxt4fjft@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:55126 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdKIG0W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 01:26:22 -0500
Received: by mail-ot0-f181.google.com with SMTP id w8so4418718otw.11
        for <linux-crypto@vger.kernel.org>; Wed, 08 Nov 2017 22:26:22 -0800 (PST)
In-Reply-To: <20171107103010.pgmgmmsjhxt4fjft@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dan,

Thank you for reviewing the patch set.

On Tue, Nov 7, 2017 at 12:30 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Nov 07, 2017 at 09:39:58AM +0000, Gilad Ben-Yossef wrote:
> > @@ -780,11 +766,10 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
> >               unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
> >               unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
> >               /* Chain to given list */
> > -             ssi_buffer_mgr_add_buffer_entry(
> > -                     dev, sg_data,
> > -                     areq_ctx->gen_ctx.iv_dma_addr + iv_ofs,
> > -                     iv_size_to_authenc, is_last,
> > -                     &areq_ctx->assoc.mlli_nents);
> > +             cc_add_buffer_entry(dev, sg_data,
> > +                                 (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
>                                     ^                                      ^
>
> No need to resend the patch, but you've added parenthesis here that
> weren't in the original code and in other places you fixed up some long
> line warnings.  I'd prefer if you didn't do that because I use scripts
> to review rename patches automatically and since these are not a rename
> so it means I have to review them manually.  Also in that patch that
> Tobin complained about you had some extra comment changes and some were
> related to the API but some were just reformatted to fit in 80 chars.
>
>
> In this sample, you've re-indented the code a bit to align correctly.
> That would be mandatory especially if the original code had aligned
> correctly so that's fine.  But otherwise try to be strict about the one
> thing per patch.
>
> > +                                 iv_size_to_authenc, is_last,
> > +                                 &areq_ctx->assoc.mlli_nents);
> >               areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
> >       }
> >
>

Noted. I have changed the patch description to at least reflect what it is
doing more accurately (i.e. more than just func name switching).

Thanks again for the review.

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
