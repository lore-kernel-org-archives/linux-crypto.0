From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 11/n]: Have HW invalidate src and dest descriptors after processing
Date: Wed, 7 May 2008 17:14:28 +0400
Message-ID: <20080507131428.GI23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <4821A63D.1040408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35557 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYEGNOj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:14:39 -0400
Content-Disposition: inline
In-Reply-To: <4821A63D.1040408@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:53:17PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     The descriptors need to be invalidated after processing for ring
>     cleanup to work properly and to avoid using an old destination
>     descriptor when the src and cmd descriptors are already set up
>     and the dst descriptor isn't.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Well, we only care about cmd register and do not process valid bit in
others, instead of cmd is not valid we do not use others, but we can
also check other descriptors too.

Thanks Patrick, I have no objections.
Ack.

-- 
	Evgeniy Polyakov
