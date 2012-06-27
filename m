From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Wed, 27 Jun 2012 08:54:57 +0800
Message-ID: <CACXcFmkrKWyyWEkud_p=vWDX1aUi2YSpA0b4KYRQ6sJArOb_sQ@mail.gmail.com>
References: <20120626161346.GB6509@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48567 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab2F0Ay7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2012 20:54:59 -0400
Received: by eeit10 with SMTP id t10so159497eei.19
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2012 17:54:58 -0700 (PDT)
In-Reply-To: <20120626161346.GB6509@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 27, 2012 at 12:13 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> Since commit ce6dd368 ("crypto: arc4 - improve performance by adding
> ecb(arc4)) we need to pull in a blkcipher.
>
> |ERROR: "crypto_blkcipher_type" [crypto/arc4.ko] undefined!
> |ERROR: "blkcipher_walk_done" [crypto/arc4.ko] undefined!
> |ERROR: "blkcipher_walk_virt" [crypto/arc4.ko] undefined!
>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>
> On a side note: do we pull in the blkcipher block mode for each cipher now to
> gain some extra performance like the openssl project? I was under the
> impression that is in general not worth it.

Arc4 is a stream cipher, NOT a block cipher. They are completely different
things, and the requirements for using them securely are different. In
particular, modes like ECB apply to block ciphers not to stream ciphers.

Unless these changes have been thoroughly analyzed by several
people who actually know crypto, they should be immediately reverted.
