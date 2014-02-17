From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW accelerated crypto modules
Date: Mon, 17 Feb 2014 11:04:16 +1030
Message-ID: <87ob26d1br.fsf@rustcorp.com.au>
References: <1392405277.27116.72.camel@schen9-DESK> <20140214202828.GA17267@hmsreliant.think-freely.org> <1392412566.27116.77.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "Marco d'Itri" <md@linux.it>
To: Tim Chen <tim.c.chen@linux.intel.com>,
	Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaBQAje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Feb 2014 19:39:34 -0500
In-Reply-To: <1392412566.27116.77.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tim Chen <tim.c.chen@linux.intel.com> writes:

> On Fri, 2014-02-14 at 15:28 -0500, Neil Horman wrote:
>> On Fri, Feb 14, 2014 at 11:14:37AM -0800, Tim Chen wrote:
>> > We added the soft module dependency of various crypto algorithm's module alias
>> >  to generic crypto algorithm's module. This loads hardware accelerated
>> >  modules and uses them when available.
>> > 
>> This is great, but have any of the module load utilties been modified to
>> recognize and handle soft dependencies in the modinfo section? Last I checked
>> they hadn't.  Do you plan to add that functionality?
>> 
>> Neil
>> 
>
> Rusty,
>
> Do you know if the upstream modprobe has the fixes (or plan) to
> recognize soft dependencies?  I was under the impression that it
> is the case.

Marco CC'd...

Cheers,
Rusty.
