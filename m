Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC930C35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97C0D21A4C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570026702;
	bh=xNLLoG7v27LIzEl5QRnINrRIqV6W7/rbqkyfxLmZxR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1YMuyO5YiAdqoMgQlxQAHui+jeFGmvRzvcNx09yRq+/94DAAYiSND7Fw36F8L8FgY
	 eH3+Lh1pZQ/TxaVp1kJy4D++ij45+SrF+/dk0WuUJJjwNZeaMStNWk4Rqi0h/XfR0K
	 DJI1kBDV+wQc2kqI19inOEO3vzQBD6H0mtsHA4Wc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJBObm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfJBObm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:31:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0867D21783;
        Wed,  2 Oct 2019 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570026701;
        bh=xNLLoG7v27LIzEl5QRnINrRIqV6W7/rbqkyfxLmZxR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uo94ACIW5phK88nh7nG3ouYTBARhTDmQYNtekEgK9HT+c7tFLmvK1O2Q+Dsq8pHp7
         ac0RUBaMCoEG5YElrjPddAH5HDrhFUYDXviuuUUPvwQ/m2wuCRwwyECcAPsvg5TmO2
         nVtcOodjpYcZ7i51BD7uKehKm9CdoIFReq3Es+gA=
Date:   Wed, 2 Oct 2019 16:31:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 02/20] crypto: x86/chacha - expose SIMD ChaCha routine
 as library function
Message-ID: <20191002143139.GB1743118@kroah.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:16:55PM +0200, Ard Biesheuvel wrote:
> Wire the existing x86 SIMD ChaCha code into the new ChaCha library
> interface.

Again, this says _what_, but not _why_.

Yes, changelogs are hard :(

thanks,

greg k-h
