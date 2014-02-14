From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Fri, 14 Feb 2014 13:16:06 -0800
Message-ID: <1392412566.27116.77.camel@schen9-DESK>
References: <1392405277.27116.72.camel@schen9-DESK>
	 <20140214202828.GA17267@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56999 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaBNVQJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 16:16:09 -0500
In-Reply-To: <20140214202828.GA17267@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-02-14 at 15:28 -0500, Neil Horman wrote:
> On Fri, Feb 14, 2014 at 11:14:37AM -0800, Tim Chen wrote:
> > We added the soft module dependency of various crypto algorithm's module alias
> >  to generic crypto algorithm's module. This loads hardware accelerated
> >  modules and uses them when available.
> > 
> This is great, but have any of the module load utilties been modified to
> recognize and handle soft dependencies in the modinfo section? Last I checked
> they hadn't.  Do you plan to add that functionality?
> 
> Neil
> 

Rusty,

Do you know if the upstream modprobe has the fixes (or plan) to
recognize soft dependencies?  I was under the impression that it
is the case.

Thanks.

Tim
