Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25020C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF7CC222C4
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="m83opc3T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbfJDOBF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:01:05 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54599 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388417AbfJDOBF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:01:05 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 684a1077;
        Fri, 4 Oct 2019 13:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=pE4whhF1RHvIuHUbJe/EDlxqfZg=; b=m83opc3
        T/n0LM8cUqfND7dsNHp/h/JdHn67Z6IYtrrotfRg9KCioQbLbjzzaTxgYPF5naNx
        SSQSesvIByC0y7iVH3z98fyCXfOHi8X77ZxU3OuVna87x0I6nBEupo+Daq2rVCkt
        y5//abKYVGokYCqlFeQqudmMu7jUBIpvQIBSYwju87afjkZGzn3Ei6hCKY0iA5Wb
        xAzwuIWXe0GHwX6E7k/rWj8biZix0z+hXRIJr76sQNWX8bDTxwVDpaQ8lF/JG9nX
        kK3nwkSCSaT/Jj8dxmWjvWZ0gn3XEdR9HpFuEVN3sRTu8hHuep6HcO6ZAQyEaIr9
        GDBdfQxiFdaEnSQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c7e08c3e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 13:14:09 +0000 (UTC)
Date:   Fri, 4 Oct 2019 16:00:57 +0200
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
Subject: Re: [PATCH v2 18/20] crypto: arm/Curve25519 - wire up NEON
 implementation
Message-ID: <20191004140057.GB114360@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-19-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-19-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:17:11PM +0200, Ard Biesheuvel wrote:
> +bool curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
> +		     const u8 scalar[CURVE25519_KEY_SIZE],
> +		     const u8 point[CURVE25519_KEY_SIZE])
> +{
> +	if (!have_neon || !crypto_simd_usable())
> +		return false;
> +	kernel_neon_begin();
> +	curve25519_neon(out, scalar, point);
> +	kernel_neon_end();
> +	return true;
> +}
> +EXPORT_SYMBOL(curve25519_arch);

This now looks more like the Zinc way of doing things, with the _arch
function returning true or false based on whether or not the
implementation was available, allowing the generic implementation to
run.

I thought, from looking at the chacha commits earlier, you had done away
with that style of things in favor of weak symbols, whereby the arch
implementation would fall back to the generic one, instead of the other
way around?
