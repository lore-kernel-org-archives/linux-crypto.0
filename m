From: Rui Wang <rui.y.wang@intel.com>
Subject: Re: [PATCH v2 4/4] crypto: testmgr - Add a test case for import()/export()
Date: Tue,  2 Feb 2016 22:16:34 +0800
Message-ID: <1454422594-19990-1-git-send-email-rui.y.wang@intel.com>
Cc: rui.y.wang@intel.com, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbcBBOge (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 09:36:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 1, 2016 4:22 PM Herbert Xu wrote:
> 
> On Wed, Jan 27, 2016 at 05:08:38PM +0800, Rui Wang wrote:
> >
> > diff --git a/crypto/testmgr.h b/crypto/testmgr.h index
> > da0a8fd..451e7eb 100644
> > --- a/crypto/testmgr.h
> > +++ b/crypto/testmgr.h
> > @@ -44,6 +44,7 @@ struct hash_testvec {
> >  	unsigned short psize;
> >  	unsigned char np;
> >  	unsigned char ksize;
> > +	unsigned char partial;
> 
> Why not make it unconditional?
> 

I initially made it unconditional, but then I found that it can easily
hang the machine during boot due to any import/export bug in any of
the hash drivers. So I used this .partial flag to guard against this
risk. Only when an author is confident that his driver can do this
test, should he add this flag. What do you think?

Thanks
Rui
