From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 13:13:47 +0300
Message-ID: <4BC443DB.1030602@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22944 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0DMKOU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 06:14:20 -0400
In-Reply-To: <20100413100308.GA9600@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi

On 13/04/10 13:03, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 12:39:55PM +0300, Dmitry Kasatkin wrote:
>    
>> btw. patch to mv_cesa is actually adding hmac to the driver.
>> How would you comment that?
>>      
> AFAICS it's doing HMAC in hardware.  Uri, is that not the case?
>
>    
As I can see from the patch initial vectors calculated with SW shash
Rest is done in hw, basically sha1.

The same can be done with omap driver.
Just in addition to finalize as done in hmac_final().

        crypto_shash_import(desc, opad) ?:
            crypto_shash_finup(desc, out, ds, req->result);


>> The same way could be also used here.
>>      
> If your hardware supports HMAC that would definitely be the way
> to go.
>
> Cheers,
>    
