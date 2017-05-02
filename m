From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: talitos: Extend max key length for
 SHA384/512-HMAC and AEAD
Date: Tue, 2 May 2017 14:02:31 +0000
Message-ID: <VI1PR0401MB25916E61B9663F1C3C7FA0A298170@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170502133835.GA17402@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Martin Hicks <mort@bork.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5/2/2017 4:38 PM, Martin Hicks wrote:=0A=
> =0A=
> An updated patch that also handles the additional key length requirements=
=0A=
> for the AEAD algorithms.=0A=
> =0A=
> The max keysize is not 96.  For SHA384/512 it's 128, and for the AEAD=0A=
> algorithms it's longer still.  Extend the max keysize for the=0A=
> AEAD size for AES256 + HMAC(SHA512).=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # 3.6+=0A=
> Fixes: 357fb60502ede ("crypto: talitos - add sha224, sha384 and sha512 to=
 existing AEAD algorithms")=0A=
> Signed-off-by: Martin Hicks <mort@bork.org>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
