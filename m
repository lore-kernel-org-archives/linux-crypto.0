Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C977C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C1E20678
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgFCMj0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:39:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60166 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgFCMjZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 08:39:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgSfq-0004ib-Cz; Wed, 03 Jun 2020 22:39:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Jun 2020 22:39:14 +1000
Date:   Wed, 3 Jun 2020 22:39:14 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     Rob Herring <robh@kernel.org>, davem@davemloft.net,
        Keerthy <j-keerthy@ti.com>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
Message-ID: <20200603123914.GA31840@gondor.apana.org.au>
References: <20200511215343.GA10123@bogus>
 <20200514125005.23641-1-t-kristo@ti.com>
 <20200528152341.GA103581@bogus>
 <a75b48ad-ecc0-89bc-f6a2-7149bc3fefb0@ti.com>
 <20200603122726.GB31719@gondor.apana.org.au>
 <18c28e88-e3a7-2ec4-1d0c-f4d4163aff1c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18c28e88-e3a7-2ec4-1d0c-f4d4163aff1c@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 03, 2020 at 03:38:03PM +0300, Tero Kristo wrote:
>
> Also I guess this should be posted against 5.8-rc1 once it is out, as merge
> window is already open. Or are you planning to pick it up for 5.8 already?

Sorry this is going to be in the next merge window.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
