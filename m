From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] [v2] crypto: serpent - add 8-way parallel
	x86_64/SSE2 assembler implementation
Date: Mon, 21 Nov 2011 16:19:00 +0800
Message-ID: <20111121081900.GA23208@gondor.apana.org.au>
References: <20111109142625.23131.66808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51400 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab1KUITG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Nov 2011 03:19:06 -0500
Content-Disposition: inline
In-Reply-To: <20111109142625.23131.66808.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 09, 2011 at 04:26:25PM +0200, Jussi Kivilinna wrote:
> Patch adds x86_64/SSE2 assembler implementation of serpent cipher. Assembler
> functions crypt data in eigth block chunks (two 4 block chunk SSE2 operations
> in parallel to improve performance on out-of-order CPUs). Glue code is based
> on one from AES-NI implementation, so requests from irq context are redirected
> to cryptd.

All five patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
