From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE support
Date: Fri, 20 Oct 2017 10:26:46 +0200
Message-ID: <20171020082646.bkxrps35sb3gq2nr@gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com>
	<20171011203027.11248-7-thgarnie@google.com>
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
	"H . Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com,
	Christoph Lameter <cl@linux.com>,
	Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Borkmann <daniel@iogearbox.net>, Jonathan Corbet <corbet@lwn.net>,
	Peter Foley <pe
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20171011203027.11248-7-thgarnie@google.com>
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

> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/entry/entry_64.S | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 49167258d587..15bd5530d2ae 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -194,12 +194,15 @@ entry_SYSCALL_64_fastpath:
>  	ja	1f				/* return -ENOSYS (already in pt_regs->ax) */
>  	movq	%r10, %rcx
>  
> +	/* Ensures the call is position independent */
> +	leaq	sys_call_table(%rip), %r11
> +
>  	/*
>  	 * This call instruction is handled specially in stub_ptregs_64.
>  	 * It might end up jumping to the slow path.  If it jumps, RAX
>  	 * and all argument registers are clobbered.
>  	 */
> -	call	*sys_call_table(, %rax, 8)
> +	call	*(%r11, %rax, 8)
>  .Lentry_SYSCALL_64_after_fastpath_call:
>  
>  	movq	%rax, RAX(%rsp)
> @@ -334,7 +337,8 @@ ENTRY(stub_ptregs_64)
>  	 * RAX stores a pointer to the C function implementing the syscall.
>  	 * IRQs are on.
>  	 */
> -	cmpq	$.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
> +	leaq	.Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
> +	cmpq	%r11, (%rsp)
>  	jne	1f
>  
>  	/*
> @@ -1172,7 +1176,8 @@ ENTRY(error_entry)
>  	movl	%ecx, %eax			/* zero extend */
>  	cmpq	%rax, RIP+8(%rsp)
>  	je	.Lbstep_iret
> -	cmpq	$.Lgs_change, RIP+8(%rsp)
> +	leaq	.Lgs_change(%rip), %rcx
> +	cmpq	%rcx, RIP+8(%rsp)
>  	jne	.Lerror_entry_done
>  
>  	/*
> @@ -1383,10 +1388,10 @@ ENTRY(nmi)
>  	 * resume the outer NMI.
>  	 */
>  
> -	movq	$repeat_nmi, %rdx
> +	leaq	repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	1f
> -	movq	$end_repeat_nmi, %rdx
> +	leaq	end_repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	nested_nmi_out
>  1:
> @@ -1440,7 +1445,8 @@ nested_nmi:
>  	pushq	%rdx
>  	pushfq
>  	pushq	$__KERNEL_CS
> -	pushq	$repeat_nmi
> +	leaq	repeat_nmi(%rip), %rdx
> +	pushq	%rdx
>  
>  	/* Put stack back */
>  	addq	$(6*8), %rsp
> @@ -1479,7 +1485,9 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	%rax		/* Support Position Independent Code */
> +	leaq	1f(%rip), %rax	/* RIP */
> +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
>  	INTERRUPT_RETURN	/* continues at repeat_nmi below */
>  	UNWIND_HINT_IRET_REGS

This patch seems to add extra overhead to the syscall fast-path even when PIE is 
disabled, right?

Thanks,

	Ingo
