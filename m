From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: HIFN driver update.
Date: Thu, 13 Nov 2008 17:04:40 +0300
Message-ID: <20081113140440.GA9947@ioremap.net>
References: <20081111190553.GB18218@ioremap.net> <20081113135854.GA32012@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Andreas Gerlich <agl@online.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from matrixpower.ru ([195.178.208.66]:45463 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYKMOEm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 09:04:42 -0500
Content-Disposition: inline
In-Reply-To: <20081113135854.GA32012@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert.

On Thu, Nov 13, 2008 at 09:58:54PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Please send them as separate patches like Patrick's original work.
> Having everything mashed together makes maintainence difficult.

Not sure if it is possible, since half of the Patrick's patches were
not applied because of already made cleanups. I can split to Patrick's
and 'the rest' though. New features (like variable ring size) will be in
the new patches.

-- 
	Evgeniy Polyakov
