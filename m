From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106 - fixed whitespace
Date: Fri, 07 Mar 2014 17:19:30 -0800
Message-ID: <1394241570.27116.145.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
	 <1394239315.27116.142.camel@schen9-DESK>
	 <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973759@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbaCHBTd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Mar 2014 20:19:33 -0500
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA973759@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-03-07 at 19:06 -0600, McCaffrey, Timothy M wrote:
> Is there any possibility of a register dump at the time of the panic?
> 
> 	- Tim
> 

Try the test code that I included in my mail and see if you hit it 
on your side. Will be easier for you to debug and you can get
the info you need that way.

Tim
