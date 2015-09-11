From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions
 optimized SHA1 & SHA256
Date: Fri, 11 Sep 2015 13:10:27 -0700
Message-ID: <1442002227.4322.45.camel@schen9-desk2.jf.intel.com>
References: <1441929871.4322.15.camel@schen9-desk2.jf.intel.com>
	 <1671234.vBOzL28The@tauon.atsec.com>
	 <1441997372.4322.37.camel@schen9-desk2.jf.intel.com>
	 <20150911.121509.844598934515668336.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, hpa@zytor.com,
	sean.m.gulley@intel.com, mouli_7982@yahoo.com,
	vinodh.gopal@intel.com, james.guilford@intel.com,
	wajdi.k.feghali@intel.com, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbbIKUK2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Sep 2015 16:10:28 -0400
In-Reply-To: <20150911.121509.844598934515668336.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2015-09-11 at 12:15 -0700, David Miller wrote:
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Date: Fri, 11 Sep 2015 11:49:32 -0700
> 
> > Still, why would some kernel module specifically not want to 
> > use the fastest HW implementation, and explicitly ask for
> > a slower driver?
> 
> Temporary workaround if a bug is found.
> 
> There is really no reason to prevent the user from having this
> flexibility, and in return anyone can test any implementation
> their cpu can support.

Mmmm..., this is a restructuring of the algorithms within
the glue code into multiple drivers instead of one and exposing
them all.  It is a bit orthogonal to the intention of this
patch set.  I think it is better that I create a 
separate patch on the glue code on top of this patch set 
to implement this.

Herbert, do you agree with this approach?

Tim
