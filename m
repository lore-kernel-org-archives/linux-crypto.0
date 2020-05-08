Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC63C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D5E1207DD
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEHM0u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 08:26:50 -0400
Received: from mail.thorsis.com ([92.198.35.195]:60383 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHM0u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 08:26:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id 474D42A4F
        for <linux-crypto@vger.kernel.org>; Fri,  8 May 2020 14:26:49 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0LUapmlvCnia for <linux-crypto@vger.kernel.org>;
        Fri,  8 May 2020 14:26:49 +0200 (CEST)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id 1A7EC4B41; Fri,  8 May 2020 14:26:45 +0200 (CEST)
From:   Alexander Dahl <ada@thorsis.com>
To:     linux-crypto@vger.kernel.org
Cc:     Stephan Mueller <smueller@chronox.de>
Subject: Re: jitterentropy_rng on armv5 embedded target
Date:   Fri, 08 May 2020 14:26:41 +0200
Message-ID: <2904279.2zIEgBPu8l@ada>
In-Reply-To: <8028774.qcRHhbuxM6@tauon.chronox.de>
References: <2567555.LKkejuagh6@ada> <2049720.SxWqT2AVQ6@ada> <8028774.qcRHhbuxM6@tauon.chronox.de>
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

Am Freitag, 8. Mai 2020, 14:22:02 CEST schrieb Stephan Mueller:
> Am Freitag, 8. Mai 2020, 14:17:25 CEST schrieb Alexander Dahl:
> > Okay and DRBG has nothing to do with /dev/random ?
> 
> Nope, it is used as part of the kernel crypto API and its use cases.
> 
> > Then where do the random
> > numbers for that come from (in the current or previous kernels without
> > your
> > new lrng)?
> 
> The DRBG is seeded from get_random_bytes and the Jitter RNG.

Oh, I was not precise enough. I wanted to know where /dev/random gets its 
numbers from. As far as I understood now: not from DRBG? (Which is sufficient 
knowledge for my current problem.)

Greets
Alex



