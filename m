From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] lib: fix 842 build on 32-bit architectures
Date: Wed, 13 May 2015 19:52:24 -0400
Message-ID: <1431561144-29931-1-git-send-email-ddstreet@ieee.org>
References: <2802721.Q9KnE9eNH4@wuerfel>
Cc: Dan Streetman <ddstreet@ieee.org>, Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35905 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965675AbbEMXwy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 19:52:54 -0400
In-Reply-To: <2802721.Q9KnE9eNH4@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Building the 842 code on 32-bit ARM currently results in this link
> error:
> 
> ERROR: "__aeabi_uldivmod" [lib/842/842_decompress.ko] undefined!

Oops!  Guess I should build/test on 32 bit more.

> 
> The reason is that the __do_index function performs a 64-bit
> division by a power-of-two number, but it has no insight into
> the function arguments.
> 
> By marking that function inline, the fsize argument is always
> known at the time that do_index is called, and the compiler is
> able to replace the extremely expensive 64-bit division with
> a cheap constant shift operation.

alternately, we know that fsize will always be less than 64 bits,
at most it's 4<<9 or 8<<8 (both == 1<<11).  So we could just change
its type to u16.

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 6b2b45aecde3..285bf6b6959c 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -169,7 +169,7 @@ static int do_data(struct sw842_param *p, u8 n)
 	return 0;
 }
 
-static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
+static int __do_index(struct sw842_param *p, u8 size, u8 bits, u16 fsize)
 {
 	u64 index, offset, total = round_down(p->out - p->ostart, 8);
 	int ret;

Or, we could inline it and change the type to u16.  In any case,

Acked-by: Dan Streetman <ddstreet@ieee.org>

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
>  {
>  	u64 index, offset, total = round_down(p->out - p->ostart, 8);
>  	int ret;
> 
