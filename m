From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/4] lib/decompress_unlz4: Change module to work with
 new LZ4 module version
Date: Sun, 8 Jan 2017 12:23:22 +0100
Message-ID: <20170108112322.GB12798@kroah.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-3-git-send-email-4sschmid@informatik.uni-hamburg.de>
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
In-Reply-To: <1483808145-18417-3-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 07, 2017 at 05:55:43PM +0100, Sven Schmidt wrote:
> This patch updates the unlz4 wrapper to work with the new LZ4 kernel module version.
> 
> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
> ---
>  lib/decompress_unlz4.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
> index 036fc88..1b0baf3 100644
> --- a/lib/decompress_unlz4.c
> +++ b/lib/decompress_unlz4.c
> @@ -72,7 +72,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
>  		error("NULL input pointer and missing fill function");
>  		goto exit_1;
>  	} else {
> -		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
> +		inp = large_malloc(LZ4_compressBound(uncomp_chunksize));

Having functions differ by different cases of the characters is ripe for
abuse and confusion.  Please never do that, especially as these "new"
functions you created don't follow the correct kernel coding style rules
:(

thanks,

greg k-h
