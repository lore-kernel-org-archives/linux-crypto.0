From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] add support of hardware random generator on
 MediaTek MT7622
Date: Tue, 20 Jun 2017 11:40:10 +0800
Message-ID: <20170620034009.GD17764@gondor.apana.org.au>
References: <cover.1497280813.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        clabbe.montjoie@gmail.com, prasannatsmkumar@gmail.com,
        romain.perier@free-electrons.com, shannon.nelson@oracle.com,
        weiyongjun1@huawei.com, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
To: sean.wang@mediatek.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60894 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdFTDlF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:41:05 -0400
Content-Disposition: inline
In-Reply-To: <cover.1497280813.git.sean.wang@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 12, 2017 at 11:56:53PM +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> Changes since v1:
> - update the bindings with the specific "mediatek,mt7622-rng"
>   instead of the generic one as "mediatek,generic-rng"
> 
> The series add support of hardware RNG on MediaTek MT7622 and
> , runtime PM support and add me as the maintainer for the existing
> and following chipset.
> 
> Sean Wang (3):
>   dt-bindings: rng: add MediaTek MT7622 Hardware Random Generator
>     bindings
>   hwrng: mtk - add runtime PM support
>   MAINTAINERS: add entry for MediaTek Random Number Generator

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
