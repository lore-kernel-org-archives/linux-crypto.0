From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 0/4] clean some ecc functions
Date: Fri, 12 May 2017 12:41:59 +0300
Message-ID: <8e121b39-d90e-7410-aa25-79db995295fb@microchip.com>
References: <1494405649-30322-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:29364 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdELJmE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 05:42:04 -0400
In-Reply-To: <1494405649-30322-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore this patch set. I will send all the changes in a new
patch set.

On 10.05.2017 11:40, Tudor Ambarus wrote:
> ecc software implementation works with chunks of u64 data. There were some
> unnecessary casts to u8 and then back to u64 for the ecc keys. Remove the
> unncessary casts.
>
> Tudor Ambarus (4):
>   crypto: ecc - remove unused function arguments
>   crypto: ecc - remove casts in ecdh_make_pub_key
>   crypto: ecc - remove casts in crypto_ecdh_shared_secret
>   crypto: ecc - remove casts in ecc_is_key_valid
>
>  crypto/ecc.c  | 30 +++++++++++++-----------------
>  crypto/ecc.h  | 15 ++++-----------
>  crypto/ecdh.c | 12 +++++-------
>  3 files changed, 22 insertions(+), 35 deletions(-)
>
