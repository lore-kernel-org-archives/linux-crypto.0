Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAE0C76190
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC91E21901
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:23:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="adWqcgyJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbfGVSXJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 14:23:09 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:32044 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfGVSXJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 14:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1563819787;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qnumY8/mhdloFOcom+Shw9Gfp4wdCivM1cGxPYllj+E=;
        b=adWqcgyJxdYap/3btmJw4BxF70StPF5kMz/RFoL3ia7w+LgCuUuafpvAHHgA0S9I5N
        dusqoSNCVPe9U4RgfimmaOfB7XnnuVll+SdlYbDIulf3pfxK9BfZSSNpCUoNOZW/COlp
        ivfeMpOMLHbidLc86HyEZCunFEP0282wph5pVEO8hLEjQfHN4ARcC9Wzxqi3N+0OlTAb
        FIARD9brPTFNbAJWNyoLx3u6GFTw+udh25KBMmDJRPUOzCpQKXSElhznknHvUunPUQsH
        yqqazfwzXnbCk8P+KPDxUCYz+hzORQSjQKJyk7zhEdKBc/Y4ezWyTteuuFpZccoSGgnp
        U/qQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs0E0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id a007f7v6MIN6JC4
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 22 Jul 2019 20:23:06 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: CAVS test implementation
Date:   Mon, 22 Jul 2019 20:23:05 +0200
Message-ID: <1576914.egHxntUF84@tauon.chronox.de>
In-Reply-To: <AT5PR8401MB053183BECE5BCE7EBDB2BC00F6C40@AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM>
References: <AT5PR8401MB053183BECE5BCE7EBDB2BC00F6C40@AT5PR8401MB0531.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. Juli 2019, 20:07:05 CEST schrieb Bhat, Jayalakshmi Manjunath:

Hi Jayalakshmi,

> Hi All,
> 
> We are in the process of implementing
> 	KAT -  known answer test
> 	MMT - Multi-block Message Test
> 	MCT - Monte Carlo Test
> 	KAS FFC - Key Agreement Scheme, Finite Field Cryptography
> 	KAS ECC - Elliptic Curve Cryptography
> 
> Our approach to implement the testing is via writing a kernel character
> driver module to pass the test vectors to kernel. Once vectors are
> processed read the result from kernel. There are synchronous and
> asynchronous kernel APIs. Can any one provide inputs on which set of API
> will suite better for us?

If you want to test all aspects and all implementations, you should use the 
async API.

> 
> Regards,
> Jaya



Ciao
Stephan


