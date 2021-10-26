Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0100C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D1F560F90
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhJZJWS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:22:18 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:33206 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhJZJWR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 05:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635239993;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=uELOwsNFWYKP2V7Wa6W8kc6bDK33Uy/EkAiJWP509lU=;
    b=Dl0l3ABqDyxjoiCnEg1DpmEJi9Nb5DTzmG+7B+wnnDBjBHbHq+voYLTsLhuTGKccS2
    VbE41N+YeI3/c0J0MqTNO9MzwoAYiU3rQCNEuia7U2WJBxqr+1vBn5mVh7WQ4U/GiUdy
    yvavfpqnRSL4BTPNEQnDvJywnJW+qfhMW34vHnnVLF/wpXDa2EfPdQPLgJdc5++P+HV3
    EJTBPDnO/0zBmmrOgudTRnGG4i0URYPNRA03/QDg6KSwYl+YBLmT5KJ6SWaunVt/icm/
    10m9OYFEIbzMatuQe5KalYB0ZPcW2OSvBEApLj4Q0fiCf5CXQI7LK3NG0y/wP6lmVTRm
    zVlg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q9Jq2Ia
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 11:19:52 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 5/6] crypto: DRBG - make drbg_prepare_hrng() handle jent instantiation errors
Date:   Tue, 26 Oct 2021 11:19:52 +0200
Message-ID: <5005897.YiOf5ahdoa@positron.chronox.de>
In-Reply-To: <20211025092525.12805-6-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-6-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:24 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Now that drbg_prepare_hrng() doesn't do anything but to instantiate a
> jitterentropy crypto_rng instance, it looks a little odd to have the
> related error handling at its only caller, drbg_instantiate().
>=20
> Move the handling of jitterentropy allocation failures from
> drbg_instantiate() close to the allocation itself in drbg_prepare_hrng().
>=20
> There is no change in behaviour.
>=20
> Signed-off-by: Nicolai Stange <nstange@suse.de>

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan


