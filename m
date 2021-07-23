Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBA1C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 09:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D367B60EC0
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 09:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGWJSN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 05:18:13 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:29565 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhGWJSN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 05:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627034327; x=1658570327;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5TPgDp7uu8AWHC8wfoLLt+8jeaJijQ4miv9mRELySmU=;
  b=kTszzSsJ0JddkAORUeQKGOvvlQCFciB3S4Y3TMT59YTxWnCNaNohPWrN
   3d68UKpO0XIiN48e2sCuTuOcb0+MpXSBL5CxnwS2DfWVcbrJbF8w5IiKX
   yVovaXoc2aB1ZDGhDmDZ58QZahmobOAYPuh8FMCaHGzCY2FLX2qM6LQB9
   UnjtfJJm4CnitQgPvWbbMqY/RFTiaWQPpZAXO1iOmSg014Fj2DIepkoc0
   y/xaOMOAgAb8ldpfNEazwMDrAeOYr93RRMhXtv2ix3/LUwPI36LgbYQeB
   qv9nuSHN7b/Haju3paHFwpmLA9PaYY4/7vfLUx6980Yj+fHdsKnFROMiK
   A==;
IronPort-SDR: ccaHjp93TFp/Gshx6VOm+oKEiUGijmGI6Os8r+pDnd/DQGWtM9tEAzR4ZObcjnj2loC7lzk1lz
 srKYTrD82nJiKEoFczTN9TRd/8lAcBDu6EuwxVA5JW8d9JhmZlQKExvCxhj3qrD6wcvmbXAlNP
 BypfRKFfXxX4n6LR+Zo+6N49HtJImGOVEDsBCMRAp3cVWt5CJPIrLpH/Sc2t6+XE/LpiW1BY27
 pnQDeHjk+fE3pXJOW2Wocf7u1Cfbu+70+HEwaxo2ujecdde8kPcS4rB54Zr5YS14jrC2VGCIaS
 FKUQbvty1o1EhVq8ci007LQ1
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="130084760"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 02:58:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 02:58:28 -0700
Received: from [10.12.72.197] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Fri, 23 Jul 2021 02:58:26 -0700
Subject: Re: [RESEND] gpu: ipu-v3: use swap()
To:     Salah Triki <salah.triki@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <gregkh@linuxfoundation.org>,
        "Tudor Ambarus" <Tudor.Ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210722165938.GA4116@pc>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <782cba94-2627-4c22-d445-31686866b722@microchip.com>
Date:   Fri, 23 Jul 2021 11:58:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722165938.GA4116@pc>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wrong $subject then...

On 22/07/2021 at 18:59, Salah Triki wrote:
> Use swap() instead of implementing it in order to make code more clean.
> 
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>   drivers/crypto/atmel-aes.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index b1d286004295..60041022c4f5 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -1819,12 +1819,8 @@ static int atmel_aes_xts_process_data(struct atmel_aes_dev *dd)
>           * the order of the ciphered tweak bytes need to be reversed before
>           * writing them into the ODATARx registers.
>           */
> -       for (i = 0; i < AES_BLOCK_SIZE/2; ++i) {
> -               u8 tmp = tweak_bytes[AES_BLOCK_SIZE - 1 - i];
> -
> -               tweak_bytes[AES_BLOCK_SIZE - 1 - i] = tweak_bytes[i];
> -               tweak_bytes[i] = tmp;
> -       }
> +       for (i = 0; i < AES_BLOCK_SIZE/2; ++i)
> +               swap(tweak_bytes[i], tweak_bytes[AES_BLOCK_SIZE - 1 - i]);
> 
>          /* Process the data. */
>          atmel_aes_write_ctrl(dd, use_dma, NULL);
> --
> 2.25.1
> 


-- 
Nicolas Ferre
