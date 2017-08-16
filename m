From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 2/3] crypto: engine - find request type with cra_type
Date: Wed, 16 Aug 2017 10:58:15 +0200
Message-ID: <20170816085815.GA5732@Red>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
 <20170814131725.9402-3-clabbe.montjoie@gmail.com>
 <f2185b14d944433c9737cabc32e3cef9@SFHDAG5NODE3.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f2185b14d944433c9737cabc32e3cef9@SFHDAG5NODE3.st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 15, 2017 at 07:51:14AM +0000, Fabien DESSENNE wrote:
> Hi Corentin,
> 
> Since I have just sent a patch to add the support of "aead_request" to crypto engine, I am wondering if your proposed change (checking cra_type instead of crypto_tfm_alg_type) and mine are compatible.
> It looks like they are (assuming we export crypto_aead_type): can you confirm?
> BR
> 
> Fabien.
> 

Hello

My change is incompatible with yours since I remove a switch(crypto_tfm_alg_type) that you use.
Anyway you will need my change:) because you use ablkcipher which is obsolete and you need to convert to skcipher.

regards
Corentin Labbe
