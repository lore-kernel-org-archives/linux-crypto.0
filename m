Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68712C61DB3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 17:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbjAIR6X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 12:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbjAIR6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 12:58:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666426C7EE;
        Mon,  9 Jan 2023 09:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E403B80EA0;
        Mon,  9 Jan 2023 17:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EA3C433F0;
        Mon,  9 Jan 2023 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673286866;
        bh=ouqlx8GtcRbTh2qvs77h0nDGF3C0ShrvNQhaxu3JhEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PGewov7Zum8VwN8zfqe3itpWo+MPuj1+EIsUDQ2dLNnrWqu91dgUX7aZFV94WMzdp
         txp2GUYVcUxas6MfpKQC8zgjgKhMyrhS2tbDSFezL9go3NWVmRYKGr52aVm+n9dO/3
         aVod6B30F1gAUcDUibhsmukSrNiSJKaMP+x5XCXrRfcIbEG0Omx+5sbALb1LuGzVkD
         4OJPrFUEjn4gslIcxluiNzZ44GGW3dqShSIhaM/HQTtk6xYqVIPUqHup6qYwN+zztv
         r0iE2suS6Db37sUrs18xZrFQEdR1tbfhxrdKvd7rZSATX6QCrjLMkAGU2sTlYuDh7g
         zkuYDLVjKntYw==
Date:   Mon, 9 Jan 2023 17:54:22 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 1/3] dt-bindings: rng: Add StarFive TRNG module
Message-ID: <Y7xUztHGvc/j5VHk@spud>
References: <20230109165249.110279-1-jiajie.ho@starfivetech.com>
 <20230109165249.110279-2-jiajie.ho@starfivetech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mMDiE/m6P+Qrq0i/"
Content-Disposition: inline
In-Reply-To: <20230109165249.110279-2-jiajie.ho@starfivetech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--mMDiE/m6P+Qrq0i/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--mMDiE/m6P+Qrq0i/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY7xUzQAKCRB4tDGHoIJi
0qVXAP0UxXRirQU2Z4dgTlIcAFAV2RQWkdEm0PYG4jzntTJ57gEApAszKyseZMpS
aq+Xvm5rWXRTEPj9Wp1gfr29HM6tPA8=
=T3G5
-----END PGP SIGNATURE-----

--mMDiE/m6P+Qrq0i/--
