Return-Path: <SRS0=RoNa=TC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96D5C43219
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 12:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB6822075E
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 12:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ptku6ZYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBMtm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 08:49:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:13316 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBMtm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 08:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1556801380;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=l2aozwNKZt6ALbSP7KS2KRjV2UoRxdXSKdnuI0wvFNw=;
        b=ptku6ZYjlIpp5JOXTUJDRkGqsefwqTvaYkdG8GX+8HmeNZGXdspqc1cS5NKvXTdZke
        mLpkDOJqdfn0O1wnDDxFKX4WVg5M88Co6Rl1bIeYy0ebsAYR34MaX6BFOtFKovq70rDL
        Z1MRcXzK+5pRwk1wntGV/Qo34LHP3+nGfTT9NeZzJqUWgRflYBXgFvfnxqNECGM8n+I0
        A6C+i2yb56RaARgkBwbDtMXI/wyP87vay11IqfiGVTvaEssv/KrYFWLpiHgRN8zYggHb
        3YYCIurdJ3rkTiFRl4uMHQHAzD93mClMsg6LDiwUXd+u5OfaPPlNfJqVGguWS4KjAOqG
        5ZFw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSd/cc="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv42CneikG
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 2 May 2019 14:49:40 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Date:   Thu, 02 May 2019 14:49:40 +0200
Message-ID: <3628280.V02LyGYBHa@tauon.chronox.de>
In-Reply-To: <20190502124811.l4yozv4llqtdvozx@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de> <20190502124811.l4yozv4llqtdvozx@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 2. Mai 2019, 14:48:11 CEST schrieb Herbert Xu:

Hi Herbert,

> Hi Stephan:
>=20
> On Thu, May 02, 2019 at 02:40:51PM +0200, Stephan M=FCller wrote:
> > +static int drbg_fips_continuous_test(struct drbg_state *drbg,
> > +				     const unsigned char *entropy)
> > +{
> > +#ifdef CONFIG_CRYPTO_FIPS
>=20
> Please use the IS_ENABLED macro from linux/kconfig.h so that all
> of the code gets compiler coverage.

Will do.
>=20
> Thanks,



Ciao
Stephan


