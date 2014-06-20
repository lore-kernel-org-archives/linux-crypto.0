From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Date: Sat, 21 Jun 2014 02:40:54 +0800
Message-ID: <20140620184053.GC3169@gondor.apana.org.au>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Seth Jennings <sjennings@variantweb.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51606 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966182AbaFTSk6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:40:58 -0400
Content-Disposition: inline
In-Reply-To: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 27, 2014 at 10:28:55AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> zswap allocates one LZO context per online cpu.
> 
> Using vmalloc() for small (16KB) memory areas has drawback of slowing
> down /proc/vmallocinfo and /proc/meminfo reads, TLB pressure and poor
> NUMA locality, as default NUMA policy at boot time is to interleave
> pages :
> 
> edumazet:~# grep lzo /proc/vmallocinfo | head -4
> 0xffffc90006062000-0xffffc90006067000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc90006067000-0xffffc9000606c000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc9000606c000-0xffffc90006071000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc90006071000-0xffffc90006076000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 
> This patch tries a regular kmalloc() and fallback to vmalloc in case
> memory is too fragmented.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
