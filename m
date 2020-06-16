Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851A4C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 16:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EBF6208B8
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592326437;
	bh=tFeDy/AowPDI/6h9VPVfcrKUX3Hq5N8CMPLQkG2tpKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AdtSi+1PGz01+zr+gSA40LnieCUgZAybt2xHvysKSKosVLynzfh9Ulnw1HZR6Ck8V
	 5emMzxf39tLHpIr3KqnBs6dethaSYGIwtkbDAd0mO3Ej4WnfDxpe4WZFnkKIM78Dcx
	 lj7B2gznqNS/amrEyyylC7cE7H4kEKzZ5AdTY3OE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgFPQx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 12:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgFPQx4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 12:53:56 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDCB020B1F;
        Tue, 16 Jun 2020 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592326435;
        bh=tFeDy/AowPDI/6h9VPVfcrKUX3Hq5N8CMPLQkG2tpKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RM6CGvr1XkQ2LnbNjIj1wOU8KoGVDVuBjdG/IAi54g1MI9y7iqg8xyxSARSqMGsee
         C0wG9HEUDW8wK4jVo3W9KMxcX+YK7i6jxm5BETAmwnUGkhoFbu6im4/zGQkr7sPNt7
         Ai5UujxhhgH6BjAX5iR89zTKiTmIqF5+fCHYdM7g=
Date:   Tue, 16 Jun 2020 09:53:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining
 and partial chaining
Message-ID: <20200616165354.GB40729@gmail.com>
References: <20200612120643.GA15724@gondor.apana.org.au>
 <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de>
 <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au>
 <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
 <20200615073024.GA27015@gondor.apana.org.au>
 <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
 <20200615185028.GB85413@gmail.com>
 <20200616110444.GA31608@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616110444.GA31608@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 09:04:44PM +1000, Herbert Xu wrote:
> On Mon, Jun 15, 2020 at 11:50:28AM -0700, Eric Biggers wrote:
> >
> > Wouldn't it make a lot more sense to make skcipher algorithms non-chainable by
> > default, and only opt-in the ones where chaining is actually working?  At the
> > moment we only test iv_out for CBC and CTR, so we can expect that all the others
> > are broken.
> 
> Yes, I'm working through all the algorithms marking them.  If it
> turns out that defaulting to off would result in a smaller patch
> then I'm certainly going to do that.
> 
> > Note that wide-block modes such as Adiantum don't support chaining either.
> > 
> > Also, please use a better name than "fcsize".
> 
> Any suggestions?
> 

Just spelling it out as final_chunksize would be much clearer.
But maybe there's a better name.

- Eric
