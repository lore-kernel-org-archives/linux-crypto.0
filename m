From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Wed, 07 May 2008 15:09:14 +0200
Message-ID: <4821A9FA.3050307@trash.net>
References: <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6044D6442@SDCEXCHANGE01.ad.amcc.com> <20080422111635.GA19543@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6045B3153@SDCEXCHANGE01.ad.amcc.com> <20080507130047.GA26872@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Loc Ho <lho@amcc.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63837 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYEGNJs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:09:48 -0400
In-Reply-To: <20080507130047.GA26872@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Tue, Apr 22, 2008 at 10:23:23AM -0700, Loc Ho wrote:
>> They are attached instead inline until I figure out how to not wrap long
>> line.
> 
> Thanks.  I've finally finished testing and integrating it.  I've
> merged them into one patch and dropped unrelated white-space
> changes.  You can resubmit those in a separate patch.


Cool, I started adding hashing support to HIFN until I noticed
the CrypoAPI doesn't support async hashing yet :)
