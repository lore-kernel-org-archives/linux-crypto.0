Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5370BC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF7E20700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="xOi5Gjcr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfJDN56 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:57:58 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:55589 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387917AbfJDN56 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:57:58 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9674039d;
        Fri, 4 Oct 2019 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=CFB8npzS86sT0MXoeS6VCr+U7ps=; b=xOi5Gjc
        rQo5O8Y7JDJUErVFK1vT5YRr9g+WRkaBnG0BvW9hN0T6u5k6uexQku/t23M1C745
        WnuQiKNcBZ5rRNMdu+5w8BPLdjyVCE5GuYCK/vJtfqPwylyBklMeDSbwIhFruSeW
        Z2MCI8dSx8AngVtgR1gYmKQXnRB7cddnCtKqVV+O9MSdoZkPX1rSYVRtjMwtdFSg
        px1mE5+q73VootCZet96TvdeGuO8XU9F5PK624n1dHwUYaO/uWQ4N32G1XdZqaJQ
        nGIhTwDZMujGtG2gqi7B03Dht9mf2WdR+S/9GoI0xo7GHJp7ZwtEHaaws6/RPSG1
        FE00BtaJrTsYMSQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 343e1c5e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 13:11:02 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:57:50 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v2 14/20] crypto: Curve25519 - generic C library
 implementations and selftest
Message-ID: <20191004135750.GA114360@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-15-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-15-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:17:07PM +0200, Ard Biesheuvel wrote:
>        - replace .c #includes with Kconfig based object selection

Cool!

> +config CRYPTO_ARCH_HAVE_LIB_CURVE25519
> +	tristate
> +
> +config CRYPTO_ARCH_HAVE_LIB_CURVE25519_BASE
> +	bool
> +
> +config CRYPTO_LIB_CURVE25519
> +	tristate "Curve25519 scalar multiplication library"
> +	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519

a || !a ==> true

Did you mean for one of these to be _BASE? Or is this a Kconfig trick of
a different variety that's intentional?

> +libcurve25519-y					:= curve25519-fiat32.o
> +libcurve25519-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o

Nice idea.
