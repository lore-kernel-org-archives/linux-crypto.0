From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG (v2)
Date: Thu, 20 Jan 2011 18:34:40 -0500
Message-ID: <20110120233440.GA2451@localhost.localdomain>
References: <1292260317-2684-1-git-send-email-nhorman@tuxdriver.com>
 <1292275514-2488-1-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50754 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1ATXew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Jan 2011 18:34:52 -0500
Content-Disposition: inline
In-Reply-To: <1292275514-2488-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 13, 2010 at 04:25:14PM -0500, Neil Horman wrote:
> Change notes:
> Changed rng_rcvmsg to allocate a fixed size maximum temp block to store rng data
> when recvmsg is called.  This should prevent malicious DoS from user space by
> tring to receive obscene amounts of random data in one call.  Instead now we
> loop using the same block of data and copy it incrementally to the user space
> buffer using memcpy_toiovecend
> 
> Also changed the accept routine to only allocate a new rng, and not store the
> seed value separately, simplifying the code somewhat.  also now we memset the
> parent sockets seed value to zero on free to hide the seed from intruders.
> 
> Summary:
> This patch enhances the AF_ALG protocol family to include support for random
> number generator algorithms.  With this enhancment, users of the AF_ALG protocol
> can now bind sockets to instances of the various RNG algorithms available to the
> kernel.  For those RNG's that support it, instances can be reseeded using the
> SETKEY socket option within the AF_ALG socket family.  Like with hashes and
> ciphers, only the intially created socket allows seeding, and only child sockets
> retured via accept may return random data.  Sending data on RNG instances is
> prohibited, only receiving RNG data is possible.
> 
> Tested successfully using NIST provided RNG vectors by myself:
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
Herbert, Sorry to bug you about this, but are you still planning on pulling this
now that Linus has the infrastructure scheduled for 2.6.38?

Neil
