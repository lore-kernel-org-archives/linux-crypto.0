From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 3/5] crypto: qat - use seq_hex_dump() to dump buffers
Date: Thu, 10 Jul 2014 14:20:37 +0300
Message-ID: <1404991237.5102.100.camel@smile.fi.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <53BD8A9F.4030409@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaGJLVK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2014 07:21:10 -0400
In-Reply-To: <53BD8A9F.4030409@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-07-09 at 11:31 -0700, Tadeusz Struk wrote:
> On 07/09/2014 08:24 AM, Andy Shevchenko wrote:
> 
> > In this case it slightly changes the output, namely the four tetrads will be
> > output on one line.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> It's ok, I can still read it.

It seems I miscalculated the tetrads. It should be 8 per line, correct?
In that case we could easily use 32 bytes per line and thus remove that
paragraph from commit message.

> Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>

Thanks!


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
