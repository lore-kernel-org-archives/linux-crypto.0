Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F6FC004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C082053B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="BNVmTgi0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGNfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 09:35:06 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:31115 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfEGNfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 09:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557236103;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=YyAEr5bT5nuL1LdgkiF5yZzUGI7WCSaE0218bO4v7l0=;
        b=BNVmTgi0uIg+VGGtj2iTYi3aF5nWf3VBpOZM+HC7P/69XUV2lLleQQ7dt26TTLMQ4E
        gGV0AitZkAfRDz9yTiT2stln59jh5otAvXvac3NtlMKkJV44RT4UwEh1KtQ6ZInYORBb
        yaGPOWeBcoBPBNw+D2fal1bfWQN29bjzDBYjTXLvlsiP+hkCXfxksnKXE88UxOs7A9gT
        YxIpaBNgowTR77egVLpQuw5C5eflyp0e3xRnoVTYUH3mCYUM6RumRZftNwrSBdk6kHVl
        Jnl8eJuDBX7QRXML8gQBY7DmNPjro3nxbJkc8KjCT8hPsyH/Q1f3TKo2o96CePYznM8G
        +agQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs0E0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 AUTH)
        with ESMTPSA id R0373fv47DYp5qG
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 7 May 2019 15:34:51 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Yann Droneaud <ydroneaud@opteya.com>, linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Date:   Tue, 07 May 2019 15:34:50 +0200
Message-ID: <2429866.3tyyabiZt7@tauon.chronox.de>
In-Reply-To: <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
References: <1852500.fyBc0DU23F@positron.chronox.de> <1654549.mqJkfNR9fV@positron.chronox.de> <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 7. Mai 2019, 15:10:38 CEST schrieb Yann Droneaud:

Hi Yann,

> > +	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
> 
> 	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
> 		return 0;

Changed
> 
> > +		unsigned short entropylen = drbg_sec_strength(drbg->core-
>flags);
> > +		int ret = 0;
> > +
> > +		/* skip test if we test the overall system */
> > +		if (list_empty(&drbg->test_data.list))
> > +			return 0;
> > +		/* only perform test in FIPS mode */
> > +		if (!fips_enabled)
> > +			return 0;
> > +
> > +		if (!drbg->fips_primed) {
> > +			/* Priming of FIPS test */
> > +			memcpy(drbg->prev, entropy, entropylen);
> > +			drbg->fips_primed = true;
> > +			/* priming: another round is needed */
> > +			return -EAGAIN;
> > +		}
> > +		ret = memcmp(drbg->prev, entropy, entropylen);
> > +		if (!ret)
> > +			panic("DRBG continuous self test failed\n");
> 
> Previous version from commit b3614763059b ("crypto: drbg - remove FIPS
> 140-2 continuous test") already has it, and so does the "self test" in
> drivers/char/random.c, but do we really want to panic() in the
> unlikely, but still possible, event of a duplicated output from the
> PRNG ? The longer the system is up, the likelier this can happen ... if
> one can wait for the end of the universe :)

Yes, we want that in FIPS mode.

The requirement is that the "crypto module" (i.e. the kernel crypto API) must 
become unavailable if that issue happens.

Commonly this can only be achieved in two ways: either we have a kind of 
global flag that effectively deactivates the kernel crypto API or we terminate 
the kernel.
> 
> > +		memcpy(drbg->prev, entropy, entropylen);
> > +		/* the test shall pass when the two values are not equal */
> > +		return (ret != 0) ? 0 : -EFAULT;
> 
> Here, it's not possible to have ret == 0, since that would panic(), so
> -EFAULT cannot be returned.

Agreed.
> 
> > +	} else {
> > +		return 0;
> > +	}
> > +}
> > +
> > 
> >  /*
> >  
> >   * Convert an integer into a byte representation of this integer.
> >   * The byte representation is big-endian
> > 
> > @@ -1006,16 +1057,23 @@ static void drbg_async_seed(struct work_struct
> > *work)> 
> >  					       seed_work);
> >  	
> >  	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
> >  	unsigned char entropy[32];
> > 
> > +	int ret;
> > 
> >  	BUG_ON(!entropylen);
> >  	BUG_ON(entropylen > sizeof(entropy));
> > 
> > -	get_random_bytes(entropy, entropylen);
> > 
> >  	drbg_string_fill(&data, entropy, entropylen);
> >  	list_add_tail(&data.list, &seedlist);
> >  	
> >  	mutex_lock(&drbg->drbg_mutex);
> > 
> > +	do {
> > +		get_random_bytes(entropy, entropylen);
> > +		ret = drbg_fips_continuous_test(drbg, entropy);
> > +		if (ret && ret != -EAGAIN)
> > +			goto unlock;
> > +	} while (ret);
> > +
> 
> A function doing get_random_bytes() and continous_test() would be
> useful to both sync and async seed function.

Changed

Thanks.

Ciao
Stephan


