Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3FDC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 08:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9062206F4
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 08:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="IuicEsZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgEOIco (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 04:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726730AbgEOIcl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 04:32:41 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1734C061A0C;
        Fri, 15 May 2020 01:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589531557;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cHEQOWUyIIldwmU2G5ztyzURhkG246vmV36B4A8PLNg=;
        b=IuicEsZLQ+IWZvn46fqIzv8mnRi9bsTzIalpbDAxiCGMZ3VRLcZucrP+fUsRXR/r0s
        rts+19tHz3YACk3hQ0NZFZcEqGDXU2Qhp3jLlxe1GBd/LjkVIWEFBRS+9zq9kn3hPJE+
        GWQ+WRzdFsrbxPBkaNLK+ViY6ALoWoO5gYMTT3dNsql48FlcIQ13ryBBxL31s5JsbkyW
        KFU5LjhqKOAcZ1YVwKXRI7SQc3OTdjHRCo1oIY2pbMqbJ5CIlwr7I54d9RD0hiyAfyiy
        szxrx0rtEHXHIohi/hzIn+qLRJcLpF7r0n1hR100/BM6Ze7y+/nu0e2YuJ3gVbtzGGKt
        lcMw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSc9C1S"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w4F8WN0ZL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 15 May 2020 10:32:23 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Fri, 15 May 2020 10:32:22 +0200
Message-ID: <2080864.23lDWg4Bvs@tauon.chronox.de>
In-Reply-To: <dleftjtv0i88ji.fsf%l.stelmach@samsung.com>
References: <4493123.C11H8YMYNy@tauon.chronox.de> <CGME20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a@eucas1p2.samsung.com> <dleftjtv0i88ji.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 15. Mai 2020, 00:18:41 CEST schrieb Lukasz Stelmach:

Hi Lukasz,
> 
> I am running tests using SP800-90B tools and the first issue I can see
> is the warning that samples contain less than 1e6 bytes of data. I know
> little about maths behind random number generators, but I have noticed
> that the bigger chunk of data from an RNG I feed into either ent or ea_iid
> the higher entropy they report. That is why I divided the data into 1024
> bit chunks in the first place. To get worse results. With ea_iid they
> get even worse (128 bytes of random data)

I read that you seem to just take the output data from the RNG. If this is 
correct, I think we can stop right here. The output of an RNG is usually after 
post-processing commonly provided by a cryptographic function.

Thus, when processing the output of the RNG all what we measure here is the 
quality of the cryptographic post-processing and not the entropy that may be 
present in the data.

What we need is to access the noise source and analyze this with the given 
tool set. And yes, the analysis may require adjusting the data to a format 
that can be consumed and analyzed by the statistical tests.

Ciao
Stephan


