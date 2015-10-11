From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: hash import/export
Date: Sun, 11 Oct 2015 23:10:39 +0100
Message-ID: <20151011221039.GA10037@n2100.arm.linux.org.uk>
References: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:56092 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbbJKWKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 18:10:51 -0400
Content-Disposition: inline
In-Reply-To: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 11, 2015 at 08:34:27PM +0100, Russell King - ARM Linux wrote:
> Herbert,
> 
> I wonder if you can clear something up about the hash export/import
> functionality.  In:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-May/344120.html
> 
> you seem to imply that the exported and imported state can't be defined
> by the driver.
> 
> Boris tells me, "AFAIR, crypto users are expecting md5/sha1/sha256_state
> depending on the crypto req state they are exporting".
> 
> From what I can see, there is only one place in the core crypto code
> where hash state is exported and imported, and that's in hash_accept(),
> and that's always done with the same driver.  The only other place is
> in the marvell cesa driver itself when initialising the hmac state.
> 
> Is there any reason a driver can't define its own structure to be
> exported here which can be shared between each of the different methods
> it supports?

A further question: it looks like struct md5_state's hash member is
always supposed to be in little endian format, whereas struct
sha*_state's state is always big endian format.  Is there a reason
why these are typed 'u32', rather than __le32 and __be32?

This would make the intention here more obvious, and should also allow
the opportunity for sparse to verify that we're getting the endianness
correct everywhere.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
