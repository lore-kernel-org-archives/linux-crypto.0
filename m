From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Tue, 05 Aug 2008 05:51:34 -0400
Message-ID: <1217929894.1613.0.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217859214.3454.629.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:10367 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbYHEJxW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 05:53:22 -0400
In-Reply-To: <1217859214.3454.629.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 15:13 +0100, David Woodhouse wrote:
> Am I missing something here, or are you registering the crypto algorithm
> _unconditionally_ and then just causing init requests for it to fail on
> older hardware?  Wouldn't it be better to register the driver _only_
> when the hardware is capable? Or at least "if at least one cpu is
> capable".
Thanks, I will move it to module init.
> I think that should depend on CONFIG_X86? 
Thanks.

