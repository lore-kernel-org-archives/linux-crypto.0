From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 23:16:28 -0700
Message-ID: <CAGXu5jJOZ3u1BTf8U20wErphfjKzaGK+m1sdhA89LqVP3MDYZA@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com> <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 5:40 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 12, 2018 at 06:02:26PM +0200, Arnd Bergmann wrote:
>>
>> Looking through some of the drivers, I found this interesting one:
>
> As I said before these patches are fundamentally broken.  Users
> of AHASH_REQUEST_ON_STACK can only use sync algorithm providers
> and therefore drivers are irrelevant.

I've also now gone to look at the few users of AHASH_REQUEST_ON_STACK,
and it seems like they come in two flavors:

- ones that can be trivially converts to shash (hibernate)
- things that use scatter/gather

Is this correct? It seems like you did the bulk of
AHASH_REQUEST_ON_STACK conversions in 2016. Can shash grow an sg
interface?

-Kees

-- 
Kees Cook
Pixel Security
