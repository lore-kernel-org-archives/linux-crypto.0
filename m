From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Set the AES size field for all modes
Date: Wed, 15 Feb 2017 13:32:35 +0800
Message-ID: <20170215053235.GA14043@gondor.apana.org.au>
References: <20170208190706.7984.97805.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33483 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFcq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:32:46 -0500
Content-Disposition: inline
In-Reply-To: <20170208190706.7984.97805.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 08, 2017 at 01:07:06PM -0600, Gary R Hook wrote:
> Ensure that the size field is correctly populated for
> all AES modes.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
