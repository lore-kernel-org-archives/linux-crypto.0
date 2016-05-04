From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Wed, 4 May 2016 12:07:32 +0800
Message-ID: <20160504040731.GA25758@gondor.apana.org.au>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: matorola@gmail.com, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38883 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcEDEHh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 00:07:37 -0400
Content-Disposition: inline
In-Reply-To: <20160503.123301.298039059390449291.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

David Miller <davem@davemloft.net> wrote:
> From: Anatoly Pugachev <matorola@gmail.com>
> Date: Tue, 3 May 2016 16:54:18 +0300
> 
>> I have git kernel OOPS (4.6.0-rc6) on sparc64. This OOPS does not
>> happen, if I set the following kernel option:
>> 
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
>> 
>> Can someone please look at https://bugzilla.kernel.org/show_bug.cgi?id=117551 ?
> 
> The lib/mpi/ code hasn't been touched in a long time, so I can only see that it might
> be the crypto/rsa.c changes that happened this release.
> 
> Can you possibly bisect this or at least tell us that 4.5 doesn't have this problem?

It would also be helpful to test the latest cryptodev tree which
has a large number of MPI fixes from Nicolai Stange.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
