From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] hwrng: mtk: add support for hardware random
 generator on MT7623 SoC
Date: Fri, 21 Apr 2017 21:16:53 +0800
Message-ID: <20170421131653.GI14803@gondor.apana.org.au>
References: <1492705466-27287-1-git-send-email-sean.wang@mediatek.com>
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
Received: from [198.176.57.175] ([198.176.57.175]:42978 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1035781AbdDUNSO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:18:14 -0400
Content-Disposition: inline
In-Reply-To: <1492705466-27287-1-git-send-email-sean.wang@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 12:24:24AM +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> This patchset introduces support for Mediatek hardware random generator (RNG)
> Currently, the driver is already tested successfully with rng-tools on MT7623
> SoC. And it should also be workable on other similar Mediatek SoCs.
> 
> Changes since v1:

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
