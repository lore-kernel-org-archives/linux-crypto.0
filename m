From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC PATCH 0/2] crypto: caam - fix cts(cbc(aes)) with CAAM driver
Date: Fri, 16 Jun 2017 21:01:45 +0000
Message-ID: <VI1PR0401MB25914CC17187DD446802C25F98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <VI1PR0401MB25910B19DB95DABF62C00A7598C00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB25913AAA76159D27E8EB13DF98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170616075941.GA5346@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0088.outbound.protection.outlook.com ([104.47.1.88]:54448
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750792AbdFPVBt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 17:01:49 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/16/2017 11:00 AM, Herbert Xu wrote:=0A=
> On Fri, Jun 16, 2017 at 07:57:00AM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>> Commit 0605c41cc53ca ("crypto: cts - Convert to skcipher") appends=0A=
>> CRYPTO_TFM_REQ_MAY_BACKLOG to the original crypto request flags for the=
=0A=
>> last block - when calling cts_cbc_encrypt().=0A=
>> Is it really needed?=0A=
> =0A=
> Yes, because at this point we cannot tell the sender to back off.=0A=
> =0A=
>> For cts(cbc(aes)) with cbc(aes) offloaded in HW, i.e. running in async=
=0A=
>> mode, we get the below stack for CAAM driver.=0A=
>> Driver is told that it can sleep (CRYPTO_TFM_REQ_MAY_BACKLOG flag), so=
=0A=
>> it uses GFP_KERNEL to allocate memory. However, this is incorrect, since=
=0A=
>> driver runs in atomic context (softirq).=0A=
> =0A=
> This is wrong.  Whether you can sleep or not is determined by=0A=
> MAY_SLEEP, not MAY_BACKLOG.  MAY_BACKLOG only indicates that this=0A=
> request must be queued, even if the queue is full.=0A=
> =0A=
Indeed, CAAM driver incorrectly decides to use GFP_KERNEL for allocation=0A=
when MAY_BACKLOG flag is set. This seems to be a long-standing issue, I=0A=
will send a fix (separately).=0A=
=0A=
Still I think we have a problem.=0A=
David reported that the user is fscrypt. Looking into fscrypt code, I=0A=
see that besides MAY_BACKLOG, MAY_SLEEP flag is also set. So we end up=0A=
in the situation I described earlier: the last block is encrypted in=0A=
atomic context and with MAY_SLEEP set.=0A=
=0A=
Thanks,=0A=
Horia=0A=
