Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905E9C001DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jul 2023 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjGZA34 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 20:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjGZA3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 20:29:55 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1242682;
        Tue, 25 Jul 2023 17:29:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qOSOp-00HYGD-8a; Wed, 26 Jul 2023 08:29:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Jul 2023 08:29:07 +0800
Date:   Wed, 26 Jul 2023 08:29:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nishanth Menon <nm@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Jayesh Choudhary <j-choudhary@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tero Kristo <t-kristo@ti.com>, Keerthy <j-keerthy@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        linux-crypto@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5 0/2] Remove power-domains property for devices with
 compatible ti,am62-sa3ul
Message-ID: <ZMBo09ZzFhzdk6L/@gondor.apana.org.au>
References: <20230614-sa3ul-v5-0-29dd2366fba3@ti.com>
 <169028509342.1718778.15078093695331558450.b4-ty@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169028509342.1718778.15078093695331558450.b4-ty@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 25, 2023 at 06:39:48AM -0500, Nishanth Menon wrote:
> Herbert,
> 
> I am going to assume that you are ok with me picking this series up as this
> results in a few broken boots for various boards. Let me know if that is not
> the case, and I will drop the series from my tree.

Sure, no problems.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
