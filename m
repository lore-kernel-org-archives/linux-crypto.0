Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37486 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeJQORu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:17:50 -0400
Date: Wed, 17 Oct 2018 14:22:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harsh@chelsio.com>
Cc: atul.gupta@chelsio.com, indranil@chelsio.com,
        swise@opengridcomputing.com, varun@chelsio.com,
        ganeshgr@chelsio.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, LinoSanfilippo@gmx.de
Subject: Re: [PATCH v2 1/1]  crypto:chelsio: Update ntx queue received from
 cxgb4
Message-ID: <20181017062228.5xamai4lcxb4ayrq@gondor.apana.org.au>
References: <cover.1539418425.git.harsh@chelsio.com>
 <c9489de40840ee72e9fcc9c5b3e8008592e8dc6d.1539418425.git.harsh@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9489de40840ee72e9fcc9c5b3e8008592e8dc6d.1539418425.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 13, 2018 at 01:46:56PM +0530, Harsh Jain wrote:
> Update cxgb4 to send No. of Tx Queue created in lldinfo struct
> and use the same ntxq in chcr driver.
> 
> This patch depends on following commit
> commit  add92a817e60e308a419693413a38d9d1e663aff
> "Fix memory corruption in DMA Mapped buffers"
> 
> v2:
> Free txq_info in error case as pointed by Lino Sanfilippo.
> 
> Signed-off-by: Harsh Jain <harsh@chelsio.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
