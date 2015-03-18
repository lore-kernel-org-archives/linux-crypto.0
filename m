From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 12:09:45 +0100
Message-ID: <6407649.tbmT00FeL6@tauon>
References: <20150318095345.GA12923@zoho.com> <1426675809.2143223.241946097.20888470@webmail.messagingengine.com> <550959EB.4000304@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46704 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbbCRLJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 07:09:50 -0400
In-Reply-To: <550959EB.4000304@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 18. M=E4rz 2015, 11:56:43 schrieb Daniel Borkmann:

Hi Daniel,

>On 03/18/2015 11:50 AM, Hannes Frederic Sowa wrote:
>> On Wed, Mar 18, 2015, at 10:53, mancha wrote:
>>> Hi.
>>>=20
>>> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to
>>> protect
>>>=20
>>> memory cleansing against things like dead store optimization:
>>>     void memzero_explicit(void *s, size_t count)
>>>     {
>>>    =20
>>>             memset(s, 0, count);
>>>             OPTIMIZER_HIDE_VAR(s);
>>>    =20
>>>     }
>>>=20
>>> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect
>>> crypto_memneq>>=20
>>> against timing analysis, is defined when using gcc as:
>>>     #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0=
"
>>>     (var))
>>>=20
>>> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc
>>> from optimizing out memset (i.e. secrets remain in memory).
>>>=20
>>> Two things that do work:
>>>     __asm__ __volatile__ ("" : "=3Dr" (var) : "0" (var))
>>=20
>> You are correct, volatile signature should be added to
>> OPTIMIZER_HIDE_VAR. Because we use an output variable "=3Dr", gcc is
>> allowed to check if it is needed and may remove the asm statement.
>> Another option would be to just use var as an input variable - asm
>> blocks without output variables are always considered being volatile
>> by gcc.
>>=20
>> Can you send a patch?
>>=20
>> I don't think it is security critical, as Daniel pointed out, the
>> call
>> will happen because the function is an external call to the crypto
>> functions, thus the compiler has to flush memory on return.
>
>Just had a look.
>
>$ gdb vmlinux
>(gdb) disassemble memzero_explicit
>Dump of assembler code for function memzero_explicit:
>    0xffffffff813a18b0 <+0>:	push   %rbp
>    0xffffffff813a18b1 <+1>:	mov    %rsi,%rdx
>    0xffffffff813a18b4 <+4>:	xor    %esi,%esi
>    0xffffffff813a18b6 <+6>:	mov    %rsp,%rbp
>    0xffffffff813a18b9 <+9>:	callq  0xffffffff813a7120 <memset>
>    0xffffffff813a18be <+14>:	pop    %rbp
>    0xffffffff813a18bf <+15>:	retq
>End of assembler dump.
>
>(gdb) disassemble extract_entropy
>[...]
>    0xffffffff814a5000 <+304>:	sub    %r15,%rbx
>    0xffffffff814a5003 <+307>:	jne    0xffffffff814a4f80
><extract_entropy+176> 0xffffffff814a5009 <+313>:	mov    %r12,%rdi
>    0xffffffff814a500c <+316>:	mov    $0xa,%esi
>    0xffffffff814a5011 <+321>:	callq  0xffffffff813a18b0
><memzero_explicit> 0xffffffff814a5016 <+326>:	mov    -0x48(%rbp),%rax
>[...]
>
>I would be fine with __volatile__.

Are we sure that simply adding a __volatile__ works in any case? I just=
=20
did a test with a simple user space app:

static inline void memset_secure(void *s, int c, size_t n)
{
        memset(s, c, n);
        //__asm__ __volatile__("": : :"memory");
        __asm__ __volatile__("" : "=3Dr" (s) : "0" (s));
}

int main(int argc, char *argv[])
{
#define BUFLEN 20
        char buf[BUFLEN];

        snprintf(buf, (BUFLEN - 1), "teststring\n");
        printf("%s", buf);

        memset_secure(buf, 0, BUFLEN);
}

When using the discussed code of __asm__ __volatile__("" : "=3Dr" (s) :=
=20
"0" (s));  I do not find the code implementing memset(0) in objdump.=20
Only when I enable the memory barrier, I see the following (when=20
compiling with -O2):

objdump -d memset_secure:
=2E..
0000000000400440 <main>:
=2E..
  400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
  400470:       00=20
  400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
  400478:       00 00=20
  40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
  400481:       00
=2E..

>
>Thanks a lot mancha, could you send a patch?
>
>Best,
>Daniel
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto=
"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
