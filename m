From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 0/2] STM32 CRYP crypto driver
Date: Wed, 29 Nov 2017 17:29:08 +1100
Message-ID: <20171129062908.GA21647@gondor.apana.org.au>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2017 at 05:10:28PM +0200, Fabien Dessenne wrote:
> This set of patches adds a new crypto driver for STMicroelectronics stm32 HW.
> This drivers uses the crypto API and provides with HW-enabled block cipher
> algorithms.
> 
> This driver was successfully tested with tcrypt / testmgr.
> 
> Changes since v5:
> -add timeout in wait_busy function
> -clear key after use
> -misc : remove unused functions, use -Exx, use dev_err

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
