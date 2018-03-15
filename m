From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Thu, 15 Mar 2018 11:18:19 +0100
Message-ID: <6d14b321-debc-5bc8-8c1b-14150052f5b8@redhat.com>
References: <20180313205945.245105-1-thgarnie@google.com>
	<20180313205945.245105-7-thgarnie@google.com>
	<20180314102951.GQ4043@hirez.programming.kicks-ass.net>
	<alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Petr Mladek <pmladek@suse.com>, Len Brown <len.brown@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>,
	kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>,
	Alok Kataria <akataria@vmware.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Joerg Roedel <joro@8bytes.org>,
	=?UTF-8?B?UmF
To: Christopher Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
Content-Language: en-US
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

On 14/03/2018 16:54, Christopher Lameter wrote:
>>> +	pushq	%rax		/* Support Position Independent Code */
>>> +	leaq	1f(%rip), %rax	/* RIP */
>>> +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
>>>  	iretq			/* continues at repeat_nmi below */
>>>  	UNWIND_HINT_IRET_REGS
>>>  1:
>> Urgh, xchg with a memop has an implicit LOCK prefix.
> this_cpu_xchg uses no lock cmpxchg as a replacement to reduce latency.

That requires using a second register, since %rax is used as the
comparison source.  At this point it's easier to just push %rax twice:

	pushq %rax
	pushq %rax
	leaq 1f(%ip), %rax
	movq %rax, 8(%rsp)
	popq %rax
	iretq

Paolo
