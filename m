From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
Date: Thu, 10 Jul 2014 03:01:43 -0700
Message-ID: <1404986503.8839.24.camel@joe-AO725>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201407092239.30561.marex@denx.de> <1404940868.932.168.camel@joe-AO725>
	 <201407100958.02218.marex@denx.de>
	 <1404985839.5102.97.camel@smile.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Marek Vasut <marex@denx.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:39601 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751942AbaGJKBs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2014 06:01:48 -0400
In-Reply-To: <1404985839.5102.97.camel@smile.fi.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2014-07-10 at 12:50 +0300, Andy Shevchenko wrote:
> I have considered to modify hex_dump_to_buffer() to return how many
> bytes it actually proceed to the buffer. In that case we can directly
> print to m->buf like other seq_<foo> calls do.
> 
> But I still have doubts about it. Any opinion?

Simpler is better.
