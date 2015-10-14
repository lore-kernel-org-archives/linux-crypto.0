From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] crypto/nx842: Add CRC and validation support
Date: Wed, 14 Oct 2015 13:20:07 -0700
Message-ID: <561EB8F7.5020206@linux.vnet.ibm.com>
References: <1444337151.10131.10.camel@hbabu-laptop> <20151014142718.GD17455@gondor.apana.org.au> <CALZtOND_g3Y6AT4HMVMTS7c0L4hx5AdxZ-bCQKSc7KogVnoQdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51756 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbbJNUU1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 16:20:27 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Wed, 14 Oct 2015 14:20:26 -0600
In-Reply-To: <CALZtOND_g3Y6AT4HMVMTS7c0L4hx5AdxZ-bCQKSc7KogVnoQdQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/14/2015 07:30 AM, Dan Streetman wrote:
> On Wed, Oct 14, 2015 at 10:27 AM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
>> On Thu, Oct 08, 2015 at 01:45:51PM -0700, Haren Myneni wrote:
>>>
>>> This patch adds CRC generation and validation support for nx-842.
>>> Add CRC flag so that nx842 coprocessor includes CRC during compression
>>> and validates during decompression.
>>>
>>> Also changes in 842 SW compression to append CRC value at the end
>>> of template and checks during decompression.
>>>
>>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>>
>> Patch applied.  Thanks.
> 
> Thanks Herbert, sorry I didn't have a chance to ack it :)
> 
> Haren, as I don't have access to the NX PowerPC hardware anymore and
> you've taken this over for IBM, can you change the maintainer to
> yourself?

Dan, OK, I will send the patch. 

> 
>> --
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
