From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: virtio - Refacotor virtio_crypto driver for new
 virito crypto services
Date: Tue, 18 Jul 2017 18:35:21 +0800
Message-ID: <20170718103521.GC6479@gondor.apana.org.au>
References: <1498231879-3795-1-git-send-email-xin.zeng@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: virtio-dev@lists.oasis-open.org, linux-crypto@vger.kernel.org,
        arei.gonglei@huawei.com
To: Xin Zeng <xin.zeng@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33154 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdGRKf6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:35:58 -0400
Content-Disposition: inline
In-Reply-To: <1498231879-3795-1-git-send-email-xin.zeng@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 11:31:19AM -0400, Xin Zeng wrote:
> In current virtio crypto device driver, some common data structures and
> implementations that should be used by other virtio crypto algorithms
> (e.g. asymmetric crypto algorithms) introduce symmetric crypto algorithms
> specific implementations.
> This patch refactors these pieces of code so that they can be reused by
> other virtio crypto algorithms.
> 
> Acked-by: Gonglei <arei.gonglei@huawei.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
