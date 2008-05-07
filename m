From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 01/n]: Endianess fixes
Date: Wed, 07 May 2008 15:01:55 +0200
Message-ID: <4821A843.9080003@trash.net>
References: <48219D24.1040702@trash.net> <20080507130011.GD23422@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYEGNCf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:02:35 -0400
In-Reply-To: <20080507130011.GD23422@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Wed, May 07, 2008 at 02:14:28PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>   
>>     [HIFN]: Endianess fixes
>>     
>>     HIFN uses little-endian by default, move cpu_to_le32 conversion to hifn_write_0/
>>     hifn_write_1, add sparse annotations and fix an invalid endian conversion in
>>     hifn_setup_src_desc.
>>     
>
> We can also be safe without volatile annotations.
>   

Yes, will also be taken care of by a later patch :)


