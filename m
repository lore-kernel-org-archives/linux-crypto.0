From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix dbg_dump_sg() style issues
Date: Thu, 22 Sep 2016 17:43:03 +0000
Message-ID: <DB4PR04MB0847A56F743D3B1AA95560C298C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1474541907-28808-1-git-send-email-cata.vasile@nxp.com>
 <DB4PR04MB084791D84A67236F89D05CE998C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto-owner@vger.kernel.org"
        <linux-crypto-owner@vger.kernel.org>
To: Cata Vasile <cata.vasile@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0086.outbound.protection.outlook.com ([104.47.2.86]:42016
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932127AbcIWEPP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2016 00:15:15 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/22/2016 2:42 PM, Horia Geanta Neag wrote:=0A=
> On 9/22/2016 1:58 PM, Catalin Vasile wrote:=0A=
>> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>=0A=
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
Actually please fix also the warning reported by kbuild test robot in=0A=
dbg_dump_sg: s/min(x, y)/min_t(size_t, x, y)=0A=
=0A=
Horia=0A=
=0A=
