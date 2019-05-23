Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A695C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 20:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF23720881
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558642736;
	bh=GAo+Q2CUwnl22M0qwci3DAHS2xF/lB7jyKGsm+hwa6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sYjYj9V430Bp42btiYCDuE7Evt/7pNPfi9BtXBn2UV1uyxJcJRtskIe4Mez0yQeE3
	 TgdWeq+BcjKVC/7aF/SAn5U8x/egEX7nX8bty8bLrmiu060RAcS5bKwgzdY0l40ALo
	 0pfCKqipyup+C366HNjF4R2fvWlEm/f2rgPnnzyk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbfEWUSy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 16:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfEWUSy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 16:18:54 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB8620644;
        Thu, 23 May 2019 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558642733;
        bh=GAo+Q2CUwnl22M0qwci3DAHS2xF/lB7jyKGsm+hwa6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ReiaMxf8ZRVVqrw8GLnl8QSU5plezKSx9XCVXnVFvIiakFCPevsjMvaR5Eww6HXXr
         OUEUZqr8utVFE5911RYQ6dYTDx6Dp9i0w4DZPOIx7vSlPmJbiVzpkiYAoSP9B972Cb
         n8AjfhSgQ3o3Lj72WHC0wphKo7YXnFGv3gwVCdYA=
Date:   Thu, 23 May 2019 13:18:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: testmgr question
Message-ID: <20190523201851.GB248378@gmail.com>
References: <AM6PR09MB3523DA127897A981C9E0074FD2000@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190522162737.GA132972@google.com>
 <AM6PR09MB3523F1C423891763D4B3BF7CD2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523190534.GB243994@google.com>
 <AM6PR09MB3523BE1CDAE2E25AC47A3FD6D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB3523BE1CDAE2E25AC47A3FD6D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 23, 2019 at 07:44:08PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@google.com]
> > Sent: Thursday, May 23, 2019 9:06 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: linux-crypto-owner@vger.kernel.org; Herbert Xu
> > <herbert@gondor.apana.org.au>
> > Subject: Re: testmgr question
> >
> > On Thu, May 23, 2019 at 07:01:46AM +0000, Pascal Van Leeuwen wrote:
> > > > -----Original Message-----
> > > > From: Eric Biggers [mailto:ebiggers@google.com]
> > > > Sent: Wednesday, May 22, 2019 6:28 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > > > Cc: linux-crypto-owner@vger.kernel.org; Herbert Xu
> > > > <herbert@gondor.apana.org.au>
> > > > Subject: Re: testmgr question
> > > >
> > > > On Wed, May 22, 2019 at 01:32:43PM +0000, Pascal Van Leeuwen wrote:
> > > > > Ugh,
> > > > >
> > > > > I just synced my development branch with Linus' mainline tree (5.2-rc1)
> > and
> > > > > apparently inherited some new testmgr tests that are now failing on the
> > > > Inside
> > > > > Secure driver. I managed to fix some trivial ones related to non-zero
> > IV
> > > > size
> > > > > on ECB modes and error codes that differed from the expected ones, but
> > now
> > > > I'm
> > > > > rather stuck with a hang case ... and I don't have a clue which
> > particular
> > > > test
> > > > > is hanging or even which algorithm is being tested :-(
> > > > >
> > > > > Is there, by any chance, some magical debug switch available to make
> > > > testmgr
> > > > > print out which test it is actually *starting* to run?
> > > > >
> > > > > Regards,
> > > > >
> > > > > Pascal van Leeuwen
> > > > > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > > > > www.insidesecure.com
> > > > >
> > > >
> > > > Not currently, but you can easily add some debugging messages to testmgr
> > > > yourself.  E.g.,
> > > >
> > > > Print 'alg' and 'driver' at beginning of alg_test() to see which
> > algorithm is
> > > > starting to be tested.
> > > >
> > > > Print 'vec_name' and 'cfg->name' at beginning of test_hash_vec_cfg(),
> > > > test_skcipher_vec_cfg(), and test_aead_vec_cfg() to see which test vector
> > is
> > > > starting to be tested and under what configuration.
> > > >
> > > Thanks. I guess adding such debugging statements to testmgr is what I've
> > been
> > > doing all along. Like everyone else having to debug these issues, I guess
> > ...
> > > Therefore I assumed by now, there might have been some standard
> > infrastructure
> > > for that. Or maybe it was just a hint that such a thing might be useful ;-)
> > >
> >
> > testmgr already prints information when a test fails which is enough for most
> > cases, and in my experience when it's not I need to add messages specific to
> > tracking down the particular issue anyway.  So that's why I haven't
> > personally
> > added more messages.  Feel free to send a patch, though.  Also, please
> > continue
> > any further discussion of this on linux-crypto.
> >
> When developing hardware drivers, when things go wrong, odds are fairly
> significant that the whole thing just hangs (or is that just me? :-).
> So I can imagine I'm not the only one adding these debug print statements,
> which means effort is probably wasted here. But I do notice that I keep
> adding and removing them/commenting them out as they're pretty annoying when
> things don't actually hang ...
> 
> Usually just knowing which specific case fails is enough for me  to reason about
> why it's failing. I rarely need more debugging information than that. Following
> a hash/HMAC operation is pretty impossible anyway unless you have a reference
> implementation standing by to compare with.
> 

The verbose debugging messages could be behind a Kconfig option, or just printed
with pr_debug() so that they could be turned on with dynamic debug
(https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html).
Again, feel free to send a patch.

- Eric
