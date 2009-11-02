From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
 wrapper
Date: Mon, 02 Nov 2009 03:36:52 -0800 (PST)
Message-ID: <20091102.033652.88749630.davem@davemloft.net>
References: <20091030125818.GA6379@gondor.apana.org.au>
	<20091030132734.GS15653@secunet.com>
	<20091030133055.GB31693@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45623
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbZKBLg1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 06:36:27 -0500
In-Reply-To: <20091030133055.GB31693@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 30 Oct 2009 09:30:55 -0400

> On Fri, Oct 30, 2009 at 02:27:34PM +0100, Steffen Klassert wrote:
>> I'm going to send a workqueue based version of padata/pcrypt
>> within the next week.
> 
> Awesome!

Thanks a lot for continuing this work Steffen.
