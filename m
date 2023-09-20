Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2FDCE79AD
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 06:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjITGyC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 02:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjITGyB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 02:54:01 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ED092;
        Tue, 19 Sep 2023 23:53:54 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 38K6rR4K056956;
        Wed, 20 Sep 2023 01:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1695192807;
        bh=vlqRL+AKyD7un6uI2p8NliupoFl8GxtG647gtWnU+oU=;
        h=From:To:CC:Subject:In-Reply-To:References:Date;
        b=RHmAtXcNgSNBC2kZHuWoD6qLhgousfDLoLU4gsF4XrqRGHeigW7ZBP9sHwFfuW1Cr
         7qj6ULZyXIUJp91biwvg4WWkMsN8Pu2eZwpc0rCZHyV3uCkMdk9lfJgeKiM6HqKeeK
         Qgfj2YqJqrqSqpHFmbpATnXdkHycrz//QvTwcrxI=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 38K6rRaH005175
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 Sep 2023 01:53:27 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 20
 Sep 2023 01:53:27 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 20 Sep 2023 01:53:26 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 38K6rQ5U113227;
        Wed, 20 Sep 2023 01:53:26 -0500
From:   Kamlesh Gurudasani <kamlesh@ti.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v2 0/6] Add support for
 Texas Instruments MCRC64 engine
In-Reply-To: <87zg28d9z4.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230812030116.GF971@sol.localdomain>
 <87h6owen39.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <20230822051710.GC1661@sol.localdomain>
 <87zg28d9z4.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Date:   Wed, 20 Sep 2023 12:23:25 +0530
Message-ID: <87a5thgwt6.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kamlesh Gurudasani <kamlesh@ti.com> writes:
...

> Hi Eric, thanks for your detailed and valuable inputs.
>
> As per your suggestion, we did some profiling. 
>
> Use case is to calculate crc32/crc64 for file input from user space.
>
> Instead of directly implementing PMULL based CRC64, we made first comparison between 
> Case 1.
> CRC32 (splice() + kernel space SW driver) 
> https://gist.github.com/ti-kamlesh/5be75dbde292e122135ddf795fad9f21
>
> Case 2.
> CRC32(mmap() + userspace armv8 crc32 instruction implementation)
> (tried read() as well to get contents of file, but that lost to mmap() so not mentioning number here)
> https://gist.github.com/ti-kamlesh/002df094dd522422c6cb62069e15c40d
>
> Case 3.
> CRC64 (splice() + MCRC64 HW)
> https://gist.github.com/ti-kamlesh/98b1fc36c9a7c3defcc2dced4136b8a0
>
>
> Overall, overhead of userspace + af_alg + driver in (Case 1) and
> ( Case 3) is ~0.025s, which is constant for any file size.
> This is calculated using real time to calculate crc  -
> driver time (time spend inside init() + update() +final()) = overhead ~0.025s    
>
>
>
> +-------------------+-----------------------------+-----------------------+------------------------+------------------------+
> |                   |                             |                       |                        |                        |
> | File size         | 120mb(ideal size for us)    | 20mb                  | 15mb                   | 5mb                    |
> +===================+=============================+=======================+========================+========================+
> |                   |                             |                       |                        |                        |
> | CRC32 (Case 1)    | Driver time 0.155s          | Driver time 0.0325s   | Driver time 0.019s     | Driver time 0.0062s    |
> |                   |    real time 0.18s          |    real time 0.06s    |    real time 0.04s     |    real time 0.03s     |
> |                   |    overhead 0.025s          |    overhead 0.025s    |    overhead 0.021s     |    overhead ~0.023s    |
> +-------------------+-----------------------------+-----------------------+------------------------+------------------------+
> |                   |                             |                       |                        |                        |
> | CRC32 (Case 2)    | Real time 0.30s             | Real time 0.05s       | Real time 0.04s        | Real time 0.02s        |
> +-------------------+-----------------------------+-----------------------+------------------------+------------------------+
> |                   |                             |                       |                        |                        |
> | CRC64 (Case 3)    | Driver time   0.385s        | Driver time 0.0665s   | Driver time 0.0515s    | Driver time 0.019s     |
> |                   |    real time 0.41s          |    real time 0.09s    |    real time 0.08s     |    real time 0.04s     |
> |                   |    overhead 0.025s          |    overhead 0.025s    |    overhead ~0.025s    |    overhead ~0.021s    |
> +-------------------+-----------------------------+-----------------------+------------------------+------------------------+
>
> Here, if we consider similar numbers for crc64 PMULL implementation as
> crc32 (case 2) , we save good number of cpu cycles using mcrc64
> in case of files bigger than 5-10mb as most of the time is being spent in HW offload.
>
> Regards,
> Kamlesh

Hi Eric,

Please let me know if above numbers make sense to you and I should send
next revision.

Regards,
Kamlesh
