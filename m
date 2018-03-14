From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Wed, 14 Mar 2018 11:29:51 +0100
Message-ID: <20180314102951.GQ4043@hirez.programming.kicks-ass.net>
References: <20180313205945.245105-1-thgarnie@google.com>
	<20180313205945.245105-7-thgarnie@google.com>
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
	kernel-hardening@lists.openwall.com,
	Christoph Lameter <cl@linux.com>, Jiri Slaby <jslaby@suse.cz>,
	Alok Kataria <akataria@vmware.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Joerg Roede
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180313205945.245105-7-thgarnie@google.com>
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

On Tue, Mar 13, 2018 at 01:59:24PM -0700, Thomas Garnier wrote:
> @@ -1576,7 +1578,9 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	%rax		/* Support Position Independent Code */
> +	leaq	1f(%rip), %rax	/* RIP */
> +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
>  	iretq			/* continues at repeat_nmi below */
>  	UNWIND_HINT_IRET_REGS
>  1:

Urgh, xchg with a memop has an implicit LOCK prefix.
