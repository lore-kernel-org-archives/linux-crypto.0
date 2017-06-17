From: David Gstir <david@sigma-star.at>
Subject: Re: [RFC PATCH 0/2] crypto: caam - fix cts(cbc(aes)) with CAAM driver
Date: Sat, 17 Jun 2017 11:05:55 +0200
Message-ID: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
 <VI1PR0401MB25910B19DB95DABF62C00A7598C00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB25913AAA76159D27E8EB13DF98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170616075941.GA5346@gondor.apana.org.au>
 <VI1PR0401MB25914CC17187DD446802C25F98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: =?utf-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdFQJF6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jun 2017 05:05:58 -0400
In-Reply-To: <VI1PR0401MB25914CC17187DD446802C25F98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Horia,

> On 16 Jun 2017, at 23:01, Horia Geantă <horia.geanta@nxp.com> wrote:
> 
> On 6/16/2017 11:00 AM, Herbert Xu wrote:
>> On Fri, Jun 16, 2017 at 07:57:00AM +0000, Horia Geantă wrote:
>>> 
>>> Commit 0605c41cc53ca ("crypto: cts - Convert to skcipher") appends
>>> CRYPTO_TFM_REQ_MAY_BACKLOG to the original crypto request flags for the
>>> last block - when calling cts_cbc_encrypt().
>>> Is it really needed?
>> 
>> Yes, because at this point we cannot tell the sender to back off.
>> 
>>> For cts(cbc(aes)) with cbc(aes) offloaded in HW, i.e. running in async
>>> mode, we get the below stack for CAAM driver.
>>> Driver is told that it can sleep (CRYPTO_TFM_REQ_MAY_BACKLOG flag), so
>>> it uses GFP_KERNEL to allocate memory. However, this is incorrect, since
>>> driver runs in atomic context (softirq).
>> 
>> This is wrong.  Whether you can sleep or not is determined by
>> MAY_SLEEP, not MAY_BACKLOG.  MAY_BACKLOG only indicates that this
>> request must be queued, even if the queue is full.
>> 
> Indeed, CAAM driver incorrectly decides to use GFP_KERNEL for allocation
> when MAY_BACKLOG flag is set. This seems to be a long-standing issue, I
> will send a fix (separately).
> 
> Still I think we have a problem.
> David reported that the user is fscrypt. Looking into fscrypt code, I
> see that besides MAY_BACKLOG, MAY_SLEEP flag is also set. So we end up
> in the situation I described earlier: the last block is encrypted in
> atomic context and with MAY_SLEEP set.

Fixing the MAY_BACKLOG issue in the CAAM driver should get rid of the problem
altogether since the CTS code clears the MAY_SLEEP flag when encrypting the
last block [1].

David

[1] http://elixir.free-electrons.com/linux/v4.12-rc5/source/crypto/cts.c#L124
