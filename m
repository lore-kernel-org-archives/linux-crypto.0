Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487C9C32771
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 02:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B6152467C
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 02:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580178899;
	bh=O6/aCXTO535hblnPIlwq6N86x4jkZI6LZb22nam/RN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lYS7UoufUAHCm0tVzkwj82QBKoczfaOAg0faSdV7/fDhYSVFbOKPZ2e8zV6OP+JbJ
	 N6nNff2GdOyxOaZgk7/yUpgoXZbyW481p3wZAr2QXlD0Zx+BQ3xf49dEvwiRs8zj9X
	 l/Csjs9N3a0i/WZEbHtiqI3yNmlX2N9G1nH6ic8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgA1Ce6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 21:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgA1Ce6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 21:34:58 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA0C24656;
        Tue, 28 Jan 2020 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580178897;
        bh=O6/aCXTO535hblnPIlwq6N86x4jkZI6LZb22nam/RN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJAJeuPdaIwDVxcPFDIzs8z23ZIe0ftCiWqSwGuFEJG110srYnheecdKV79rlczsr
         WkMDOXhETjBGT9G7KqspS4HM9qG+crPjqRZCV3SUOlurNswRi8h12gFiNFnzVvYHGS
         wK+3OQN9HDjO7r42EXjz5M+BrRacNb/8HDID30QU=
Date:   Mon, 27 Jan 2020 18:34:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Message-ID: <20200128023455.GC960@sol.localdomain>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 10:04:26AM +0200, Gilad Ben-Yossef wrote:
> 
> When both vec->alen and vec->plen are 0, which can happen as
> generate_random_bytes will happily generate  zero length from time to
> time,
> we seem to be getting a scatterlist with the first entry (as well as
> the 2nd) being a NULL.
> 
> This seems to violate the words of wisdom from aead.h and much more
> important to me crashes the ccree driver :-)
> 
> Is there anything I am missing or is this a valid concern?
> 

My understanding is that all crypto API functions that take scatterlists only
forbid zero-length scatterlist elements in the part of the scatterlist that's
actually passed to the API call.  The input to these functions is never simply a
scatterlist, but rather a (scatterlist, length) pair.  Algorithms shouldn't look
beyond 'length', so in the case of 'length == 0', they shouldn't look at the
scatterlist at all -- which may be just a NULL pointer.

If that's the case, there's no problem with this test code.

I'm not sure the comment in aead.h is relevant here.  It sounds like it's
warning about not providing an empty scatterlist element for the AAD when it's
followed by a nonempty scatterlist element for the plaintext.  I'm not sure it's
meant to also cover the case where both are empty.

Herbert and Stephan, any thoughts on what was intended?

- Eric
