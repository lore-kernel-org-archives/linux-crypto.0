From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/5] dt-bindings: Document STM32 CRC bindings
Date: Tue, 28 Mar 2017 19:28:48 -0500
Message-ID: <20170329002847.jfgs3ru3dwlepl3v@rob-hp-laptop>
References: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
 <1490109211-4869-2-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34776 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbdC2A2u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 20:28:50 -0400
Content-Disposition: inline
In-Reply-To: <1490109211-4869-2-git-send-email-fabien.dessenne@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 04:13:27PM +0100, Fabien Dessenne wrote:
> Document device tree bindings for the STM32 CRC (crypto CRC32)
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
> ---
>  .../devicetree/bindings/crypto/st,stm32-crc.txt          | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt

Acked-by: Rob Herring <robh@kernel.org>
