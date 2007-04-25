From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/5] jffs2: Allow selection of compression mode via a
	sysfs attribute
Date: Wed, 25 Apr 2007 13:31:20 +0100
Message-ID: <1177504280.2755.212.camel@pmac.infradead.org>
References: <1172690034.16062.144.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: Richard Purdie <rpurdie@openedhand.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:52929 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965522AbXDYMb0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Apr 2007 08:31:26 -0400
In-Reply-To: <1172690034.16062.144.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> Allow selection of the compression mode for jffs2 via a sysfs 
> attribute. This establishes a sysfs presence for jffs2 through
> which other compression options could easily be exported too. 

And other options like GC threshold and other allocation things. So
perhaps put the sysfs subsystem_register() and other core bits into a
generic (and Linux-specific) file?

-- 
dwmw2
