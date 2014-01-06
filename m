From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 06 Jan 2014 15:41:51 -0800
Message-ID: <52CB3F3F.5070105@zytor.com>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>	 <1389030119.2624.19.camel@schen9-DESK>	 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>	 <1389031023.2624.21.camel@schen9-DESK> <52CAEF55.5090308@zytor.com>	 <1389031855.2624.26.camel@schen9-DESK> <20140106202640.GB17863@pd.tnic>	 <52CB1E45.6060204@zytor.com> <1389051546.2624.31.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Borislav Petkov <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:46682 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbaAFXmS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 18:42:18 -0500
In-Reply-To: <1389051546.2624.31.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2014 03:39 PM, Tim Chen wrote:
> 
> Will renaming the file to aesni_intel_avx-x86_64.S make things clearer
> now?
> 
> Tim

Yes.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

Herbert, can you pick it up?

	-hpa
