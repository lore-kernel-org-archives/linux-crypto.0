Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BD6C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1A42087C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FDGsK4pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgIDJHJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:07:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53583 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbgIDJHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:07:08 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200904090707euoutp024025de61729c42c3b0c24d129823f688~xiWkUxsA21431414314euoutp02K
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 09:07:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200904090707euoutp024025de61729c42c3b0c24d129823f688~xiWkUxsA21431414314euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599210427;
        bh=IqE/ZCuueqw+2/m8cMT/uCjm2LtVAnNylq3DpnDKyPg=;
        h=Subject:To:From:Date:In-Reply-To:References:From;
        b=FDGsK4pjEDZn9FRgBXtypWSRITRkzYY32TA3Axcx1QkpPcEY6EaRb6Il7VZ+tbfFg
         v0EqEvx8ud+DZQ1w/G3eXUcyWlw47vQm/vAvKI1ho+o29Tv39/9Rx17mzmnxuthgUp
         47gCqK48q6MLcMiVyWGv4fHv/9RVwCWi1S0N3eCk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200904090706eucas1p15b9050bdbcd7ed018ff84cd21bef5a30~xiWkFWp8L3161631616eucas1p1f;
        Fri,  4 Sep 2020 09:07:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 23.02.06318.AB3025F5; Fri,  4
        Sep 2020 10:07:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200904090706eucas1p10c262692b3d884aabf0a8f92fb82adf3~xiWjumMab1986019860eucas1p1g;
        Fri,  4 Sep 2020 09:07:06 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200904090706eusmtrp28b73170824226c71212a2027a01c1d06~xiWjtl6340660706607eusmtrp2c;
        Fri,  4 Sep 2020 09:07:06 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-7a-5f5203ba81c5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 08.D9.06017.AB3025F5; Fri,  4
        Sep 2020 10:07:06 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200904090705eusmtip1a09c33a3c811e85e75200f8ff4f9b080~xiWjNmJ6j1726517265eusmtip1C;
        Fri,  4 Sep 2020 09:07:05 +0000 (GMT)
Subject: Re: [PATCH 2/3] crypto: s5p-sss - Add and fix kerneldoc
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <ad460c31-aa10-21a8-2fd9-698d5a7ca823@samsung.com>
Date:   Fri, 4 Sep 2020 11:07:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903180400.2865-2-krzk@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRj2O+dsO44mx6n5olK28kdFmlh0sBCTfizMEIsyQ9fKk442lc17
        f6bmNcG75hQsIWziPVtqKbpmoksXBGUlKWgsB1JeijRtbTtK/nve58L3PPCRuPAZx4uUJaUy
        yiSpXMTlE7rX66ZjA3iU5Pjj2kC60XSPoJsMUxz6vsWHNpm6ePTsl3WMfjfQyKUfmIYwOn/Q
        wKOtG3l4qLO4V/sRE+uG/cQ9rcVc8d9H1YR4tWdfJCeGfyaekcvSGWVAyA1+Ym5tISelySNz
        vuotoUY1riXImQTqBKgn+vASxCeF1BMExpbfiD3WEBR1m7eVVQTa+RW0EynqmiJYoQVBQUUn
        lz2WEGy9/IHbXW5UKJjbLBy74E4ZMGg3F3DsApcKgJHJccKOBVQIVHxWO3iCOgTWkQZH2IO6
        Bv1fF3msxxXG6xccfmfb0y0zRQ4/TnnCp4UmjMX74flSo6MrUDoedGj6eWzXc6D7MESw2A0s
        Y73bvA9Y++1heyDPNltdw2OPUgSDa71c1nUaVpeHbZi0PXEYOgcCWPosaJ9uOWigXGB6yZUt
        4QKVujqcpQVQVCBk3X5gnijFWOwNJdYODovFUJ6Ti8rRAc2umZpd0zS7pmn+d3iIiFbkyaSp
        FAmMKiiJyfBXSRWqtKQE/1vJih5k+0zGv2M/+9DQ5k09okgk2iOY/h4pEXKk6aoshR4BiYvc
        BWGTxjihIF6alc0okyXKNDmj0iNvkhB5CoKaF2OFVII0lbnDMCmMckfFSGcvNWrX3i3T+je3
        QbBU0j0saonJj9iyzBlLhJ5UDhaXvzlyKTq2OEgxe0Hu++d2Zeb7U6OzJ33H+bPh8kHJ/Fy2
        l2xz5kXHcmFZad2v8Kiwg9edjlLRvhFWLNjJZbHKdWPvWMN0/dUU5uKby27VshVdxtzg6HJH
        A2Bz59u/XdEbXokIVaI08AiuVEn/ATRzVthIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t/xu7q7mIPiDfZdFLOYc76FxWL+kXOs
        Ft2vZCzOn9/AbnH/3k8mi8u75rBZzDi/j8mide8Rdov/v5qZHTg9tqy8yeSx7YCqx6ZVnWwe
        /xZOYfH4vEkugDVKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSez
        LLVI3y5BL6NpWjtrwXzRiseTL7A0ME4V7GLk5JAQMJHo2HCOpYuRi0NIYCmjxKRpv9khEtIS
        jadXM0HYwhJ/rnWxQRS9ZpRYe2IHC0hCWMBB4vmaV6wgCRGBI0wS62c+Z4Ko2sgosXD+GbAq
        NgF9iYNnT4LZvAJ2EhNvN7CC2CwCKhL/D85m7mLk4BAViJTYucMSokRQ4uTMJ2DlnEDnLb/T
        AVbOLKAu8WfeJWYIW1zi1pP5TBC2vMT2t3OYJzAKzkLSPgtJyywkLbOQtCxgZFnFKJJaWpyb
        nltspFecmFtcmpeul5yfu4kRGG/bjv3csoOx613wIUYBDkYlHt4b7wPihVgTy4orcw8xSnAw
        K4nwOp09HSfEm5JYWZValB9fVJqTWnyI0RTot4nMUqLJ+cBUkFcSb2hqaG5haWhubG5sZqEk
        ztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgVGITcWA5yd/zOQnl/6kOXNb7BJQ3b9w3y3RIn+W
        DtXUM/daNFdJZZd5LHLnvZG66e+mj6Wvvubev922a4/VGilJp+sPjsX8Ts67Wywhply0on7J
        57/cH7/8L67vKFY7+ZbTxfevXfSiswmfLALzO9eJXl6bWue47tdVwT0r+TlZLtnx2gkXfFBi
        Kc5INNRiLipOBAB6QgkFzQIAAA==
X-CMS-MailID: 20200904090706eucas1p10c262692b3d884aabf0a8f92fb82adf3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200903180416eucas1p224f764a13664b5444cb3c00fca84c369
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200903180416eucas1p224f764a13664b5444cb3c00fca84c369
References: <20200903180400.2865-1-krzk@kernel.org>
        <CGME20200903180416eucas1p224f764a13664b5444cb3c00fca84c369@eucas1p2.samsung.com>
        <20200903180400.2865-2-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/3/20 8:03 PM, Krzysztof Kozlowski wrote:
> Add missing and fix existing kerneldoc to silence W=1 warnings:
> 
>   drivers/crypto/s5p-sss.c:333: warning: Function parameter or member 'pclk' not described in 's5p_aes_dev'
>   drivers/crypto/s5p-sss.c:373: warning: Function parameter or member 'sgl' not described in 's5p_hash_reqctx'
>   drivers/crypto/s5p-sss.c:373: warning: Function parameter or member 'buffer' not described in 's5p_hash_reqctx'
>   drivers/crypto/s5p-sss.c:1143: warning: Function parameter or member 'new_len' not described in 's5p_hash_prepare_sgs'
>   drivers/crypto/s5p-sss.c:1143: warning: Excess function parameter 'nbytes' description in 's5p_hash_prepare_sgs'
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/s5p-sss.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 341433fbcc4a..f67f1e22ecd1 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -260,6 +260,7 @@ struct s5p_aes_ctx {
>   * struct s5p_aes_dev - Crypto device state container
>   * @dev:	Associated device
>   * @clk:	Clock for accessing hardware
> + * @pclk:	APB bus clock necessary to access the hardware
>   * @ioaddr:	Mapped IO memory region
>   * @aes_ioaddr:	Per-varian offset for AES block IO memory
>   * @irq_fc:	Feed control interrupt line
> @@ -342,13 +343,13 @@ struct s5p_aes_dev {
>   * @engine:	Bits for selecting type of HASH in SSS block
>   * @sg:		sg for DMA transfer
>   * @sg_len:	Length of sg for DMA transfer
> - * @sgl[]:	sg for joining buffer and req->src scatterlist
> + * @sgl:	sg for joining buffer and req->src scatterlist
>   * @skip:	Skip offset in req->src for current op
>   * @total:	Total number of bytes for current request
>   * @finup:	Keep state for finup or final.
>   * @error:	Keep track of error.
>   * @bufcnt:	Number of bytes holded in buffer[]
> - * @buffer[]:	For byte(s) from end of req->src in UPDATE op
> + * @buffer:	For byte(s) from end of req->src in UPDATE op
>   */
>  struct s5p_hash_reqctx {
>  	struct s5p_aes_dev	*dd;
> @@ -1125,7 +1126,7 @@ static int s5p_hash_copy_sg_lists(struct s5p_hash_reqctx *ctx,
>   * s5p_hash_prepare_sgs() - prepare sg for processing
>   * @ctx:	request context
>   * @sg:		source scatterlist request
> - * @nbytes:	number of bytes to process from sg
> + * @new_len:	number of bytes to process from sg
>   * @final:	final flag
>   *
>   * Check two conditions: (1) if buffers in sg have len aligned data, and (2)
> 

Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
Acked-by: Kamil Konieczny <k.konieczny@samsung.com>

