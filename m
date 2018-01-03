From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Wed, 3 Jan 2018 21:38:30 +0100
Message-ID: <CAK8P3a1P9Qa3p+AT3UDTa7qVjm5H-RTq7hfvxYK3DcNeTij1VQ@mail.gmail.com>
References: <20171220205213.1025257-1-arnd@arndb.de> <20171220214648.GO2353@tucnak>
 <CAK8P3a2b7+KxJ5kKYcnrAV8jDkNBiCR4gCg47iRsiZGdyPoGVg@mail.gmail.com>
 <CAKv+Gu_BYU3JZBVOqeV4CwustnV+Z_Ok6jFipXEzeTpQ8Svy9g@mail.gmail.com>
 <CANc+2y61_o80Wf4JAYB1xi3bb3=6oai77QskSVNjSvpnNZJP0Q@mail.gmail.com>
 <CAKv+Gu8BQfe1ye-q2MQu=omkbMob6dPp9WpZuR0YkoH=Dsnq2g@mail.gmail.com>
 <CAK8P3a11y=HFaVZkyUFQMNO+47cuAF408+=vTFpEB9zJM8iRFA@mail.gmail.com> <CAKv+Gu_+nQA15NuOEA6QLbEFRJkztJ7YcPvFuX5p5j8dkiJrAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_+nQA15NuOEA6QLbEFRJkztJ7YcPvFuX5p5j8dkiJrAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 3, 2018 at 6:36 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 3 January 2018 at 16:37, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Dec 22, 2017 at 4:47 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> A minimal patch would be to disable UBSAN specifically for aes-generic.c
>> for gcc-7.2+ but not gcc-8 to avoid the potential stack overflow. We could
>> also force building with -Os on gcc-7, and leave UBSAN enabled,
>> this would improve performance some 3-5% on x86 with gcc-7 (both
>> 7.1 and 7.2.1) and avoid the stack overflow.
>>
>
> Can't we just disable UBSAN for that file for all GCC versions and be
> done with it? It is not a production feature, and that code is
> unlikely to change in ways where UBSAN would make a difference anyway,
> nor is it ever executed on 99.9% of systems running Linux.

It's up to Herbert in the end. I'm leaning to the -Os change in the Makefile,
since it improves the performance for the common case as well, and
once we start disabling UBSAN for performance-critical files, it becomes
a slippery slope.

I'll send the patch with the -Os change as v2, and note the ubsan-disabling
alternative in the changelog.

       Arnd
