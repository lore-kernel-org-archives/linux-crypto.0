From: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Fri, 14 Aug 2009 09:01:07 +0800
Message-ID: <1250211667.5337.288.camel@yhuang-dev.sh.intel.com>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
	 <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
	 <20090813045300.GA19993@gondor.apana.org.au>
	 <20090813073910.GA21784@gondor.apana.org.au>
	 <20090813131253.GA27289@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbZHNBBN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 21:01:13 -0400
In-Reply-To: <20090813131253.GA27289@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2009-08-13 at 21:12 +0800, Herbert Xu wrote:
> On Thu, Aug 13, 2009 at 05:39:10PM +1000, Herbert Xu wrote:
> > 
> > Oh I see what's going on.  It's the switch from chainiv to eseqiv
> > that created the error.  I'll apply your patch.
> 
> Actually we can't use seqiv on raw counter mode because it cannot
> guarantee IV uniqueness.  I think reverting to chainiv is the safer
> option.


I see seqiv is used in rfc3686 mode, it means seqiv can not be used on
raw counter mode but can be used for rfc3686?

Best Regards,
Huang Ying

