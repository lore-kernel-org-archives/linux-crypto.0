From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3 0/3] Support new function in new CCPs
Date: Fri, 24 Mar 2017 22:12:38 +0800
Message-ID: <20170324141237.GA14780@gondor.apana.org.au>
References: <20170315182014.29335.93268.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42606 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935816AbdCXONT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20170315182014.29335.93268.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 15, 2017 at 01:20:34PM -0500, Gary R Hook wrote:
> The following series implements new function in a version 5 coprocessor.
> New features are:
>  - Support for SHA-2 384-bit and 512-bit hashing
>  - Support for 3DES encryption
>  - Support for AES GCM encryption
> 
> Changes from V2:
>  - Correct a comment in the GCM support code.
>  - Ensure the patches apply to the current repo

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
