From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto - ablk_helper: add module parameter to allow
 testing cryptd redirection of requests
Date: Thu, 25 Oct 2012 17:29:06 +0300
Message-ID: <20121025172906.12984eq3c2esm680@www.dalek.fi>
References: <20121021174529.11043.15034.stgit@localhost6.localdomain6>
 <20121024131702.GE3251@gondor.apana.org.au>
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
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:53061 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759687Ab2JYO3M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2012 10:29:12 -0400
In-Reply-To: <20121024131702.GE3251@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Sun, Oct 21, 2012 at 08:45:29PM +0300, Jussi Kivilinna wrote:
>> Add module parameter to allow forcing redirection of crypto requests to
>> cryptd worker threads. This allows these code paths to be actually tested
>> (easier).
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> Wouldn't this be applicable in other spots too? Perhaps we need
> something that just makes irq_fpu_usable return false?

That would make sense. Maybe some sort of debug config option which  
gives kernel that forces irq_fpu_usable to false?

-Jussi
