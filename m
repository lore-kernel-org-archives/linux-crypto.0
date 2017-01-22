From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] lib: Update LZ4 compressor module
Date: Sun, 22 Jan 2017 12:05:29 +0100
Message-ID: <20170122110529.GB17972@kroah.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485011351-7463-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485011351-7463-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbdAVLFU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2017 06:05:20 -0500
Content-Disposition: inline
In-Reply-To: <1485011351-7463-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 21, 2017 at 04:09:08PM +0100, Sven Schmidt wrote:
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
> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>

Please fix up so that it doesn't break the build as reported by the
kbuild tool...

thanks,

greg k-h
