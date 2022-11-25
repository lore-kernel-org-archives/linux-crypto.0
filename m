Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD04C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiKYJtx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiKYJsR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:48:17 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D13F044
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 01:46:56 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVIL-000i0D-6P; Fri, 25 Nov 2022 17:46:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:46:53 +0800
Date:   Fri, 25 Nov 2022 17:46:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] hwrng: u2fzero - account for high quality RNG
Message-ID: <Y4CPDQqYLOdOWutt@gondor.apana.org.au>
References: <20221119134259.2969204-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119134259.2969204-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 19, 2022 at 02:42:59PM +0100, Jason A. Donenfeld wrote:
> The U2F zero apparently has a real TRNG in it with maximum quality, not
> one with quality of "1", which was likely a misinterpretation of the
> field as a boolean. So remove the assignment entirely, so that we get
> the default quality setting.
> 
> In the u2f-zero firmware, the 0x21 RNG command used by this driver is
> handled as such [1]:
> 
>   case U2F_CUSTOM_GET_RNG:
>     if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
>       NULL, 0,
>       appdata.tmp,
>       sizeof(appdata.tmp), &res) == 0 )
>     {
>       memmove(msg->pkt.init.payload, res.buf, 32);
>       U2FHID_SET_LEN(msg, 32);
>       usb_write((uint8_t*)msg, 64);
>     }
>     else
>     {
>       U2FHID_SET_LEN(msg, 0);
>       usb_write((uint8_t*)msg, 64);
>     }
> 
> This same call to `atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,
> ATECC_RNG_P2,...)` is then also used in the token's cryptographically
> critical "u2f_new_keypair" function, as its rather straightforward
> source of random bytes [2]:
> 
>   int8_t u2f_new_keypair(uint8_t * handle, uint8_t * appid, uint8_t * pubkey)
>   {
>     struct atecc_response res;
>     uint8_t private_key[36];
>     int i;
> 
>     watchdog();
> 
>     if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
>       NULL, 0,
>       appdata.tmp,
>       sizeof(appdata.tmp), &res) != 0 )
>     {
>       return -1;
>     }
> 
> So it seems rather plain that the ATECC RNG is considered to provide
> good random numbers.
> 
> [1] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/custom.c
> [2] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/u2f_atecc.c
> 
> Cc: Andrej Shadura <andrew.shadura@collabora.co.uk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/hid/hid-u2fzero.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
