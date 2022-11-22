Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B990C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiKVKZZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiKVKY4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:24:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF37912AE8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:22:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E29BB819D6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 10:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C0EC433D6;
        Tue, 22 Nov 2022 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669112558;
        bh=H/s0YY6Nqh5hcAyWsUutldDo2QE+Z110LD9Bv0I4A5A=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=dgcHhF+ZT9j21//JZ0WGKvg8fTRyvO267NhE8dWNlTeUqbWahnXgUG+PT0XWuzutg
         HXo0Qq5l1INo4GqKdMukjdXTvh1/81IFOoS5IOLToNs2+dbbstbJDfNUumuSXejEYC
         ByaEvmmokYC/7585o7t1W8Kk8uh9OAzUR07awgm8eb5jPJ8QZLdbwGD4KOeVU0n/1x
         cjZ0q6GWP3NYfo6mfVCkwkgFIimxDNRwPzP4UIRKDQcpKvxjx2PnHi38rmpKSM/HZy
         hES1X/IxYsfgMq2Gwgxe1Drx4hzbm6aBdcx7N9Aao4eBsYFRAV0uOF6ZZ85rMtR3Jp
         ehPHbRK7CQV6Q==
Date:   Tue, 22 Nov 2022 11:22:37 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: Re: [PATCH] hwrng: u2fzero - account for high quality RNG
In-Reply-To: <20221119134259.2969204-1-Jason@zx2c4.com>
Message-ID: <nycvar.YFH.7.76.2211221122220.6045@cbobk.fhfr.pm>
References: <20221119134259.2969204-1-Jason@zx2c4.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 19 Nov 2022, Jason A. Donenfeld wrote:

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

Good catch, thanks Jason. Applied.

-- 
Jiri Kosina
SUSE Labs

