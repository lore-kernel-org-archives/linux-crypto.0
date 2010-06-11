From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Fri, 11 Jun 2010 09:47:15 +0200
Message-ID: <4C11EA03.50505@gnutls.org>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc> <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48560 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0FKHr0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jun 2010 03:47:26 -0400
Received: by wwb18 with SMTP id 18so506275wwb.19
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2010 00:47:19 -0700 (PDT)
In-Reply-To: <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Andrzej Siewior wrote:
> * Phil Sutter | 2010-06-10 20:22:29 [+0200]:
> 
>> Hello everyone,
> Hi Phil,
> 
> please take look at [0] and [1]. From README I can tell that those two
> posts are different from you have so far.
> You might want to take a look at AF_PACKET interface. It does zero copy
> via a ring buffer interface of pre-mmaped user memory. So no
> get_user_pages() then :)
> 
> I think that is the way to go.

The problem with right or wrong is that they are only known afterwards.
For me the right way to go is _to go_. I can see discussions in this
least, years ago on talks about the "perfect" userspace crypto api and
rejections implementations because they are not perfect enough. I don't
believe there is such thing as a perfect crypto api. Other operating
systems have a userspace crypto API (maybe not perfect) but linux
hasn't. I don't think this is the way to go.

regards,
Nikos
