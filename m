From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Sun, 20 Jan 2013 14:24:26 +0200
Message-ID: <20130120142426.32982bygy4o4y874@www.dalek.fi>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
 <20130105182556.87853b23jydihzk0@www.dalek.fi>
 <065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130119015457.1386129jh3k4firk@www.dalek.fi>
 <065BBB7616BCE543832A2EF096986B94161931@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Garg Vakul-B16394 <B16394@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:45203 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3ATMY3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jan 2013 07:24:29 -0500
In-Reply-To: <065BBB7616BCE543832A2EF096986B94161931@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Garg Vakul-B16394 <B16394@freescale.com>:

>
>
>> -----Original Message-----
>> From: Jussi Kivilinna [mailto:jussi.kivilinna@mbnet.fi]
>> Sent: Saturday, January 19, 2013 5:25 AM
>> To: Garg Vakul-B16394
>> Cc: linux-crypto@vger.kernel.org
>> Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
>> parallel.
>>
>> Quoting Garg Vakul-B16394 <B16394@freescale.com>:
>>
>> >
>> >> Does not this change make tcrypt give inconsistent results?
>> >>
>> >
>> > Based on kernel scheduling of threads, this change can make tcrypt
>> > give varying results in different runs.
>> > For consistent results, we can use existing synchronous mode crypto
>> sessions.
>>
>> But one cannot get consistent results for asynchronous software
>> implementations after this patch.
>
> Should we launch threads optionally based on module argument (in  
> both synchronous and async mode)?
> This would preserve existing tcrypt behavior.

Yes, that would be better.

-Jussi
