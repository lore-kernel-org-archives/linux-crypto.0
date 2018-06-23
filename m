From: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFC PATCH 1/2] crypto: Fix -Wstringop-truncation warnings
Date: Fri, 22 Jun 2018 19:22:20 -0700
Message-ID: <CAMo8BfLZi5NBr-rjGd8y88t8o=e9q-Mra05GJbH5OtUvXZhZgw@mail.gmail.com>
References: <20180623020753.27266-1-shorne@gmail.com> <20180623020753.27266-2-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Stafford Horne <shorne@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180623020753.27266-2-shorne@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 22, 2018 at 7:07 PM, Stafford Horne <shorne@gmail.com> wrote:
> As of GCC 9.0.0 the build is reporting warnings like:
>
>     crypto/ablkcipher.c: In function =E2=80=98crypto_ablkcipher_report=E2=
=80=99:
>     crypto/ablkcipher.c:374:2: warning: =E2=80=98strncpy=E2=80=99 specifi=
ed bound 64 equals destination size [-Wstringop-truncation]
>       strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        sizeof(rblkcipher.geniv));
>        ~~~~~~~~~~~~~~~~~~~~~~~~~
>
> This means the strnycpy might create a non null terminated string.  Fix t=
his by
> limiting the size of the string copy to include the null terminator.

That could work if the destination buffer was zero-initialized,
but it's allocated on stack and is not initialized.
Replacing strncpy with strlcpy without changing its arguments
should do the right thing.

--=20
Thanks.
-- Max
