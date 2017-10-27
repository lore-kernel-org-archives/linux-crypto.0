From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: ccree: Fix indentation in ssi_buffer_mgr.c
Date: Fri, 27 Oct 2017 07:23:58 -0700
Message-ID: <1509114238.1914.4.camel@perches.com>
References: <20171027015342.6345-1-stephen@brennan.io>
         <20171027083247.sdsdwjiyhyflvjug@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Brennan <stephen@brennan.io>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:39263 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750919AbdJ0OYC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 10:24:02 -0400
In-Reply-To: <20171027083247.sdsdwjiyhyflvjug@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2017-10-27 at 11:32 +0300, Dan Carpenter wrote:
> On Thu, Oct 26, 2017 at 06:53:42PM -0700, Stephen Brennan wrote:
> > In particular, fixes some over-indented if statement bodies as well as a
> > couple lines indented with spaces. checkpatch.pl now reports no warnings
> > on this file other than 80 character warnings.
[]
> > diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
[]
> > @@ -1029,10 +1029,10 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
> >  			 * verification is made by CPU compare in order to simplify
> >  			 * MAC verification upon request completion
> >  			 */
> > -			  u32 size_to_skip = req->assoclen;
> > +			u32 size_to_skip = req->assoclen;
> >  
> > -			  if (areq_ctx->is_gcm4543)
> > -				  size_to_skip += crypto_aead_ivsize(tfm);
> > +			if (areq_ctx->is_gcm4543)
> > +				size_to_skip += crypto_aead_ivsize(tfm);
> >  
> >  			  ssi_buffer_mgr_copy_scatterlist_portion(
> >  				dev, areq_ctx->backup_mac, req->src,
> 
> But then ssi_buffer_mgr_copy_scatterlist_portion() is still not indented
> correctly.

The latest version of checkpatch should bleat something on the
	...scatterlist_portion(
line
