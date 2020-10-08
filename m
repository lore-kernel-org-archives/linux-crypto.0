Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0339FC433E7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 23:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF732224E
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 23:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602200146;
	bh=guZ/fnj2ggLXl4Yp8HJIheTTgfcwcLKJ0a/mAEZhKzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IzGA+0LCMMxBebwPe1OvLAgXKXBX6VNrdMT9krccHZOEFYDqjl9B+uLADizTuJScu
	 fUDX3ie5AIUVpkUat9ot5OoUUymiaYMJPPu2ECsRtLo4blNHR5Nu8LZhskTAJua1AT
	 Yk47GKEWF4jt7cxg/DCa6CyrU4Ol5UndLrndXoyQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgJHXfp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 19:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgJHXfp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 19:35:45 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C437622242;
        Thu,  8 Oct 2020 23:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602200145;
        bh=guZ/fnj2ggLXl4Yp8HJIheTTgfcwcLKJ0a/mAEZhKzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CpQZjGH5CzbMztfF3MTCGeBC8Jb/z5ONyNYEHNE+WvWQwGNSL2UCtw8a8P6NMuKCf
         Wn0RPKS/dSxDHpV7M8JTThgGAf1uAsnWIyg30GAGjEWCyruAWr/25FMp+BO0WrZGF6
         5L0WMBTako/b3vxkmC8AXr2zDvWb5sK5Pp6iWkDk=
Date:   Thu, 8 Oct 2020 16:35:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20201008233543.GD1869638@gmail.com>
References: <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
 <20200910122248.GA22506@Red>
 <20200911041354.GA5275@gondor.apana.org.au>
 <20200914104058.GA14265@Red>
 <20200924030859.GA8223@gondor.apana.org.au>
 <20200924132738.GA24386@Red>
 <20201008055238.GA9813@gondor.apana.org.au>
 <20201008063623.GA17802@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008063623.GA17802@Red>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 08, 2020 at 08:36:23AM +0200, Corentin Labbe wrote:
> On Thu, Oct 08, 2020 at 04:52:38PM +1100, Herbert Xu wrote:
> > On Thu, Sep 24, 2020 at 03:27:38PM +0200, Corentin Labbe wrote:
> > >
> > > This is an example on next-20200923+BigEndian
> > > alg: ahash: sha1 test failed (wrong result) on test vector \"random: psize=194 ksize=0\", cfg=\"random: inplace may_sleep use_finup src_divs=[98.25%@+1124, <flush>1.75%@+5] iv_offset=18\"

This failure is in one of the randomly generated test cases.  If it doesn't
reproduce reliably, you can set cryptomgr.fuzz_iterations=1000 on the kernel
command line (increased from the default 100).

It is confusing that it says just "sha1".  This seems to be a quirk specific to
how tcrypt calls alg_test().  It's probably really testing "sha1-sun4i-ss".
I guess that testmgr.c should be using the actual cra_driver_name in the log
messages, not the 'driver' string that was passed into alg_test().

- Eric
