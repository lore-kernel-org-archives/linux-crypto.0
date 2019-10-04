Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D1BC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D71F222C4
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kLeufadS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbfJDNQY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:16:24 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:56733 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388234AbfJDNQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:16:24 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2383115b;
        Fri, 4 Oct 2019 12:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=ZzuTVC/SsCvt7l1FZ6cDBDQzGk8=; b=kLeufad
        Sjn/8MzGTXdc7O4UHkSWhHE1wg5gs2wkWT8yoTjR1ClWl408Ry1B3B4cRbBCF2Il
        hmyPBckVDU2KIDPGZAoVRwRe/NJmvwXEaHhUNIHfdMsnRODXmhP9NUGrFnC9PJXo
        KTs6lIIlgf2ARSYvmWCCTaepIcIzwXI4FObKWfhATKHNt+wnaRU/HyAUwkRSoxi+
        gnEAGIk1F5BRNmHtqvE0tVqGLBPOQIy/JRD4Xh5QIg572c8mWUi3E4aHX3uLJKfX
        Wm7PKWxfA8aZcNCNGbgXraXJRFLP+7VlfN1A49HVRIEuMgzxjtXfykiCM5/vXEBV
        8oEH6RpRvpS/+fA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id afcaba72 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 12:29:28 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:16:15 +0200
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
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for
 WireGuard
Message-ID: <20191004131615.GA112631@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Wed, Oct 02, 2019 at 04:16:53PM +0200, Ard Biesheuvel wrote:
> This is a followup to RFC 'crypto: wireguard with crypto API library interface'
> [0]. Since no objections were raised to my approach, I've proceeded to fix up
> some minor issues, and incorporate [most of] the missing MIPS code.
> 
> Changes since RFC/v1:
> - dropped the WireGuard patch itself, and the followup patches - since the
>   purpose was to illustrate the extent of the required changes, there is no
>   reason to keep including them.
> - import the MIPS 32r2 versions of ChaCha and Poly1305, but expose both the
>   crypto API and library interfaces so that not only WireGuard but also IPsec
>   and Adiantum can benefit immediately. (The latter required adding support for
>   the reduced round version of ChaCha to the MIPS asm code)
> - fix up various minor kconfig/build issues found in randconfig testing
>   (thanks Arnd!)

Thanks for working on this. By wiring up the accelerated primitives,
you're essentially implementing Zinc, and I expect that by the end of
this, we'll wind up with something pretty close to where I started, with
the critical difference that the directory names are different. Despite
my initial email about WireGuard moving to the crypto API, it sounds
like in the end it is likely to stay with Zinc, just without that name.

Jason
