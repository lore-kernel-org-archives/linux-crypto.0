Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308A4C004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 08:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED27D204FD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 08:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfEGI7N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 04:59:13 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:36007 "EHLO ou.quest-ce.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfEGI7M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 04:59:12 -0400
X-Greylist: delayed 2370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 04:59:11 EDT
Received: from [2a01:e35:39f2:1220:2452:dd6c:fe2f:be2c] (helo=opteyam2)
        by ou.quest-ce.net with esmtpsa (TLS1.1:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <ydroneaud@opteya.com>)
        id 1hNvK6-0006Hu-SW; Tue, 07 May 2019 10:19:39 +0200
Message-ID: <b6332dfac8da2dc6a11eeda9e4d0fba44d21509e.camel@opteya.com>
From:   Yann Droneaud <ydroneaud@opteya.com>
To:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Tue, 07 May 2019 10:19:38 +0200
In-Reply-To: <1978979.Zxv6YQyJUk@positron.chronox.de>
References: <1852500.fyBc0DU23F@positron.chronox.de>
         <5352150.0CmBXKFm2E@positron.chronox.de>
         <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
         <1978979.Zxv6YQyJUk@positron.chronox.de>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1 (3.32.1-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:39f2:1220:2452:dd6c:fe2f:be2c
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH v4] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

Le vendredi 03 mai 2019 à 21:58 +0200, Stephan Müller a écrit :
> 
> FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> self test. Afterwards it was moved to a location that is inconsistent
> with the FIPS 140-2 requirements.
> 

Could you list the commit that move the self test and add that
information in the commit message.

> Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
> seed. This patch resurrects the function drbg_fips_continous_test that
> existed some time ago and applies it to the noise sources.
> 

Please identify the commit it was resurrected from, for traceability
purpose.

Regards.

-- 
Yann Droneaud
OPTEYA


