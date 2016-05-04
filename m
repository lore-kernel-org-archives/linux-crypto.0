From: Jamie Heilman <jamie@audible.transient.net>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509
 certificate (-2)
Date: Wed, 4 May 2016 02:25:39 +0000
Message-ID: <20160504022539.GE20775@cucamonga.audible.transient.net>
References: <20160503172536.GC20775@cucamonga.audible.transient.net>
 <20160430083248.GA20775@cucamonga.audible.transient.net>
 <26795.1462266613@warthog.procyon.org.uk>
 <11323.1462307740@warthog.procyon.org.uk>
 <5711d3da-7d3c-9ba9-d50e-bf0e24cdc1af@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from audible.transient.net ([24.143.126.66]:36048 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932935AbcEDCZl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 22:25:41 -0400
Content-Disposition: inline
In-Reply-To: <5711d3da-7d3c-9ba9-d50e-bf0e24cdc1af@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk wrote:
> Could you please check if this one fixes the problem for you:
> https://patchwork.kernel.org/patch/8766361/

That patch is already present by 4.6-rc5 and the problem still exists,
so no, it doesn't.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
