From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Sun, 13 Nov 2016 17:49:21 +0800
Message-ID: <20161113094921.GB7399@gondor.apana.org.au>
References: <20161101190505.1191.20536.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44860 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbcKMJuW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 04:50:22 -0500
Content-Disposition: inline
In-Reply-To: <20161101190505.1191.20536.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 01, 2016 at 02:05:05PM -0500, Gary R Hook wrote:
> The exponent size in the ccp_op structure is in bits. A v5
> CCP requires the exponent size to be in bytes, so convert
> the size from bits to bytes when populating the descriptor.
> 
> The current code references the exponent in memory, but
> these fields have not been set since the exponent is
> actually store in the LSB. Populate the descriptor with
> the LSB location (address).
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
