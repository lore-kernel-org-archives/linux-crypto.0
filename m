From: Stephan Mueller <smueller@chronox.de>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Sun, 25 Oct 2015 12:58:38 +0100
Message-ID: <2725312.7LhRVP0piv@tauon.atsec.com>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34391 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbbJYL6o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Oct 2015 07:58:44 -0400
In-Reply-To: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 25. Oktober 2015, 11:56:27 schrieb Harsh Jain:

Hi Harsh,

>Hi,
>
>
>When trying to calculate HMAC(SHA1) with openssl using af-alg engine
>kernel crashes.Find below the command used and kernel. I have added
>some debug print in logs.
>
>Command used : ./openssl dgst -engine af_alg -sha1 -hmac "key" r.txt
>kernel version : 3.17.8
>
>Initial Investigation : In shash_desc structure tfm pointer contains
>5a5a5a5a5a5a5a5a(invalid pointer), when it triess to reference export
>function pointer it crashes. As per my understanding tfm object should
>have pointer of memory bloack allocated in
>"crypto_init_shash_ops_async" function
>
>Please give some pointers to debug the issue.Any documentation to
>understand the crypto-api code.

May I ask you to send 2 things: the source code of the OpenSSL af_alg engine 
that you use (IIRC it is not included upstream, I want to be sure I used the 
right one).

Further, can you attach an strace of the aforementioned command?

Note, I am playing and abusing the AF_ALG interface for quite some time with 
[1] but I did not come across any issues like the one you describe here.

[1] http://www.chronox.de/libkcapi.html

Ciao
Stephan
