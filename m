From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Date: Wed, 28 May 2014 01:30:50 +0800
Message-ID: <20140527173050.GA18214@gondor.apana.org.au>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Seth Jennings <sjennings@variantweb.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

Looks good to me.  This would seem like something that could be
generalised to other vmalloc users, no?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
