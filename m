From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: engine - permit to enqueue aead_request
Date: Fri, 22 Sep 2017 17:09:21 +0800
Message-ID: <20170922090921.GA15677@gondor.apana.org.au>
References: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
 <1503047946-27799-2-git-send-email-fabien.dessenne@st.com>
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
In-Reply-To: <1503047946-27799-2-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 18, 2017 at 11:19:04AM +0200, Fabien Dessenne wrote:
> The current crypto engine allows ablkcipher_request and ahash_request to
> be enqueued. Extend this to aead_request.
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>

I'd like to see the crypto_engine interface cleaned up a little
before we expand it further.  Please refer to

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
