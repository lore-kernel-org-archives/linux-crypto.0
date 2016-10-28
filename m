From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: mxs-dcp - Remove hash support
Date: Fri, 28 Oct 2016 19:55:16 +0000
Message-ID: <AMSPR04MB083958F93F3E945D0B57D6EE98AD0@AMSPR04MB0839.eurprd04.prod.outlook.com>
References: <1477327394-2976-1-git-send-email-festevam@gmail.com>
 <423fc7f0-fcab-eee6-6e7b-9ba2261fd0b3@denx.de>
 <CAOMZO5DEdQzttFqB2rQjW_TtUU+Y29pe7rgGzhyQuZu2jcBEKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "gianfranco.costamagna@abinsula.com"
        <gianfranco.costamagna@abinsula.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>
To: Fabio Estevam <festevam@gmail.com>, Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0083.outbound.protection.outlook.com ([104.47.2.83]:29024
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753955AbcJ1TzX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 15:55:23 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/25/2016 12:33 AM, Fabio Estevam wrote:=0A=
> On Mon, Oct 24, 2016 at 6:39 PM, Marek Vasut <marex@denx.de> wrote:=0A=
> =0A=
>> Can't you rather fix it?=0A=
> =0A=
> I would love to have this fixed, but I don't know how.=0A=
=0A=
Looking on the i.MX6 Solo Lite security manual, the fix seems to consist=0A=
in enabling context switching - i.e. setting=0A=
DCP_CTRL[ENABLE_CONTEXT_SWITCHING] - and saving/restoring (part of) the=0A=
context buffer.=0A=
=0A=
However, I am not familiar with DCP crypto engine and don't have HW to test=
.=0A=
=0A=
Horia=0A=
=0A=
