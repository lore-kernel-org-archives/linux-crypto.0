From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 0/9] crypto: Remove VLA usage
Date: Tue, 4 Sep 2018 13:19:05 +0800
Message-ID: <20180904051905.a2vyzijz6xyxvyhb@gondor.apana.org.au>
References: <20180807211843.47586-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        qat-linux@intel.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807211843.47586-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2018 at 02:18:34PM -0700, Kees Cook wrote:
> v8 cover letter:
> 
> I continue to hope this can land in v4.19, but I realize that's unlikely.
> It would be nice, though, if some of the "trivial" patches could get taken
> (e.g. cbc, xcbc, ccm VLA removals) so I don't have to keep repeating them.
> *fingers crossed*
> 
> Series cover letter:
> 
> This is nearly the last of the VLA removals[1], but it's one of the
> largest because crypto gets used in lots of places. After looking
> through code, usage, reading the threads Gustavo started, and comparing
> the use-cases to the other VLA removals that have landed in the kernel,
> I think this series is likely the best way forward to shut the door on
> VLAs forever.
> 
> For background, the crypto stack usage is for callers to do an immediate
> bit of work that doesn't allocate new memory. This means that other VLA
> removal techniques (like just using kmalloc) aren't workable, and the
> next common technique is needed: examination of maximum stack usage and
> the addition of sanity checks. This series does that, and in several
> cases, these maximums were already implicit in the code.
> 
> This series is intended to land via the crypto tree for 4.19, though it
> touches dm, networking, and a few other things as well, since there are
> dependent patches (new crypto #defines being used, etc).

I have applied patches 1-4 and 6-8.  I'd like to get an ack from
the dm folks regarding patch 5.  As to patch 9, please fix it so
it doesn't rely on the BUG_ON to catch things.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
