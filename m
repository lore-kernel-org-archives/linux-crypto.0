From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 4/9] dm integrity: Remove VLA usage
Date: Sun, 1 Jul 2018 14:29:14 +0800
Message-ID: <20180701062914.nihtpl5ekf7nytat@gondor.apana.org.au>
References: <20180629002843.31095-1-keescook@chromium.org>
 <20180629002843.31095-5-keescook@chromium.org>
 <CAK8P3a3F2y8B3a5zhYyG2KSMmSx5L3J3C_0sV-Csa0zPOzYJhA@mail.gmail.com>
 <CAGXu5j+MLs-Jj7VCcpKS8Yo6MFAf=Nyf3jYsCbBoXnhtEvn4+g@mail.gmail.com>
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
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+MLs-Jj7VCcpKS8Yo6MFAf=Nyf3jYsCbBoXnhtEvn4+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 29, 2018 at 02:56:37PM -0700, Kees Cook wrote:
>
> This conversion was following the existing check (PAGE_SIZE / 8), and
> not via an analysis of alg.digestsize users. Let me double-check. For
> predefined stuff, it looks like the largest is:
> 
> SKEIN1024_DIGEST_BIT_SIZE/8 == 128

This should be removed.  We shouldn't allow generic or new crypto
algorithms in staging.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
