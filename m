From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Sat, 8 Dec 2007 01:02:04 +0800
Message-ID: <fd3e431c0712070902s202f2369l73d1bcd9302600de@mail.gmail.com>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com>
	 <20071205214947.GA20246@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:39963 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXLGRCF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 12:02:05 -0500
Received: by el-out-1112.google.com with SMTP id v27so28998ele
        for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 09:02:04 -0800 (PST)
In-Reply-To: <20071205214947.GA20246@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sebastian,

On Dec 6, 2007 5:49 AM, Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> The patch is a large one. Do you thing all those comments are requried
> or helping to understand what is going on?
Actually no, I don't think the comments outside of the functions are
that helpful. But let me explain why I left them in there:

The assembly code was written by Bernstein 2 years ago in 2005 (see
<http://cr.yp.to/snuffle/salsa20/x86-pm/salsa20.s>). Since then I
suppose folks have vetted the code. These folks may want reassurance
that I did not corrupt it when adding indentations. By leaving the
comments and extraneous functions intact, I was HOPING they can verify
it with "diff -b".

> Besides that, I saw the keysetup routine is also included in assembly.
> Is the computed key any different from the C version? *I* would prefer
> to share the keysetup code with the C version because it is not a
> performace critical part.
The keysetup() should be the same as the C version... except that I've
previously modified the C version to use key length in bytes while the
assembly version uses bits! :-) I could change the C code back. But I
personally prefer to use the assembly version since it was distributed
as a "self-contained and complete solution" in Bernstein's
"salsa20.s".

> There are a few labels like '_label:' and 'label:' One of them should be
> enough or am I missing something?
You are absolutely right. I forgot to remove them when removing
".globl _ECRYPT_* ".

Hope is a fickle thing. I just tried "diff -b" and it did not work as
I hoped. My removal of ".globl _ECRYPT_* " confuses diff. That being
the case, I will go with everyone's wish to remove the extraneous
comments. As for folks who want to verify that I did not corrupt the
assembly code, I will also provide the script I used to automate the
process. (I will do all these in a separate post.)

Swee Heng
