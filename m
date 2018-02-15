From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: stm32/hash: Correction to improve robustness
Date: Thu, 15 Feb 2018 23:51:34 +0800
Message-ID: <20180215155133.GL7352@gondor.apana.org.au>
References: <20180129142811.13273-1-lionel.Debieve@st.com>
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
To: Lionel Debieve <lionel.Debieve@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180129142811.13273-1-lionel.Debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 29, 2018 at 03:28:08PM +0100, Lionel Debieve wrote:
> From: Lionel Debieve <lionel.debieve@st.com>
> 
> Hi,
> 
> This patch serie will improve global robustness for stm32-hash driver. 
> 
> Patch #1 is fixing dma-burst issue when configuration is not set.
> Patch #2 solves issue that occurs when irq append during final req processing.
> Patch #3 is fixing an issue that have been introduced while managing padding but
> breaking the padding length calculation by hardware to generate correct hash.
> 
> Regards,
> 
> Lionel Debieve (3):
>   crypto: stm32/hash: avoid error if maxburst not defined
>   crypto: stm32/hash: fix performance issues
>   crypto: stm32/hash: rework padding length

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
