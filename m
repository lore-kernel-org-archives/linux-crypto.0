Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683AFC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 16:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF90207F7
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 16:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="D+z1Q/wx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFLQAG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 12:00:06 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:36540 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLQAF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 12:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591977601;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=3Fnf+9Qj/MnZfPVMdDU93UNwYp75+7wUMi95ZLEwoTM=;
        b=D+z1Q/wxg+P07A4+ja8wYew8g4rVHZpfbgIaylhp4vshgAnUjji0GjdxJnzBjFirne
        yb+iitVT/qD6X40et6iFeSJhJBNOXmXLbhyN5C/d+u5sBLh1hP6ReXoxVb0RjoVYMvfP
        Q6/lQdqrjLKSVAMEgmfPwb6tBv1qvQ6EDgyCiZJxh/YM3NAuMfwYpsRtlhACpRZChYnm
        OQHIUP2LczfvCRMkbi8LMzx3q5pldY6dxzPstD/YWQAhQhxaLtLIFfpcvj0NFPkJfVgv
        iPg0qE08RVOupHgdMTtKIfTUNtc9174GWmOSAFEYtwFY/4rXFJX/JbvK+zNHdRyRgRdx
        cV+g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaL/SXH98="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.4 DYNA|AUTH)
        with ESMTPSA id U03fedw5CG003k6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 12 Jun 2020 18:00:00 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Peter P." <p.pan48711@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: HMAC Selftests keylen in FIPS mode
Date:   Fri, 12 Jun 2020 18:00:00 +0200
Message-ID: <1751149.rdBM11ybyJ@tauon.chronox.de>
In-Reply-To: <CAPVaeBk1S44EzHgXh=g_1LaM+rMDd=zLPB7M=1GLoG78MvYz5g@mail.gmail.com>
References: <CAPVaeBk1S44EzHgXh=g_1LaM+rMDd=zLPB7M=1GLoG78MvYz5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 12. Juni 2020, 17:51:52 CEST schrieb Peter P.:

Hi Peter,

> Hi,
> 
> According to NIST SP800-131A Table 9, HMAC generation in FIPS must
> have a keylen of 14 bytes minimum. I've noticed that in the crypto
> algorithm testing framework, the HMAC test vectors from RFC 4231 all
> have a test case that utilizes a 4 byte key.
> Is this permissible when operating the kernel in FIPS mode and if so
> how is the 14 byte minimum keysize enforced?

SP800-131A specifies the ciphers and their cryptographic strengths. Thus, the 
specification you refer to there shall ensure that HMAC with an appropriate 
strength is used.

When performing a self test, the cryptographic strength of the cipher is 
irrelevant as only the mathematical construct is verified to work correctly. 
Thus, using a smaller HMAC key is considered to be acceptible for FIPS 140-2 
section 4.9.

Note, it would even be possible to use, say, RSA with a 512 bit key for the 
self test knowing that SP800-131A allows key sizes 2048 and higher.

Though, there is no limitation on the key length supported for HMAC. Note, 
SP800-131A allows using HMAC with keys < 112 bits provided it is only used for 
verification in legacy mode. Thus, limiting it in the code would not be the 
right way.

Ciao
Stephan


