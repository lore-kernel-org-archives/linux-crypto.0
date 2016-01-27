From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] crypto: chacha20_4block_xor_ssse3: Align stack pointer to
 64 bytes
Date: Wed, 27 Jan 2016 01:40:00 +0100
Message-ID: <CAHmME9oU4gUVCHUu0tec0_4ugs7+xmJoih7TS-cgFH5QgCgzyg@mail.gmail.com>
References: <1453393448-13636-1-git-send-email-elicooper@gmx.com>
	<1453449324.36963.7.camel@strongswan.org>
	<20160125135946.GD8256@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Martin Willi <martin@strongswan.org>,
	Eli Cooper <elicooper@gmx.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:44656 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbcA0AkG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 19:40:06 -0500
In-Reply-To: <20160125135946.GD8256@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Can we queue this up for stable too, please?

On Mon, Jan 25, 2016 at 2:59 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Patch applied.  Thanks!
