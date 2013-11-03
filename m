From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] random: use device attach events for entropy
Date: Sun, 3 Nov 2013 13:44:07 -0500
Message-ID: <20131103184407.GA7376@thunk.org>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
 <1383485595-2020-2-git-send-email-tytso@mit.edu>
 <20131103145118.GD2007@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53828 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3KCSoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Nov 2013 13:44:12 -0500
Content-Disposition: inline
In-Reply-To: <20131103145118.GD2007@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 03, 2013 at 06:51:18AM -0800, Greg KH wrote:
> Is it an issue that dev->devt will almost always be 0,0 for this
> function call?  Why not use the name instead here, that's more "unique"
> and every device has one, not just a tiny %.

Hmm, good point.  Thanks for raising it.  I'll make this change and
respin the patches.

						- Ted
