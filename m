From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing of memory regions
Date: Mon, 16 Sep 2013 19:25:10 +0200
Message-ID: <87bo3ssmq1.fsf@mid.deneb.enyo.de>
References: <5232CDCF.50208@redhat.com>
	<1379259179-2677-1-git-send-email-james@openvpn.net>
	<878uyyks0e.fsf@mid.deneb.enyo.de> <5235E77F.1050807@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <dborkman@redhat.com>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ka.mail.enyo.de ([87.106.162.201]:60161 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab3IPRZY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Sep 2013 13:25:24 -0400
In-Reply-To: <5235E77F.1050807@openvpn.net> (James Yonan's message of "Sun, 15
	Sep 2013 10:59:43 -0600")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* James Yonan:

> noinline unsigned long __crypto_mem_not_equal(const void *a, const
> void *b, size_t size);
>
> static inline int crypto_mem_not_equal(const void *a, const void *b,
> size_t size) {
> 	return __crypto_mem_not_equal(a, b, size) != 0UL ? 1 : 0;
> }
>
> This hides the fact that we are only interested in a boolean result
> from the compiler when it's compiling crypto_mem_not_equal.c, but also
> ensures type safety when users test the return value.  It's also
> likely to have little or no performance impact.

Yes, that looks good to me.

(I haven't checked the other parts of your patch, though, especially
those where you adjust all callers.)
