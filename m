Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC683EB64DC
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 07:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjFXHsB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjFXHr6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 03:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC0119B7
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AC860B86
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 07:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A54C433C8
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 07:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687592876;
        bh=XEldgn6bhBSEZDNAAQvG79aKrxjb/pYkv/L2yRsBT0M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UWnXAitXpCD4FdFokbrU0pjmxv23ff/eEMBmv9WfAdciqP+VdFN3YINjsYJ59pwZM
         bIgwladbSABPxrfxHYQpV0wZy4D2MbriQjINlqVlYG8SQANz8WtfYCFJF55Pf5zAAv
         e7RA+PaEZoeSxwpr18tpAIWoxFbgojBvfMZ/1UjPxuDarPcFpt7QC7cYJYmQoPOl2J
         ZMyMwvkcx8VobtbsCxETkKamDzwj/DU0F3j/MRBxT3FWuU8yPmapnii5fLnpBpp94h
         y1oaZkwDX+i6Ut/cHjvDdyk0Z6wG+EiWbBnNhVGuVA8uiiR3j4fhXGkPhG3QBCq+7B
         wlMajp/XQtATA==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2b5c231c23aso2822281fa.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:47:56 -0700 (PDT)
X-Gm-Message-State: AC+VfDw0zfqUic83rn09RJSA+4xUDhb5dBRQvo5OdoDXTVIoc30UB0T7
        p/boYTyLXyR21hapHFnajWUV3AH9O8k2bJSMFZA=
X-Google-Smtp-Source: ACHHUZ7/sHyCez9uxriI0V9m+v956F8maDxAYueCo17ik4MCKm0xth8AJzztZDeIJecL+aHwye3BupmfnzOnMr34SAc=
X-Received: by 2002:a19:e012:0:b0:4f8:70b0:eec6 with SMTP id
 x18-20020a19e012000000b004f870b0eec6mr4403314lfg.28.1687592874321; Sat, 24
 Jun 2023 00:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <202306231917.utO12sx8-lkp@intel.com> <ZJZ8/JifEeygojAq@gondor.apana.org.au>
 <CAMj1kXGKnusvWDV8rSUhQexeKy1e2+x2-ZXw6_6RiExvtiR_8A@mail.gmail.com> <ZJafbEJ4SOYPEo1N@gondor.apana.org.au>
In-Reply-To: <ZJafbEJ4SOYPEo1N@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 24 Jun 2023 09:47:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE7GT99EnjsmO1HYX1KOoAfbDUNZwpYxfuo5oYptdW_KA@mail.gmail.com>
Message-ID: <CAMj1kXE7GT99EnjsmO1HYX1KOoAfbDUNZwpYxfuo5oYptdW_KA@mail.gmail.com>
Subject: Re: [PATCH] crypto: sm2 - Provide sm2_compute_z_digest when sm2 is disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 24 Jun 2023 at 09:47, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Jun 24, 2023 at 09:40:59AM +0200, Ard Biesheuvel wrote:
> >
> > How is this supposed to work when
> > CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y but SM2 is configured as a
> > module?
>
> It will fail as it did previously.  I'm just rearranging the code.
> Perhaps when another algorithm that requires a non-standard digest
> comes up we can think up of a proper abstraction.
>

Fair enough.
