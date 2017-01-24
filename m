From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/4] lib: Update LZ4 compressor module
Date: Mon, 23 Jan 2017 16:23:57 -0800
Message-ID: <20170123162357.69f8b6a8717af086a03b512e@linux-foundation.org>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
        <1485113717-29261-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
        <1485113717-29261-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdAXAX7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 19:23:59 -0500
In-Reply-To: <1485113717-29261-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 22 Jan 2017 20:35:14 +0100 Sven Schmidt <4sschmid@informatik.uni-hamburg.de> wrote:

> This patch updates LZ4 kernel module to LZ4 v1.7.3 by Yann Collet.
> The kernel module is inspired by the previous work by Chanho Min.
> The updated LZ4 module will not break existing code since there were alias
> methods added to ensure backwards compatibility.
> 
> API changes:
> 
> New method LZ4_compress_fast which differs from the variant available
> in kernel by the new acceleration parameter,
> allowing to trade compression ratio for more compression speed
> and vice versa.
> 
> LZ4_decompress_fast is the respective decompression method, featuring a very
> fast decoder (multiple GB/s per core), able to reach RAM speed in multi-core
> systems. The decompressor allows to decompress data compressed with
> LZ4 fast as well as the LZ4 HC (high compression) algorithm.
> 
> Also the useful functions LZ4_decompress_safe_partial
> LZ4_compress_destsize were added. The latter reverses the logic by trying to
> compress as much data as possible from source to dest while the former aims
> to decompress partial blocks of data.
> 
> A bunch of streaming functions were also added
> which allow compressig/decompressing data in multiple steps
> (so called "streaming mode").
> 
> The methods lz4_compress and lz4_decompress_unknownoutputsize
> are now known as LZ4_compress_default respectivley LZ4_decompress_safe.
> The old methods are still available for providing backwards compatibility.
> 
> ...
>
> +/*
> + * For backward compatibility
> + */
> +static inline int lz4_compressbound(size_t isize)
>  {

Do we actually need the back-compat wrappers?  After your other three
patches we have no callers, correct?  If so, we should go ahead and
eliminate such back-compatibility interfaces.


> -	return isize + (isize / 255) + 16;
> +	return LZ4_COMPRESSBOUND(isize);
>  }
