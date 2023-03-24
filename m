Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D57C6FD20
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 12:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCXMBZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjCXMBX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 08:01:23 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3147723C74
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 05:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679659278; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ky6dkT5btkbDfhrLMIy1LGPiIA7szGH81buvm7MNvfSlgknSR29oFoa1DMviJ1s5yx
    47TCbcUEcetaFn5iYFi35kMP3EONSgjfbIdWfUkr4KXDaMLR9MuAewrLa+YxDIza0LYv
    xDKkREPNssaR+3KTPbzBtJeKe0wpd5WJRGMTolsKasfDrBkfc3TyDpDFERPDJ1KeVTR+
    mXm/4L9iTLriBslqzsFXkhVk1LCWRK9Z64SjLLiyJWT7uyQOeLzZHOV8yMaHiv0BNyag
    fhgHLuwqhy1DFbn0tHO0m23EXQXPFYrWggK6DqDcsPptA+yhkIosK9gH9ecnsSRNmG/g
    5tgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679659278;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jUJbwQB3iqjUqj0pnXv+tp6fMxB6gLsRL1oFO6Mx2Nc=;
    b=lVoxYhp6gTJEPAF/HHcCMk/Q9esu6m8RGNE0JcV/2XjapE9I45OyiL7YNTDLyJzLc6
    XDbDVEK3Ipz5YAPvRq/AsbGHMvOD7Iyk/1qPa3CDmFrW+zY/U3RKk5AHxuM45+jIAhMi
    8nX2+6dVnkhnenwp6vEdz5ddzJmwfIX3fpL7IFowkxIh0CmOS+AY3Thcm6sk4tkerJRc
    3jHnlnbygLsGdBXxxXlIjw9TqkLpJxvW71YiL0LtTKLjM5H3KwtJfylb6YsnU5bZQPX4
    aDF9nJVaK91cYspxMJ5DwH29qYvyIXKECm4GlQ+J5ud9/j12moC5GBI4WjBycgXDl34J
    VJtw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679659278;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jUJbwQB3iqjUqj0pnXv+tp6fMxB6gLsRL1oFO6Mx2Nc=;
    b=b+uvwT2Ycr+MAhepwvmIzI6a5bET7/ArgQ+pHskt2Jq/Y1jRpCEjsck/wOCBagp08s
    ansvpdhyoP3Y9YloojYVa3NwHVqNqlVpt5j86vARWS9ryqg9Q1UQZVmMYRCtPyIEBjBi
    xKV2Cdb0DfN32JI2JWpsyos+bJwFCxugfRssyuygtJK9x69NtPSKpo8VX03KhadfDj5s
    7iUwkiMem+qP9KWpebThMJycdL63QgJE3diLHxjibcqxEN4qL2+7hlH426lfEyIStIgW
    XUg7boEG6vVq4SSlD7xzopswPK9DQT35u29mvV7g+KrnhQHCAkaRYQEfmuL2X1qC6GHX
    3LEA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDr2d0uyvAg="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.3.1 DYNA|AUTH)
    with ESMTPSA id u24edez2OC1HdDl
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 24 Mar 2023 13:01:17 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Jitter RNG - Permanent and Intermittent health errors
Date:   Fri, 24 Mar 2023 13:01:16 +0100
Message-ID: <19310206.9zqlukQJUG@tauon.chronox.de>
In-Reply-To: <ZB1tCY3ruqvtWfHS@gondor.apana.org.au>
References: <12194787.O9o76ZdvQC@positron.chronox.de>
 <ZB1tCY3ruqvtWfHS@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 24. M=E4rz 2023, 10:27:37 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 23, 2023 at 08:17:14AM +0100, Stephan M=FCller wrote:
> > @@ -138,29 +139,35 @@ static int jent_kcapi_random(struct crypto_rng *t=
fm,
> >=20
> >  	spin_lock(&rng->jent_lock);
> >=20
> > -	/* Return a permanent error in case we had too many resets in a row. =
*/
> > -	if (rng->reset_cnt > (1<<10)) {
> > +	/* Enforce a disabled entropy source. */
> > +	if (rng->disabled) {
> >=20
> >  		ret =3D -EFAULT;
> >  		goto out;
> >  =09
> >  	}
>=20
> Can we please get rid of this completely when we're not in FIPS
> mode? Remember that jent is now used by all kernel users through
> drbg.  Having it fail permanently in this fashion is unacceptable.
>=20
> If we're not in FIPS mode it should simply carry on or at least
> seek another source of entropy, perhaps from the kernel RNG.

I will remove that from this patch. I plan to release another patch where t=
he=20
oversampling rate will be increased in case of such health errors. This=20
increase in the oversampling rate would handle this issue much more=20
gracefully.

Thanks

Ciao
Stephan


