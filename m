From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for
 AHASH_REQUEST_ON_STACK
Date: Mon, 16 Jul 2018 08:01:18 +0800
Message-ID: <20180716000118.nna5jkgcjxofbsup@gondor.apana.org.au>
References: <20180711203619.1020-1-keescook@chromium.org>
 <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
 <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
 <CAGXu5jJOZ3u1BTf8U20wErphfjKzaGK+m1sdhA89LqVP3MDYZA@mail.gmail.com>
 <20180713062204.2o7gz5xri374nii6@gondor.apana.org.au>
 <CAGXu5jJp3Y4RZD+ZUYsWqf+sTbGJwdN3M=KOiPBn9VecYE4OgQ@mail.gmail.com>
 <20180715024430.n6bcnb4k7cm3ugtj@gondor.apana.org.au>
 <CAGXu5jLkhC8Jb0zVXuVZnbJM6tmMpyGkaoCvw=jACLA3fnoChw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLkhC8Jb0zVXuVZnbJM6tmMpyGkaoCvw=jACLA3fnoChw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jul 14, 2018 at 07:59:09PM -0700, Kees Cook wrote:
> On Sat, Jul 14, 2018 at 7:44 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Fri, Jul 13, 2018 at 08:07:10PM -0700, Kees Cook wrote:
> >>
> >> On a plane today I started converting all these to shash. IIUC, it
> >> just looks like this (apologies for whitespace damage):
> >
> > Yes if it doesn't actually make use of SGs then shash would be
> > the way to go.  However, for SG users ahash is the best interface.
> 
> Nearly all of them artificially build an sg explicitly to use the
> ahash interface. :P
> 
> So, I'll take that as a "yes, do these conversions." :) Thanks!

Yeah anything that's doing a single-element SG list should just
be converted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
