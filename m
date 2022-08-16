Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF4DC2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 07:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiHPHz7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 03:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiHPHzW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 03:55:22 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2404564C5
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 22:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1660626589;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JUJQ7vkSNb+RnNIx9CGBZZIIU1Sz8rfGCe5AhhUa4PI=;
    b=Xn3/V+nGJmQ+/XY59xgpShx7I5ZZoXENgolJX/0nVYszYAI3nt7fLoxf1J/glEKk9T
    dWN5TQgZErV1XoTvI0unbQng8UIE6OmM+MVMRa3KRUs+gDYTUzWasImDsRD4KFZBBiUh
    vVQzIs+UW+fa/8tyF2rHP5Tm2fBcIQr4gxzV8ER2Vp/Xdcu/KUSY2cIYPdtKejKiM3Wc
    EE/ZR/BAfR9JKydjem1xSj96TPeQUMCJHso39ThYE/RohEs+pyqaVitX56EvI7GpcsC8
    /LVq3qgt5e2Yh/r2mRjIbVBvblRBnijGhmlK4u1CPAFUYQCxURv76QwxFsumpGfxaZjx
    ziXQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmgLKehaO2hZDSTWbg/LOA=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id k44a27y7G59kYqx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 16 Aug 2022 07:09:46 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Robert Elliott <elliott@hpe.com>, tim.c.chen@linux.intel.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        toshi.kani@hpe.com, rwright@hpe.com
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Date:   Tue, 16 Aug 2022 07:09:44 +0200
Message-ID: <2802022.gAprrWTQMp@tauon.chronox.de>
In-Reply-To: <YvsEN+6k4lTvXY7I@gondor.apana.org.au>
References: <20220813231443.2706-1-elliott@hpe.com> <Yvq65Xd6GjeLdmO5@sol.localdomain> <YvsEN+6k4lTvXY7I@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 16. August 2022, 04:43:03 CEST schrieb Herbert Xu:

Hi Herbert,

> On Mon, Aug 15, 2022 at 02:30:13PM -0700, Eric Biggers wrote:
> > Note that this is only a problem because tcrypt calls alg_test() directly.
> >  The normal way that alg_test() gets called is for the registration-time
> > self-test. It's not clear to me why tcrypt calls alg_test() directly; the
> > registration-time test should be enough.  Herbert, do you know?
> 
> The tcrypt code predates testmgr.  So at the beginning we only had
> the enumerative testing.  Registration-time testing was added later.
> 
> We could remove the enumerative testing, but I think the FIPS people
> have grown rather attached to it because it ticks some sort of a box
> at boot-time.
> 
> Stephane, would it be a problem for FIPS if we simply got rid of the
> enumerative testing in tcrypt and instead relied on registration-time
> testing?

The tcrypt code has only one purpose for FIPS: to allocate all crypto 
algorithms at boot time and thus to trigger the self test during boot time. 
That was a requirement until some time ago. These requirements were relaxed a 
bit such that a self test before first use is permitted, i.e. the approach we 
have in testmgr.c.

Therefore, presently we do not need this boot-time allocation of an algorithm 
via tcrypt which means that from a FIPS perspective tcrypt is no longer 
required.
> 
> Cheers,


Ciao
Stephan


