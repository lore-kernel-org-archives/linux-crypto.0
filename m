From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Thu, 10 Jun 2010 23:14:33 +0200
Message-ID: <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org,
	Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41996 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0FJVOe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jun 2010 17:14:34 -0400
Content-Disposition: inline
In-Reply-To: <20100610182237.1B48E4CD45@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Phil Sutter | 2010-06-10 20:22:29 [+0200]:

>Hello everyone,
Hi Phil,

please take look at [0] and [1]. From README I can tell that those two
posts are different from you have so far.
You might want to take a look at AF_PACKET interface. It does zero copy
via a ring buffer interface of pre-mmaped user memory. So no
get_user_pages() then :)

I think that is the way to go.

[0] http://article.gmane.org/gmane.linux.kernel.cryptoapi/2656
[1] http://article.gmane.org/gmane.linux.kernel.cryptoapi/2658

>Phil

Sebastian
