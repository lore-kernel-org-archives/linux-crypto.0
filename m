Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB46C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 12:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BEF5217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 12:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="hfKvUJo9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfAYMwH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:52:07 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:35585 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfAYMwH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 07:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1548420722;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=7sln4uk/5WygqPBHBf4G6eTsEIocQH8wMf0dbY9tB0s=;
        b=hfKvUJo9Akk53lv7x+8WgYuOkYoq98rbGMsAPE39bdKJnu7fE786j55iUbLlt5YRnP
        9Xq6OSL/krGEMuAekYQGhB72rA/6o1indw6GtcM+YK7ynH50RRJiZesZnXHjFCZUb3C9
        OoeM1ytcw1eHv2NHJjtznftNS3dYqLyO294Hf2Gp9xfKnXR+h/LmP81bnSOUwokdhLYr
        +PGs/s8T6SP1UKnYkynbOLFc4LidX8kMgZ+NcXmvQTK8/CXAgJMqz3rtCdhJRNNvoDlu
        nF6kTQ6dkV0EFPo1Q2Bo+K0TUpbJZHmPWYy6ww6EVy0xSFl41IQMreoPqlqQjyHiEMzQ
        5sdw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIfSf89Ln"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.9 DYNA|AUTH)
        with ESMTPSA id 309bcfv0PCq2sl1
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 25 Jan 2019 13:52:02 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: mark crc32 checksum as FIPS allowed
Date:   Fri, 25 Jan 2019 13:52:01 +0100
Message-ID: <2924484.9zSPOiJp0u@tauon.chronox.de>
In-Reply-To: <20190125093147.10266-1-gmazyland@gmail.com>
References: <20190125093147.10266-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 25. Januar 2019, 10:31:47 CET schrieb Milan Broz:

Hi Milan,

> The CRC32 is not a cryptographic hash algorithm,
> so the FIPS restrictions should not apply to it.
> (The CRC32C variant is already allowed.)
> 
> This CRC32 variant is used for in dm-crypt legacy TrueCrypt
> IV implementation (tcw); detected by cryptsetup test suite
> failure in FIPS mode.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


