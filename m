From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106 - fixed whitespace
Date: Mon, 10 Mar 2014 16:10:51 -0700
Message-ID: <1394493051.27116.155.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
	 <1394239315.27116.142.camel@schen9-DESK>
	 <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973760@USEA-EXCH7.na.uis.unisys.com>
	 <1394243568.27116.151.camel@schen9-DESK>
	 <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973763@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbaCJXLH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 19:11:07 -0400
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973763@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-03-07 at 19:56 -0600, McCaffrey, Timothy M wrote:
> Ok, will generate another patch for glue.c.  Since the asm doesn't verify the aadlen or taglen either (they have a constrained set of values as well), perhaps they should be verified by glue.c as well?
> 
> 	- Tim
> 

Ran through the validation tests and the new code looks good.  The
performance difference is negligible between the new and original 
code for 128 bit key.

Tim Chen
