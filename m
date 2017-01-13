From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Fri, 13 Jan 2017 07:07:58 -0600
Message-ID: <20170113130758.t6flrek6v7r2qkp6@treble>
References: <20170111031124.GA4515@gondor.apana.org.au>
 <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au>
 <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170113083648.GA22022@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdAMNIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 08:08:00 -0500
Content-Disposition: inline
In-Reply-To: <20170113083648.GA22022@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 04:36:48PM +0800, Herbert Xu wrote:
> On Thu, Jan 12, 2017 at 12:08:07PM -0800, Andy Lutomirski wrote:
> >
> > I think we have some inline functions that do asm volatile ("call
> > ..."), and I don't see any credible way of forcing alignment short of
> > generating an entirely new stack frame and aligning that.  Ick.  This
> 
> A straight asm call from C should always work because gcc keeps
> the stack aligned in the prologue.
> 
> The only problem with inline assembly is when you start pushing
> things onto the stack directly.

I tried another approach.  I rebuilt the kernel with
-mpreferred-stack-boundary=4 and used awk (poor man's objtool) to find
all leaf functions with misaligned stacks.

  objdump -d ~/k/vmlinux | awk '/>:/ { f=$2; call=0; push=0 } /fentry/ { next } /callq/ { call=1 } /push/ { push=!push } /sub.*8,%rsp/ { push=!push } /^$/ && call == 0 && push == 0 { print f }'

It found a lot of functions.  Here's one of them:

  ffffffff814ab450 <mpihelp_add_n>:
  ffffffff814ab450:	55                   	push   %rbp
  ffffffff814ab451:	f7 d9                	neg    %ecx
  ffffffff814ab453:	31 c0                	xor    %eax,%eax
  ffffffff814ab455:	4c 63 c1             	movslq %ecx,%r8
  ffffffff814ab458:	48 89 e5             	mov    %rsp,%rbp
  ffffffff814ab45b:	53                   	push   %rbx
  ffffffff814ab45c:	4a 8d 1c c5 00 00 00 	lea    0x0(,%r8,8),%rbx
  ffffffff814ab463:	00 
  ffffffff814ab464:	eb 03                	jmp    ffffffff814ab469 <mpihelp_add_n+0x19>
  ffffffff814ab466:	4c 63 c1             	movslq %ecx,%r8
  ffffffff814ab469:	49 c1 e0 03          	shl    $0x3,%r8
  ffffffff814ab46d:	45 31 c9             	xor    %r9d,%r9d
  ffffffff814ab470:	49 29 d8             	sub    %rbx,%r8
  ffffffff814ab473:	4a 03 04 02          	add    (%rdx,%r8,1),%rax
  ffffffff814ab477:	41 0f 92 c1          	setb   %r9b
  ffffffff814ab47b:	4a 03 04 06          	add    (%rsi,%r8,1),%rax
  ffffffff814ab47f:	41 0f 92 c2          	setb   %r10b
  ffffffff814ab483:	49 89 c3             	mov    %rax,%r11
  ffffffff814ab486:	83 c1 01             	add    $0x1,%ecx
  ffffffff814ab489:	45 0f b6 d2          	movzbl %r10b,%r10d
  ffffffff814ab48d:	4e 89 1c 07          	mov    %r11,(%rdi,%r8,1)
  ffffffff814ab491:	4b 8d 04 0a          	lea    (%r10,%r9,1),%rax
  ffffffff814ab495:	75 cf                	jne    ffffffff814ab466 <mpihelp_add_n+0x16>
  ffffffff814ab497:	5b                   	pop    %rbx
  ffffffff814ab498:	5d                   	pop    %rbp
  ffffffff814ab499:	c3                   	retq   
  ffffffff814ab49a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

That's a leaf function which, as far as I can tell, doesn't use any
inline asm, but its prologue produces a misaligned stack.

I added inline asm with a call instruction and no operands or clobbers,
and got the same result.

So Andy's theory seems to be correct.  As long as we allow calls from
inline asm, we can't rely on aligned stacks.

-- 
Josh
