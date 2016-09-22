From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - fix sg dump
Date: Thu, 22 Sep 2016 11:47:49 +0000
Message-ID: <DB4PR04MB0847AAA0EE82226E33D8155D98C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <20160922105500.GA6306@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Cata Vasile <cata.vasile@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-crypto-owner@vger.kernel.org"
        <linux-crypto-owner@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0045.outbound.protection.outlook.com ([104.47.2.45]:30394
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933377AbcIVLrx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 07:47:53 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/22/2016 1:55 PM, Herbert Xu wrote:=0A=
> Horia Geanta Neag <horia.geanta@nxp.com> wrote:=0A=
>>=0A=
>>> +=0A=
>>> +static void dbg_dump_sg(const char *level, const char *prefix_str,=0A=
>>> +                       int prefix_type, int rowsize, int groupsize,=0A=
>>> +                        struct scatterlist *sg, size_t tlen, bool asci=
i,=0A=
>>> +                    bool may_sleep)=0A=
>> may_sleep is no longer needed.=0A=
> =0A=
> As I've already applied this patch, please send any improvements=0A=
> as incremental patches.=0A=
=0A=
I am trying to understand the process here...=0A=
Would adding an official maintainer for the driver avoid applying=0A=
patches without an ack?=0A=
(This is not the first time changes are applied without getting a chance=0A=
to comment. OTOH I admit there were also cases when there was absolute=0A=
silence.)=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
