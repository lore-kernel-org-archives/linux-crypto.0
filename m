From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 06/n]: Properly handle requests for less than the full scatterlist
Date: Wed, 7 May 2008 17:01:45 +0400
Message-ID: <20080507130145.GE23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <4821A0E4.8070904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59424 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYEGNCE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:02:04 -0400
Content-Disposition: inline
In-Reply-To: <4821A0E4.8070904@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:30:28PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     [HIFN]: Properly handle requests for less than the full scatterlist
>     
>     The scatterlist may contain more data than the crypto request, causing
>     an underflow of the remaining byte count while walking the list.
>     
>     Use the minimum of the scatterlist element size and the remaining byte
>     count specified in the crypto request to avoid this.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

That one is the nastiest! Thanks a lot Patrick for fixing that.
Ack of course.

-- 
	Evgeniy Polyakov
