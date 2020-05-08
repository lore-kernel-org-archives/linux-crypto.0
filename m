Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99649C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F097E215A4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="df3F939/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHMau (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 08:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726863AbgEHMau (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 08:30:50 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AE3C05BD43
        for <linux-crypto@vger.kernel.org>; Fri,  8 May 2020 05:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588941047;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qlLfPHVlrCRGCHJwPAmHIg3OIWLDKZ6MsIUQoaaBUx8=;
        b=df3F939/NGJVRpHonDW/SjHx7sPjhrnY/UEbibXS+SuaZM11y6+IbDhutffpbZqTSh
        3fNwB5r2xAnBc5Hz/9iHrZ9xOLz9CIFcxyWfryS3+/BMjGZUwhPFT+hX1q+4d0+UmxCN
        N1mvh55b+RMX0uZYbVAgp0SYVLGZ6VJIgO3JkY42kXF1c7zsPEmb6hiWCGmYYBJeVmgA
        HXRkg+VCVaOjtqbW3o4m23fNmsTebyVOZ07NgsGbnkyb4YVKRBU7JxwtLabLnI6n3VMr
        3HfAXkHXiH787ALXtftzRo9WrIx7x/osvbesFpEilgJljQwu8yIxdX+x4GwvPebct8BE
        vMcQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSfJdtJ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w48CUlQh9
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 14:30:47 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: jitterentropy_rng on armv5 embedded target
Date:   Fri, 08 May 2020 14:30:47 +0200
Message-ID: <6708214.Ppv1U3N1OP@tauon.chronox.de>
In-Reply-To: <2904279.2zIEgBPu8l@ada>
References: <2567555.LKkejuagh6@ada> <8028774.qcRHhbuxM6@tauon.chronox.de> <2904279.2zIEgBPu8l@ada>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 8. Mai 2020, 14:26:41 CEST schrieb Alexander Dahl:

Hi Alexander,

> Hello,
> 
> Am Freitag, 8. Mai 2020, 14:22:02 CEST schrieb Stephan Mueller:
> > Am Freitag, 8. Mai 2020, 14:17:25 CEST schrieb Alexander Dahl:
> > > Okay and DRBG has nothing to do with /dev/random ?
> > 
> > Nope, it is used as part of the kernel crypto API and its use cases.
> > 
> > > Then where do the random
> > > numbers for that come from (in the current or previous kernels without
> > > your
> > > new lrng)?
> > 
> > The DRBG is seeded from get_random_bytes and the Jitter RNG.
> 
> Oh, I was not precise enough. I wanted to know where /dev/random gets its
> numbers from. As far as I understood now: not from DRBG? (Which is
> sufficient knowledge for my current problem.)

Interrupts, HID events, block device events, external sources.

For a full analysis, see [1]

[1] https://bsi.bund.de/SharedDocs/Downloads/EN/BSI/Publications/Studies/
LinuxRNG/LinuxRNG_EN.pdf


Ciao
Stephan


