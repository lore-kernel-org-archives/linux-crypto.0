From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v12 2/4] random: conditionally compile code depending
 on LRNG
Date: Tue, 18 Jul 2017 10:47:00 +0200
Message-ID: <CAK8P3a1mFxSgttJU9vUkdb6nT6mYPSceFDcRRg9cFprZCjWn5A@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <1830340.t0pR7po4tk@positron.chronox.de>
 <CAK8P3a2aQ8nJUjo76Vwt-vkPUoa9BT616ZVZWsVykHHiz4Pdpw@mail.gmail.com> <1590546.5d4hGCCWgT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1590546.5d4hGCCWgT@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 10:37 AM, Stephan M=C3=BCller <smueller@chronox.de>=
 wrote:
> Am Dienstag, 18. Juli 2017, 10:13:55 CEST schrieb Arnd Bergmann:
>> On Tue, Jul 18, 2017 at 9:58 AM, Stephan M=C3=BCller <smueller@chronox.d=
e> wrote:
>> > When selecting the LRNG for compilation, disable add_disk_randomness a=
nd
>> > its supporting function.
>> >
>> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > CC: Arnd Bergmann <arnd@arndb.de>
>> > CC: Jason A. Donenfeld <Jason@zx2c4.com>
>> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
>>
>> I think this needs a better explanation. Why do we ignore the extra
>> entropy here?
>
> I was not sure whether to add all the details about the reason into the p=
atch
> submission.
>
> The reason is explained here in [1] page 3 and re-iterated in [2].
>

Ok, got it. A half-sentence summary of that ("... to avoid adding the
same event twice from interrupt and block") would be sufficient for
the patch description, longer is also fine.

Generally speaking, each patch description should describe why
that particular patch is required rather than describe what it does
(which in cases like this is plain to see from looking a few lines
down).

        Arnd
