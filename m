Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61FEC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7964020700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MX3DilIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbfJDNqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:46:53 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:47031 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388682AbfJDNqx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:46:53 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 560d45af;
        Fri, 4 Oct 2019 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :content-transfer-encoding:in-reply-to; s=mail; bh=IRdG80MEikobf
        x0cek6l4NDhfE8=; b=MX3DilIbuWSwW5XlTRZpZjrY9aKCexia4kkfoGTAojctY
        sQl07PAFmqUapnxxDDbZcnke+HBiOqcgq48mKCxldIcvznayBtTsZk/SXYVcbZLR
        hp8S0q+nTtEp/yto/Uwp7syWdIauQiGrS6ABvsEsWw7IvB9bQaPTW/G3Jud+nw1T
        xVrDiNZNprqMLTZ1TQzBilcqvJbq6GtsDFjGTLe3jsZyQainYhwWTtUkHm9og2Ze
        Img9OT0CKZSopblqDTd3ecO7x291OsfWbb31Bj+2mnvaoyUkCJ07Id/RkU6UrQTT
        ZbXjafw9Pba0a0l9jUPnhpj/V7aE0OkWXd2EMxa3g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00e5d61a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 12:59:57 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:46:44 +0200
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
Message-ID: <20191004134644.GE112631@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191002141713.31189-6-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:16:58PM +0200, Ard Biesheuvel wrote:
> This integrates the accelerated MIPS 32r2 implementation of ChaCha
> into both the API and library interfaces of the kernel crypto stack.
> 
> The significance of this is that, in addition to becoming available
> as an accelerated library implementation, it can also be used by
> existing crypto API code such as Adiantum (for block encryption on
> ultra low performance cores) or IPsec using chacha20poly1305. These
> are use cases that have already opted into using the abstract crypto
> API. In order to support Adiantum, the core assembler routine has
> been adapted to take the round count as a function argument rather
> than hardcoding it to 20.

Could you resubmit this with first my original commit and then with your
changes on top? I'd like to see and be able to review exactly what's
changed. If I recall correctly, René and I were really starved for
registers and tried pretty hard to avoid spilling to the stack, so I'm
interested to learn how you crammed a bit more sauce in there.

I also wonder if maybe it'd be better to just leave this as is with 20
rounds, which it was previously optimized for, and just not do
accelerated Adiantum for MIPS. Android has long since given up on the
ISA entirely.
