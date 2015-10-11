From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: hash import/export
Date: Sun, 11 Oct 2015 21:38:58 +0200
Message-ID: <20151011213858.74b993d4@bbrezillon>
References: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55474 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751793AbbJKTjD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 15:39:03 -0400
In-Reply-To: <20151011193427.GI32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 11 Oct 2015 20:34:27 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

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

Actually, this was my interpretation of Herbert's answer to this driver
submission [1], but maybe I completely misunderstood his point.

> 
> From what I can see, there is only one place in the core crypto code
> where hash state is exported and imported, and that's in hash_accept(),
> and that's always done with the same driver.  The only other place is
> in the marvell cesa driver itself when initialising the hmac state.
> 
> Is there any reason a driver can't define its own structure to be
> exported here which can be shared between each of the different methods
> it supports?
> 
> Thanks.
> 

[1]http://lists.infradead.org/pipermail/linux-arm-kernel/2015-May/344120.html

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
