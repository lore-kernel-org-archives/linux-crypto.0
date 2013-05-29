From: Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v2] OMAP: AES: Don't idle/start AES device between Encrypt operations
Date: Wed, 29 May 2013 09:39:05 -0700
Message-ID: <878v2x91w6.fsf@linaro.org>
References: <1369785775-3737-1-git-send-email-joelagnel@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: Joel A Fernandes <joelagnel@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42902 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab3E2QjJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 12:39:09 -0400
Received: by mail-pa0-f44.google.com with SMTP id wp1so6918258pac.17
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2013 09:39:08 -0700 (PDT)
In-Reply-To: <1369785775-3737-1-git-send-email-joelagnel@ti.com> (Joel
	A. Fernandes's message of "Tue, 28 May 2013 19:02:55 -0500")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Joel A Fernandes <joelagnel@ti.com> writes:

> Calling runtime PM API for every block causes serious perf hit to
> crypto operations that are done on a long buffer.
> As crypto is performed on a page boundary, encrypting large buffers can
> cause a series of crypto operations divided by page. The runtime PM API
> is also called those many times.
>
> We call runtime_pm_get_sync only at beginning on the session (cra_init)
> and runtime_pm_put at the end. This result in upto a 50% speedup as below.
> This doesn't make the driver to keep the system awake as runtime get/put
> is only called during a crypto session which completes usually quickly.
>
> Before:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 13310 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 64 size blocks: 13040 aes-128-cbc's in 0.04s
> Doing aes-128-cbc for 3s on 256 size blocks: 9134 aes-128-cbc's in 0.03s
> Doing aes-128-cbc for 3s on 1024 size blocks: 8939 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4299 aes-128-cbc's in 0.00s
>
> After:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 18911 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 64 size blocks: 18878 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 256 size blocks: 11878 aes-128-cbc's in 0.10s
> Doing aes-128-cbc for 3s on 1024 size blocks: 11538 aes-128-cbc's in 0.05s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4857 aes-128-cbc's in 0.03s
>
> While at it, also drop enter and exit pr_debugs, in related code. tracers
> can be used for that.
>
> Tested on a Beaglebone (AM335x SoC) board.
>
> v3 changes:
> Refreshed patch on kernel v3.10-rc3
>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>

This patch had at least 2 acks (myself and Mark Greer) which you should
include when reposting.  

Also, changelog says v3 but subject says v2.

Kevin
