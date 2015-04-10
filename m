From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 15:25:44 +0200
Message-ID: <2792913.x6Cv5ZCyOY@tauon>
References: <20150318095345.GA12923@zoho.com> <550959EB.4000304@iogearbox.net> <6407649.tbmT00FeL6@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6407649.tbmT00FeL6@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 18. M=E4rz 2015, 12:09:45 schrieb Stephan Mueller:

Hi,

>Am Mittwoch, 18. M=E4rz 2015, 11:56:43 schrieb Daniel Borkmann:
>
>Hi Daniel,
>
>>On 03/18/2015 11:50 AM, Hannes Frederic Sowa wrote:
>>> On Wed, Mar 18, 2015, at 10:53, mancha wrote:
>>>> Hi.
>>>>=20
>>>> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to
>>>> protect
>>>>=20
>>>> memory cleansing against things like dead store optimization:
>>>>     void memzero_explicit(void *s, size_t count)
>>>>     {
>>>>    =20
>>>>             memset(s, 0, count);
>>>>             OPTIMIZER_HIDE_VAR(s);
>>>>    =20
>>>>     }
>>>>=20
>>>> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect
>>>> crypto_memneq>>
>>>>=20
>>>> against timing analysis, is defined when using gcc as:
>>>>     #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "=
0"
>>>>     (var))
>>>>=20
>>>> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc
>>>> from optimizing out memset (i.e. secrets remain in memory).
>>>>=20
>>>> Two things that do work:
>>>>     __asm__ __volatile__ ("" : "=3Dr" (var) : "0" (var))
>>>=20
>>> You are correct, volatile signature should be added to
>>> OPTIMIZER_HIDE_VAR. Because we use an output variable "=3Dr", gcc i=
s
>>> allowed to check if it is needed and may remove the asm statement.
>>> Another option would be to just use var as an input variable - asm
>>> blocks without output variables are always considered being volatil=
e
>>> by gcc.
>>>=20
>>> Can you send a patch?
>>>=20
>>> I don't think it is security critical, as Daniel pointed out, the
>>> call
>>> will happen because the function is an external call to the crypto
>>> functions, thus the compiler has to flush memory on return.
>>
>>Just had a look.
>>
>>$ gdb vmlinux
>>(gdb) disassemble memzero_explicit
>>
>>Dump of assembler code for function memzero_explicit:
>>    0xffffffff813a18b0 <+0>:	push   %rbp
>>    0xffffffff813a18b1 <+1>:	mov    %rsi,%rdx
>>    0xffffffff813a18b4 <+4>:	xor    %esi,%esi
>>    0xffffffff813a18b6 <+6>:	mov    %rsp,%rbp
>>    0xffffffff813a18b9 <+9>:	callq  0xffffffff813a7120 <memset>
>>    0xffffffff813a18be <+14>:	pop    %rbp
>>    0xffffffff813a18bf <+15>:	retq
>>
>>End of assembler dump.
>>
>>(gdb) disassemble extract_entropy
>>[...]
>>
>>    0xffffffff814a5000 <+304>:	sub    %r15,%rbx
>>    0xffffffff814a5003 <+307>:	jne    0xffffffff814a4f80
>>
>><extract_entropy+176> 0xffffffff814a5009 <+313>:	mov    %r12,%rdi
>>
>>    0xffffffff814a500c <+316>:	mov    $0xa,%esi
>>    0xffffffff814a5011 <+321>:	callq  0xffffffff813a18b0
>>
>><memzero_explicit> 0xffffffff814a5016 <+326>:	mov    -0x48(%rbp),%rax
>>[...]
>>
>>I would be fine with __volatile__.
>
>Are we sure that simply adding a __volatile__ works in any case? I jus=
t
>did a test with a simple user space app:
>
>static inline void memset_secure(void *s, int c, size_t n)
>{
>        memset(s, c, n);
>        //__asm__ __volatile__("": : :"memory");
>        __asm__ __volatile__("" : "=3Dr" (s) : "0" (s));
>}
>
>int main(int argc, char *argv[])
>{
>#define BUFLEN 20
>        char buf[BUFLEN];
>
>        snprintf(buf, (BUFLEN - 1), "teststring\n");
>        printf("%s", buf);
>
>        memset_secure(buf, 0, BUFLEN);
>}
>
>When using the discussed code of __asm__ __volatile__("" : "=3Dr" (s) =
:
>"0" (s));  I do not find the code implementing memset(0) in objdump.
>Only when I enable the memory barrier, I see the following (when
>compiling with -O2):
>
>objdump -d memset_secure:
>...
>0000000000400440 <main>:
>...
>  400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
>  400470:       00
>  400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
>  400478:       00 00
>  40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
>  400481:       00
>...

I would like to bring up that topic again as I did some more analyses:

=46or testing I used the following code:

static inline void memset_secure(void *s, int c, size_t n)
{
        memset(s, c, n);
	BARRIER
}

where BARRIER is defined as:

(1) __asm__ __volatile__("" : "=3Dr" (s) : "0" (s));

(2) __asm__ __volatile__("": : :"memory");

(3) __asm__ __volatile__("" : "=3Dr" (s) : "0" (s) : "memory");

I tested the code with gcc and clang, considering that there is effort=20
underway to compile the kernel with clang too.

The following table marks an X when the aforementioned movq/movl code i=
s=20
present (or an invocation of memset@plt) in the object code (i.e. the c=
ode we=20
want). Contrary the table marks - where the code is not present (i.e. t=
he code=20
we do not want):

         | BARRIER  | (1) | (2) | (3)
---------+----------+     |     |
Compiler |          |     |     |
=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
                    |     |     |
gcc -O0             |  X  |  X  |  X
                    |     |     |
gcc -O2             |  -  |  X  |  X
                    |     |     |
gcc -O3             |  -  |  X  |  X
                    |     |     |
clang -00           |  X  |  X  |  X
                    |     |     |
clang -02           |  X  |  -  |  X
                    |     |     |
clang -03           |  -  |  -  |  X

As the kernel is compiled with -O2, clang folks would still be left unc=
overed=20
with the current solution (i.e. BARRIER option (2)).

Thus, may I propose to update the patch to use option (3) instead as (i=
) it=20
does not cost anything extra on gcc and (ii) it covers clang too?

Ciao
Stephan=20
