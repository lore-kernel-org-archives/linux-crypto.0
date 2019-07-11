Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A44C74A35
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF61D206B8
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="VsBWIpov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfGKPdv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 11:33:51 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:18934 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfGKPdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 11:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562859229;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=wXYSwrVKmSiKFnLIqd3QD5ata78pErb1hIhwUpGh7Jc=;
        b=VsBWIpovvYHoWwYRiS8+bAJ/pQ6B14fx+LVNqlDZSvQ3j7GMPAnL+/NhWUEs+Hmzh0
        dns9ZPeeCzWQgyH2l/NJm1sckAndPF1Aemr9fsva9ZqTg24rEhnAZR0eobCmr36qJFp0
        fW3hKQMQi4JhlZu0GIXP3CyDlSkZX9Su43SeKGf8H9FI7cQEOOZVVZfGU5JEY+t/+b5B
        7YQS/20SYk+WEUP65/d230S+6bo4z2x2k7bTX9bZrDQdaCDIHRXJ8MhlyPj2ZAnOhTFl
        i1YGXMYK36p24eAcnz9x+oqa1MdlJ3bm5voTumy3iHV9hbBSzAygQPMCHnhCh05Af0T7
        5fEw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs0E0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id 9078d1v6BFXnyMY
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 11 Jul 2019 17:33:49 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: CAVS test harness
Date:   Thu, 11 Jul 2019 17:33:47 +0200
Message-ID: <2317418.W1bvXbUTk3@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB05445179722F462CD8C05AB0F6F30@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <1782078.ZURsmYODYl@tauon.chronox.de> <TU4PR8401MB05445179722F462CD8C05AB0F6F30@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 11. Juli 2019, 17:22:00 CEST schrieb Bhat, Jayalakshmi 
Manjunath:

Hi Jayalakshmi,

> Hi Stephan,
> 
> Thank you very much for the reply. Yes we would need to write the test for
> AEC (ECB,CBC,CTR) 128 and 256 bits, SHA-1, SHA-2 (256,384 and 512), HMAC,
> DRBG and also for key derivation functions. We are planning to write
> netlink based kernel module to receive the data (test vector input) from
> the user space and process the data and generate the result, pass it on to
> user space.
> 
> I wanted to know if this sounds a reasonable approach?

That sounds reasonable.

I implemented the kernel module as you described it but with a debugfs 
interface to use the interface straight from a shell if needed.

Ciao
Stephan


