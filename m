From: Andreas WESTIN <andreas.westin@stericsson.com>
Subject: Re: [PATCH 2/3 v4] crypto: ux500: Add driver for HASH hardware
Date: Tue, 10 Apr 2012 12:25:16 +0200
Message-ID: <4F840A8C.7030103@stericsson.com>
References: <1333098168-30706-1-git-send-email-andreas.westin@stericsson.com> <1333098168-30706-3-git-send-email-andreas.westin@stericsson.com> <20120409070919.GA30624@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kim.phillips@freescale.com" <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:44879 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab2DJKZe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Apr 2012 06:25:34 -0400
In-Reply-To: <20120409070919.GA30624@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 2012-04-09 09:09, Herbert Xu wrote:
> On Fri, Mar 30, 2012 at 11:02:47AM +0200, Andreas Westin wrote:
>>
>> +/**
>> + * hash_hw_update - Updates current HASH computation hashing another part of
>> + *                  the message.
>> + * @req:	Byte array containing the message to be hashed (caller
>> + *		allocated).
>> + *
>> + * Reentrancy: Non Re-entrant
>> + */
>
> As the crypto API is reentrant this comment suggests that this
> driver cannot be accepted as is.

This is a legacy comment, it does not apply anymore. I will remove it 
and create a new patch.

Cheers
Andreas
