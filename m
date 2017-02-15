From: Harsh Jain <Harsh@chelsio.com>
Subject: BUG: af_alg bind fails for 50 % request from userspace for hash algo
Date: Wed, 15 Feb 2017 22:12:16 +0530
Message-ID: <4fae9b51-ce64-f380-def3-f91f7bffc244@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:39118 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751272AbdBOQmp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 11:42:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert/Stephen,

When I try to run 100 application which calculates sha384 digest from userspace, nearly 50 applications fail in bind system call with error ENOENT.

"crypto_alg_mod_lookup" in api.c call fails in kernel space. Issue comes in 1st try only(Seems some relation with crypto test executions).  If I execute same test again issue didn't reproduce.

Regards

Harsh Jain
