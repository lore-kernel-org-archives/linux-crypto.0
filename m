From: msb@google.com
Subject: Re: [PATCH] lib/sha1.c: quite sparse noise about symbol not
 declared
Date: Tue, 13 Sep 2011 14:58:51 -0700
Message-ID: <20110913215851.GD9560@google.com>
References: <201109091130.28110.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:19952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab1IMV7M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Sep 2011 17:59:12 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p8DLx91F022117
	for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2011 14:59:10 -0700
Received: from pzk1 (pzk1.prod.google.com [10.243.19.129])
	by wpaz21.hot.corp.google.com with ESMTP id p8DLwxc6024599
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2011 14:59:08 -0700
Received: by pzk1 with SMTP id 1so2026536pzk.30
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2011 14:59:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201109091130.28110.hartleys@visionengravers.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

+cc linux-crypto, herbert, davem, torvalds

H Hartley Sweeten (hartleys@visionengravers.com) wrote:
> Include <linux/cryptohash.h> to pickup the declarations for sha_transform
> and sha_init to quite the sparse noise:
> 
> warning: symbol 'sha_transform' was not declared. Should it be static?
> warning: symbol 'sha_init' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> 

Acked-by: Mandeep Singh Baines <msb@chromium.org>

Thanks.

> ---
> 
> diff --git a/lib/sha1.c b/lib/sha1.c
> index f33271d..1de509a 100644
> --- a/lib/sha1.c
> +++ b/lib/sha1.c
> @@ -8,6 +8,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/bitops.h>
> +#include <linux/cryptohash.h>
>  #include <asm/unaligned.h>
>  
>  /*
