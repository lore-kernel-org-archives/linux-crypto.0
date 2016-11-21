From: Eric Biggers <ebiggers@google.com>
Subject: Re: vmalloced stacks and scatterwalk_map_and_copy()
Date: Mon, 21 Nov 2016 10:08:14 -0800
Message-ID: <20161121180814.GA30672@google.com>
References: <20161103181624.GA63852@google.com>
 <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
 <CALCETrXg5ytkLHBpKMJG7fBea+xy2wz6kSm2XK5c8K7_Hr9UuA@mail.gmail.com>
 <20161121082619.GA6462@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@amacapital.net>, regressions@leemhuis.info,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121082619.GA6462@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 21, 2016 at 04:26:19PM +0800, Herbert Xu wrote:
> crypto: scatterwalk - Remove unnecessary aliasing check in map_and_copy
> 
> The aliasing check in map_and_copy is no longer necessary because
> the IPsec ESP code no longer provides an IV that points into the
> actual request data.  As this check is now triggering BUG checks
> due to the vmalloced stack code, I'm removing it.
> 
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
> index 52ce17a..c16c94f8 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -68,10 +68,6 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
>  
>  	sg = scatterwalk_ffwd(tmp, sg, start);
>  
> -	if (sg_page(sg) == virt_to_page(buf) &&
> -	    sg->offset == offset_in_page(buf))
> -		return;
> -
>  	scatterwalk_start(&walk, sg);
>  	scatterwalk_copychunks(buf, &walk, nbytes, out);
>  	scatterwalk_done(&walk, out, 0);

This looks fine to me if you're confident that the aliasing check is indeed no
longer necessary.

Another idea I had was to replace memcpy() with memmove().  But I don't want to
be in a situation where we're stuck with memmove() forever because of users who
probably don't even exist.

Eric
