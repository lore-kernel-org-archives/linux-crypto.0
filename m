From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: stm32 - Add power mamagement support
Date: Mon, 9 Jul 2018 00:43:59 +0800
Message-ID: <20180708164358.qfgj5maijnetucj7@gondor.apana.org.au>
References: <1530017566-14779-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Lionel Debieve <lionel.debieve@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530017566-14779-1-git-send-email-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 26, 2018 at 02:52:43PM +0200, Lionel Debieve wrote:
> This set of patches add pm and pm_runtime feature to stm32 crypto
> drivers.
> 
> Lionel Debieve (3):
>   crypto: stm32/cryp - Add power management support
>   crypto: stm32/hash - Add power management support
>   crypto: stm32/crc - Add power management support
> 
>  drivers/crypto/stm32/stm32-cryp.c  | 62 +++++++++++++++++++++++++++++++++
>  drivers/crypto/stm32/stm32-hash.c  | 71 ++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/stm32/stm32_crc32.c | 62 +++++++++++++++++++++++++++++++++
>  3 files changed, 195 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
