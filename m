From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: powerpc: Add POWER8 optimised crc32c
Date: Tue, 5 Jul 2016 23:14:15 +0800
Message-ID: <20160705151415.GA8117@gondor.apana.org.au>
References: <1467325185-21091-1-git-send-email-anton@ozlabs.org>
 <1467325185-21091-2-git-send-email-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
	davem@davemloft.net, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Anton Blanchard <anton@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36701 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbcGEPOk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 11:14:40 -0400
Content-Disposition: inline
In-Reply-To: <1467325185-21091-2-git-send-email-anton@ozlabs.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 01, 2016 at 08:19:45AM +1000, Anton Blanchard wrote:
> From: Anton Blanchard <anton@samba.org>
> 
> Use the vector polynomial multiply-sum instructions in POWER8 to
> speed up crc32c.
> 
> This is just over 41x faster than the slice-by-8 method that it
> replaces. Measurements on a 4.1 GHz POWER8 show it sustaining
> 52 GiB/sec.
> 
> A simple btrfs write performance test:
> 
>     dd if=/dev/zero of=/mnt/tmpfile bs=1M count=4096
>     sync
> 
> is over 3.7x faster.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
