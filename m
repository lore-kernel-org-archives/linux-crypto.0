From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Fri, 20 Oct 2017 19:52:17 +0200
Message-ID: <3EA62B98-ED93-48BC-9113-05CA09E6FC5E@amacapital.net>
References: <20171011203027.11248-1-thgarnie@google.com> <20171011203027.11248-7-thgarnie@google.com> <20171020082646.bkxrps35sb3gq2nr@gmail.com> <CAJcbSZFScsqOORMGXFQdsqcN5xbfHWpzSHGdxQB=45zgSDryLw@mail.gmail.com> <20171020152028.syq6woeet6it3z3h@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Thomas Garnier <thgarnie@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Kees Cook <keescook@chromium.org>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Matthias Kaehlcke <mka@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
 Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
 Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
 Tejun Heo <tj@kernel
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-10214-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171020152028.syq6woeet6it3z3h@gmail.com>
List-Id: linux-crypto.vger.kernel.org



> On Oct 20, 2017, at 5:20 PM, Ingo Molnar <mingo@kernel.org> wrote:
>=20
>=20
> * Thomas Garnier <thgarnie@google.com> wrote:
>=20
>>>>       */
>>>> -     cmpq    $.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
>>>> +     leaq    .Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
>>>> +     cmpq    %r11, (%rsp)
>>>>      jne     1f
>=20
>>> This patch seems to add extra overhead to the syscall fast-path even whe=
n PIE is
>>> disabled, right?
>>=20
>> It does add extra instructions when one is not possible, I preferred
>> that over ifdefing but I can change it.
>=20
> So my problem is, this pattern repeats in many other places as well, but s=
prinking=20
> various pieces of assembly code with #ifdefs would be very bad as well.
>=20
> I have no good idea how to solve this.
>=20
> Thanks,

Ugh, brain was off.  This is a bit messy. We could use a macro for this, too=
, I suppose.

>=20
>    Ingo
