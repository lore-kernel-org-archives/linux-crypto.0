From: David Miller <davem@davemloft.net>
Subject: Re: [sparc64] cryptomgr_test OOPS kernel 4.9.0+
Date: Mon, 26 Dec 2016 15:59:11 -0500 (EST)
Message-ID: <20161226.155911.1929580721580916933.davem@davemloft.net>
References: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
To: matorola@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:59688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755798AbcLZU7P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Dec 2016 15:59:15 -0500
In-Reply-To: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anatoly Pugachev <matorola@gmail.com>
Date: Sun, 25 Dec 2016 20:56:08 +0300

> Disabling kernel config option
> CRYPTO_MANAGER_DISABLE_TESTS
> i.e. enable run-time self tests, makes kernel unbootable:
> 
> tested with git kernels v4.9-8648-g5cc60aeedf31 and v4.9-12259-g7c0f6ba682b9

I'm getting this with the current GIT tree too, will try to see
what's going wrong.
