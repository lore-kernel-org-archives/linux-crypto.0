Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C62C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7D6206A5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLLPeg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:34:36 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:54412 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfLLPeg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 10:34:36 -0500
Received: from obook.fritz.box (unknown [IPv6:2a01:2a8:8500:5c01:6946:d015:47d4:9c3d])
        by mail.strongswan.org (Postfix) with ESMTPSA id CCF5B401A2;
        Thu, 12 Dec 2019 16:34:34 +0100 (CET)
Message-ID: <ab103a1e20889d6f4d1a68991e29ae542c85c83c.camel@strongswan.org>
Subject: Re: [PATCH crypto-next v2 2/3] crypto: x86_64/poly1305 - add faster
 implementations
From:   Martin Willi <martin@strongswan.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, ebiggers@kernel.org
Cc:     Samuel Neves <sneves@dei.uc.pt>, Andy Polyakov <appro@openssl.org>
Date:   Thu, 12 Dec 2019 16:34:34 +0100
In-Reply-To: <20191212093008.217086-2-Jason@zx2c4.com>
References: <20191211170936.385572-1-Jason@zx2c4.com>
         <20191212093008.217086-1-Jason@zx2c4.com>
         <20191212093008.217086-2-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> These x86_64 vectorized implementations are based on Andy Polyakov's
> implementation, and support AVX, AVX-2, and AVX512F. The AVX-512F
> implementation is disabled on Skylake, due to throttling, but it is
> quite fast on >= Cannonlake.

>  arch/x86/crypto/poly1305-avx2-x86_64.S |  390 ---
>  arch/x86/crypto/poly1305-sse2-x86_64.S |  590 ----
>  arch/x86/crypto/poly1305-x86_64.pl     | 4266 ++++++++++++++++++++++++

As the author of the removed code, I'm certainly biased, so I won't
hinder the adaption of the new code. Nonetheless some final remarks
from my side:

 * It removes the existing SSE2 code path. Most likely not that much of
   an issue due to the new AVX variant.
 * I certainly would favor gradual improvement, and I think the code
   would allow it. But as said, not my pick.
 * Those 4000+ lines perl/asm are a lot and a hard review; I won't find
   time and motivation to do it. ;-)

Thanks!
Martin

