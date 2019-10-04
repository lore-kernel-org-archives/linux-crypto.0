Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CA1C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B376620700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eaAF93SE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbfJDNsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:48:39 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:36403 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388491AbfJDNsj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:48:39 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d12798db;
        Fri, 4 Oct 2019 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=h0seV4y9pFUaTQY+rFbA38FUwJ0=; b=eaAF93S
        E9npxPaf1oyF44fuDKur7oOWAiuIvVE9stfqFCGB+wshmWwgxr/gMAg2o1hokm1P
        U1da3t6hF55uIx7LrJNEyPp0tcsxR+RnYnSWZMTsV7jwWsZDNm1hO0b9YiRc1nZq
        Mhb0QPSr2Cctq80rVrCdkGPccbQAtEqBE2/66pY+oHJAidseaX1rXFtgvjo3ITkZ
        YEve3zapuVNOn2OIKZ9UMiiTDoHLd5nej5r2meTQpTpQ4Pko7GUtAHi4Q2SZPzjQ
        4Z1ldU45a3Eu2M/+liyJtdlhcAvl0WJVsDfyqg+ts4/k2iySTZM2iTFxcFhyAjaO
        SJd8zRah0Exe89A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 117db93b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 13:01:43 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:48:30 +0200
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
Subject: Re: [PATCH v2 10/20] crypto: mips/poly1305 - import accelerated 32r2
 code from Zinc
Message-ID: <20191004134830.GF112631@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-11-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-11-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:17:03PM +0200, Ard Biesheuvel wrote:
> This integrates the accelerated MIPS 32r2 implementation of ChaCha
> into both the API and library interfaces of the kernel crypto stack.
> 
> The significance of this is that, in addition to becoming available
> as an accelerated library implementation, it can also be used by
> existing crypto API code such as IPsec, using chacha20poly1305.

Same thing here: can you please split the assembly into two commits so I
can see what you changed from the original?
