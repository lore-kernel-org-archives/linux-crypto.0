From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Mon, 27 Apr 2015 22:34:30 +0200
Message-ID: <553E9D56.1020202@iogearbox.net>
References: <20150318095345.GA12923@zoho.com> <5527E22C.9080909@iogearbox.net> <2604864.n87lBBrmsR@tauon> <11353383.zL7vZDIZ69@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59926 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbbD0Ueh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 16:34:37 -0400
In-Reply-To: <11353383.zL7vZDIZ69@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/27/2015 09:10 PM, Stephan Mueller wrote:
...
> I posted the issue on the clang mailing list on April 10 -- no word so far. I
> would interpret this as a sign that it is a no-issue for them.

Hm. ;)

Here's a bug report on the topic, gcc vs llvm:

   https://llvm.org/bugs/show_bug.cgi?id=15495

Lets add a new barrier macro to linux/compiler{,-gcc}.h, f.e.

   #define barrier_data(ptr) __asm__ __volatile__("" : : "r" (ptr) : "memory")

or the version Mancha proposed. You could wrap that ...

   #define OPTIMIZER_HIDE(ptr)   barrier_data(ptr)

... and use that one for memzero_explicit() instead:

   void memzero_explicit(void *s, size_t count)
   {
      memset(s, 0, count);
      OPTIMIZER_HIDE(s);
   }

It certainly needs comments explaining in what situations to use
which OPTIMIZER_HIDE* variants, etc.

Do you want to send a patch?
