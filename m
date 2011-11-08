From: David Miller <davem@davemloft.net>
Subject: Re: Add IPSec IP Range in Linux kernel
Date: Tue, 08 Nov 2011 12:16:20 -0500 (EST)
Message-ID: <20111108.121620.2044664919065812135.davem@davemloft.net>
References: <92909814.20111108111036@mail.ru>
	<1320733465.21617.4.camel@ppwaskie-mobl2>
	<CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: peter.p.waskiewicz.jr@intel.com, danila.st@mail.ru,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
To: adobriyan@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHRQ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 12:16:28 -0500
In-Reply-To: <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 8 Nov 2011 14:08:24 +0200

> changing addr_match() is trivial for ipv4 and easy for ipv6. :-)

No, this is not happening.  This added complexity screws up all the hash table
and lookup optimizations we have in the XFRM layer.
