From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [BUG] crypto: sun4i-ss: Random data corruption
Date: Sun, 13 Mar 2016 13:40:26 +0100
Message-ID: <56E55FBA.90703@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBPF7SW3QKGQEOSV6L4Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hello

I had some report of random data corruption of people using cryptsetup with my sun4i-ss driver (via AF_ALG).
Even if it is hard to hit, I could confirm it by continuously moving files on a LUKS encrypted FS and comparing hash of it before and after.
The corruption is always when deciphering the end of 512bytes sector and always of a length multiple of 4.

The only way of removing this random corruption is to transform all spinlock_bh by spinlock_irqsave.
In fact this problem is extremely similar to another bug that I have encountered (https://lkml.org/lkml/2015/10/11/47)
The only difference is that I do not need to remove SG_MITER_ATOMIC for removing the issue.

So my question remains nearly the same than on my first problem: Why disabling irq remove this data corruption ?

Any help/suggestions will be really appreciated since I doesn't understand why this fix works.

Regards

LABBE Corentin
