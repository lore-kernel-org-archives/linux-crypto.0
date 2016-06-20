From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 09:25:28 +0800
Message-ID: <20160620012528.GA7471@gondor.apana.org.au>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
 <20160619231827.GB9848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160619231827.GB9848@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 19, 2016 at 07:18:28PM -0400, Theodore Ts'o wrote:
>
> C) Simply compiling in the Crypto layer and the ChaCha20 generic
> handling (all of which is doing extra work which we would then be
> undoing in the random layer --- and I haven't included the extra code
> in the random driver needed interface with the crypto layer) costs an
> extra 20k.  That's roughly the amount of extra kernel bloat that the
> Linux kernel grew in its allnoconfig from version to version from 3.0
> to 3.16.  I don't have the numbers from the more recent kernels, but
> roughly speaking, we would be responsible for **all** of the extra
> kernel bloat (and if there was any extra kernel bloat, we would
> helping to double it) in the kernel release where this code would go
> in.  I suspect the folks involved with the kernel tinificaiton efforts
> wouldn't exactly be pleased with this.
> 
> Yes, I understand the argument that the networking stack is now
> requiring the crypto layer --- but not all IOT devices may necessarily
> require the IP stack (they might be using some alternate wireless
> communications stack) and I'd much rather not make things worse.

Sure, but 99% of the kernels out there will have a crypto API.
So why not use it if it's there and use the standalone chacha
code otherwise?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
