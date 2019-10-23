Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF3CCA9EAE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713AD21920
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571806321;
	bh=47Z1H/p0N2jcwU/x4IbEzZERiJ51lQQcZJ0FyZl862Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eKk7j55fA0wE9S0EF03Lej4KXQhWIWf3BeFAjdyRsGC5W8VmSed4SwP42bijT5GP/
	 H9M/UBm369zFqT7iaYtwmwoFz2D4HRyg8Mm/rn4oAXoZ9R/wEfNfu3RXKRIGkIFrK1
	 oH8/JgUy20Mw5BiGhfgVBqNRXa7nCDZzsMshbra8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbfJWEwA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 00:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733132AbfJWEwA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 00:52:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D23B82173B;
        Wed, 23 Oct 2019 04:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571806319;
        bh=47Z1H/p0N2jcwU/x4IbEzZERiJ51lQQcZJ0FyZl862Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DLTytyko2pm1pyusZU+r1+PMj9jpPQzR603MVJjmNAawSR+2RpQVRggV/Q+nxOUqZ
         c/yJWfIVeZBtfRtegsyZh6fot3dR29pLnegCt0BTTU8Pz6ikk0xQzObwzvzpjQMVin
         v4rXcdS+PcBTcIcENraXOa/9CIBTs6OeRa+4uu60=
Date:   Tue, 22 Oct 2019 21:51:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 22/35] crypto: BLAKE2s - generic C library
 implementation and selftest
Message-ID: <20191023045157.GB361298@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-23-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-23-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:09:19PM +0200, Ard Biesheuvel wrote:
> diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
> new file mode 100644
> index 000000000000..7ba00fcc6b60
> --- /dev/null
> +++ b/lib/crypto/blake2s-selftest.c
> @@ -0,0 +1,2093 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <crypto/blake2s.h>
> +#include <linux/string.h>
> +
> +static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
[...]
> +bool __init blake2s_selftest(void)
> +{
> +	u8 key[BLAKE2S_KEY_SIZE];
> +	u8 buf[ARRAY_SIZE(blake2s_testvecs)];
> +	u8 hash[BLAKE2S_HASH_SIZE];
> +	size_t i;
> +	bool success = true;
> +
> +	for (i = 0; i < BLAKE2S_KEY_SIZE; ++i)
> +		key[i] = (u8)i;
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i)
> +		buf[i] = (u8)i;
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_keyed_testvecs); ++i) {
> +		blake2s(hash, buf, key, BLAKE2S_HASH_SIZE, i, BLAKE2S_KEY_SIZE);
> +		if (memcmp(hash, blake2s_keyed_testvecs[i], BLAKE2S_HASH_SIZE)) {
> +			pr_err("blake2s keyed self-test %zu: FAIL\n", i + 1);
> +			success = false;
> +		}
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i) {
> +		blake2s(hash, buf, NULL, BLAKE2S_HASH_SIZE, i, 0);
> +		if (memcmp(hash, blake2s_testvecs[i], BLAKE2S_HASH_SIZE)) {
> +			pr_err("blake2s unkeyed self-test %zu: FAIL\n", i + i);
> +			success = false;
> +		}
> +	}
> +	return success;
> +}

The only tests here are for blake2s(), with 0 and 32-byte keys.  There's no
tests that incremental blake2s_update()s work correctly, nor any other key
sizes.  And these don't get tested properly by the blake2s-generic shash tests
either, because blake2s-generic has a separate implementation of the boilerplate
and calls blake2s_compress_generic() directly.  Did you consider implementing
blake2s-generic on top of blake2s_init/update/final instead?

Also, blake2s_hmac() needs tests.

- Eric
