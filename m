From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Mon, 5 Sep 2011 10:36:29 +0800
Message-ID: <CACXcFmkxX2=qGDgCdYJ4ZjhX1TOxSmq686eHymc1RgVNuVqMXA@mail.gmail.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34517 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IECga (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Sep 2011 22:36:30 -0400
Received: by vxi9 with SMTP id 9so3511530vxi.19
        for <linux-crypto@vger.kernel.org>; Sun, 04 Sep 2011 19:36:29 -0700 (PDT)
In-Reply-To: <1314974248-1511-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 2, 2011 at 10:37 PM, Jarod Wilson <jarod@redhat.com> wrote:

> Certain security-related certifications and their respective review
> bodies have said that they find use of /dev/urandom for certain
> functions, such as setting up ssh connections, is acceptable, but if and
> only if /dev/urandom can block after a certain threshold of bytes have
> been read from it with the entropy pool exhausted. ...
>
> At present, urandom never blocks, even after all entropy has been
> exhausted from the entropy input pool. random immediately blocks when
> the input pool is exhausted. Some use cases want behavior somewhere in
> between these two, where blocking only occurs after some number have
> bytes have been read following input pool entropy exhaustion. Its
> possible to accomplish this and make it fully user-tunable, by adding a
> sysctl to set a max-bytes-after-0-entropy read threshold for urandom. In
> the out-of-the-box configuration, urandom behaves as it always has, but
> with a threshold value set, we'll block when its been exceeded.

Is it possible to calculate what that threshold should be? The Yarrow
paper includes arguments about the frequency of rekeying required to
keep a block cipher based generator secure. Is there any similar
analysis for the has-based pool? (& If not, should we switch to a
block cipher?)

/dev/urandom should not block unless both it has produced enough
output since the last rekey that it requires a rekey and there is not
enough entropy in the input pool to drive that rekey.

But what is a reasonable value for "enough" in that sentence?
