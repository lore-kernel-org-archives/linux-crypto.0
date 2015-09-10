From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions optimized SHA1 & SHA256
Date: Fri, 11 Sep 2015 00:52:20 +0200
Message-ID: <4887557.26yiVA9gU0@tauon.atsec.com>
References: <cover.1441929717.git.tim.c.chen@linux.intel.com> <1441924040.4322.3.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34092 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbIJWw0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 18:52:26 -0400
In-Reply-To: <1441924040.4322.3.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 10. September 2015, 15:27:20 schrieb Tim Chen:

Hi Tim,

>This patch adds the glue code to detect and utilize the Intel SHA
>extensions optimized SHA1 and SHA256 update transforms when available.
>
>This code has been tested on Broxton for functionality.

A general comment on this file: shouldn't this file be cleaned and use the 
standard mechanisms of the kernel crypto API?

This glue implements its own selection of which SHA implementation to use. But 
the kernel crypto API implements that logic already. The issue with the 
current implementation in this file is that you have no clue which particular 
implementation of SHA is in use in one particular case.

So, may I suggest a restructuring to define independent instances of SHA, such 
as

- cra_name == "sha1", cra_driver_name="sha1_ssse3", cra_priority=300
- cra_name == "sha1", cra_driver_name="sha1_avx", cra_priority=400
- cra_name == "sha1", cra_driver_name="sha1_avx2", cra_priority=500
- cra_name == "sha1", cra_driver_name="sha1_shavx", cra_priority=600

Similarly for the other SHAs?

In all the register functions for the ciphers, you can bail out if the 
hardware does not support an implementation.

Ciao
Stephan
