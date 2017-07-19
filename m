From: Kees Cook <keescook@chromium.org>
Subject: Re: Re: x86: PIE support and option to extend
 KASLR randomization
Date: Wed, 19 Jul 2017 12:21:05 -0700
Message-ID: <CAGXu5jKRC0G9GCQoYfPF9htns=_KU53UTPTSt54BRYmgbGOp5w@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <alpine.DEB.2.20.1707190906490.17764@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>,
	Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@in
To: Christopher Lameter <cl@linux.com>
Return-path: <kernel-hardening-return-9063-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.20.1707190906490.17764@nuc-kabylake>
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 7:08 AM, Christopher Lameter <cl@linux.com> wrote:
> On Tue, 18 Jul 2017, Thomas Garnier wrote:
>
>> Performance/Size impact:
>> Hackbench (50% and 1600% loads):
>>  - PIE enabled: 7% to 8% on half load, 10% on heavy load.
>> slab_test (average of 10 runs):
>>  - PIE enabled: 3% to 4%
>> Kernbench (average of 10 Half and Optimal runs):
>>  - PIE enabled: 5% to 6%
>>
>> Size of vmlinux (Ubuntu configuration):
>>  File size:
>>  - PIE disabled: 472928672 bytes (-0.000169% from baseline)
>>  - PIE enabled: 216878461 bytes (-54.14% from baseline)
>
> Maybe we need something like CONFIG_PARANOIA so that we can determine at
> build time how much performance we want to sacrifice for performance?
>
> Its going to be difficult to understand what all these hardening config
> options do.

This kind of thing got discussed recently, and like
CONFIG_EXPERIMENTAL, a global config doesn't really work. The best
thing to do is to document each config as well as possible and system
builders can decide.

-Kees

-- 
Kees Cook
Pixel Security
