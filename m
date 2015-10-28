From: Stephan Mueller <smueller@chronox.de>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Wed, 28 Oct 2015 01:55:13 +0100
Message-ID: <42534143.fhk1W1Xe60@myon.chronox.de>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com> <CAFXBA==5iFOGWrZ+JtM4Yr1XnBL2NFRs=EMoeS4F2mF-R89iqQ@mail.gmail.com> <2100556.thFK4ZhSZX@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34421 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbbJ1AzS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 20:55:18 -0400
In-Reply-To: <2100556.thFK4ZhSZX@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Oktober 2015, 01:09:58 schrieb Stephan Mueller:

Hi Harsh,

> 
> 
> However, any error in user space should not crash the kernel. So, a fix
> should be done. But I think your code is not correct as it solidifies a
> broken user space code.

After thinking a bit again, I think your approach is correct after all. I was 
able to reproduce the crash by simply adding more accept calls to my test 
code. And I can confirm that your patch works, for hashes.

*BUT* it does NOT work for HMAC as the key is set on the TFM and the 
subsequent accepts do not transport the key. Albeit your code prevents the 
kernel from crashing, the HMAC calculation will be done with an empty key as 
the setkey operation does not reach the TFM handle in the subordinate accept() 
call.

So, I would think that the second accept is simply broken, for HMAC at least.

Herbert, what is the purpose of that subordinate accept that is implemented 
with hash_accept? As this is broken for HMACs, should it be removed entirely?

-- 
Ciao
Stephan
