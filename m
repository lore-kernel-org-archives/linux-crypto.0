From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] STM32 CRC crypto driver
Date: Wed, 5 Apr 2017 22:09:29 +0800
Message-ID: <20170405140929.GD27150@gondor.apana.org.au>
References: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37562 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753260AbdDEOR1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:17:27 -0400
Content-Disposition: inline
In-Reply-To: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 04:13:26PM +0100, Fabien Dessenne wrote:
> This set of patches adds a new crypto driver for STMicroelectronics stm32f746.
> The drivers uses the crypto API and provides with an HW-enabled CRC32 algorithm.
> It was developed and tested (tcrypt / testmgr) on evaluation board stm32746g.
> 
> v2 changes:
> - remove useless check of crc / crc->clk
> - enable crypto in stm32 defconfig
> - typo fix in dt-bindings

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
