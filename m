Return-Path: <SRS0=EbYU=7U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E9BC433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Jun 2020 13:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD69206D5
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Jun 2020 13:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="BUuZQM33"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgFGNKi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Jun 2020 09:10:38 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:12788 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgFGNKi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Jun 2020 09:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591535436;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BE6yntl6/s4SfLyuaEKkEHfZSqol6aSdStfdIVau+k4=;
        b=BUuZQM33lZ6e0zAWAfTIoUpc5O2LQG8upd08vNv2JAnu0rMT6Rltzft+1xuEJlHkKN
        O2NHF4IM3R45rvuWzlx214GGgf+6UmOCquHstOlDTcCfxKyECsx3ci4AjmHoveUKVHZx
        qlYY5cEcnEuEvDAH2cv/n/h67Oj4eJG1kx2aNHkiRdAnnc3n1zDPXEwRB2a9IHijSl0C
        CAVybR0xaVK+umudVSaNv2cNynITWEKo712nDiE2Bi4zldyJisyYl84fWSMiy2MUSZT3
        XAWSF/5UuMbAkXPxg3XD8Ak9dF2n9ReF3Tjdx1II5EBQVH8M3RaONZi7bJX4822zg0qw
        9Jhw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvdOeueZtw="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.9.1 DYNA|AUTH)
        with ESMTPSA id I05374w57D7YFfe
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 7 Jun 2020 15:07:34 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] crypto: DRBG - always try to free Jitter RNG instance
Date:   Sun, 07 Jun 2020 15:07:34 +0200
Message-ID: <2533674.mvXUDI8C0e@positron.chronox.de>
In-Reply-To: <20200605162149.GE1373@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com> <4575667.y41LbVH5lo@tauon.chronox.de> <20200605162149.GE1373@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 5. Juni 2020, 18:21:49 CEST schrieb Eric Biggers:

Hi Eric,

> To be concrete, I'm suggesting:
> 
> 	if (!IS_ERR_OR_NULL(drbg->jent))
> 		crypto_free_rng(drbg->jent);
> 	drbg->jent = NULL;

I currently do not see that this could lead to an issue. But you are right, we 
should use defensive programming everywhere.

I will send a v3 shortly.

Thanks.


Ciao
Stephan


