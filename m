From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 06 Jan 2014 10:00:53 -0800
Message-ID: <52CAEF55.5090308@zytor.com>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com>	 <1389030119.2624.19.camel@schen9-DESK>	 <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com> <1389031023.2624.21.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Borislav Petkov <bp@alien8.de>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:42706 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbaAFSBS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 13:01:18 -0500
In-Reply-To: <1389031023.2624.21.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2014 09:57 AM, Tim Chen wrote:
> On Mon, 2014-01-06 at 09:45 -0800, H. Peter Anvin wrote:
>> Can the code be adjusted to compile for 32 bit x86 or is that pointless?
>>
> 
> Code was optimized for wide registers.  So it is only meant for x86_64.
> 

Aren't the "wide registers" the vector registers?  Or are you also
relying on 64-bit integer registers (in which case we should just rename
the file to make it clear it is x86-64 only.)

	-hpa
