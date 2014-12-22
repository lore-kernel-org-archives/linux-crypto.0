From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: algif - Mark sgl end at the end of data
Date: Mon, 22 Dec 2014 23:05:26 +1100
Message-ID: <20141222120525.GE21045@gondor.apana.org.au>
References: <20141208200342.15309.4739.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49249 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaLVMFa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Dec 2014 07:05:30 -0500
Content-Disposition: inline
In-Reply-To: <20141208200342.15309.4739.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2014 at 12:03:42PM -0800, Tadeusz Struk wrote:
> Hi,
> algif_skcipher sends 127 sgl buffers for encryption regardless of how
> many buffers acctually have data to process, where the few first with
> valid len and the rest with zero len. This is not very eficient.
> This patch marks the last one with data as the last one to process.
> 
> Changes:
> v2 - use data len to find the last buffer instead of nents in RX list.
> v3 - Mark/unmark end when data is added and sgl->cur changed.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
