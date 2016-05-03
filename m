From: David Miller <davem@davemloft.net>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Tue, 03 May 2016 12:33:01 -0400 (EDT)
Message-ID: <20160503.123301.298039059390449291.davem@davemloft.net>
References: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
To: matorola@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47930 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338AbcECQdc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 12:33:32 -0400
In-Reply-To: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anatoly Pugachev <matorola@gmail.com>
Date: Tue, 3 May 2016 16:54:18 +0300

> I have git kernel OOPS (4.6.0-rc6) on sparc64. This OOPS does not
> happen, if I set the following kernel option:
> 
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> 
> Can someone please look at https://bugzilla.kernel.org/show_bug.cgi?id=117551 ?

The lib/mpi/ code hasn't been touched in a long time, so I can only see that it might
be the crypto/rsa.c changes that happened this release.

Can you possibly bisect this or at least tell us that 4.5 doesn't have this problem?
