From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Thu, 22 Jan 2015 10:23:57 -0800
Message-ID: <54C1403D.1010608@intel.com>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <20150120031704.GB10475@gondor.apana.org.au> <40625395.stBBYbAQtz@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbbAVS12 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 13:27:28 -0500
In-Reply-To: <40625395.stBBYbAQtz@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/20/2015 05:25 PM, Stephan Mueller wrote:
>> Rather than adding a bogus setkey function, please fix this mess
>> properly by moving the top-level setkey function into the __driver
>> one where it should be.  Compare with how we handle it in the
>> ablk_helper which is pretty much the same thing.
> 
> Tadeusz, are you working on that update or shall I have a look?
> 
Hi,
No, I thought that the agreement was that we don't want to allow user
space to use these helpers directly, right? Am I missing something?
