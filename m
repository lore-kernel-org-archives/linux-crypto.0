From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/11] crypto: shash: Remove VLA usage
Date: Wed, 20 Jun 2018 13:36:45 -0700
Message-ID: <CAGXu5jKmZ2jn1V8rd3B5BcS0z_WOj0x4eThSG=DYdxSj+fnd2g@mail.gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org> <20180620190408.45104-2-keescook@chromium.org>
 <638faf05-946a-1345-dda4-f75fee5b07d9@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <638faf05-946a-1345-dda4-f75fee5b07d9@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 12:30 PM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:
>
>
> On 06/20/2018 07:03 PM, Kees Cook wrote:
>>
>> In the quest to remove all stack VLA usage from the kernel[1], this
>> removes the VLAs in SHASH_DESC_ON_STACK (via crypto_shash_descsize())
>> by using the maximum allowable size (which is now more clearly captured
>> in a macro). Similar limits are turned into macros as well.
>>
>> [1]
>> https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=3DqPXydAac=
U1RqZWA@mail.gmail.com
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
>
> Got the following warnings:
>
> crypto/testmgr.c: In function =E2=80=98alg_test_crc32c.part.4=E2=80=99:
> crypto/testmgr.c:1896:1: warning: the frame size of 2088 bytes is larger
> than 1024 bytes [-Wframe-larger-than=3D]
> crypto/hmac.c: In function =E2=80=98hmac_setkey=E2=80=99:
> crypto/hmac.c:88:1: warning: the frame size of 2088 bytes is larger than
> 1024 bytes [-Wframe-larger-than=3D]

Ah yes. I didn't do 32-bit builds. So, here's the issue: this uncovers
the frame size problems that were hidden by in being a VLA before. It
was always possible for the frame to get this big, it's just that the
compiler couldn't see it.

For qat, I raised the -Wframe-larger-than flag. It seems we'll need to
do this in some other places too.

-Kees

--=20
Kees Cook
Pixel Security
