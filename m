From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 09/n]: Fix max queue length value
Date: Wed, 7 May 2008 16:46:58 +0400
Message-ID: <20080507124658.GC23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <4821A2C7.9070100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38367 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbYEGMrK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:47:10 -0400
Content-Disposition: inline
In-Reply-To: <4821A2C7.9070100@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:38:31PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> 

> commit 21b18f9b22c7aa0a458c3f93fc1771a5eb5e70c8
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed May 7 13:00:10 2008 +0200
> 
>     [HIFN]: Fix max queue length value
>     
>     All but the last element of the command and result descriptor rings can be
>     used for crypto requests, fix HIFN_QUEUE_LENGTH.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Yaah, that's right, we can also wrap it into (), although current usage
is ok.

Thanks Patric.

-- 
	Evgeniy Polyakov
