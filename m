From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: akcipher API: plans
Date: Wed, 26 Aug 2015 12:39:52 -0700
Message-ID: <55DE1608.1010606@intel.com>
References: <8426933.kyc3qjWJkc@tauon.atsec.com>
 <20150826135156.GA24618@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	=?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3022 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbHZTl0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Aug 2015 15:41:26 -0400
In-Reply-To: <20150826135156.GA24618@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 08/26/2015 06:51 AM, Herbert Xu wrote:
>> - Type of input data: currently, the akcipher API uses linear buffers. The 
>> > question was raised to convert it to scatter lists. Linear buffers were seen 
>> > as appropriate as the data to be operated on is usually quite small. However, 
>> > some hardware seems to support scatter lists (CAAM was mentioned). 
> I think an SG interface makes sense even if today's algorithms
> don't need it.  The user-space interface is naturally SG based
> for example.
> 
>> > - Split of setkey into public/private setkey function. The current 
>> > implementation provides ASN.1 structure that allows setting all three 
>> > components forming a public and private key. However, considering the next 
>> > bullet, a split int pub/priv key may need to be considered.
> I think this makes sense too.
> 
>> > - Structure of keys: The current ASN.1 structure is used solely in the kernel. 
>> > Thus, DER keys generated in user space (like by OpenSSL) can only be loaded 
>> > after a conversion. To support such DER keys out of the box, I think only the 
>> > ASN.1 definition must be changed. In addition, the setkey function must be 
>> > split as the ASN.1 structures of a DER pub and private key are completely 
>> > different.
> Ditto.

So I'll rework the API to accommodate your suggestion. I don't really see how sgl
support would be beneficial for buffers that will never be bigger that one page
(in most cases they will not be bigger than 512 bytes) but if you think that the
way to go I fine with that. The split for private and public set_key functions,
even though is not needed for RSA (I think) might be required for other asymmetric
algorithms, so I'll change it.
For RSA I still think I can get both working on existing interface and with
the same ASN.1 definition.
Thanks for your feedback.
T
