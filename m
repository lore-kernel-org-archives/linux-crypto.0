From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing of memory regions
Date: Sun, 15 Sep 2013 17:45:53 +0200
Message-ID: <878uyyks0e.fsf@mid.deneb.enyo.de>
References: <5232CDCF.50208@redhat.com>
	<1379259179-2677-1-git-send-email-james@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <dborkman@redhat.com>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ka.mail.enyo.de ([87.106.162.201]:45801 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab3IOPqG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 11:46:06 -0400
In-Reply-To: <1379259179-2677-1-git-send-email-james@openvpn.net> (James
	Yonan's message of "Sun, 15 Sep 2013 09:32:59 -0600")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* James Yonan:

> + * Constant-time equality testing of memory regions.
> + * Returns 0 when data is equal, non-zero otherwise.
> + * Fast path if size == 16.
> + */
> +noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size)

I think this should really return unsigned or int, to reduce the risk
that the upper bytes are truncated because the caller uses an
inappropriate type, resulting in a bogus zero result.  Reducing the
value to 0/1 probably doesn't hurt performance too much.  It also
doesn't encode any information about the location of the difference in
the result value, which helps if that ever leaks.
