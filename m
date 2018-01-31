From: Vakul Garg <vakul.garg@nxp.com>
Subject: RE: [PATCHv2] tls: Add support for encryption using async offload
 accelerator
Date: Wed, 31 Jan 2018 17:22:38 +0000
Message-ID: <HE1PR04MB30827E0097BB30E4E2EE51648BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
References: <20180131160437.6583-1-vakul.garg@nxp.com>
 <20180131152228.GA24247@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ilyal@mellanox.com" <ilyal@mellanox.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0072.outbound.protection.outlook.com ([104.47.2.72]:26304
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752431AbeAaRWl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 12:22:41 -0500
In-Reply-To: <20180131152228.GA24247@davejwatson-mba>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Dave Watson [mailto:davejwatson@fb.com]
> Sent: Wednesday, January 31, 2018 8:52 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: linux-crypto@vger.kernel.org; ilyal@mellanox.com;
> aviadye@mellanox.com; davem@davemloft.net; netdev@vger.kernel.org;
> Gilad Ben-Yossef <gilad@benyossef.com>
> Subject: Re: [PATCHv2] tls: Add support for encryption using async offloa=
d
> accelerator
>=20
> On 01/31/18 09:34 PM, Vakul Garg wrote:
> > Async crypto accelerators (e.g. drivers/crypto/caam) support
> > offloading GCM operation. If they are enabled, crypto_aead_encrypt()
> > return error code -EINPROGRESS. In this case tls_do_encryption() needs
> > to wait on a completion till the time the response for crypto offload
> > request is received.
>=20
> Comments from V1
> > On Wed, Jan 31, 2018 at 8:10 AM, Gilad Ben-Yossef
> <gilad@benyossef.com> wrote:
> >> Hi Vakul,
> >>
> >> On Wed, Jan 31, 2018 at 12:36 PM, Vakul Garg <vakul.garg@nxp.com>
> wrote:
> >>> Async crypto accelerators (e.g. drivers/crypto/caam) support
> >>> offloading GCM operation. If they are enabled, crypto_aead_encrypt()
> >>> return error code -EINPROGRESS. In this case tls_do_encryption()
> >>> needs to wait on a completion till the time the response for crypto
> >>> offload request is received.
> >>>
> >>
> >> Thank you for this patch. I think it is actually a bug fix and should
> >> probably go into stable
> >
> > On second though in stable we should probably just disable async tfm
> > allocations.
> > It's simpler. But this approach is still good for -next
> >
> >
> > Gilad
>=20
> I agree with Gilad, just disable async for now.
>=20

How to do it? Can you help with the api name?

> If the flag MSG_DONTWAIT is set, we should be returning -EINPROGRESS and
> not wait for a response.  I had started working on a patch for that, but =
it's
> pretty tricky to get right.

Can you point me to your WIP code branch for this?

If MSG_DONTWAIT is not used, will it be sane if enqueue the crypto request =
to=20
accelerator and return to user space back so that user space can send more =
plaintext data while=20
crypto accelerator is working in parallel?
=20
