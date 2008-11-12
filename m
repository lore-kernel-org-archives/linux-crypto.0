From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: dm-crypt using hifn_795x - still broken
Date: Thu, 13 Nov 2008 01:42:03 +0300
Message-ID: <20081112224202.GA20748@ioremap.net>
References: <200811121710.41666.tobias.geiger@vido.info> <200811122043.06790.tobias.geiger@vido.info> <20081112205121.GB7854@ioremap.net> <200811122336.49835.tobias.geiger@vido.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tobias Geiger <tobias.geiger@vido.info>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:50073 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYKLWmI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 17:42:08 -0500
Content-Disposition: inline
In-Reply-To: <200811122336.49835.tobias.geiger@vido.info>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 12, 2008 at 11:36:49PM +0100, Tobias Geiger (tobias.geiger@vido.info) wrote:
> it works! for the first time i have this card, it actually does something 
> useful ;) Thanks a lot so far!
> 
> Problem now is, it eates up all my cpu somehow - i.e. my system now generates 
> hi/si 98% of the time, everything feels ~200% slower than "normal"

You can play with ring sizes (decrease multiplier in four _RSIZE
definitions), namely decrease multiplier from 4 to 3 for example, I'm
thinking on how to implement it to be more easily tunable.

-- 
	Evgeniy Polyakov
