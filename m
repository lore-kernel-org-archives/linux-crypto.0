From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 07 May 2008 14:45:15 +0200
Message-ID: <4821A45B.7060209@trash.net>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net> <20080507124220.GA23422@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63034 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYEGMp4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:45:56 -0400
In-Reply-To: <20080507124220.GA23422@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Wed, May 07, 2008 at 02:26:30PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>   
>> I'm not entirely sure about the alignmask change at the end of
>> this patch, is an alignmask of 1 correct if no source buffer
>> alignment is required, but the destination buffer should be
>> (doesn't have to be though) 4 byte aligned?
>>     
>
>   
>> commit f76618d53e82c8905214e889a3f79f1816c680fb
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Wed May 7 12:44:15 2008 +0200
>>
>>     [HIFN]: Fix data alignment checks
>>     
>>     The check for misalignment of the scatterlist data has two bugs:
>>     
>>     - the source buffer doesn't need to be aligned at all
>>     - the destination buffer and its size needs to be aligned to a multiple
>>       of 4, not to the crypto alg blocksize
>>     
>>     
>
> If memory serves me right, both src and dst addresses have to be 4 bytes
> aligned. Protocol alignment is not needed.
>
> If it is not the issue, then I have no objections.
>   

Of the data buffers only the destination buffer needs to be aligned,
see the Source Pointer description in "2.2 Source Descriptors" in
the HIFN documentation.


