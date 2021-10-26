Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168C6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BC860F70
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJZJNj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:13:39 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:10608 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbhJZJNb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 05:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635239105;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bwI0EMSDhui3G9nAXrRR/fGiIoa7r45zPTa6qOOeZ2k=;
    b=dNt8Trs9NhitRLKz03siCjqYBQETacWBo4DrKsIKc9lcwo/mjNuBLwf0C09Wr37S6P
    X6yGeHxf81t10EO3l78ZZdMlVES8uLuGRJi02yPrMJWhctbCAjzXtN8wsTLyHPyizhJu
    J0GOfLvjvFU+SwIpP0PLgSGrL5EJ10Bn8TVHUrdsuAo9pgAWT9JVCyFANnhF9mP85fbr
    k2jwopyOyRI/Kp8vFKYf0uwEOSDdeyEg/Ts+j7Hj6PsW+SmGDn+sXEVIasXjq5zA3qkL
    L95UpgAAhvKbMk9FpX8z/ZyhGFpTAPwIAnoxETGBubVRlK9I3z3V75td74pSh+4s3sAJ
    508g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q9542DE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 11:05:04 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 3/6] crypto: DRBG - move dynamic ->reseed_threshold adjustments to __drbg_seed()
Date:   Tue, 26 Oct 2021 11:05:03 +0200
Message-ID: <2442182.SrK068eSPn@positron.chronox.de>
In-Reply-To: <20211025092525.12805-4-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-4-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:22 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Since commit 42ea507fae1a ("crypto: drbg - reseed often if seedsource is
> degraded"), the maximum seed lifetime represented by ->reseed_threshold
> gets temporarily lowered if the get_random_bytes() source cannot provide
> sufficient entropy yet, as is common during boot, and restored back to
> the original value again once that has changed.
>=20
> More specifically, if the add_random_ready_callback() invoked from
> drbg_prepare_hrng() in the course of DRBG instantiation does not return
> -EALREADY, that is, if get_random_bytes() has not been fully initialized
> at this point yet, drbg_prepare_hrng() will lower ->reseed_threshold
> to a value of 50. The drbg_async_seed() scheduled from said
> random_ready_callback will eventually restore the original value.
>=20
> A future patch will replace the random_ready_callback based notification
> mechanism and thus, there will be no add_random_ready_callback() return
> value anymore which could get compared to -EALREADY.
>=20
> However, there's __drbg_seed() which gets invoked in the course of both,
> the DRBG instantiation as well as the eventual reseeding from
> get_random_bytes() in aforementioned drbg_async_seed(), if any. Moreover,
> it knows about the get_random_bytes() initialization state by the time the
> seed data had been obtained from it: the new_seed_state argument introduc=
ed
> with the previous patch would get set to DRBG_SEED_STATE_PARTIAL in case
> get_random_bytes() had not been fully initialized yet and to
> DRBG_SEED_STATE_FULL otherwise. Thus, __drbg_seed() provides a convenient
> alternative for managing that ->reseed_threshold lowering and restoring at
> a central place.
>=20
> Move all ->reseed_threshold adjustment code from drbg_prepare_hrng() and
> drbg_async_seed() respectively to __drbg_seed(). Make __drbg_seed()
> lower the ->reseed_threshold to 50 in case its new_seed_state argument
> equals DRBG_SEED_STATE_PARTIAL and let it restore the original value
> otherwise.
>=20
> There is no change in behaviour.
>=20
> Signed-off-by: Nicolai Stange <nstange@suse.de>

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan


