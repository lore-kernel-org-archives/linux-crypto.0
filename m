From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
Date: Wed, 9 Jul 2014 14:24:29 -0400
Message-ID: <CALzAhNUUqJNm=o0YoLqoLEnARJ6L34WpcCYScEx5aDeef4B1nQ@mail.gmail.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	Linux-Media <linux-media@vger.kernel.org>,
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 9, 2014 at 11:24 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Instead of custom approach let's use recently added seq_hex_dump() helper.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

ack

Reviewed-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
