Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CE9C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 16:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0661D22363
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574180595;
	bh=Et+NziiyOApfNBcF0Smr+w05xUXuYpnKtSMneS6tkQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Cfjwndge9VAGNeY7nw2s+HGWwUMlZLoUtHin7ZI0Mk9Z4I9HzJNj+ujh1/esC3vID
	 mI9UKOLBkNLzmm9Fp82+jvsVnvOIcm5cVTvE4q2nNcTMq4Oggg6yC61q0S0K9ya5yS
	 1sy3ca0GC5/08H7oKUXbzLyu4veD3czIWDPx9mlA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfKSQXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfKSQXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 11:23:13 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2AD222A2;
        Tue, 19 Nov 2019 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574180593;
        bh=Et+NziiyOApfNBcF0Smr+w05xUXuYpnKtSMneS6tkQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1choS67o2JRwMBu/1xPc4sbkLp2GTw7XsLxsQTYkmd/KN0risE+9qZ99QYx3ry4c
         Amg0Ef2rjxcnCct2sJIdpfLXJH1nXWcIn8yKO+k2TlmKgy+YHD3mCNgOLjH2D9a1Ph
         dnXAkZE38ycXcL69anaLvNku8BfqG42PlFmSoJ5Y=
Date:   Tue, 19 Nov 2019 08:23:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for
 WireGuard
Message-ID: <20191119162311.GA819@sol.localdomain>
References: <20191108122240.28479-1-ardb@kernel.org>
 <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
 <20191115090921.jn45akou3cw4flps@gondor.apana.org.au>
 <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
 <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com>
 <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 04:44:11PM +0100, Jason A. Donenfeld wrote:
> >
> > So for future changes, could we please include performance numbers
> > based on realistic workloads?
> 
> Yea I share your concerns here. From preliminary results, I think the
> Poly1305 code will be globally better, and I don't think we'll need an
> abundance of discussion about it.
> 
> The ChaCha case is more interesting. I'll submit this with lots of
> packet-sized microbenchmarks, as well as on-the-wire WireGuard
> testing. Eric - I'm guessing you don't care too much about Adamantium
> performance on x86 where people are probably better off with AES-XTS,
> right? Are there other specific real world cases we care about? IPsec
> is another one, but those concerns, packet-size wise, are more or less
> the same as for WireGuard. But anyway, we can cross this bridge when
> we come to it.

I'd like for Adiantum to continue to be accelerated on x86, but it doesn't have
to squeeze out all performance possible on x86, given that hardware AES support
is available there so most people will use that instead.  So if e.g. the ChaCha
implementation is still AVX2 accelerated, but it's primarily optimized for
networking packets rather than disk encryption, that would probably be fine.

- Eric
