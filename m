From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 2/3] SCRIPTS: s/should/must/ for all ERRORs
Date: Thu, 11 Feb 2010 23:01:19 +0100
Message-ID: <m3y6izl9e8.fsf@intrepid.localdomain>
References: <1265762465-21114-1-git-send-email-richih.mailinglist@gmail.com>
	<20100210084908.ad315b9b.rdunlap@xenotime.net>
	<2d460de71002100959j49c25e37n11a8870454251d84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-crypto@vger.kernel.org,
	Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:49894 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0BKWBn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Feb 2010 17:01:43 -0500
In-Reply-To: <2d460de71002100959j49c25e37n11a8870454251d84@mail.gmail.com>
	(Richard Hartmann's message of "Wed, 10 Feb 2010 18:59:11 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Richard Hartmann <richih.mailinglist@gmail.com> writes:

> Personally, I feel that warnings are suggestions and errors are hard
> limits,

This is technically impossible - humans are much smarter than the simple
checkpatch script and still every one of us was proven wrong, many times.

These hard limits are not that necessary, though - a fair dose of
flexibility and common sense is an advantage.
-- 
Krzysztof Halasa
