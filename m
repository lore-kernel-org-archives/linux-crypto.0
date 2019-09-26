Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF53C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 21:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44144222BE
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 21:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="42+OolRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfIZVWt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 17:22:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfIZVWs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 17:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q4R7UfVYGZJoQlextE7kd33omghSb6abX3Sbjx+dlt8=; b=42+OolRyRFsJNrJkDhAyOC+tPy
        AqkOt4KkLTNAp18uAMOXj2lM164RvjVgcORYj0iPgpFD/sQmL/++7HR9BDAO5KegsqBVudiVwlSZj
        wWisCGXC8NQwMuBnoEkOR3scspTcXSW0pJHT2LB4D0kzjmZq0FXnPlLKUaQ2DhnPPrmE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDbDX-00065C-VN; Thu, 26 Sep 2019 23:22:27 +0200
Date:   Thu, 26 Sep 2019 23:22:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>, Will Deacon <will@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
Message-ID: <20190926212227.GG20927@lunn.ch>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
 <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > So are you saying that the handshake timing constraints in the
> > WireGuard protocol are so stringent that we can't run it securely on,
> > e.g., an ARM CPU that lacks a NEON unit? Or given that you are not
> > providing accelerated implementations of blake2s or Curve25519 for
> > arm64, we can't run it securely on arm64 at all?
> 
> Deployed at scale, the handshake must have a certain performance to
> not be DoS'd. I've spent a long time benching these and attacking my
> own code.  I won't be comfortable with this going in without the fast
> implementations for the handshake. 

As a networking guy, the relation between fast crypto for handshake
and DoS is not obvious. Could you explain this a bit?

It seems like a lot of people would like an OpenWRT box to be their
VPN gateway. And most of them are small ARM or MIPs processors. Are
you saying WireGuard will not be usable on such devices?

Thanks
	Andrew
