Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D9BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 12:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhLQMQR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 07:16:17 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:11928 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbhLQMQQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 07:16:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639743374;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=N0yIqUqNwPy3IXCs5VMfUCb3eF8HSbNkCL6XIzU5drk=;
    b=Aosa4/KSCls8Ttgn256Jge52V3h27daPuaXEjsBRyM+9HcKly20CTCTsMm0dxAKp9Q
    OBnKGBSQmH2+ZzVJlccYaw968InrdVXVubRBn/fpEBT7rm1dZFNqo5VpM3dgN+KPzZRo
    qTH0qq7nYDyUTYBTg2Yru/ijZ1ryXGmW4BjytdAIGqlQYKMBQchpOK6P8JKaDRwVi/uh
    e6I+H/XNLU+4zf/tIfFafoazd3eblbXOMUdmtxUCVsXKDuiwNviSCwOBqLBkb9lzumyu
    ZfSQayEgGsPwiL2LFqx92g7J2afdjnvWN4fzDDvSbK6qx5ozPcjOf8CIYkwC9dt9ibnQ
    uZ4A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.35.3 AUTH)
    with ESMTPSA id h03d91xBHCGDIoB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Dec 2021 13:16:13 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, Simo Sorce <simo@redhat.com>
Cc:     linux-crypto@vger.kernel.org, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH] crypto: jitter - add oversampling of noise source
Date:   Fri, 17 Dec 2021 13:16:13 +0100
Message-ID: <4742341.vXUDI8C0e8@positron.chronox.de>
In-Reply-To: <ee13fe8c757a419f0f4c6b60419afb1b63003f2f.camel@redhat.com>
References: <2573346.vuYhMxLoTh@positron.chronox.de> <ee13fe8c757a419f0f4c6b60419afb1b63003f2f.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 17. Dezember 2021, 13:06:07 CET schrieb Simo Sorce:

Hi Simo,

> >  static void jent_gen_entropy(struct rand_data *ec)
> >  {
> > 
> > -	unsigned int k = 0;
> > +	unsigned int k = 0, safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
> > +
> > +	if (!jent_fips_enabled())
> > +		safety_factor = 0;
> 
> I would find this more readable if safety_factor is initialized to 0,
> and then in the code:
> 	if (jent_fips_enabled())
> 		safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
> 
> However this is just readability for me, either option is perfectly
> identicaly IMO, so

Thank you, I will send an updated patch.

Ciao
Stephan


