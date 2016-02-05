From: Marcus Meissner <meissner@suse.de>
Subject: Re: [PATCH 2/2] crypto: testmgr: mark more algorithms as FIPS
 compliant
Date: Fri, 5 Feb 2016 14:42:41 +0100
Message-ID: <20160205134241.GC14228@suse.de>
References: <1454678545-7420-1-git-send-email-meissner@suse.de>
 <2304471.iOLiAjeuEP@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbcBENmn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Feb 2016 08:42:43 -0500
Content-Disposition: inline
In-Reply-To: <2304471.iOLiAjeuEP@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 05, 2016 at 02:41:01PM +0100, Stephan Mueller wrote:
> Am Freitag, 5. Februar 2016, 14:22:25 schrieb Marcus Meissner:
> 
> Hi Marcus,
> 
> >Some more authenc() wrapped algorithms are FIPS compliant, tag
> >them as such.
> 
> Is this patch a duplication of the first one?

yes, I mistakenly sent it as part of a series, while it is not.

Ciao, Marcus
