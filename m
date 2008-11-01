From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: hifn_795x and geode-aes module
Date: Sat, 1 Nov 2008 23:40:32 +0300
Message-ID: <20081101204032.GC27404@ioremap.net>
References: <490C905B.10807@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andreas Gerlich <linux-crypto@online.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:45838 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYKAUkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Nov 2008 16:40:36 -0400
Content-Disposition: inline
In-Reply-To: <490C905B.10807@online.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Sat, Nov 01, 2008 at 06:22:35PM +0100, Andreas Gerlich (linux-crypto@online.de) wrote:
> When I use the software modules (aes_i586, aes_generic) all works.
> 
> The hifn_795x module without geode-aes module works NOT!
> It seems when both modules hifn_795x and goede-aes are loaded only
> the geode-aes is used (only with keysize 128).

Apparently hifn does not work correctly in your case which requires a
little bit of debugging we have discussed in private. When both modules
are loaded, only one with higher prio is used (until you specify exactly
needed module), geode-aes for specified chain mode (cbc, ecb and so on)
is higher for geode aes (400 vs 300 for hifn), so it is used.

-- 
	Evgeniy Polyakov
