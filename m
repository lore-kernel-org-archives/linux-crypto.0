From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 06 Jan 2014 13:21:09 -0800
Message-ID: <52CB1E45.6060204@zytor.com>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com> <1389030119.2624.19.camel@schen9-DESK> <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com> <1389031023.2624.21.camel@schen9-DESK> <52CAEF55.5090308@zytor.com> <1389031855.2624.26.camel@schen9-DESK> <20140106202640.GB17863@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbaAFVVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 16:21:33 -0500
In-Reply-To: <20140106202640.GB17863@pd.tnic>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2014 12:26 PM, Borislav Petkov wrote:
> On Mon, Jan 06, 2014 at 10:10:55AM -0800, Tim Chen wrote:
>> Yes, the code is in the file named aesni_intel_avx.S. So it should be
>> clear that the code is meant for x86_64.
> 
> How do you deduce aesni_intel_avx.S is meant for x86_64 only from the
> name?
> 
> Shouldn't it be called aesni_intel_avx-x86_64.S, as is the naming
> convention in arch/x86/crypto/
> 

Quite.

	-hpa
