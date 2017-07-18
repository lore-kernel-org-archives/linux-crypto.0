From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 11:02:02 +0200
Message-ID: <CAK8P3a1g8_D6Z0d-LOjomGcxuX5v_Y9fJ_b9TEeOQ6izOneE=g@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <22067042.Wh8NKMhEMa@positron.chronox.de>
 <20170718083014.GA18340@kroah.com> <5020806.nso7MErEBx@positron.chronox.de> <20170718084959.GA25267@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718084959.GA25267@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 10:49 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 18, 2017 at 10:40:07AM +0200, Stephan M=C3=BCller wrote:
>> Am Dienstag, 18. Juli 2017, 10:30:14 CEST schrieb Greg Kroah-Hartman:
>>
>> Hi Greg,
>>
>> > > +typedef  unsigned long long      __u64;
>> > > +typedef  long long               __s64;
>> >
>> > types.h already has these defines, don't re-typedef them again...
>>
>> The issue is that the C code is compiled without optimizations. Thus, th=
e C
>> code shall not depend on any other header file.
>
> That is very strange for a kernel file, I don't know what to say...
>
>> This issue was discussed during the inclusion of the Jitter RNG C code i=
nto
>> the kernel.
>
> Ok, that was then, this is now, why not change it now?  How does
> including types.h change anything?

I can see why the jitterentropy implementation avoids using kernel headers,
the problem now is that part of it gets moved into a new header, and that
already violates the original principle.

>From my reading of the code, we could probably leave the structure
definition in the crypto/jitterentropy.c, and have the statically
allocated instance in the same file when CONFIG_LRNG is
set, or provide a way to allocate an instance early (I assume you
can't call jent_entropy_collector_alloc() here since you need
the RNG long before kzalloc() works).

        Arnd
