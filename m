From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 18:22:31 +0100
Message-ID: <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207155507.GA15355@gondor.apana.org.au>
	 <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753261AbYLGRXM@vger.kernel.org>
In-Reply-To: <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Dec 7, 2008 at 18:01, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Wrong. First at least because tty/console stuff is built in.
>
> Are you two people or just two names and email addresses for
> the same ?
>
> /dev/console is a logical mapping to a device which may well be
> different, loaded after PCI is initialised and dependant on PCI.

So wrong. If no driver is associated, like early, in that case, we
must return -ENODEV, instead of calling modprobe in a loop. It's a
built-in device, and it's easy to fix.

Again, please start to think about, it's all contained in the kernel,
and the kernel is wrong. Claiming userspace is guilty to triggering
this kernel bug does not help anything.

Kay
