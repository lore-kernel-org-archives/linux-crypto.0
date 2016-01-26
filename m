From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Add hash state import and export support
Date: Tue, 26 Jan 2016 19:16:07 +0800
Message-ID: <20160126111607.GC21069@gondor.apana.org.au>
References: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
 <56A26568.3000806@amd.com>
 <20160125072044.GB5609@gondor.apana.org.au>
 <56A63821.1090501@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56628 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbcAZLQN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 06:16:13 -0500
Content-Disposition: inline
In-Reply-To: <56A63821.1090501@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 08:58:41AM -0600, Tom Lendacky wrote:
> 
> Many of the fields in the rctx structure are set during the update
> operation and don't matter to the driver from an export and import
> perspective. I included them to make the routines simple, but if
> user-space exposure is a concern I can pare down the amount of data
> that is exported and imported. I can send a follow-on patch to do
> that if you prefer.

I've already merged your patch into cryptodev so it'll eventually
make it into mainline and then percolate back via stable.

Of course any improvements to the export/import functions are
still welcome but I'd prefer to leave the patch in cryptodev
for now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
