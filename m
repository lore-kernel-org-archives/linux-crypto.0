From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Mon, 20 Jun 2016 17:49:17 +0200
Message-ID: <2101992.L9gKN5cFdv@tauon.atsec.com>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu> <20160620051917.GA8719@gondor.apana.org.au> <20160620150147.GD9848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37408 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbcFTQn2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 12:43:28 -0400
In-Reply-To: <20160620150147.GD9848@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. Juni 2016, 11:01:47 schrieb Theodore Ts'o:

Hi Theodore,

> 
> So simply doing chacha20 encryption in a tight loop in the kernel
> might not be a good proxy for what would actually happen in real life
> when someone calls getrandom(2).  (Another good question to ask is
> when someone might be needing to generate millions of 256-bit session
> keys per second, when the D-H setup, even if you were using ECCDH,
> would be largely dominating the time for the connection setup anyway.)

Is speed everything we should care about? What about:

- offloading of crypto operation from the CPU

- potentially additional security features a hardware cipher may provide like 
cache coloring attack resistance?

Ciao
Stephan
