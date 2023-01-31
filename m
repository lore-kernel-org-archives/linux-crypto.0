Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1D4C38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 07:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjAaH3B convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 02:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjAaH27 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 02:28:59 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39839CFC;
        Mon, 30 Jan 2023 23:28:56 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id E590724E1D1;
        Tue, 31 Jan 2023 15:28:54 +0800 (CST)
Received: from EXMBX066.cuchost.com (172.16.7.66) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 31 Jan
 2023 15:28:54 +0800
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX066.cuchost.com
 (172.16.6.66) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 31 Jan
 2023 15:28:54 +0800
Received: from EXMBX168.cuchost.com ([fe80::3c2d:dee5:4938:3fc4]) by
 EXMBX168.cuchost.com ([fe80::3c2d:dee5:4938:3fc4%16]) with mapi id
 15.00.1497.044; Tue, 31 Jan 2023 15:28:54 +0800
From:   JiaJie Ho <jiajie.ho@starfivetech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Olivia Mackall <olivia@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: RE: [PATCH] hwrng: starfive - Enable compile testing
Thread-Topic: [PATCH] hwrng: starfive - Enable compile testing
Thread-Index: AQHZMj8fsXkTT9lyaUa0z6voqL4hdK64JkoA
Date:   Tue, 31 Jan 2023 07:28:54 +0000
Message-ID: <2b7520a85def477d9650120a0bd01860@EXMBX168.cuchost.com>
References: <20230117015445.32500-1-jiajie.ho@starfivetech.com>
 <20230117015445.32500-3-jiajie.ho@starfivetech.com>
 <Y9OveVKTkX8cRhyP@gondor.apana.org.au>
In-Reply-To: <Y9OveVKTkX8cRhyP@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [202.188.176.82]
x-yovoleruleagent: yovoleflag
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Enable compile testing for jh7110.  Also remove the dependency on
> HW_RANDOM.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Reviewed-by: Jia Jie Ho <jiajie.ho@starfivetech.com>

Thanks,
Jia Jie
