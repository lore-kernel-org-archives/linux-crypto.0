From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v6 1/5] lib: Update LZ4 compressor module
Date: Wed, 1 Feb 2017 21:18:59 +0100
Message-ID: <20170201201859.GA15641@bierbaron.springfield.local>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485554524-4844-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485554524-4844-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170131152744.5bd2f3ba@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com,
        4sschmid@informatik.uni-hamburg.de
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38208 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750945AbdBAUTN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 15:19:13 -0500
Content-Disposition: inline
In-Reply-To: <20170131152744.5bd2f3ba@lwn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 31, 2017 at 03:27:44PM -0700, Jonathan Corbet wrote:
> On Fri, 27 Jan 2017 23:02:00 +0100
> Sven Schmidt <4sschmid@informatik.uni-hamburg.de> wrote:
> 
> I have one quick question...
> 
> >  /*
> > + * LZ4_compress_default()
> > + *	Compresses 'sourceSize' bytes from buffer 'source'
> > + *	into already allocated 'dest' buffer of size 'maxOutputSize'.
> > + *	Compression is guaranteed to succeed if
> > + *	'maxOutputSize' >= LZ4_compressBound(inputSize).
> > + *	It also runs faster, so it's a recommended setting.
> > + *	If the function cannot compress 'source'
> > + *	into a more limited 'dest' budget,
> > + *	compression stops *immediately*,
> > + *	and the function result is zero.
> > + *	As a consequence, 'dest' content is not valid.
> > + *
> > + *	source       : source address of the original data
> > + *	dest         : output buffer address
> > + *                 of the compressed data
> > + *	inputSize    : Max supported value is
> > + *                 LZ4_MAX_INPUT_SIZE
> > + *	maxOutputSize: full or partial size of buffer 'dest'
> > + *                 (which must be already allocated)
> > + *	workmem      : address of the working memory.
> > + *                 This requires 'workmem' of size LZ4_MEM_COMPRESS.
> > + *	return       : the number of bytes written into buffer 'dest'
> > + *   (necessarily <= maxOutputSize) or 0 if compression fails
> > + */
> > +int LZ4_compress_default(const char *source, char *dest, int inputSize,
> > +	int maxOutputSize, void *wrkmem);
> 
> Is there any chance you could format these as kerneldoc comments?  You're
> not too far from it now, and that would allow the LZ4 interface to be
> pulled into the documentation.
> 
> Thanks,
> 
> jon

Hi Jon,

of course, that makes sense. I already checked the documentation and you're right, I'm not that far from it.
Will do the necessary changes.

Thanks,

Sven
