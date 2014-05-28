From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto/nx/nx-842: dev_set_drvdata can no longer fail
Date: Wed, 28 May 2014 13:39:23 -0700
Message-ID: <20140528203923.GA3687@kroah.com>
References: <20140528140224.3352b072@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1Ufs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2014 16:35:48 -0400
Content-Disposition: inline
In-Reply-To: <20140528140224.3352b072@endymion.delvare>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 28, 2014 at 02:02:24PM +0200, Jean Delvare wrote:
> Don't check if dev_set_drvdata() failed, it can't, and it returns void
> now.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
> Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> ---
> I believe this should go through Greg's driver-core tree, as this is
> where the rest of the dev_set_drvdata() changes are.

You forgot a reported-by: field :(

I'll add it but be more careful in the future...

greg k-h
