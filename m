From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 14:58:18 +0300
Message-ID: <55AF855A.9000202@freescale.com>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
 <20150722013241.GA31240@gondor.apana.org.au> <55AF19D0.5040700@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	=?UTF-8?B?VHVkb3IgQW1ixINydciZ?= <tudor.ambarus@freescale.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:45024
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964802AbbGVMcS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 08:32:18 -0400
In-Reply-To: <55AF19D0.5040700@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/22/2015 7:19 AM, Tadeusz Struk wrote:
> On 07/21/2015 06:32 PM, Herbert Xu wrote:
>> I think we should finish the conversion of the only in-kernel
>> user of RSA before we add the user-space interface.  Otherwise
>> this unnecessarily ties our hands to the current API.
>>
>> For example, do we want an SG interface for the input and output?
>> As it stands even if a hardware device came with SG support we
>> would not be able to use it.
>>
>> Tadeusz, can you confirm again that qat does not support SG with
>> respect to RSA input and output?
> 
> No, it doesn't. Even if we would add SG support on the API it will
> need to be copied into contiguous buffers before it is sent to the HW.

OTOH, caam has SG support for all PK operations, including rsa-encrypt,
rsa-decrypt primitives.
We are working at upstreaming - aligning our internal caam-pkc with
akcipher.

Please consider designing a flexible AF_ALG interface, as Stephan suggested.

Thanks,
Horia
