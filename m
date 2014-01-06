From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v1] crypto: aesni - fix build on x86 (32bit)
Date: Mon, 06 Jan 2014 09:45:32 -0800
Message-ID: <637fa237-687f-4e88-88d2-4a9dd0c2bf14@email.android.com>
References: <1388411544-4559-1-git-send-email-andriy.shevchenko@linux.intel.com> <1389030119.2624.19.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Borislav Petkov <bp@alien8.de>
To: Tim Chen <tim.c.chen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:42527 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbaAFRqH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 12:46:07 -0500
In-Reply-To: <1389030119.2624.19.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Can the code be adjusted to compile for 32 bit x86 or is that pointless?

Tim Chen <tim.c.chen@linux.intel.com> wrote:
>
>
>On Mon, 2013-12-30 at 15:52 +0200, Andy Shevchenko wrote:
>> It seems commit d764593a "crypto: aesni - AVX and AVX2 version of
>AESNI-GCM
>> encode and decode" breaks a build on x86_32 since it's designed only
>for
>> x86_64. This patch makes a compilation unit conditional to
>CONFIG_64BIT and
>> functions usage to CONFIG_X86_64.
>
>Thanks for catching and fixing it.
>
>Tim
>> 
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
