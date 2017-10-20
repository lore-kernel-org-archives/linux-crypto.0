From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Fri, 20 Oct 2017 17:20:28 +0200
Message-ID: <20171020152028.syq6woeet6it3z3h@gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com>
	<20171011203027.11248-7-thgarnie@google.com>
	<20171020082646.bkxrps35sb3gq2nr@gmail.com>
	<CAJcbSZFScsqOORMGXFQdsqcN5xbfHWpzSHGdxQB=45zgSDryLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	linux-doc@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
	Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
	Christopher Li <sparse@chrisli.org>,
	Jan H =?iso-8859-1?Q?=2E_Sch=F6nherr?= <jschoenh@amazon.de>,
	Alexei Starovoitov <ast@kernel.org>,
	virtualization@lists.linux-foundation.org,
	David Howells <dhowells@redhat.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Waiman Long <longman@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
	the arch/x86 maintainers <x86@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Borkmann <daniel@iogearbox.net>, Jon
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <CAJcbSZFScsqOORMGXFQdsqcN5xbfHWpzSHGdxQB=45zgSDryLw@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> >>        */
> >> -     cmpq    $.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
> >> +     leaq    .Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
> >> +     cmpq    %r11, (%rsp)
> >>       jne     1f

> > This patch seems to add extra overhead to the syscall fast-path even when PIE is
> > disabled, right?
> 
> It does add extra instructions when one is not possible, I preferred
> that over ifdefing but I can change it.

So my problem is, this pattern repeats in many other places as well, but sprinking 
various pieces of assembly code with #ifdefs would be very bad as well.

I have no good idea how to solve this.

Thanks,

	Ingo
