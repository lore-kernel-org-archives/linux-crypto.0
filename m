From: "George Spelvin" <linux@horizon.com>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: 17 Feb 2015 12:47:40 -0500
Message-ID: <20150217174740.31169.qmail@ns.horizon.com>
References: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux@horizon.com
To: keescook@chromium.org, minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:29951 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751471AbbBQRrm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Feb 2015 12:47:42 -0500
In-Reply-To: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> And now my head-scratching: your bisect shows that v3.19-rc7 fails,
> but that prior to 4943ba16bbc2, things work correctly? As in, when
> _only_ 5d26a105b5a7 is in your tree things _work_?

Basically, yes.  v3.19-rc7 fails with basically the same symptoms:
wpa_supplicant keeps looping trying to associate.  I haven't compared
the log messages line-by-line.

It appears that it negotiates a crypto key and then fails to pass
it down to the kernel.

I haven't tested 5d26a105b5a7 specifically (when you say "_only_
5d26a105b5a7 is in your tree", do you mean that state, or that commit
cherry-picked?), but 4 commits later (476c7fe20f30) did get tested,
and it worked.  (In fact, that was the final test in my bisect
process; once I typed "git bisect good", things worked.)

Also, one more detail:
- When I changed CTR and CCM from =m to =y, things started working.

Perhaps it's the unexpected case of a module using a static algorithm?
Anyway, let me collect more information before you put more time into
it.

> Could you rename and instrument your /sbin/modprobe to do something like:
>
> #!/bin/sh
> echo "$@" >> /root/modprobe.log
> exec /sbin/modprobe.bin "$@"
> 
> Perhaps there's something being explicitly requested rather than
> having it be kernel auto-loaded?

Glad to.  Thanks for the pointer!

Unless you say otherwise, I'll probably test on 3.19 release, since that
seems the most useful baseline for future repair.
