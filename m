From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] hw_random: core, sleep interruptible in read
Date: Fri, 4 Dec 2015 22:40:48 +0800
Message-ID: <20151204144048.GA17703@gondor.apana.org.au>
References: <20151127130603.GA29503@gondor.apana.org.au>
 <1448639443-21760-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	linux-crypto@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55340 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbLDOk4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:40:56 -0500
Content-Disposition: inline
In-Reply-To: <1448639443-21760-1-git-send-email-jslaby@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 27, 2015 at 04:50:43PM +0100, Jiri Slaby wrote:
> hwrng kthread can be waiting via hwrng_fillfn for some data from a rng
> like virtio-rng:
> hwrng           D ffff880093e17798     0   382      2 0x00000000
> ...
> Call Trace:
>  [<ffffffff817339c6>] wait_for_completion_killable+0x96/0x210
>  [<ffffffffa00aa1b7>] virtio_read+0x57/0xf0 [virtio_rng]
>  [<ffffffff814f4a35>] hwrng_fillfn+0x75/0x130
>  [<ffffffff810aa243>] kthread+0xf3/0x110
> 
> And when some user program tries to read the /dev node in this state,
> we get:
> rngd            D ffff880093e17798     0   762      1 0x00000004
> ...
> Call Trace:
>  [<ffffffff817351ac>] mutex_lock_nested+0x15c/0x3e0
>  [<ffffffff814f478e>] rng_dev_read+0x6e/0x240
>  [<ffffffff81231958>] __vfs_read+0x28/0xe0
>  [<ffffffff81232393>] vfs_read+0x83/0x130
> 
> And this is indeed unkillable. So use mutex_lock_interruptible
> instead of mutex_lock in rng_dev_read and exit immediatelly when
> interrupted. And possibly return already read data, if any (as POSIX
> allows).
> 
> v2: use ERESTARTSYS instead of EINTR
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: <linux-crypto@vger.kernel.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
