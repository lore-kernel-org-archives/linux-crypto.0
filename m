From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Thu, 22 Jan 2015 13:55:13 -0800
Message-ID: <54C171C1.1070000@intel.com>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com> <1876694.bQrN48MF7q@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAVV7J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 16:59:09 -0500
In-Reply-To: <1876694.bQrN48MF7q@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/22/2015 01:20 PM, Stephan Mueller wrote:
> That would be correct. But if I understood Herbert correctly, he is 
> creating a patch that disables these service ciphers for general usage.

Yes, and this should also implicitly fix the problem with user space.
Thanks,
Tadeusz
