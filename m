From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Bug 37862] padlock related kernel NULL pointer dereference
Date: Thu, 28 Jul 2011 17:34:08 +0800
Message-ID: <20110728093408.GA5757@gondor.apana.org.au>
References: <bug-37862-2647@https.bugzilla.kernel.org/> <201107280920.p6S9KDhw003188@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jethro Beekman - E.T.S.V. Scintilla" <jethrob@scintilla.utwente.nl>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48789 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1JeQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2011 05:34:16 -0400
Content-Disposition: inline
In-Reply-To: <201107280920.p6S9KDhw003188@demeter1.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 28, 2011 at 09:20:13AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=37862
> 
> 
> 
> 
> 
> --- Comment #10 from Jethro Beekman <kernel@jbeekman.nl>  2011-07-28 09:20:13 ---
> That is interesting, on 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=history;f=drivers/crypto
> that particular patch is included but on
> https://github.com/mirrors/linux-2.6/commits/v2.6.26/drivers/crypto
> it isn't.
> 
> Anyway, my distro's kernel source package has the patch applied.

OK, it does seem that it was applied.  Suresh, any ideas what
might be wrong here? The crash looks eerily like the one that
was fixed by your patch.

> I will try to use the latest kernel, but in the very near future I won't be
> able to test on that system. In that case, I will try to get a colleague
> working on this.

Please do.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
