From: Jay Monkman <jtm@smoothsmoothie.com>
Subject: Re: Crypto driver -DCP
Date: Tue, 02 Jun 2015 13:57:28 -0500
Message-ID: <556DFC98.10406@smoothsmoothie.com>
References: <554BBD05.3050807@freescale.com> <201505290300.36019.marex@denx.de> <20150529012359.GA15471@gondor.apana.org.au> <201505290329.59713.marex@denx.de> <20150529013211.GA15566@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smoothsmoothie.com ([198.58.104.115]:51802 "EHLO
	smoothsmoothie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbFBTGQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 15:06:16 -0400
In-Reply-To: <20150529013211.GA15566@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/28/2015 08:32 PM, Herbert Xu wrote:
> On Fri, May 29, 2015 at 03:29:59AM +0200, Marek Vasut wrote:
>> On Friday, May 29, 2015 at 03:23:59 AM, Herbert Xu wrote:
>>> On Fri, May 29, 2015 at 03:00:35AM +0200, Marek Vasut wrote:
>>>> My understanding (!) is that everyone should be able to use this key to
>>>> encrypt/decrypt their data using the AES128 engine in the DCP.
>>> If that's the case just make it the key you use if setkey has never
>>> been called.
>> Shouldn't you always call setkey when using symetric crypto ?
> Normally yes but we don't require it so in this case it should
> be fine.
>
> Cheers,

Okay, that seems obvious after you suggested it.

I have another question. The DCP (and other crypto accelerators on other 
SOCs) supports key slots - basically write only RAM that's used to store 
keys so they can be used for encrypt/decrypt operations. DCP supports 4 
key slots, other devices have different numbers. Do you have any 
suggestion for how to add support for something like that to the driver?

Thanks.
