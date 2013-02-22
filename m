From: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Fri, 22 Feb 2013 13:14:14 +0200
Message-ID: <CAFtRNNxb+o0P2wpu=k7r_V_rNr8PQf_44emqku_64QD6Ox7p6Q@mail.gmail.com>
References: <51157686.9000404@chronox.de>
	<CAFtRNNzcUpxT3R6ttUJ0c-7QTVRxbwRVq6bPqvkSL93vbstT4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:58371 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3BVLOP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Feb 2013 06:14:15 -0500
In-Reply-To: <CAFtRNNzcUpxT3R6ttUJ0c-7QTVRxbwRVq6bPqvkSL93vbstT4g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm so sorry, something went terribly wrong with gmail/thunderbird :-(

2013/2/22 Nick Kossifidis <mickflemm@gmail.com>:
> Hello all,
>
> It's nice to see there is still discussion on the matter of using cpu
> timings for entropy. In general using cpu timings for gathering entropy is a
> nice idea but it's not that unpredictable. If someone can profile the system
> he/she can get enough infos to predict (to some point) the generator's
> outcome, especially during boot/reboot. You might pass the tests on a single
> run but if you try to compare the runs e.g. when booting the system multiple
> times you'll see they are correlated.
>
> Take a look at this:
>
> http://dl.dropbox.com/u/11670313/runtime-data.tar.bz2
>
> It's the output of this patch, before passing data to the entropy pool (btw
> did anyone review this patch or should I resend it ?):
>
> https://patchwork.kernel.org/patch/1759821/
>
> If you plot the datasets you'll see e.g. that across reboots you get a very
> similar distribution. It is somehow different across boots but still there
> is some correlation there too, notice the difference when fsck runs, still
> not much.
>
> The distribution is good in general, for mixing it with the rest in the
> system's entropy pool, but on its own I don't think it's enough, especially
> without crypto post-processing.



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
