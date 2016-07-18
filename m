From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v3 1/4] crypto: add template handling for RNGs
Date: Mon, 18 Jul 2016 11:23:26 -0400
Message-ID: <CACXcFmk2huwT94eVec46Dmfs2p3dcMNzf+nUaFRgYPB-AnZo3g@mail.gmail.com>
References: <2944776.2qGGKJgDkv@positron.chronox.de> <20160718071417.GA12600@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33941 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcGRPXe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 11:23:34 -0400
In-Reply-To: <20160718071417.GA12600@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 18, 2016 at 3:14 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Stephan Mueller <smueller@chronox.de> wrote:

>> This patch adds the ability to register templates for RNGs. RNGs are
>> "meta" mechanisms using raw cipher primitives. Thus, RNGs can now be
>> implemented as templates to allow the complete flexibility the kernel
>> crypto API provides.

I do not see why this might be desirable, let alone necessary.
Security-critical code should be kept as simple as possible.
Don't we need just one good RNG?
