Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A52EC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2427561105
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhJMNNG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 09:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234152AbhJMNNG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 09:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D69610FC;
        Wed, 13 Oct 2021 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634130662;
        bh=teGcBvjkKcvW58YVaruBcXJovWJTtD1vxXWTSxfLepM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXPe2vE1fb9Pn6GDKQbsAJEAsUG/rxFjdlElS6D7bjH5kak9/st7J7N15QfVPIlU/
         jv/fD1vsHF6BENDGR6WV3qft2teF0clFGxJAkT2IrD7m4lQJHh9fGTz5ZJl5kWSqu6
         iVnt+ASwodVsiaxj0Ex+MLzz8F8/aH5Oc53Xdasg=
Date:   Wed, 13 Oct 2021 15:11:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Vegard Nossum <vegard.nossum@oracle.com>,
        linux-staging@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC
Message-ID: <YWba5CIZNpFkRKEm@kroah.com>
References: <20211011152941.12847-1-vegard.nossum@oracle.com>
 <YWbQd51r8R3BprMi@kroah.com>
 <1bfd3945-3487-31ab-5489-9c12c759276b@oracle.com>
 <CAK8P3a05E2muUiy0KcRgzhGef-Xg99_pY3gnDpWt7uHmbTxVGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a05E2muUiy0KcRgzhGef-Xg99_pY3gnDpWt7uHmbTxVGg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 13, 2021 at 03:03:41PM +0200, Arnd Bergmann wrote:
> On Wed, Oct 13, 2021 at 2:51 PM Vegard Nossum <vegard.nossum@oracle.com> wrote:
> > On 10/13/21 2:26 PM, Greg Kroah-Hartman wrote:
> > > On Mon, Oct 11, 2021 at 05:29:41PM +0200, Vegard Nossum wrote:
> > >> Fix the following build/link errors:
> > >>
> > >>   ld: drivers/staging/ks7010/ks_hostif.o: in function `michael_mic.constprop.0':
> > >>   ks_hostif.c:(.text+0x95b): undefined reference to `crypto_alloc_shash'
> > >>   ld: ks_hostif.c:(.text+0x97a): undefined reference to `crypto_shash_setkey'
> > >>   ld: ks_hostif.c:(.text+0xa13): undefined reference to `crypto_shash_update'
> > >>   ld: ks_hostif.c:(.text+0xa28): undefined reference to `crypto_shash_update'
> > >>   ld: ks_hostif.c:(.text+0xa48): undefined reference to `crypto_shash_finup'
> > >>   ld: ks_hostif.c:(.text+0xa6d): undefined reference to `crypto_destroy_tfm'
> > >>
> > >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> > >> ---
> > >>  drivers/staging/ks7010/Kconfig | 3 +++
> > >>  1 file changed, 3 insertions(+)
> > >>
> > >> diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
> > >> index 0987fdc2f70db..8ea6c09286798 100644
> > >> --- a/drivers/staging/ks7010/Kconfig
> > >> +++ b/drivers/staging/ks7010/Kconfig
> > >> @@ -5,6 +5,9 @@ config KS7010
> > >>      select WIRELESS_EXT
> > >>      select WEXT_PRIV
> > >>      select FW_LOADER
> > >> +    select CRYPTO
> > >> +    select CRYPTO_HASH
> > >> +    select CRYPTO_MICHAEL_MIC
> > >
> > > Let's try to rely on 'depend' and not 'select' please.
> >
> > I used 'select' because it seemed to be the established pattern for
> > these options.
> 
> Yes, this is the correct way to do it here. In general, using "depends on"
> is better than "select", especially when crossing subsystem boundaries,
> however mixing the two is what really hurts because of the circular
> dependencies you'd get.
> 
> The only way we could use 'depends on' here would be to change all
> the other drivers to do the same.
> 
> > Compare:
> >
> > $ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO$' | wc --lines
> > 1
> >
> > $ find -name '*Kconfig*' | xargs git grep 'select CRYPTO$' | wc --lines
> > 66
> >
> > $ find -name '*Kconfig*' | xargs git grep 'depends on CRYPTO' | wc --lines
> > 87
> >
> > $ find -name '*Kconfig*' | xargs git grep 'select CRYPTO' | wc --lines
> > 1005
> >
> > That said, I have found several other cases where CRYPTO_* algorithms
> > are getting 'select'-ed without also selecting CRYPTO/CRYPTO_HASH, so I
> > definitely see the problem you're trying to address.
> >
> > I've added some more people on Cc to see if there is a consensus on the
> > best way to do this for the CRYPTO* options going forwards. Thoughts,
> > anybody?
> 
> I don't think there is much point in trying to change the
> existing pattern for crypto. We might want to change some of those
> that use 'depends on' at the moment for consistency, though most of
> those look correct as well.

Ok, I'll take this as-is then.

thanks,

greg k-h
