Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BF6C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 19:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245506AbiA0TUR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 14:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiA0TUQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 14:20:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC70C061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39D9961DCD
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 19:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E90C340E4;
        Thu, 27 Jan 2022 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643311215;
        bh=NTjizZsk233EJ0vZRxWy4nnxr+BH+D7tsdvUox2xP1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TEMGwiEHQypOxnFhBI+PS5u913eN6VUEKsrsUkEAOo/HJGkIWWdwFYlMqSWSsHxYg
         Thclgk8FG+sunIl6U3epDO3e32fcD16MTRMc8fAcDauWe8kHp75k9yF0fZAY8+KLm2
         BtIuGwJqzZPnJalNRud+ZsCSX0QRlc/isItBdjglMM27RF/TNEIKONC6dZ7yGOhIOC
         IT+j97aqsTDjUrGaW45tGmv3tpvJklMe04c+b54WKKL++3SW2qFOgAOQlTNb6toFty
         IKXrUWBNEpCMZf6aFpMRf/hee7PzKri++H3WziUnJVU/gEw7AK3xcHBmncjdFl33p3
         oxeGXDe/Mp8Jw==
Date:   Thu, 27 Jan 2022 11:20:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfLwbSKNbf7MAoM/@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <CAMj1kXG5vQ6SmRPPYjd4gg4O7gtjQg_NCOtEjY_EZoCPohcf2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG5vQ6SmRPPYjd4gg4O7gtjQg_NCOtEjY_EZoCPohcf2w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 10:29:31AM +0100, Ard Biesheuvel wrote:
> > diff --git a/crypto/hctr2.c b/crypto/hctr2.c
> > new file mode 100644
> > index 000000000000..af43f81b68f3
> > --- /dev/null
> > +++ b/crypto/hctr2.c
> > @@ -0,0 +1,475 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * HCTR2 length-preserving encryption mode
> > + *
> > + * Copyright 2021 Google LLC
> 
> Off by one?

To be pedantic, AFAIK if the first version of a file was written in 2021, then
it's correct to write 2021 even if it wasn't "published" yet.  But writing 2022
instead would also be fine if updates were made in 2022 (and I'd recommend just
doing that, to prevent people from thinking it's the wrong year :-) ).

- Eric
