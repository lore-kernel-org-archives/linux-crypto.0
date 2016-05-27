From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: AES-NI: slower than aes-generic?
Date: Fri, 27 May 2016 16:40:37 -0400
Message-ID: <CAH8yC8k3WVZWL0=hy4xwvY8NMXfYkYGjDDuK08kbJLdfsT2A6w@mail.gmail.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
	<CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
	<4972668.UQ1QRNriDb@positron.chronox.de>
	<20160527021429.GA21331@thunk.org>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34611 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbcE0Uki (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 16:40:38 -0400
Received: by mail-io0-f170.google.com with SMTP id 190so79061359iow.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2016 13:40:38 -0700 (PDT)
In-Reply-To: <20160527021429.GA21331@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> If we implement something which happens to result in a 2 minute stall
> in boot times, the danger is that a clueless engineer at Sony, or LGE,
> or Motorola, or BMW, or Toyota, etc, will "fix" the problem without
> telling anyone about what they did, and we might not notice right away
> that the fix was in fact catastrophically bad.

This is an non-trivial threat. +1 for recognizing it.

I know of one VM hypervisor used in US Financial that was effectively
doing "One thing you should not do is the following..." from
http://lwn.net/Articles/525459/.

Jeff
