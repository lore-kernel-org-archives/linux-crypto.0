From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 15:41:23 +0100
Message-ID: <47BD8D93.3070906@trash.net>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru> <47BD88BD.2030305@trash.net> <20080221143721.GB9140@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:14221 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYBUOmK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 09:42:10 -0500
In-Reply-To: <20080221143721.GB9140@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Thu, Feb 21, 2008 at 03:20:45PM +0100, Patrick McHardy (kaber@trash.net) wrote:
>> Almost I guess :) There are similar loops in hifn_setup_session().
>> Additionally we need to check that the return value of ablkcipher_walk()
>> is not a negative errno code.
> 
> Yep. Kind of this one:

Thanks, I'll give it a try. It includes one chunk I missed when
trying this myself, which might explain the problems I saw
afterwards.
