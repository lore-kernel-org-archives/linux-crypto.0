From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 4/8] random: remove unused branch in hot code path
Date: Thu, 27 Apr 2017 13:23:56 +0200
Message-ID: <CAMuHMdWBjqzPUN=W-4s8Y6nsayyetAf6MsikQigW-cAS27kU2Q@mail.gmail.com>
References: <3254875.f5A5oHPdxF@positron.chronox.de> <3380804.uZWydldqLU@positron.chronox.de>
 <20170118043536.aeqmxfthmx4h33g7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170118043536.aeqmxfthmx4h33g7@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ted,

(replying to an old thread)

On Wed, Jan 18, 2017 at 5:35 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 27, 2016 at 11:40:23PM +0100, Stephan M=C3=BCller wrote:
>> The variable ip is defined to be a __u64 which is always 8 bytes on any
>> architecture. Thus, the check for sizeof(ip) > 4 will always be true.
>>
>> As the check happens in a hot code path, remove the branch.
>
> The fact that it's a hot code path means the compiler will optimize it
> out, so the fact that it's on the hot code path is irrelevant.  The
> main issue is that on platforms with a 32-bit IP's, ip >> 32 will
> always be zero.  It might be that we can just do this via
>
> #if BITS_PER_LONG =3D=3D 32
>   ...
> #else
>   ...
> #endif
>
> I'm not sure that works for all platforms, though.  More research is
> needed...

Is the intention for the test "sizeof(ip) > 4" to distinguish between
32-bit and 64-bit platforms?
As ip is __u64, while regs is a pointer, shouldn't the test be
"sizeof(regs) > 4"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
