From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Mon, 19 Jan 2015 06:34:29 -0800
Message-ID: <54BD15F5.8@intel.com>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbbASOh5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 09:37:57 -0500
In-Reply-To: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/18/2015 02:56 PM, Stephan Mueller wrote:
> The cipher registered as __driver-gcm-aes-aesni is never intended
> to be used directly by any caller. Instead it is a service mechanism to
> rfc4106-gcm-aesni.
> 
> The kernel crypto API unconditionally calls the registered setkey
> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> call to crypto_aead_setkey will cause a NULL pointer dereference without
> this patch.

Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
