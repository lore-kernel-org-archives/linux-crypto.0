From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Make some CCP DMA channels private
Date: Fri, 24 Mar 2017 22:18:07 +0800
Message-ID: <20170324141807.GM14780@gondor.apana.org.au>
References: <20170323175330.8742.62747.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42772 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935648AbdCXOSV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:18:21 -0400
Content-Disposition: inline
In-Reply-To: <20170323175330.8742.62747.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 23, 2017 at 12:53:30PM -0500, Gary R Hook wrote:
> The CCP registers its queues as channels capable of handling
> general DMA operations. The NTB driver will use DMA if
> directed, but as public channels can be reserved for use in
> asynchronous operations some channels should be held back
> as private. Since the public/private determination is
> handled at a device level, reserve the "other" (secondary)
> CCP channels as private.
> 
> Add a module parameter that allows for override, to be
> applied to all channels on all devices.
> 
> CC: <stable@vger.kernel.org> # 4.10.x-
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
