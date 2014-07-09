From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
Date: Wed, 09 Jul 2014 14:21:08 -0700
Message-ID: <1404940868.932.168.camel@joe-AO725>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201407092239.30561.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <201407092239.30561.marex@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2014-07-09 at 22:39 +0200, Marek Vasut wrote:
> The above function looks like almost verbatim copy of print_hex_dump(). The only 
> difference I can spot is that it's calling seq_printf() instead of printk(). Can 
> you not instead generalize print_hex_dump() and based on it's invocation, make 
> it call either seq_printf() or printk() ?

How do you propose doing that given any seq_<foo> call
requires a struct seq_file * and print_hex_dump needs
a KERN_<LEVEL>.

Is there an actual value to it?
