Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2DAC0018C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 20:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65255233E2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 20:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgLPUsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgLPUsi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 15:48:38 -0500
Date:   Wed, 16 Dec 2020 12:47:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608151678;
        bh=+qa4SiUsr0KsaR/ZIuIzJuRL1EymJEY0zWOtCIZHFCI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJuWmwkEy/KCqdJGkkDrUcR3d1Ylz9tOiF1TSGTNq2pXyU5DVX5ScwwN5Bwt0DiZx
         NkfTWaMwy2siXRBUsrx6RFRtDNm0CtWsQjwWNXkzRJICwmOXBO756cNe4i8ewicNfh
         9qllvQd9MYIiZFGkbRCQjuw7aauvmRgKsAPuq/FPsqQTcj8K3qUw96/7OlNlhYrqxm
         olmwx0eGJtekws0ekhDkM68+6EnEKaBPGp5hdqEsPq0wshqIm5jhZqZyP5HH22HU5j
         U8uC4mcKZ80hfX+wGvB2gh7PbM7NPpzwRpx1Y6Hz3x17dPqcvhLDFd4xZ+/WBzHvOR
         EHe0TJcbUliTg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 0/5] crypto: add NEON-optimized BLAKE2b
Message-ID: <X9pyfAaw5hQ6ngTI@gmail.com>
References: <20201215234708.105527-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215234708.105527-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 03:47:03PM -0800, Eric Biggers wrote:
> This patchset adds a NEON implementation of BLAKE2b for 32-bit ARM.
> Patches 1-4 prepare for it by making some updates to the generic
> implementation, while patch 5 adds the actual NEON implementation.
> 
> On Cortex-A7 (which these days is the most common ARM processor that
> doesn't have the ARMv8 Crypto Extensions), this is over twice as fast as
> SHA-256, and slightly faster than SHA-1.  It is also almost three times
> as fast as the generic implementation of BLAKE2b:
> 
> 	Algorithm            Cycles per byte (on 4096-byte messages)
> 	===================  =======================================
> 	blake2b-256-neon     14.1
> 	sha1-neon            16.4
> 	sha1-asm             20.8
> 	blake2s-256-generic  26.1
> 	sha256-neon	     28.9
> 	sha256-asm	     32.1
> 	blake2b-256-generic  39.9
> 
> This implementation isn't directly based on any other implementation,
> but it borrows some ideas from previous NEON code I've written as well
> as from chacha-neon-core.S.  At least on Cortex-A7, it is faster than
> the other NEON implementations of BLAKE2b I'm aware of (the
> implementation in the BLAKE2 official repository using intrinsics, and
> Andrew Moon's implementation which can be found in SUPERCOP).
> 
> NEON-optimized BLAKE2b is useful because there is interest in using
> BLAKE2b-256 for dm-verity on low-end Android devices (specifically,
> devices that lack the ARMv8 Crypto Extensions) to replace SHA-1.  On
> these devices, the performance cost of upgrading to SHA-256 may be
> unacceptable, whereas BLAKE2b-256 would actually improve performance.
> 
> Although BLAKE2b is intended for 64-bit platforms (unlike BLAKE2s which
> is intended for 32-bit platforms), on 32-bit ARM processors with NEON,
> BLAKE2b is actually faster than BLAKE2s.  This is because NEON supports
> 64-bit operations, and because BLAKE2s's block size is too small for
> NEON to be helpful for it.  The best I've been able to do with BLAKE2s
> on Cortex-A7 is 19.0 cpb with an optimized scalar implementation.

By the way, if people are interested in having my ARM scalar implementation of
BLAKE2s in the kernel too, I can send a patchset for that too.  It just ended up
being slower than BLAKE2b and SHA-1, so it wasn't as good for the use case
mentioned above.  If it were to be added as "blake2s-256-arm", we'd have:

	Algorithm            Cycles per byte (on 4096-byte messages)
	===================  =======================================
	blake2b-256-neon     14.1
	sha1-neon            16.4
	blake2s-256-arm      19.0
	sha1-asm             20.8
	blake2s-256-generic  26.1
	sha256-neon	     28.9
	sha256-asm	     32.1
	blake2b-256-generic  39.9
