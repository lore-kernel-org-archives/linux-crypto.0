From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 4/4] crypto: add CRYPTO_TFM_REQ_IV_SERIALIZE flag
Date: Wed, 14 Feb 2018 13:47:41 +0100
Message-ID: <1608123.Kiafq77GoN@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <3191772.GlMloJJ0Yf@positron.chronox.de> <57d07371-8ad5-0f79-d511-2a0000f4eda1@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:8430 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967589AbeBNMrq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 07:47:46 -0500
In-Reply-To: <57d07371-8ad5-0f79-d511-2a0000f4eda1@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 14. Februar 2018, 06:50:38 CET schrieb Harsh Jain:

Hi Harsh,

> On 10-02-2018 03:34, Stephan M=FCller wrote:
> > Crypto drivers may implement a streamlined serialization support for AIO
> > requests that is reported by the CRYPTO_ALG_SERIALIZES_IV_ACCESS flag to
> > the crypto user. When the user decides that he wants to send multiple
> > AIO requests concurrently and wants the crypto driver to handle the
> > serialization, the caller has to set CRYPTO_TFM_REQ_IV_SERIALIZE to not=
ify
> > the crypto driver.
>=20
> Will crypto_alloc_* API takes cares of this flag?. For Kernel Crypto user=
 IV
> Synchronization logic depends on weather tfm allocated supports IV
> Serialisation or not.

The alloc API calls are not related to this flag. This flag is set in the=20
request sent to the driver. If the driver sees this flag, it shall perform =
its=20
serialization.

The idea is the following: the driver reports CRYPTO_ALG_SERIALIZES_IV_ACCE=
SS=20
if it can serialize requests. In this case, the higher level functions (lik=
e=20
AF_ALG) would not serialize the request. Now, the higher level functions mu=
st=20
inform the driver that its serialization function shall be performed which=
=20
implemented with CRYPTO_TFM_REQ_IV_SERIALIZE.

Note, the higher level functions may decide that no serialization is necess=
ary=20
(e.g. in the case the inline IV handling is followed by AF_ALG). This impli=
es=20
that the CRYPTO_TFM_REQ_IV_SERIALIZE flag would not be set even though the=
=20
driver is capable of serializing (and thus would report=20
CRYPTO_ALG_SERIALIZES_IV_ACCESS).

Ciao
Stephan
