Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEA1C742D7
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 20:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C477208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 20:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="BcqX4E8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGLUF3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 16:05:29 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:31768 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfGLUF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 16:05:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562961924;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=QLHJFykW2mxl6hEJNm++qn7YIxG1rRtQE7+LG/ensUc=;
        b=BcqX4E8hcYz/0dV8GSYkUjd02VTYXyXl4WClHZisXg0+18ULPkLyRo9/laGQGNy2X5
        6uxYblXYJslzkYl67yc2Z0sbgomU2eCIyyla9dvdz+NZnTzQfcknbzFFdSUvGYa+Jhmb
        YHzvKK7KGet+APYm2mXaE3hgTE2yjyqBAKjCO3Qb1838K0ypeDKRJzPxz0rHIGTQ8loM
        W229xO5iv5sZd3jU+B4C/XvREqPREjLgzEv1aMW1Zl+TB8reIw9K1Z8XtVvD/8f2Q5T/
        21fU9pjNyJxBeCurg83hRm0YPgWUc2XG9O/RzB1RBG4RaONuooAHcDShkjvY+pk9kuRb
        16ew==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs0E0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id 9078d1v6CK5N46f
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 12 Jul 2019 22:05:23 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: CAVS test harness
Date:   Fri, 12 Jul 2019 22:05:22 +0200
Message-ID: <1973019.N0B863glP0@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB0544B9D0BCD4C091857A1EAFF6F20@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <2317418.W1bvXbUTk3@tauon.chronox.de> <TU4PR8401MB0544B9D0BCD4C091857A1EAFF6F20@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 12. Juli 2019, 19:55:07 CEST schrieb Bhat, Jayalakshmi Manjunath:

Hi Jayalakshmi,

> Hi Stephan,
> 
> Thank you very much for the suggestions, I have another question, is it
> possible to implement MMT and MCT using kernel crypto API's.

Yes, for sure - I have successfully implemented all CAVS tests for all ciphers 
(see the CAVP validation list for the kernel crypto API).

> Also FCC and
> FCC functions.

I guess you mean FFC and ECC - yes, see the CAVP [2] web site.

Eric:

MCT - Monte Carlo Tests
MMT - Multi-Block Message Tests

In general, see [1] for all CAVS test specifications.

[1] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program

[2] https://csrc.nist.rip/groups/STM/cavp/validation.html

Ciao
Stephan


