From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto-next 00/23] crypto: skcipher - Remove VLA usage
Date: Tue, 25 Sep 2018 12:49:26 +0800
Message-ID: <20180925044926.vkkj2fnfvshjqpt5@gondor.apana.org.au>
References: <20180919021100.3380-1-keescook@chromium.org>
 <CAGXu5jKFdMXYGJ9AmR9=OkTqrU9_RqtMXeOmXfivv0VvwPfOmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKFdMXYGJ9AmR9=OkTqrU9_RqtMXeOmXfivv0VvwPfOmg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 05:49:37PM -0700, Kees Cook wrote:
>
> > Kees Cook (23):
> >   crypto: skcipher - Introduce crypto_sync_skcipher
> >   gss_krb5: Remove VLA usage of skcipher
> >   lib80211: Remove VLA usage of skcipher
> >   mac802154: Remove VLA usage of skcipher
> >   s390/crypto: Remove VLA usage of skcipher
> >   x86/fpu: Remove VLA usage of skcipher
> >   block: cryptoloop: Remove VLA usage of skcipher
> >   libceph: Remove VLA usage of skcipher
> >   ppp: mppe: Remove VLA usage of skcipher
> >   rxrpc: Remove VLA usage of skcipher
> >   wusb: Remove VLA usage of skcipher
> >   crypto: ccp - Remove VLA usage of skcipher
> >   crypto: vmx - Remove VLA usage of skcipher
> >   crypto: null - Remove VLA usage of skcipher
> >   crypto: cryptd - Remove VLA usage of skcipher
> >   crypto: sahara - Remove VLA usage of skcipher
> >   crypto: qce - Remove VLA usage of skcipher
> >   crypto: artpec6 - Remove VLA usage of skcipher
> >   crypto: chelsio - Remove VLA usage of skcipher
> >   crypto: mxs-dcp - Remove VLA usage of skcipher
> >   crypto: omap-aes - Remove VLA usage of skcipher
> >   crypto: picoxcell - Remove VLA usage of skcipher
> >   crypto: skcipher - Remove SKCIPHER_REQUEST_ON_STACK()
> 
> How do these look to you, Herbert? I'd really like to make sure these
> make it for the next merge window -- they're the last VLAs left in the
> kernel now. :)

I have no problems with the crypto parts.  Do we have acks for
all of the others?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
