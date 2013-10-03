From: tobias.polzer@fau.de
Subject: Re: crypto: GCM API usage
Date: Thu, 3 Oct 2013 08:03:45 +0200
Message-ID: <b2497b2c434ee21c2c700427f48cc398.squirrel@faumail.uni-erlangen.de>
References: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
    <20130916183411.GC3380@d-paulus.de>
    <20130919203316.GA31494@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Dominik Paulus" <dominik@d-paulus.de>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, tobias.polzer@fau.de,
	linux-kernel@i4.cs.fau.de
To: "Marcelo Cerri" <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:41376 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab3JCGNr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Oct 2013 02:13:47 -0400
In-Reply-To: <20130919203316.GA31494@oc8526070481.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I haven't used the IV generation facility of the Crypto API, but it
> seems to be very straightforward although there's no documentation
> about that.
>
> You should use aead_givcrypt_set_callback(), aead_givcrypt_set_assoc()
> and aead_givcrypt_set_crypt() as you would use the regular aead
> functions, that includes that you have to provide a buffer with length
> equals to the algorithm block size for the IV. And then you should call
> aead_givcrypt_set_giv() passing a counter and another IV buffer.
>
> The difference between the two IV buffers that you have to provide to
> aead_givcrypt_set_crypt() and aead_givcrypt_set_giv() is that the first
> one will be updated by the algorithm during the encryption of each block
> and the second one will contain the generated IV that you will have to
> use to decrypt data.
>
> The last step is to call crypto_aead_givencrypt() as you would call
> crypto_aead_encrypt().

We discovered those functions, yet the only way we found how to use them was
to use one of the ipsec modes, e.g.:
	crypto_alloc_aead("rfc4106(gcm(aes))", 0, 0)

Is this the only way this API should be used, or is there some high level
interface to use iv generators like seqiv?

Thank you for your help,
	Dominik Paulus and Tobias Polzer
