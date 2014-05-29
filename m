From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] crypto/nx/nx-842: dev_set_drvdata can no longer fail
Date: Thu, 29 May 2014 09:03:27 +0200
Message-ID: <20140529090327.3ec39cc1@endymion.delvare>
References: <20140528140224.3352b072@endymion.delvare>
	<20140528203923.GA3687@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbaE2HDb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 May 2014 03:03:31 -0400
In-Reply-To: <20140528203923.GA3687@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 28 May 2014 13:39:23 -0700, Greg Kroah-Hartman wrote:
> On Wed, May 28, 2014 at 02:02:24PM +0200, Jean Delvare wrote:
> > Don't check if dev_set_drvdata() failed, it can't, and it returns void
> > now.
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
> > Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> > Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> > ---
> > I believe this should go through Greg's driver-core tree, as this is
> > where the rest of the dev_set_drvdata() changes are.
> 
> You forgot a reported-by: field :(
> 
> I'll add it but be more careful in the future...

Sorry, I'm not yet used to reported-by :-( I'll try to remember it next
time.

-- 
Jean Delvare
SUSE L3 Support
