From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 23:07:09 -0600
Message-ID: <20170113050709.yrdtfet5d4sebubi@treble>
References: <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170112201511.yj5ekqmj76r2yv6t@treble>
 <CALCETrXom8aY2XhpAyOtAwQQYF7wftBHJE_px1xr0iRmcYEJoA@mail.gmail.com>
 <20170113031107.mgitq54fmjnrvi6f@treble>
 <CALCETrUFCFn-rKnr+NG3SU7J78ree9siJC=Kz8f_Bk6eG2HyPA@mail.gmail.com>
 <20170113042758.whof5fk6eu7myctq@treble>
 <CA+55aFzRrSwGxxfZk-RUEnsz=xhcSmOwE1CenfCPBWtsS9MwDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbdAMFHM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 00:07:12 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFzRrSwGxxfZk-RUEnsz=xhcSmOwE1CenfCPBWtsS9MwDw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 08:37:18PM -0800, Linus Torvalds wrote:
> On Jan 12, 2017 8:28 PM, "Josh Poimboeuf" <jpoimboe@redhat.com> wrote:
> 
> 
> The stack frame was always 16-byte aligned regardless of whether the
> buf array size was even or odd.
> 
> 
> Including with -fomit-frame-pointer?
> 
> With frame pointers, stack frames really are naturally 16 bytes, and then
> keeping the frame 16-byte aligned is just a matter of making any extra
> frame allocations or push/pop sequences that you do also be a multiple of
> 16 bytes.
> 
> But *without* frame pointers, the"native" frame size is just 8 bytes, and a
> function that doesn't need any other local storage and then calls another
> function (think various trivial wrapper functions that just add an argument
> and then munge the return value) would thus naturally cause the frame to
> become misaligned.
> 
> So then the compiler actually needs to start adding useless instructions
> just to keep the stack 16-byte aligned.

Disabling frame pointers didn't seem to help, but I finally got it to
misalign with a different test case.  I think it had been aligning the
array, so instead I made it push a register.


void otherfunc(void);

static inline void bar(int f)
{
	register void *__sp asm(_ASM_SP);
	asm volatile("call otherfunc" : "+r" (__sp) : "b"(f));
}

void foo(void)
{
	bar(5);
}


00000000000020f0 <foo>:
    20f0:	55                   	push   %rbp
    20f1:	48 89 e5             	mov    %rsp,%rbp
    20f4:	53                   	push   %rbx
    20f5:	bb 05 00 00 00       	mov    $0x5,%ebx
    20fa:	e8 00 00 00 00       	callq  20ff <foo+0xf>
			20fb: R_X86_64_PC32	otherfunc-0x4
    20ff:	5b                   	pop    %rbx
    2100:	5d                   	pop    %rbp
    2101:	c3                   	retq   
    2102:	0f 1f 40 00          	nopl   0x0(%rax)
    2106:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    210d:	00 00 00 

-- 
Josh
