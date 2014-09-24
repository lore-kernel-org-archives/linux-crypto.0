From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Check for CCP before registering crypto
 algs
Date: Wed, 24 Sep 2014 14:22:37 +0800
Message-ID: <20140924062237.GA28656@gondor.apana.org.au>
References: <20140905153109.14637.12600.stgit@tlendack-t1.amdoffice.net>
 <alpine.LNX.2.11.1409052327320.570@localhost.localdomain>
 <20140915114709.GB4923@gondor.apana.org.au>
 <54203B3B.70307@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scot Doyle <lkml14@scotdoyle.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51267 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXGWt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2014 02:22:49 -0400
Content-Disposition: inline
In-Reply-To: <54203B3B.70307@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 22, 2014 at 10:07:39AM -0500, Tom Lendacky wrote:
> On 09/15/2014 06:47 AM, Herbert Xu wrote:
> >On Fri, Sep 05, 2014 at 11:49:38PM +0000, Scot Doyle wrote:
> >>
> >>On Fri, 5 Sep 2014, Tom Lendacky wrote:
> >>
> >>>If the ccp is built as a built-in module, then ccp-crypto (whether
> >>>built as a module or a built-in module) will be able to load and
> >>>it will register its crypto algorithms.  If the system does not have
> >>>a CCP this will result in -ENODEV being returned whenever a command
> >>>is attempted to be queued by the registered crypto algorithms.
> >>>
> >>>Add an API, ccp_present(), that checks for the presence of a CCP
> >>>on the system.  The ccp-crypto module can use this to determine if it
> >>>should register it's crypto alogorithms.
> >>>
> >>>Reported-by: Scot Doyle <lkml14@scotdoyle.com>
> >>>Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >>Tested-by: Scot Doyle <lkml14@scotdoyle.com>
> >
> >Patch applied.  Thanks!
> >
> 
> Hi Herbert,
> 
> Can you push this patch into the 3.17 release?

Thanks for the note, I've moved the patch to the crypto tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
