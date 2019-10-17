Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8490BECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 15:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E02C20872
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 15:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KoI2j82P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406249AbfJQPSW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 11:18:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43298 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405685AbfJQPSW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 11:18:22 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20191017151819euoutp01fb981d143cb42b8ab4caece64e472656~OeDeG2WOK1440014400euoutp01h
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 15:18:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20191017151819euoutp01fb981d143cb42b8ab4caece64e472656~OeDeG2WOK1440014400euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571325499;
        bh=b58jRUiLzLvFOzzV75NY0MJsBJnVwcCEZB0VgXzKFqY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=KoI2j82PLGh1wg7sLUblTVfMbdBsxsEe+GQe5RdgeTZMD3804mt/bg3MVUPMuPp1F
         kCL2TxCs98le9x4d8WLc0fMuer7Vwtv2dov25EBG6dUlBHoQDGl7NOgVejEqMEKkOA
         aKMgP/LBW8YO8eywblDBA8LKb/z5dT6AhfYdoTGs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191017151819eucas1p23f6db447f5d15df979b3c508469b776c~OeDd177R12006720067eucas1p2O;
        Thu, 17 Oct 2019 15:18:19 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 00.DA.04469.B3688AD5; Thu, 17
        Oct 2019 16:18:19 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191017151819eucas1p174dff9a7d813114dc62b8fa6eda42a46~OeDdktV9G3273232732eucas1p1N;
        Thu, 17 Oct 2019 15:18:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191017151819eusmtrp2b9a32bcb61e1aaf65d1c50301fe23ace~OeDdkFq2T0061800618eusmtrp28;
        Thu, 17 Oct 2019 15:18:19 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-f6-5da8863b5125
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9F.00.04117.B3688AD5; Thu, 17
        Oct 2019 16:18:19 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191017151818eusmtip1ec4b79ccaa04c600121e918e6c9c70ca~OeDdEM3-82563425634eusmtip1P;
        Thu, 17 Oct 2019 15:18:18 +0000 (GMT)
Subject: Re: [PATCH 07/25] crypto: s5p - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <c07712f3-dea5-7953-82a0-706c1fe0e5d6@samsung.com>
Date:   Thu, 17 Oct 2019 17:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014121910.7264-8-ard.biesheuvel@linaro.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+7Ldh1OrtPaSaNsMKJJWiR1K9GkPtyoD9aHiMLy1m4qzZd2
        nZoWKcrKGWYRVsNSIUotSqeYL2O5ZQ6LJhpI9mppb9LCmhL2tna9SX77Pef8z3P+fzgUruoj
        I6iMrFzemMUZNDIF0d4341m1ydyQsrpsKIrxT3YjpmagjGAGb5aRTMXEEqbS4UfMwECznLGN
        DZPM61czGHNpwIEx/h+l+GYF29Y4grHtPVq2zmZibU3lMvbFsF3Gtl47yf6pv0Cwzi92jPXZ
        liYH7VXE63lDRh5vjE1IVaRXO2tlOeZFBY1Vt1AxehtqQUEU0HHQY7+Oi6yiGxAMN7MWpAjw
        FIIqZzeSGj4Epb5tcwON1YOkJLqBwPPEJZMeXgRjJSOEBVFUGJ0Iz0YxEcPpHTDUrxYlOO3G
        wNpYSYofyehYcD7uJ0RW0gnwuNs764KgtVD+0iEXZxfSe+DRNCdJQqH/8visPCggHzFXyEXG
        aTU8G6/FJF4Gd701uLgL6FdyKPedwSTTW6Gp1CqTOAwm3G1yiZeAv7P2nyYf3tVXyqXhMgSj
        p74SUmMT3HeLianAhpVwpytWKifBr67qWZ9Ah8BTb6jkIQTOt1/EpbISTptVkloLHx7OuYkE
        i/82WYU01nnJrPPSWOelsf7fW4eIJqTmTUJmGi+syeLzYwQuUzBlpcUcys60ocB1Pfrj/taB
        pocOuhBNIU2wsiO5IUVFcnnCsUwXAgrXhCvxwkBJqeeOFfLG7ANGk4EXXCiSIjRqZdGC0X0q
        Oo3L5Y/wfA5vnOtiVFBEMdJm6w0r7CMfN2yUO9pbNuj63vVc2dVcMKY/nF/Zu+7SibXfXxw/
        X3xv+fZPVxN9uo6iUa9r/eJCP/MktSTbFUzG7fZEW8wkMr6POjpl2v9GPdkS3nl2528qsubG
        A+y9Tp80mBev9YyntMa6e39+v3ozLro7JPfl6i3Pz+V8c31eN6khhHRujQ43CtxfcvtoIFkD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xu7rWbStiDU6t4rb4/2E3o8Wc8y0s
        FhdXt7BadL+Ssejb95/R4vz5DewWmx5fY7W4f+8nk8WM8/uYLP7/amZ24PLYsvImk8e2A6oe
        CzaVemxa1cnmcefaHjaPzUvqPf4tnMLicfDdHiaPz5vkAjij9GyK8ktLUhUy8otLbJWiDS2M
        9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DKmHZzPVtAmVrFywhrGBsZHgl2MnBwS
        AiYSK6ddZO1i5OIQEljKKDHn4hQWiIS0ROPp1UwQtrDEn2tdbBBFrxklJny5AORwcAgL2Evc
        esAEYooI+EhcOikOUsIscJJJon3dHbBeIYGjjBL9r2RBbDYBfYmDZ0+CzecVsJM4u/stM4jN
        IqAq0Xl3HzuILSoQIfF8+w1GiBpBiZMzn4DVcwLV32zrBqthFlCX+DPvEjOELS5x68l8Jghb
        XmL72znMExiFZiFpn4WkZRaSlllIWhYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQIjNht
        x35u2cHY9S74EKMAB6MSD++OgBWxQqyJZcWVuYcYJTiYlUR4mauAQrwpiZVVqUX58UWlOanF
        hxhNgZ6byCwlmpwPTCZ5JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNTUwtSi2D6mDg4
        pRoYN3ycK8n8aP7HOj7DiMP8sl8yTG9c73QzOlZq7L75kkze/8WmvxzEdmrt2T/HiathZVGH
        jPop1dtCxru25nQ6V20y+cKnY1Qj8zNvklLDy4h/N8R+SxrNWSS//M3thIx7f0rM7xndPTXh
        c0i+XMODp2yxGecXfYt/ZbL5q6S2ijR7mJlS3jleJZbijERDLeai4kQAccrNH+4CAAA=
X-CMS-MailID: 20191017151819eucas1p174dff9a7d813114dc62b8fa6eda42a46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191014121950epcas4p18dbe227632fbee9b09f322d80deeb1c1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191014121950epcas4p18dbe227632fbee9b09f322d80deeb1c1
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
        <CGME20191014121950epcas4p18dbe227632fbee9b09f322d80deeb1c1@epcas4p1.samsung.com>
        <20191014121910.7264-8-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 14.10.2019 14:18, Ard Biesheuvel wrote:
> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> dated 20 august 2015 introduced the new skcipher API which is supposed to
> replace both blkcipher and ablkcipher. While all consumers of the API have
> been converted long ago, some producers of the ablkcipher remain, forcing
> us to keep the ablkcipher support routines alive, along with the matching
> code to expose [a]blkciphers via the skcipher API.
> 
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.
> 
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

There are comments for hash functions changed, see below.
With that fixed, you can add my

Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
Tested-by: Kamil Konieczny <k.konieczny@samsung.com>

>  drivers/crypto/s5p-sss.c | 191 ++++++++++----------
>  1 file changed, 91 insertions(+), 100 deletions(-)
>  [...]
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 010f1bb20dad..e6f1d4d5186c 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> [...]
> @@ -660,7 +660,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
>  {
>  	struct platform_device *pdev = dev_id;
>  	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
> -	struct ablkcipher_request *req;
> +	struct skcipher_request *req;
>  	int err_dma_tx = 0;
>  	int err_dma_rx = 0;
>  	int err_dma_hx = 0;

These two comments below should not be touched, they are for hash part.

> @@ -1208,7 +1208,7 @@ static int s5p_hash_prepare_sgs(struct s5p_hash_reqctx *ctx,
>   *
>   * Note 1: we can have update flag _and_ final flag at the same time.
>   * Note 2: we enter here when digcnt > BUFLEN (=HASH_BLOCK_SIZE) or
> - *	   either req->nbytes or ctx->bufcnt + req->nbytes is > BUFLEN or
> + *	   either req->cryptlen or ctx->bufcnt + req->cryptlen is > BUFLEN or
>   *	   we have final op
>   */
>  static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
> @@ -1555,7 +1555,7 @@ static int s5p_hash_final_shash(struct ahash_request *req)
>   * s5p_hash_final() - close up hash and calculate digest
>   * @req:	AHASH request
>   *
> - * Note: in final req->src do not have any data, and req->nbytes can be
> + * Note: in final req->src do not have any data, and req->cryptlen can be
>   * non-zero.
>   *
>   * If there were no input data processed yet and the buffered hash data is
> [...]

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

