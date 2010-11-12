From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto ahash error handling
Date: Fri, 12 Nov 2010 13:30:40 +0200
Message-ID: <4CDD2560.1010509@nokia.com>
References: <20101110122759.GA18577@gondor.apana.org.au> <4CDAB23B.9000704@nokia.com> <20101111161707.GA32431@gondor.apana.org.au> <4CDC31C9.8070002@nokia.com> <20101112000532.GA4188@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:36278 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0KLLbT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 06:31:19 -0500
In-Reply-To: <20101112000532.GA4188@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Well.. That was not the case before.
I made a new patch set.

I will send updates for SHA and AES soon after some more testing.

- Dmitry


On 12/11/10 02:05, ext Herbert Xu wrote:
> On Thu, Nov 11, 2010 at 08:11:21PM +0200, Dmitry Kasatkin wrote:
>   
>> Hi,
>>
>> Yes. Our HW is capable of producing unfinalised hashes.
>> Everything is fine.
>>     
> OK then you should be fine even if the user never makes the "final"
> call, right?
>
> Cheers,
>   
