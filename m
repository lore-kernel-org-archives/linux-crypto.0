Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7388DECAAD3
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 08:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiIGIsf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIGIsc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 04:48:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70FCA7AA2
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 01:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3A62B81ADB
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 08:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3BDC433C1;
        Wed,  7 Sep 2022 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662540501;
        bh=DSSlvyJIYaiZo3JTisnVqvW/vHgnYFMuYvuJZHk/g/M=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=gPvkPgz4c19RDsKuXnB3QgYzLDkfJmbwYqK/H3xakVqFP7j6ALR9Sw0Uz7Urf+grJ
         VynDcvKAXAmpkS/i22LXfMxXxylNc6YtpZ472iKMjLKGRvTqQLKmPJJYnGwEg9VVsc
         vd/rBft16Hz1oQjkmJr7E9oUBC58H8jITE8K9I9/XHj0QArFI1o6rQWk6m87RyLepO
         c5kKWnnhG+l7vxm8jvlvF9y9VaEu9Ku8rjhEmSJ6jENgRLmPoZc2bhHtnsSTlYhGm7
         dNU4ErhescFqBZ8oFDRLcQ9+Svk74LmpYSvU4Mm/5uGWYhlVi3ZpHEpA1BqprIzcoI
         hNxwTpPoZ/RwA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <DM6PR19MB31633BFB6AD885E0EAF68F14A1419@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com> <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com> <166247313358.3585.5988889047992659412@kwain> <DM6PR19MB31633BFB6AD885E0EAF68F14A1419@DM6PR19MB3163.namprd19.prod.outlook.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Peter Harliman Liem <pliem@maxlinear.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Message-ID: <166254049905.4625.8082287890585826042@kwain>
Date:   Wed, 07 Sep 2022 10:48:19 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-07 08:46:32)
> On 6/9/2022 10:05 pm, Antoine Tenart wrote:
> >> CRYPTO_AES is needed for aes-related algo (e.g.
> >> safexcel-gcm-aes, safexcel-xcbc-aes, safexcel-cmac-aes).
> >> Without it, we observe failures when allocating transform
> >> for those algo.
> >>
> >> Fixes: 363a90c2d517 ("crypto: safexcel/aes - switch to library version=
 of key expansion routine")
> >=20
> > The above commit explicitly switched crypto drivers to use the AES
> > library instead of the generic AES cipher one, which seems like a good
> > move. What are the issues you're encountering and why the AES lib makes
> > the driver to fail?
>=20
> If I load the kernel module (CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not
> set), I am getting failure messages below.
> IMHO this happens because some functions in the driver still rely on
> generic AES cipher (e.g. refer to safexcel_aead_gcm_cra_init() or
> safexcel_xcbcmac_cra_init()), therefore CONFIG_CRYPTO_AES is still needed.

That's possible, and the right fix might be what you proposed. I think
it would be nice to understand what is failing and where, so we have a
good argument for restoring the AES dependency (or not).

> Maybe the alternative is to switch all of them to use AES lib instead?
> Let me know if you prefer this.

If the AES lib can be used instead of the AES generic implementation
that would be great yes. If that's possible, depending on what is
actually failing, yes please go for this solution. Otherwise restoring
the AES dependency with a good explanation should work.

Thanks!
Antoine
