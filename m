Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A933C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA7DE20700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fjN92bb9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388733AbfJDOD6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:03:58 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:37031 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388438AbfJDOD6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:03:58 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f57d76bc;
        Fri, 4 Oct 2019 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=F5JZyQzg7Aj24xz3O9TfxXOfke8=; b=fjN92bb
        9T0RkRTr7hELtqPT93MgMxBslDlQi5/KbOneOeGY+aGDEKn64QgnDmUL4fR2JOyH
        aeGOpNPaNCxnLNGLIwtrhT/NlWFTjbIA9LuTaDpoCUBca8mdUJi3VfyOIcpAoj7X
        tmcERrHw82M5+DucBJEx09JU00Oj83LIMvc8t4w618PJI6w25h0NhsJqsVC/0OE6
        OowbmPjcc7NQAHOMgYDpxPOwt2ecLHf2c1X4wX07rVXZkT4QNUg4EdBDr9fTAuhi
        ipjiToGj9f/+LCgqx2qO/DnMYNmC+x/urQBpOlQNfB7K6Yl6MsSUfYpgJadx8Q6N
        7iv2W9fIVVzIrsg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 727d4da7 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 13:17:02 +0000 (UTC)
Date:   Fri, 4 Oct 2019 16:03:50 +0200
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
Subject: Re: [PATCH v2 20/20] crypto: lib/chacha20poly1305 - reimplement
 crypt_from_sg() routine
Message-ID: <20191004140350.GC114360@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-21-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-21-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:17:13PM +0200, Ard Biesheuvel wrote:
> Reimplement the library routines to perform chacha20poly1305 en/decryption
> on scatterlists, without [ab]using the [deprecated] blkcipher interface,
> which is rather heavyweight and does things we don't really need.
> 
> Instead, we use the sg_miter API in a novel and clever way, to iterate
> over the scatterlist in-place (i.e., source == destination, which is the
> only way this library is expected to be used). That way, we don't have to
> iterate over two scatterlists in parallel.

Nice idea. Probably this will result in a real speedup, as I suspect
those extra prior kmaps weren't free. Looking forward to benching it.
