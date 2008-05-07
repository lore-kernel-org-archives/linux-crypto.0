From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 07 May 2008 15:05:48 +0200
Message-ID: <4821A92C.1040707@trash.net>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net> <20080507124220.GA23422@2ka.mipt.ru> <4821A45B.7060209@trash.net> <20080507130433.GF23422@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63703 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbYEGNGX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:06:23 -0400
In-Reply-To: <20080507130433.GF23422@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Wed, May 07, 2008 at 02:45:15PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>> Of the data buffers only the destination buffer needs to be aligned,
>> see the Source Pointer description in "2.2 Source Descriptors" in
>> the HIFN documentation.
> 
> Ok, thanks for the reference.


As a side-note: its also not just an overseight in the documentation,
not aligning the destination buffer to a multiple of 4 results in the
HW freezing, the source buffer alignment changes work fine though.

