Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA9FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 18:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804822089D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 18:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="mhFxH9Q3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgE0StA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 14:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgE0StA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 14:49:00 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1135DC08C5C1
        for <linux-crypto@vger.kernel.org>; Wed, 27 May 2020 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590605337;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=bvgZNafOy+6LyUdwZuXd3nEb/vqTAw+TQTFod1zD3mY=;
        b=mhFxH9Q3iGlUT9sN8SnmnOWYI2eqFa1YNWmKsad94jOkjYIbEtxJ3noPeAw3a9/+cO
        vRIwpPZZpJchaWe5/rvyOklzflG9KMk4bCgzPaWnAvMywsjBA4H7qB0NRevHG51OiJHi
        0m0ktZnRg26VMxixX+PId/MNFw3tKgkC8FMpvI4MdkjJzQzk6ERXnYW1RvMdYTkq3dQa
        6pNeoDJapA3zDd3XFU/aVHBZBGMvL4aI0Cuw2qb+XHFeOCBewQMm+sXswfWdYgU4OMQr
        v0Jxgc5fkSOWpaMp5AKU22JW9Iv/V1mpphUsjRUhb2r0t30D6vOFyB1wgRqinWNxEPLr
        ES9w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIvSfYao+"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4RImvidu
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 27 May 2020 20:48:57 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: DRBG CAVS using libkcapi
Date:   Wed, 27 May 2020 20:48:57 +0200
Message-ID: <4958358.O0iSefo5KS@tauon.chronox.de>
In-Reply-To: <CS1PR8401MB0646C32205BFF9D0E8B5CCC2F6B10@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
References: <CS1PR8401MB0646C32205BFF9D0E8B5CCC2F6B10@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 27. Mai 2020, 04:21:31 CEST schrieb Bhat, Jayalakshmi Manjunath:

Hi Jayalakshmi,

> Hi All,
> 
> I was going through libkcapi APIs to see if it can be used for DRBG CAVS
> validation. But I am thinking it cannot be. I also found cavs_driver.pl,
> this seems to depend on some kernel mode driver. Is it like I need to
> testmgr.c kind of an interface and that should be accessed by user mode.
> 
> Please can any confirm if my understandings are correct?

The libkcapi cannot be used for CAVS testing the DRBG. Also a number of other 
ciphers like the asymmetric ciphers are not testable via libkcapi.

And yes, the Perl code refers to a kernel module that I developed but is 
private that allows full CAVS testing - this is the one that is used for all 
kernel crypto API CAVS/ACVP certificates that are out there.

Ciao
Stephan


