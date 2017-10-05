From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: engine - permit to enqueue aead_request
Date: Thu, 5 Oct 2017 11:39:25 +0800
Message-ID: <20171005033925.GA31996@gondor.apana.org.au>
References: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
 <1503047946-27799-2-git-send-email-fabien.dessenne@st.com>
 <20170922090921.GA15677@gondor.apana.org.au>
 <20206811-7075-5ca9-98cd-26a5709751fb@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20206811-7075-5ca9-98cd-26a5709751fb@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 03, 2017 at 07:48:08AM +0000, Fabien DESSENNE wrote:
>
> It looks like there is no more activity around this "crypto_engine 
> interface clean up" task.
> This unfortunately has been blocking the introduction of this new STM32 
> crypto driver for 3 months now.
> Would it make sense to have this driver reviewed first, and then 
> reworked (I expect minor update here) when the interface update is ready?

Hmm, is it possible to disable the AEAD part of the driver first?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
