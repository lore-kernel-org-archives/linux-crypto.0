From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: hifn_795x module on a 64 bit system
Date: Sat, 27 Feb 2010 20:32:33 +0300
Message-ID: <20100227173233.GA20108@ioremap.net>
References: <da90d1f21002270604q771dfacj28071771bca33ebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Michael Bohn <bohn75@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cet.com.ru ([195.178.208.66]:56671 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030250Ab0B0Rcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2010 12:32:36 -0500
Content-Disposition: inline
In-Reply-To: <da90d1f21002270604q771dfacj28071771bca33ebe@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 27, 2010 at 03:04:13PM +0100, Michael Bohn (bohn75@googlemail.com) wrote:
> is there a way to use the hifn_795x  module on a 64 bit system. ( with
> 4GB  RAM ) ?
> 
> I get this error message if I try to load this module.
> 
> [    3.466307] HIFN supports only 32-bit addresses.
> [ 1147.645181] HIFN supports only 32-bit addresses.

That's it - card only works in 32bit mode, it is limited by descriptor
registers. The only way is to work this around is to allocate temporal
buffer and copy data here and there, which is unlikely to be faster than
software encryption.

-- 
	Evgeniy Polyakov
