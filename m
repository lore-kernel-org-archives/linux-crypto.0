From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm
	(i586 version)
Date: Fri, 7 Dec 2007 19:44:32 +0100
Message-ID: <20071207184432.GE24292@Chamillionaire.breakpoint.cc>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com> <20071205214947.GA20246@Chamillionaire.breakpoint.cc> <fd3e431c0712070902s202f2369l73d1bcd9302600de@mail.gmail.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52709 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbXLGSof (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 13:44:35 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712070902s202f2369l73d1bcd9302600de@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tan Swee Heng | 2007-12-08 01:02:04 [+0800]:

>Hi Sebastian,
Hi,

>On Dec 6, 2007 5:49 AM, Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
>> The patch is a large one. Do you thing all those comments are requried
>> or helping to understand what is going on?
>Actually no, I don't think the comments outside of the functions are
>that helpful. But let me explain why I left them in there:
>
>The assembly code was written by Bernstein 2 years ago in 2005 (see
><http://cr.yp.to/snuffle/salsa20/x86-pm/salsa20.s>). Since then I
>suppose folks have vetted the code. These folks may want reassurance
>that I did not corrupt it when adding indentations. By leaving the
>comments and extraneous functions intact, I was HOPING they can verify
>it with "diff -b".
Yes, I saw this, there are very identical. They released test vectors to
verify an implementation.

>> Besides that, I saw the keysetup routine is also included in assembly.
>> Is the computed key any different from the C version? *I* would prefer
>> to share the keysetup code with the C version because it is not a
>> performace critical part.
>The keysetup() should be the same as the C version... except that I've
>previously modified the C version to use key length in bytes while the
>assembly version uses bits! :-) I could change the C code back. But I
>personally prefer to use the assembly version since it was distributed
>as a "self-contained and complete solution" in Bernstein's
>"salsa20.s".
I would go for the smaller files. That's why merged the AES code
earlier. 

>Hope is a fickle thing. I just tried "diff -b" and it did not work as
>I hoped. My removal of ".globl _ECRYPT_* " confuses diff. That being
>the case, I will go with everyone's wish to remove the extraneous
>comments. As for folks who want to verify that I did not corrupt the
>assembly code, I will also provide the script I used to automate the
>process. (I will do all these in a separate post.)
I would not mind modifing the source code for the greated good :) Should
you make a mistake than the test vectors should detect them.
After all, you modified the C version and s/keysize/bits. 

>Swee Heng
Sebastian
