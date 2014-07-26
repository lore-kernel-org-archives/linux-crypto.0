From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
Date: Sat, 26 Jul 2014 15:12:26 -0300
Message-ID: <20140726151226.44cbb027.m.chehab@samsung.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	Linux-Media <linux-media@vger.kernel.org>,
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Steven Toth <stoth@kernellabs.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Em Wed, 9 Jul 2014 14:24:29 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Instead of custom approach let's use recently added seq_hex_dump() helper.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> ack
> 
> Reviewed-by: Steven Toth <stoth@kernellabs.com>
> 
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Regards,
Mauro
