From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v4 1/4] lib: Update LZ4 compressor module
Date: Tue, 24 Jan 2017 17:48:02 +0100
Message-ID: <20170124164802.GA1108@bierbaron.springfield.local>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485113717-29261-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485113717-29261-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170123162357.69f8b6a8717af086a03b512e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mxchg01.rrz.uni-hamburg.de ([134.100.38.111]:43817 "EHLO
        mxchg01.rrz.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbdAXQ6L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2017 11:58:11 -0500
Content-Disposition: inline
In-Reply-To: <20170123162357.69f8b6a8717af086a03b512e@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 23, 2017 at 04:23:57PM -0800, Andrew Morton wrote:
> On Sun, 22 Jan 2017 20:35:14 +0100 Sven Schmidt <4sschmid@informatik.uni-hamburg.de> wrote:
> 
> > This patch updates LZ4 kernel module to LZ4 v1.7.3 by Yann Collet.
> > The kernel module is inspired by the previous work by Chanho Min.
> > The updated LZ4 module will not break existing code since there were alias
> > methods added to ensure backwards compatibility.
> > 
> > API changes:
> > 
> > New method LZ4_compress_fast which differs from the variant available
> > in kernel by the new acceleration parameter,
> > allowing to trade compression ratio for more compression speed
> > and vice versa.
> > 
> > LZ4_decompress_fast is the respective decompression method, featuring a very
> > fast decoder (multiple GB/s per core), able to reach RAM speed in multi-core
> > systems. The decompressor allows to decompress data compressed with
> > LZ4 fast as well as the LZ4 HC (high compression) algorithm.
> > 
> > Also the useful functions LZ4_decompress_safe_partial
> > LZ4_compress_destsize were added. The latter reverses the logic by trying to
> > compress as much data as possible from source to dest while the former aims
> > to decompress partial blocks of data.
> > 
> > A bunch of streaming functions were also added
> > which allow compressig/decompressing data in multiple steps
> > (so called "streaming mode").
> > 
> > The methods lz4_compress and lz4_decompress_unknownoutputsize
> > are now known as LZ4_compress_default respectivley LZ4_decompress_safe.
> > The old methods are still available for providing backwards compatibility.
> > 
> > ...
> >
> > +/*
> > + * For backward compatibility
> > + */
> > +static inline int lz4_compressbound(size_t isize)
> >  {
> 
> Do we actually need the back-compat wrappers?  After your other three
> patches we have no callers, correct?  If so, we should go ahead and
> eliminate such back-compatibility interfaces.
> 
> 
> > -	return isize + (isize / 255) + 16;
> > +	return LZ4_COMPRESSBOUND(isize);
> >  }
> 

Hey Andrew,

you're absolutely right. Since I changed the callers to use the new functions, we do not need these wrappers anymore.

I will add a patch removing them and send an update.

Thanks,

Sven
