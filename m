From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Fri, 11 Jun 2010 11:08:56 +0200
Message-ID: <20100611090856.GA31092@Chamillionaire.breakpoint.cc>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc>
 <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
 <4C11EA03.50505@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38707 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259Ab0FKJJB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jun 2010 05:09:01 -0400
Content-Disposition: inline
In-Reply-To: <4C11EA03.50505@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nikos Mavrogiannopoulos | 2010-06-11 09:47:15 [+0200]:

>Sebastian Andrzej Siewior wrote:
>> * Phil Sutter | 2010-06-10 20:22:29 [+0200]:
>
>The problem with right or wrong is that they are only known afterwards.
>For me the right way to go is _to go_. I can see discussions in this
>least, years ago on talks about the "perfect" userspace crypto api and
>rejections implementations because they are not perfect enough. I don't
>believe there is such thing as a perfect crypto api. Other operating
>systems have a userspace crypto API (maybe not perfect) but linux
>hasn't. I don't think this is the way to go.

Phil asked me for my opinion and he got it. The fundumention problems
from what I've seen was the interface:
- kernel structs which are exposed to userland which limit the
  parameters. For instance the iv was limited to 16 bytes while we have
  allready algos with a much longer iv.
- the interface was using write()/poll()/read() and get_user_pages(). I
  pointed out Herbert's opinion about this and the alternative. So this
  _was_ allready discsussed.

>regards,
>Nikos

Sebastian
