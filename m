From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export functions
Date: Sat, 10 Oct 2015 00:37:33 +0200
Message-ID: <87oag78y8i.fsf@natisbad.org>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
	<E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:59748 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbJIWhu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 18:37:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russel,

Russell King <rmk+kernel@arm.linux.org.uk> writes:

> As all the import functions and export functions are virtually
> identical, factor out their common parts into a generic
> mv_cesa_ahash_import() and mv_cesa_ahash_export() respectively.  This
> performs the actual import or export, and we pass the data pointers and
> length into these functions.
>
> We have to switch a % const operation to do_div() in the common import
> function to avoid provoking gcc to use the expensive 64-bit by 64-bit
> modulus operation.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks for the refactoring and for the fixes. All patches look good to 
me. Out of curiosity, can I ask what perf you get w/ openssh or openssl
using AF_ALG and the CESA?

Cheers,

a+
