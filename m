From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 21:12:59 +0300
Message-ID: <1315419179.3576.6.camel@lappy>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <1315417137-12093-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51823 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab1IGSNX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 14:13:23 -0400
In-Reply-To: <1315417137-12093-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2011-09-07 at 13:38 -0400, Jarod Wilson wrote:
> Certain security-related certifications and their respective review
> bodies have said that they find use of /dev/urandom for certain
> functions, such as setting up ssh connections, is acceptable, but if and
> only if /dev/urandom can block after a certain threshold of bytes have
> been read from it with the entropy pool exhausted. Initially, we were
> investigating increasing entropy pool contributions, so that we could
> simply use /dev/random, but since that hasn't (yet) panned out, and
> upwards of five minutes to establsh an ssh connection using an
> entropy-starved /dev/random is unacceptable, we started looking at the
> blocking urandom approach.

Can't you accomplish this in userspace by trying to read as much as you
can out of /dev/random without blocking, then reading out
of /dev/urandom the minimum between allowed threshold and remaining
bytes, and then blocking on /dev/random?

For example, lets say you need 100 bytes of randomness, and your
threshold is 30 bytes. You try reading out of /dev/random and get 50
bytes, at that point you'll read another 30 (=threshold) bytes
out /dev/urandom and then you'll need to block on /dev/random until you
get the remaining 20 bytes.

-- 

Sasha.
