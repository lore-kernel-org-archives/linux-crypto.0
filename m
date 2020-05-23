Return-Path: <SRS0=aEsr=7F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB0DC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7D620787
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:43:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="i2Hhj9bE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgEWSnr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 May 2020 14:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWSnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 May 2020 14:43:46 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3D3C061A0E
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2020 11:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590259424;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=iGthswHfJP7AAhV1YdJnpKloyw5KYC0F3KhDn/onUZU=;
        b=i2Hhj9bEWz6tQdEvx0VflzYRbt2CbcoYCFNz0/bzpFEnuaYuzGLFa1IUpNg+oZWr0B
        Rns791HQnpNJiy8Dj8F10FcIGywf53XCeQ3xrW9JPohCNhhv2scqR9/Ps9cpuuKyKzuW
        fZqsqXXatOxx4FhjfrgP/9g6hwrnUOH6JnZ/1wHPiTfN+sSlRiESOosjO8ab14OSFhkf
        qwRHR81dzU1+5VnMWSgrTkWDPpVXsr/v1d562hzvXXi0YF+Lrmc55rLYp2ozUr5hoM+4
        8v4ioEyhk/yWsTG2TI2CGTzWWJAnyUO9KMK0DXgJJVVuEmyPZ0EY0GZ0V5or+udN5lFt
        4VoA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJ/SdwHc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4NIhhI0v
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 23 May 2020 20:43:43 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Monte Carlo Test (MCT) for AES
Date:   Sat, 23 May 2020 20:43:43 +0200
Message-ID: <12555443.uLZWGnKmhe@positron.chronox.de>
In-Reply-To: <CAMj1kXFa3V1o5Djrqa0XV5HvBqLjFvWqnNLRteiZo+dbhy=Tnw@mail.gmail.com>
References: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <TU4PR8401MB054452A7CD9FF3A50F994C4DF6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <CAMj1kXFa3V1o5Djrqa0XV5HvBqLjFvWqnNLRteiZo+dbhy=Tnw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 23. Mai 2020, 00:11:35 CEST schrieb Ard Biesheuvel:

Hi Ard,

> (+ Stephan)
> 
> On Fri, 22 May 2020 at 05:20, Bhat, Jayalakshmi Manjunath
> 
> <jayalakshmi.bhat@hp.com> wrote:
> > Hi All,
> > 
> > We are using libkcapi for CAVS vectors verification on our Linux kernel.
> > Our Linux kernel version is 4.14.  Monte Carlo Test (MCT) for SHA worked
> > fine using libkcapi. We are trying to perform Monte Carlo Test (MCT) for
> > AES using libkcapi. We not able to get the result successfully. Is it
> > possible to use libkcapi to achieve AES MCT?

Yes, it is possible. I have the ACVP testing implemented completely for AES 
(ECB, CBC, CFB8, CFB128, CTR, XTS, GCM internal and external IV generation, 
CCM), TDES (ECB, CTR, CBC), SHA, HMAC, CMAC (AES and TDES). I did not yet try 
TDES CFB8 and CFB64 through, but it should work out of the box.

AES-KW is the only one that cannot be tested through libkcapi as AF_ALG has 
one shortcoming preventing this test.

The testing is implemented with [1] but the libkcapi test backend is not 
public. The public code in [1] already implements the MCT. So, if you want to 
use [1], all you need to implement is a libkcapi backend that just invokes the 
ciphers as defined by the API in [1].

[1] https://github.com/smuellerDD/acvpparser

Ciao
Stephan


