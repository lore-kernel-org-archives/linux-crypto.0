From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Thu, 22 Jan 2015 14:30:47 -0800
Message-ID: <54C17A17.8060306@intel.com>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <20150120031704.GB10475@gondor.apana.org.au> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com> <20150122222302.GA10895@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13297 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbbAVWeO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 17:34:14 -0500
In-Reply-To: <20150122222302.GA10895@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/22/2015 02:23 PM, Herbert Xu wrote:
> Yes but we should also fix this so that it's a proper aead
> algorithm.
Ok, I'll do that.
Thanks,
Tadeusz
