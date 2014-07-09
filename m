From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1 0/5] fs/seq_file: introduce seq_hex_dump() helper
Date: Wed, 09 Jul 2014 11:26:14 -0700
Message-ID: <1404930374.932.142.camel@joe-AO725>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
> This introduces a new helper and switches current users to use it.

While seq_print_hex_dump seems useful, I'm not sure
existing forms can be changed to use it if any output
content changes.

seq_ is supposed to be a stable API.
