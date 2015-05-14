From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] lib: fix 842 build on 32-bit architectures
Date: Thu, 14 May 2015 11:03:30 +0100
Message-ID: <20150514100330.GV2067@n2100.arm.linux.org.uk>
References: <2802721.Q9KnE9eNH4@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Streetman <ddstreet@ieee.org>, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:44963 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbbENKDl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 May 2015 06:03:41 -0400
Content-Disposition: inline
In-Reply-To: <2802721.Q9KnE9eNH4@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2015 at 10:56:39PM +0200, Arnd Bergmann wrote:
> Building the 842 code on 32-bit ARM currently results in this link
> error:
> 
> ERROR: "__aeabi_uldivmod" [lib/842/842_decompress.ko] undefined!
> 
> The reason is that the __do_index function performs a 64-bit
> division by a power-of-two number, but it has no insight into
> the function arguments.
> 
> By marking that function inline, the fsize argument is always
> known at the time that do_index is called, and the compiler is
> able to replace the extremely expensive 64-bit division with
> a cheap constant shift operation.
> 
> Aside from fixing that link error, this approach should also improve
> both code size and performance on 32-bit architectures significantly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Found while building arm32 allmodconfig with gcc-5.0
> 
> diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
> index 6b2b45aecde3..285bf6b6959c 100644
> --- a/lib/842/842_decompress.c
> +++ b/lib/842/842_decompress.c
> @@ -169,7 +169,7 @@ static int do_data(struct sw842_param *p, u8 n)
>  	return 0;
>  }
>  
> -static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
> +static inline int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)

This had better get a comment to say why this is done, to stop the
"don't do static inline in a .c" brigade reverting this change.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
