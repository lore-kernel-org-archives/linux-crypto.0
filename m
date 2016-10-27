From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [ANNOUNCE] libkcapi v0.12.0 released
Date: Wed, 26 Oct 2016 22:05:28 -0400
Message-ID: <CAH8yC8n+37D+4i6-WS8yZMLOm-LvMnVV93uWbPcOStwJRWvFWA@mail.gmail.com>
References: <2974976.xU0nDqBFOZ@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33642 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcJ0CF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 22:05:29 -0400
Received: by mail-oi0-f68.google.com with SMTP id i127so2112643oia.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2016 19:05:29 -0700 (PDT)
In-Reply-To: <2974976.xU0nDqBFOZ@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> The Linux kernel exports a network interface of type AF_ALG to allow user
> space to utilize the kernel crypto API. libkcapi uses this network interface
> and exports an easy to use API so that a developer does not need to consider
> the low-level network interface handling.
>
> The library does not implement any low level cipher algorithms. All consumer
> requests are sent to the kernel for processing. Results from the kernel crypto
> API are returned to the consumer via the library API.
>
> The kernel interface and therefore this library can be used by unprivileged
> processes.
>
> The library code archive also provides a drop-in replacement for the command
> line tools of sha*sum, fipscheck/fipshmac and sha512hmac.
>
> The source code and the documentation is available at [1].

That looks awesome Stephan.

How can user code reliably detect when the API is available? Are there
any preprocessor macros to guard code paths in userland? What are the
preprocessor macros we can use to guard it?

Jeff
