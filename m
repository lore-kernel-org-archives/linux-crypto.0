From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 01/n]: Endianess fixes
Date: Wed, 07 May 2008 15:46:12 +0200
Message-ID: <4821B2A4.5040602@trash.net>
References: <48219D24.1040702@trash.net> <20080507130011.GD23422@2ka.mipt.ru> <4821A843.9080003@trash.net> <20080507132345.GL23422@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64935 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYEGNqq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:46:46 -0400
In-Reply-To: <20080507132345.GL23422@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Wed, May 07, 2008 at 03:01:55PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>>> We can also be safe without volatile annotations.
>>>  
>> Yes, will also be taken care of by a later patch :)
> 
> I just receive them in a strange order and do not know when others will
> arrive :)


Appologies for imperfect ordering :) The patchset grew while fixing
issues as I ran into them and attempts to reorder caused too many
conflicts.

The removal of volatile doesn't belong in this patch though.
