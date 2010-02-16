From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Feb 2010 09:05:10 +0200
Message-ID: <4B7A43A6.6090409@nokia.com>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com> <4B799E83.5000700@nokia.com> <20100216004430.GA26021@gondor.apana.org.au> <4B7A3CD8.2000500@nokia.com> <20100216065844.GA28436@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48609 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0BPHKd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 02:10:33 -0500
In-Reply-To: <20100216065844.GA28436@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

How is it possible to wait for completion here?: shash.c

shash_compat_digest()
{
....
        data = crypto_kmap(sg_page(sg), 0);
        err = crypto_shash_digest(desc, data + offset, nbytes, out);
        crypto_kunmap(data, 0);
....
}

It happens as single operation/call.

Thanks,
Dmitry


ext Herbert Xu wrote:
> On Tue, Feb 16, 2010 at 08:36:08AM +0200, Dmitry Kasatkin wrote:
>   
>> Hi,
>>
>> we have HW accelerator which can be accessed without DMA.
>> CPU just sequentially writes data to the port and then reads result.
>>     
>
> Well if that's the case then you definitely don't need anything
> other than kmap_atomic.  You should be able to map it atomically,
> write the data out, unmap it, and then wait for the completion.
>
> Non-atomic kmaps should be avoided if at all possible.
>
> Cheers,
>   
