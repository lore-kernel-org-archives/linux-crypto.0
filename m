From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 2/3] crypto: ccp - Enable support for AES GCM on v5
 CCPs
Date: Thu, 9 Mar 2017 18:32:26 +0800
Message-ID: <20170309103226.GA7102@gondor.apana.org.au>
References: <20170302212331.30959.44149.stgit@taos>
 <20170302212654.30959.31.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39161 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753996AbdCIKch (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:32:37 -0500
Content-Disposition: inline
In-Reply-To: <20170302212654.30959.31.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 02, 2017 at 03:26:54PM -0600, Gary R Hook wrote:
> A version 5 device provides the primitive commands
> required for AES GCM. This patch adds support for
> en/decryption.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

This patch doesn't apply to the current cryptodev tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
