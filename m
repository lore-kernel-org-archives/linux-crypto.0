From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: hash import/export
Date: Sun, 11 Oct 2015 20:34:27 +0100
Message-ID: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55898 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbJKTef (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 15:34:35 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

I wonder if you can clear something up about the hash export/import
functionality.  In:

http://lists.infradead.org/pipermail/linux-arm-kernel/2015-May/344120.html

you seem to imply that the exported and imported state can't be defined
by the driver.

Boris tells me, "AFAIR, crypto users are expecting md5/sha1/sha256_state
depending on the crypto req state they are exporting".

>From what I can see, there is only one place in the core crypto code
where hash state is exported and imported, and that's in hash_accept(),
and that's always done with the same driver.  The only other place is
in the marvell cesa driver itself when initialising the hmac state.

Is there any reason a driver can't define its own structure to be
exported here which can be shared between each of the different methods
it supports?

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
