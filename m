From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Tue, 19 Feb 2008 17:27:25 +0100
Message-ID: <47BB036D.7090701@trash.net>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, johnpol@2ka.mipt.ru
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:42309 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbYBSQ1l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Feb 2008 11:27:41 -0500
In-Reply-To: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>> I couldn't figure out where in the crypto code the
>> nbytes decrement by 12 bytes compared to the length
>> seen when setting up the crypto operation happens
>> or I might have tried to properly fix it myself.
>> I'll happily test patches in case someone more
>> familiar with the code does a proper fix.
> 
> The usual ICV is 12 bytes long so that could be where it's coming
> from.


Yes, probably. So I take it the assumption in HIFN that the
sg-list length matches req->nbytes is incorrect?
