From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 7/8] crypto: ecdh - constify key
Date: Mon, 28 Aug 2017 13:34:01 +0300
Message-ID: <cdf29df5-ff6f-3330-0ecb-1d854217c7bd@microchip.com>
References: <2715753.J0rCo2lbig@positron.chronox.de>
 <1694255.qHQGcMPfKl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61718 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1Key (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2017 06:34:54 -0400
In-Reply-To: <1694255.qHQGcMPfKl@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 04/19/2017 02:07 AM, Stephan Müller wrote:
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>   include/crypto/ecdh.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
> index 03a64f6..b5bb149 100644
> --- a/include/crypto/ecdh.h
> +++ b/include/crypto/ecdh.h
> @@ -40,7 +40,7 @@
>    */
>   struct ecdh {
>   	unsigned short curve_id;
> -	char *key;
> +	const char *key;
>   	unsigned short key_size;
>   };
>   
> 

I just came across this and remembered that Stephan already
made a patch, so:

Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
