From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 11/n]: Have HW invalidate src and dest descriptors after
 processing
Date: Wed, 07 May 2008 15:18:11 +0200
Message-ID: <4821AC13.3040809@trash.net>
References: <48219D24.1040702@trash.net> <4821A63D.1040408@trash.net> <20080507131428.GI23422@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64120 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYEGNSq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:18:46 -0400
In-Reply-To: <20080507131428.GI23422@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Wed, May 07, 2008 at 02:53:17PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>>     The descriptors need to be invalidated after processing for ring
>>     cleanup to work properly and to avoid using an old destination
>>     descriptor when the src and cmd descriptors are already set up
>>     and the dst descriptor isn't.
>>     
>>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> Well, we only care about cmd register and do not process valid bit in
> others, instead of cmd is not valid we do not use others, but we can
> also check other descriptors too.

I noticed the ring cleanup debugging printing ever increasing
use counts for src and dst descriptors, which went away with
this patch, but the more important point is avoiding that the
HW accidentally uses an old descriptors of course.

> Thanks Patrick, I have no objections.

Thanks Evgeniy. Thats it for now, next round will take until
tonight or maybe tommorrow.
