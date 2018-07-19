From: Ken Moffat <zarniwhoop73@googlemail.com>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Thu, 19 Jul 2018 01:19:27 +0100
Message-ID: <CANVEwpbcaTq=gFHVi0FUjq=7vLbQNYRX7aBRxWvH68oY_LFm-A@mail.gmail.com>
References: <20180718014344.1309-1-tytso@mit.edu> <20180718015154.GE3489@thunk.org>
 <CANVEwpY2H+OBnYNAf15bRRbmepFCerWrisLiLQ=h3+_692MY7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANVEwpY2H+OBnYNAf15bRRbmepFCerWrisLiLQ=h3+_692MY7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 July 2018 at 18:21, Ken Moffat <zarniwhoop73@googlemail.com> wrote:
> On 18 July 2018 at 02:43, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> This will prevent getrandom(2) from blocking, if there is a
>> willingness to trust the CPU manufacturer.

> For me, it seems a price worth paying. I've got bigger problems than
> _worriying_ about my government, or yours, spying on me, so I'd like to t=
ake
> the risk.
>
Sadly, my enthusiasm was premature: the Kaveri doesn't have a hwrng. So
although I've enabled the device under the HW_RANDOM options, nothing
comes out and this "fix" will only work for some machines.

For me, I'll have to go to plan B (revise the bootscript and/or patch unbou=
nd).
I see that Nixos seems to bind /dev/urandom to /var/lib/unbound/dev/random
so I guess that ought to work. Sorry for the noise.

=C4=B8en
