From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 10:40:20 -0400
Message-ID: <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-2-git-send-email-tytso@mit.edu>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35467 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbcEDOkV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 10:40:21 -0400
In-Reply-To: <1462170413-7164-2-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> +static inline u32 rotl32(u32 v, u8 n)
> +{
> +       return (v << n) | (v >> (sizeof(v) * 8 - n));
> +}

That's undefined behavior when n=0.

I think the portable way to do a rotate that avoids UB is the
following. GCC, Clang and ICC recognize the pattern, and emit a rotate
instruction.

    static const unsigned int MASK=31;
    return (v<<n)|(v>>(-n&MASK));

You should also avoid the following because its not constant time due
to the branch:

    return n == 0 ? v : (v << n) | (v >> (sizeof(v) * 8 - n));

Jeff
