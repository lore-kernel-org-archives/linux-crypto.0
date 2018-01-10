From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 1/6] Documentation: crypto: document crypto engine API
Date: Wed, 10 Jan 2018 20:14:50 +0100
Message-ID: <20180110191450.GB12214@Red>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
 <20180103201109.16077-2-clabbe.montjoie@gmail.com>
 <849600f6-3082-c090-205d-75e3d14b38f9@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre TORGUE <alexandre.torgue@st.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <849600f6-3082-c090-205d-75e3d14b38f9@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 10, 2018 at 02:13:13PM +0000, Fabien DESSENNE wrote:
> Hi Corentin,
> 
> 
> Thank you for this new version which I have testes successfully with the 
> stm32 hash & cryp drivers.
> 
> As a general comment on this patchset, I would say that it does not 
> cover all async requests: typically I need (for the pending stm32 cryp 
> driver uprade) to use CryptoEngine to process AEAD requests which is not 
> covered here.
> 
> Could you please consider adding the 'transfer' and 'finalize' EXPORTed 
> functions for aead requests? (the implementation is quite trivial)
> 
> Have also a look at struct acomp_req (acompress.h) and struct 
> kpp_request (kpp.h) which also use "struct crypto_async_request base"
> 
> 
> BR
> 
> Fabien
> 

Hello

Thanks for your review and test (could I add your tested-by ?).
I didn't add aead (and kpp/acompress), since I do not have any way to test it.
Since you have a way to test aead, I will add it to the next release.

Regards

> 
> On 03/01/18 21:11, Corentin Labbe wrote:
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >   Documentation/crypto/crypto_engine.rst | 46 ++++++++++++++++++++++++++++++++++
> >   1 file changed, 46 insertions(+)
> >   create mode 100644 Documentation/crypto/crypto_engine.rst
> >
> > diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
> > new file mode 100644
> > index 000000000000..b0ed37f9fb0c
> > --- /dev/null
> > +++ b/Documentation/crypto/crypto_engine.rst
> > @@ -0,0 +1,46 @@
> > +=============
> > +CRYPTO ENGINE
> > +=============
> > +
> > +Overview
> > +--------
> > +The crypto engine API (CE), is a crypto queue manager.
> > +
> > +Requirement
> > +-----------
> > +You have to put at start of your tfm_ctx the struct crypto_engine_reqctx
> > +struct your_tfm_ctx {
> > +        struct crypto_engine_reqctx enginectx;
> > +        ...
> > +};
> > +Why: Since CE manage only crypto_async_request, it cannot know the underlying
> > +request_type and so have access only on the TFM.
> > +So using container_of for accessing __ctx is impossible.
> > +Furthermore, the crypto engine cannot know the "struct your_tfm_ctx",
> > +so it must assume that crypto_engine_reqctx is at start of it.
> > +
> > +Order of operations
> > +-------------------
> > +You have to obtain a struct crypto_engine via crypto_engine_alloc_init().
> > +And start it via crypto_engine_start().
> > +
> > +Before transferring any request, you have to fill the enginectx.
> > +- prepare_request: (taking a function pointer) If you need to do some processing before doing the request
> > +- unprepare_request: (taking a function pointer) Undoing what's done in prepare_request
> > +- do_one_request: (taking a function pointer) Do encryption for current request
> > +
> > +Note: that those three functions get the crypto_async_request associated with the received request.
> > +So your need to get the original request via container_of(areq, struct yourrequesttype_request, base);
> > +
> > +When your driver receive a crypto_request, you have to transfer it to
> > +the cryptoengine via one of:
> > +- crypto_transfer_cipher_request_to_engine()
> > +- crypto_transfer_skcipher_request_to_engine()
> > +- crypto_transfer_akcipher_request_to_engine()
> > +- crypto_transfer_hash_request_to_engine()
> > +
> > +At the end of the request process, a call to one of the following function is needed:
> > +- crypto_finalize_cipher_request
> > +- crypto_finalize_skcipher_request
> > +- crypto_finalize_akcipher_request
> > +- crypto_finalize_hash_request
