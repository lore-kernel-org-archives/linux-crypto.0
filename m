From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4
 v1.7.2.
Date: Sun, 8 Jan 2017 12:22:23 +0100
Message-ID: <20170108112223.GA12798@kroah.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483808145-18417-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 07, 2017 at 05:55:42PM +0100, Sven Schmidt wrote:
> +/*!LZ4_compressbound() :
> +    Provides the maximum size that LZ4 may output in a "worst case" scenario
> +    (input data not compressible)
> +*/

Odd coding style, please use kerneldoc format if you are going to have
comments like this.

> +static inline int LZ4_compressBound(int isize) {
> +  return LZ4_COMPRESSBOUND(isize);

And follow the proper kernel coding style rules, putting your patches
through scripts/checkpatch.pl should help you out here.

thanks,

greg k-h
