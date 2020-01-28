Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9828C33CB7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6832467F
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580180470;
	bh=dgrFC/YlQ6vdFSWhyXSefEtBu5RQiQmH81+Yg354x4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=q8orVP7xLZejtL1z0O3gBcSHVWOVEEfD9tDxda9IQTyAmtcFkKagW9zVqZZHiKWqx
	 TM3Jm9uQOH3puPYM+oIoBKyEDWtwCSFv9SifoVa83nwMIS9DBnanREi4gdSjjnsZpB
	 wvLsaeMETvQPvsse8c4LaBxHn2Lj0IiGJcN+HwFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgA1DBJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgA1DBJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 22:01:09 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9FC2173E;
        Tue, 28 Jan 2020 03:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580180469;
        bh=dgrFC/YlQ6vdFSWhyXSefEtBu5RQiQmH81+Yg354x4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sf7i7IYZ0uS4LnBOERwv1uqa4ceGCqq1UdA0Y651rMIVD9VSu82bNt/HeQqWiTs0w
         D0xoPbpjVPTR1H8CcV4Y5VazM9WNc3YPBUImegCWEJwQgAm8d90CuF7YQcVRceoTP1
         iwSkABjAfIqXqKCOxN6zB2D0JkEzxVq229+zPpyY=
Date:   Mon, 27 Jan 2020 19:01:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3] crypto: ccree - protect against short scatterlists
Message-ID: <20200128030107.GF960@sol.localdomain>
References: <20200127150822.12126-1-gilad@benyossef.com>
 <CAMuHMdVFcsS9K=7+LfT_Tmmpz4LMS69=+EO+8_BkJoXCOfPzPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVFcsS9K=7+LfT_Tmmpz4LMS69=+EO+8_BkJoXCOfPzPA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 04:22:53PM +0100, Geert Uytterhoeven wrote:
> Hi Gilad,
> 
> On Mon, Jan 27, 2020 at 4:08 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > Deal gracefully with the event of being handed a scatterlist
> > which is shorter than expected.
> >
> > This mitigates a crash in some cases due to
> > attempt to map empty (but not NULL) scatterlists with none
> > zero lengths.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Thank you, boots fine on Salvator-XS with R-Car H3ES2.0, and
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y.
> 
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Gr{oetje,eeting}s,
> 

Note that you need to *unset* CONFIG_CRYPTO_MANAGER_DISABLE_TESTS to enable the
self-tests.

So to run the full tests, the following is needed:

# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

- Eric
