From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 16:31:53 +0100
Message-ID: <47BD9969.2050904@trash.net>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru> <47BD88BD.2030305@trash.net> <20080221143721.GB9140@2ka.mipt.ru> <47BD8D93.3070906@trash.net> <47BD98F2.4080305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:62064 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754027AbYBUPcM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 10:32:12 -0500
In-Reply-To: <47BD98F2.4080305@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patrick McHardy wrote:
> It also looks like at least two more changes are needed:
 > ...

One more thing: I got lots of "printk: 4 messages suppressed"
without any real messages. The reason is a printk_ratelimit()
before a dprintk(). This probably wants either an #ifdef or
a real printk.
