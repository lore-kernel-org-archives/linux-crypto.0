Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7072DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E612073A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eg3Q+4u1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KTfzcCae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgGIHjJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 03:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIHjJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 03:39:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131B1C061A0B;
        Thu,  9 Jul 2020 00:39:09 -0700 (PDT)
Date:   Thu, 9 Jul 2020 09:39:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594280347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9iDuCPY5jQD/QE0vjfP0a2K9MiEkv+fafOh2l6dUgtQ=;
        b=eg3Q+4u1Jkv/Kn5+vvvuWi/l0zsTaal1qOeVcF6HT01CBEq/I82eHHL1HpKwoLiXp+zMbJ
        7rNCoW2CDsD2XwouMOsR/VdBNuVcabqS28PLIOigPwHkH/x09iSxxGbvF2wXqDZNoVW/7/
        3eWIeGfBndrDJRV/fkvsn9LdoLCKO0mMPZUmzin8Sza5d+K6pBWBEnuKFBcOO3yjVqxSd1
        19GathtpXqFwljq5K9M3aeJ2Lkro6SeRrEFKuCq5hXJcg0L8qG1K/adJyXlHIOX6s4rKXC
        KMjl01whu/u63DVoU5bAXutnVDC8rMEDUfzAEpLy/+pYqA71+4sgLoWBK3Dibw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594280347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9iDuCPY5jQD/QE0vjfP0a2K9MiEkv+fafOh2l6dUgtQ=;
        b=KTfzcCae9F6ml/fMfVsarbSqtOzXHPyKmy9J6NmM0RURPwLtWxlU3+PjTA4wqLG1EUYvJ4
        9+z+5he+1U8aAGAQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200709073905.lgs5kvccnz6eqsyd@linutronix.de>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD25610B7@DGGEMI525-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B926444035E5E2439431908E3842AFD25610B7@DGGEMI525-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-07-09 01:32:38 [+0000], Song Bao Hua (Barry Song) wrote:
> > This looks using the same synchronous mechanism around an asynchronous
> > interface. It works as a PoC.
> > 
> > As far as I remember the crypto async interface, the incoming skbs were fed to
> > the async interface and returned to the caller so the NIC could continue
> > allocate new RX skbs and move on. Only if the queue of requests was getting
> > to long the code started to throttle. Eventually the async crypto code
> > completed the decryption operation in a different context and fed the
> > decrypted packet(s) into the stack.
> > 
> > From a quick view, you would have to return -EINPROGRESS here and have at
> > the caller side something like that:
> > 
> > iff --git a/mm/page_io.c b/mm/page_io.c
> > index e8726f3e3820b..9d1baa46ec3ed 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -252,12 +252,15 @@ int swap_writepage(struct page *page, struct
> > writeback_control *wbc)
> >                 unlock_page(page);
> >                 goto out;
> >         }
> > -       if (frontswap_store(page) == 0) {
> > +       ret = frontswap_store(page);
> > +       if (ret == 0) {
> >                 set_page_writeback(page);
> >                 unlock_page(page);
> >                 end_page_writeback(page);
> >                 goto out;
> >         }
> > +       if (ret = -EINPROGRESS)
> > +               goto out;
> >         ret = __swap_writepage(page, wbc, end_swap_bio_write);
> >  out:
> >         return ret;
> > 
> Unfortunately, this is not true and things are not that simple.
> 
> We can't simply depend on -EINPROGRESS and go out.
> We have to wait for the result of compression to decide if we should
> do __swap_writepage(). As one page might be compressed into two
> pages, in this case, we will still need to do _swap_writepage().
> As I replied in the latest email, all of the async improvement to frontswap
> needs very careful thinking and benchmark. It can only happen after
> we build the base in this patch, fixing the broken connection between
> zswap and those new zip drivers.

At the time the compression finishes you see what happens and based on
the design you can either complete it immediately (the 0/error case from
above) or forward the result to the caller and let him decide.

> Thanks
> Barry

Sebastian
