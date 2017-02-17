From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: BUG: af_alg bind fails for 50 % request from userspace for hash algo
Date: Fri, 17 Feb 2017 23:25:45 +0100
Message-ID: <2078437.67e00qAA34@positron.chronox.de>
References: <4fae9b51-ce64-f380-def3-f91f7bffc244@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59698 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935000AbdBQWZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 17:25:49 -0500
In-Reply-To: <4fae9b51-ce64-f380-def3-f91f7bffc244@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 15. Februar 2017, 22:12:16 CET schrieb Harsh Jain:

Hi Harsh,

> Hi Herbert/Stephen,
> 
> When I try to run 100 application which calculates sha384 digest from
> userspace, nearly 50 applications fail in bind system call with error
> ENOENT.
> 
> "crypto_alg_mod_lookup" in api.c call fails in kernel space. Issue comes in
> 1st try only(Seems some relation with crypto test executions).  If I
> execute same test again issue didn't reproduce.

I can concur that once in a while I see an ENOENT too for hashes. Let me try 
to investigate that.
> 
> Regards
> 
> Harsh Jain


Ciao
Stephan
