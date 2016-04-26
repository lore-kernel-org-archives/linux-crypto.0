From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 08:42:56 -0400
Message-ID: <CACXcFmnFuZ162zOSBuN9_JPd6sCCPiheO33P4KCfF3ERuE=aaQ@mail.gmail.com>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
	<87twipn05w.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35089 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcDZMm6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 08:42:58 -0400
In-Reply-To: <87twipn05w.fsf@tassilo.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 12:06 PM, Andi Kleen <andi@firstfloor.org> wrote:

> Sandy Harris <sandyinchina@gmail.com> writes:
>
> There is also the third problem of horrible scalability of /dev/random
> output on larger systems, for which patches are getting ignored.

I did not write that. I think Andi is quoting himself here, not me.

> https://lkml.org/lkml/2016/2/10/716
>
> Ignoring problems does not make them go away.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only
