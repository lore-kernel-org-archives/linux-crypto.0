From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 1/4] crypto: blowfish - split generic and common c code
Date: Thu, 22 Sep 2011 17:25:18 +0300
Message-ID: <20110922172518.14262m8p1a6wq24g@www.81.fi>
References: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
 <20110922112938.GA32559@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56333 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1IVOZV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Sep 2011 10:25:21 -0400
In-Reply-To: <20110922112938.GA32559@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Fri, Sep 02, 2011 at 01:45:07AM +0300, Jussi Kivilinna wrote:
>> Patch splits up the blowfish crypto routine into a common part (key setup)
>> which will be used by blowfish crypto modules (x86_64 assembly and  
>> generic-c).
>>
>> Also fixes errors/warnings reported by checkpatch.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> All applied to cryptodev.

Ok, thanks!

I'll send the further improvements/changes as new patches on top of those.

-Jussi

>
> Thanks!
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
