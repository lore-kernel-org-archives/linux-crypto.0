Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F0CC4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 05:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF53610E5
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 05:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhG0FhB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Jul 2021 01:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234867AbhG0FhA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jul 2021 01:37:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A6A60F90;
        Tue, 27 Jul 2021 05:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627364219;
        bh=jKzvWPkfAb5WuJ+G+O/MkNwGWFDdzaWqwH/aj0q3pLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KV5v64dIM/ubl9YEgS5klpW6aX+UNPdQNMevrLRrkfsqlgrEZVIFH0L3i1GvEtuc8
         o15JBE9O1SliTbYPwIBIMvURoGru1Val0sZaKlef6mwOurjg5FNGkZ18US6j09tIHU
         8f2qjFaahvc0gO0CP5vgEjcZm9fV1Vc+8nZekfMM=
Date:   Tue, 27 Jul 2021 07:36:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jordy Zomer <jordy@pwning.systems>, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccm - avoid negative wrapping of integers
Message-ID: <YP+beE4NGUCDIQHR@kroah.com>
References: <20210726170120.410705-1-jordy@pwning.systems>
 <YP7udzoj4vVQHlYv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP7udzoj4vVQHlYv@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 26, 2021 at 10:18:47AM -0700, Eric Biggers wrote:
> On Mon, Jul 26, 2021 at 07:01:20PM +0200, Jordy Zomer wrote:
> > Set csize to unsigned int to avoid it from wrapping as a negative number (since format input sends an unsigned integer to this function). This would also result in undefined behavior in the left shift when msg len is checked, potentially resulting in a buffer overflow in the memcpy call.
> > 
> > Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> > ---
> > To address was corrected, and ccm was added to the topic to indicate that this is just for ccm.
> > 
> >  crypto/ccm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/ccm.c b/crypto/ccm.c
> > index 6b815ece51c6..e14201edf9db 100644
> > --- a/crypto/ccm.c
> > +++ b/crypto/ccm.c
> > @@ -66,7 +66,7 @@ static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
> >  	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
> >  }
> >  
> > -static int set_msg_len(u8 *block, unsigned int msglen, int csize)
> > +static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
> >  {
> >  	__be32 data;
> 
> This isn't necessarily a bad change, but the value of csize is clearly in
> [1, 256] if you read format_input(), and in fact is in [2, 8] if you read the
> whole file, so please don't claim this is actually fixing anything, as it's not.

Oh that was not obvious at all, I looked at that for a long time and
missed the place where this was checked earlier.  Perhaps just make
csize here a u8 and that would take away all question about what is
happening?

thanks,

greg k-h
