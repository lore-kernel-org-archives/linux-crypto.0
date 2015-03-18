From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 11:56:43 +0100
Message-ID: <550959EB.4000304@iogearbox.net>
References: <20150318095345.GA12923@zoho.com> <1426675809.2143223.241946097.20888470@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47384 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbbCRK4t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 06:56:49 -0400
In-Reply-To: <1426675809.2143223.241946097.20888470@webmail.messagingengine.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/18/2015 11:50 AM, Hannes Frederic Sowa wrote:
>
>
> On Wed, Mar 18, 2015, at 10:53, mancha wrote:
>> Hi.
>>
>> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to protect
>> memory cleansing against things like dead store optimization:
>>
>>     void memzero_explicit(void *s, size_t count)
>>     {
>>             memset(s, 0, count);
>>             OPTIMIZER_HIDE_VAR(s);
>>     }
>>
>> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect crypto_memneq
>> against timing analysis, is defined when using gcc as:
>>
>>     #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
>>
>> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc from
>> optimizing out memset (i.e. secrets remain in memory).
>>
>> Two things that do work:
>>
>>     __asm__ __volatile__ ("" : "=r" (var) : "0" (var))
>
> You are correct, volatile signature should be added to
> OPTIMIZER_HIDE_VAR. Because we use an output variable "=r", gcc is
> allowed to check if it is needed and may remove the asm statement.
> Another option would be to just use var as an input variable - asm
> blocks without output variables are always considered being volatile by
> gcc.
>
> Can you send a patch?
>
> I don't think it is security critical, as Daniel pointed out, the call
> will happen because the function is an external call to the crypto
> functions, thus the compiler has to flush memory on return.

Just had a look.

$ gdb vmlinux
(gdb) disassemble memzero_explicit
Dump of assembler code for function memzero_explicit:
    0xffffffff813a18b0 <+0>:	push   %rbp
    0xffffffff813a18b1 <+1>:	mov    %rsi,%rdx
    0xffffffff813a18b4 <+4>:	xor    %esi,%esi
    0xffffffff813a18b6 <+6>:	mov    %rsp,%rbp
    0xffffffff813a18b9 <+9>:	callq  0xffffffff813a7120 <memset>
    0xffffffff813a18be <+14>:	pop    %rbp
    0xffffffff813a18bf <+15>:	retq
End of assembler dump.

(gdb) disassemble extract_entropy
[...]
    0xffffffff814a5000 <+304>:	sub    %r15,%rbx
    0xffffffff814a5003 <+307>:	jne    0xffffffff814a4f80 <extract_entropy+176>
    0xffffffff814a5009 <+313>:	mov    %r12,%rdi
    0xffffffff814a500c <+316>:	mov    $0xa,%esi
    0xffffffff814a5011 <+321>:	callq  0xffffffff813a18b0 <memzero_explicit>
    0xffffffff814a5016 <+326>:	mov    -0x48(%rbp),%rax
[...]

I would be fine with __volatile__.

Thanks a lot mancha, could you send a patch?

Best,
Daniel
