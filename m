From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] [v2] crypto: aes-generic - fix aes-generic regression
 on powerpc
Date: Mon, 17 Sep 2018 11:29:35 +0200
Message-ID: <20180917092935.GA26181@kroah.com>
References: <20180115160735.593519-1-arnd@arndb.de>
 <20180120004425.GA6484@gondor.apana.org.au>
 <VI1PR0402MB34855F454AA1D324ABEC0090981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Horia Geanta <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34855F454AA1D324ABEC0090981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 17, 2018 at 09:18:37AM +0000, Horia Geanta wrote:
> On 1/20/2018 2:44 AM, Herbert Xu wrote:
> > On Mon, Jan 15, 2018 at 05:07:22PM +0100, Arnd Bergmann wrote:
> >> My last bugfix added -Os on the command line, which unfortunately caused
> >> a build regression on powerpc in some configurations.
> >>
> >> I've done some more analysis of the original problem and found slightly
> >> different workaround that avoids this regression and also results in
> >> better performance on gcc-7.0: -fcode-hoisting is an optimization step
> >> that got added in gcc-7 and that for all gcc-7 versions causes worse
> >> performance.
> >>
> >> This disables -fcode-hoisting on all compilers that understand the option.
> >> For gcc-7.1 and 7.2 I found the same performance as my previous patch
> >> (using -Os), in gcc-7.0 it was even better. On gcc-8 I could see no
> >> change in performance from this patch. In theory, code hoisting should
> >> not be able make things better for the AES cipher, so leaving it
> >> disabled for gcc-8 only serves to simplify the Makefile change.
> >>
> >> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> >> Link: https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30418.html
> >> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> >> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83651
> >> Fixes: 148b974deea9 ("crypto: aes-generic - build with -Os on gcc-7+")
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Patch applied.  Thanks.
> > 
> This fix ("commit 6e36719fbe90213fbba9f50093fa2d4d69b0e93c upstream") is needed
> also in 4.14.y stable tree, since it contains commit
> 7cae67e31292 ("crypto: aes-generic - build with -Os on gcc-7+")
> 
> Compilation fails without it:
> crypto/aes_generic.o: In function `crypto_aes_set_key':
> crypto/aes_generic.c:1300: undefined reference to `_restgpr_31_x'

Thanks for letting me know, now queued up.

greg k-h
