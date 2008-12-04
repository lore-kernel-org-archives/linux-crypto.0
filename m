From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: Re: [PATCH 1/4 v2] crypto: sha512 - Remove W (message schedule)	from
 struct sha512_ctx
Date: Thu, 04 Dec 2008 11:51:36 +0100
Message-ID: <4937B638.4080605@codelabs.ch>
References: <12283831302697-git-send-email-ken@codelabs.ch> <12283831303264-git-send-email-ken@codelabs.ch> <20081204100543.GA19425@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailx.swiss-it.ch ([81.6.4.203]:49115 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYLDLQu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 06:16:50 -0500
In-Reply-To: <20081204100543.GA19425@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Thu, Dec 04, 2008 at 10:32:07AM +0100, Adrian-Ken Rueegsegger wrote:
>>  static void
>> -sha512_transform(u64 *state, u64 *W, const u8 *input)
>> +sha512_transform(u64 *state, const u8 *input)
>>  {
>>  	u64 a, b, c, d, e, f, g, h, t1, t2;
>> -
>> +	u64 W[80];
> 
> This is too big for the stack.  So we need to put it somewhere
> else.  A static per-cpu area is one choice.

Yes, sorry about that. I didn't properly read your previous mail. I will
redo the sha512 patches.

Thanks for the review,
Adrian
