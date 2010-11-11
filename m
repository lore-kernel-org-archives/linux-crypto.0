From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto ahash error handling
Date: Thu, 11 Nov 2010 20:11:21 +0200
Message-ID: <4CDC31C9.8070002@nokia.com>
References: <20101110122759.GA18577@gondor.apana.org.au> <4CDAB23B.9000704@nokia.com> <20101111161707.GA32431@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:47296 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab0KKSLx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Nov 2010 13:11:53 -0500
In-Reply-To: <20101111161707.GA32431@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Yes. Our HW is capable of producing unfinalised hashes.
Everything is fine.

No. It is not broken.. It cleans up if error...

- Dmitry


On 11/11/10 18:17, ext Herbert Xu wrote:
> On Wed, Nov 10, 2010 at 04:54:51PM +0200, Dmitry Kasatkin wrote:
>   
>> This is not good.
>>
>> Driver might allocate some resources, which needs to be released.
>> crypto_ahash_final() should do some kind of "cleanup" task.
>>     
> Then your driver is broken.  The whole hash API is designed around
> the fact that each update operation completely stores all output
> state in the memory provided, leaving no state behind in the
> hardware.
>
> Is your hardware capable of producing unfinalised hashes? If not
> then you shouldn't even be implementing an update operation in
> hardware.  You should instead use a software fallback.
>
> Cheers,
>   
