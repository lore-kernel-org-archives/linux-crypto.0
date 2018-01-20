From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] [v2] crypto: aes-generic - fix aes-generic regression
 on powerpc
Date: Sat, 20 Jan 2018 11:44:25 +1100
Message-ID: <20180120004425.GA6484@gondor.apana.org.au>
References: <20180115160735.593519-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        linux-crypto@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55696 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753054AbeATApw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 19:45:52 -0500
Content-Disposition: inline
In-Reply-To: <20180115160735.593519-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 15, 2018 at 05:07:22PM +0100, Arnd Bergmann wrote:
> My last bugfix added -Os on the command line, which unfortunately caused
> a build regression on powerpc in some configurations.
> 
> I've done some more analysis of the original problem and found slightly
> different workaround that avoids this regression and also results in
> better performance on gcc-7.0: -fcode-hoisting is an optimization step
> that got added in gcc-7 and that for all gcc-7 versions causes worse
> performance.
> 
> This disables -fcode-hoisting on all compilers that understand the option.
> For gcc-7.1 and 7.2 I found the same performance as my previous patch
> (using -Os), in gcc-7.0 it was even better. On gcc-8 I could see no
> change in performance from this patch. In theory, code hoisting should
> not be able make things better for the AES cipher, so leaving it
> disabled for gcc-8 only serves to simplify the Makefile change.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Link: https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30418.html
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83651
> Fixes: 148b974deea9 ("crypto: aes-generic - build with -Os on gcc-7+")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
