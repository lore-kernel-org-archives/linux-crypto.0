From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Fri, 14 Feb 2014 15:28:28 -0500
Message-ID: <20140214202828.GA17267@hmsreliant.think-freely.org>
References: <1392405277.27116.72.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56849 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaBNU2o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 15:28:44 -0500
Content-Disposition: inline
In-Reply-To: <1392405277.27116.72.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 14, 2014 at 11:14:37AM -0800, Tim Chen wrote:
> We added the soft module dependency of various crypto algorithm's module alias
>  to generic crypto algorithm's module. This loads hardware accelerated
>  modules and uses them when available.
> 
This is great, but have any of the module load utilties been modified to
recognize and handle soft dependencies in the modinfo section? Last I checked
they hadn't.  Do you plan to add that functionality?

Neil
