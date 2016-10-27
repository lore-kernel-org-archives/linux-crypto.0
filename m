From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [ANNOUNCE] libkcapi v0.12.0 released
Date: Thu, 27 Oct 2016 04:52:07 +0200
Message-ID: <10631833.2nPcTagHHZ@positron.chronox.de>
References: <2974976.xU0nDqBFOZ@positron.chronox.de> <CAH8yC8n+37D+4i6-WS8yZMLOm-LvMnVV93uWbPcOStwJRWvFWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47028 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934884AbcJ0CwM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 22:52:12 -0400
In-Reply-To: <CAH8yC8n+37D+4i6-WS8yZMLOm-LvMnVV93uWbPcOStwJRWvFWA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 26. Oktober 2016, 22:05:28 CEST schrieb Jeffrey Walton:

Hi Jeffrey,

> > The Linux kernel exports a network interface of type AF_ALG to allow user
> > space to utilize the kernel crypto API. libkcapi uses this network
> > interface and exports an easy to use API so that a developer does not
> > need to consider the low-level network interface handling.
> > 
> > The library does not implement any low level cipher algorithms. All
> > consumer requests are sent to the kernel for processing. Results from the
> > kernel crypto API are returned to the consumer via the library API.
> > 
> > The kernel interface and therefore this library can be used by
> > unprivileged
> > processes.
> > 
> > The library code archive also provides a drop-in replacement for the
> > command line tools of sha*sum, fipscheck/fipshmac and sha512hmac.
> > 
> > The source code and the documentation is available at [1].
> 
> That looks awesome Stephan.
> 
> How can user code reliably detect when the API is available? Are there

The detection is done through the various _init calls such as 
kcapi_cipher_init. They will return an error if AF_ALG is not available. 
According to the documentation these calls return:

 * @return 0 upon success; ENOENT - algorithm not available;
 *          -EOPNOTSUPP - AF_ALG family not available;
 *          -EINVAL - accept syscall failed
 *          -ENOMEM - cipher handle cannot be allocated

Technically, the bind operation will fail if the respective AF_ALG interface 
is not available.

> any preprocessor macros to guard code paths in userland? What are the

There are no special guards. If AF_ALG is available, all user space processes 
can use it.

> preprocessor macros we can use to guard it?

I am not entirely sure I understand the question.
> 
> Jeff


Ciao
Stephan
