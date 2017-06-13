From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: rng: add MediaTek MT7622 Hardware
 Random Generator bindings
Date: Tue, 13 Jun 2017 11:39:38 +0200
Message-ID: <3f01f336-b2ac-20ee-d984-2f13f7853d1f@gmail.com>
References: <cover.1497280813.git.sean.wang@mediatek.com>
 <89b9b682ff9e294df7cda75787c1439c95ffc992.1497280813.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, keyhaede@gmail.com,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-crypto@vger.kernel.org, weiyongjun1@huawei.com,
        linux-arm-kernel@lists.infradead.org
To: sean.wang@mediatek.com, herbert@gondor.apana.org.au,
        mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        clabbe.montjoie@gmail.com, prasannatsmkumar@gmail.com,
        romain.perier@free-electrons.com, shannon.nelson@oracle.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34486 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdFMJjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 05:39:42 -0400
In-Reply-To: <89b9b682ff9e294df7cda75787c1439c95ffc992.1497280813.git.sean.wang@mediatek.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 12/06/17 17:56, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> Document the bindings used by MediaTek MT7622 SoC hardware random number
> generator.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
>   Documentation/devicetree/bindings/rng/mtk-rng.txt | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> index a6d62a2..366b99b 100644
> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> @@ -2,7 +2,9 @@ Device-Tree bindings for Mediatek random number generator
>   found in Mediatek SoC family
>   
>   Required properties:
> -- compatible	    : Should be "mediatek,mt7623-rng"
> +- compatible	    : Should be
> +			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
> +			"mediatek,mt7623-rng" : for MT7623
>   - clocks	    : list of clock specifiers, corresponding to
>   		      entries in clock-names property;
>   - clock-names	    : Should contain "rng" entries;
> 
