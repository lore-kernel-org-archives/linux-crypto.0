From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 02/n]: Remove printk_ratelimit() for debugging printk
Date: Wed, 7 May 2008 16:23:26 +0400
Message-ID: <20080507122326.GB17128@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219D6A.3060208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35966 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbYEGMXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:23:42 -0400
Content-Disposition: inline
In-Reply-To: <48219D6A.3060208@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:15:38PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     [HIFN]: Remove printk_ratelimit() for debugging printk
>     
>     Without debugging this spams the log with "printk: N messages surpressed"
>     without any actual messages on error. With debugging its more useful to
>     always see the message.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Acked :)

-- 
	Evgeniy Polyakov
