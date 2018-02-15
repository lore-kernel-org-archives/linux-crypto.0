From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: stm32/cryp - add AEAD cipher algorithms
Date: Thu, 15 Feb 2018 23:53:02 +0800
Message-ID: <20180215155302.GQ7352@gondor.apana.org.au>
References: <1518008935-30428-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1518008935-30428-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 07, 2018 at 02:08:53PM +0100, Fabien Dessenne wrote:
> This patchset depends on "crypto: engine - Permit to enqueue all async requests"
> proposed by Corentin Labbe [https://lkml.org/lkml/2018/1/26/608].
> stm32-cryp uses this updated crpyto engine to handle AEAD cipher algortihms.
> 
> Fabien Dessenne (2):
>   crypto: stm32/cryp - add aes gcm / ccm support
>   crypto: stm32/cryp - add stm32mp1 support

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
