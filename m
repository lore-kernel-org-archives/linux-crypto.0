From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions optimized SHA1 & SHA256
Date: Fri, 11 Sep 2015 19:02:04 +0200
Message-ID: <1671234.vBOzL28The@tauon.atsec.com>
References: <cover.1441929717.git.tim.c.chen@linux.intel.com> <4887557.26yiVA9gU0@tauon.atsec.com> <1441929871.4322.15.camel@schen9-desk2.jf.intel.com>
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
Received: from mail.eperm.de ([89.247.134.16]:34103 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbIKRCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Sep 2015 13:02:11 -0400
In-Reply-To: <1441929871.4322.15.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 10. September 2015, 17:04:31 schrieb Tim Chen:

Hi Tim,
>
>Is there a scenario you can think of
>when a lower performing sha1 transform needs to
>be exposed as a separate driver?

My immediate concern is testing: it is hard to test the individual 
implementations.
>
>Otherwise the glue code logic will only expose the
>best performing one for a cpu and hide the others, which was intentional
>on our part to prevent a lower performing sha from getting used.

Agreed, but the kernel crypto API does that already using the priorities -- 
IMHO a very clean and easy to interpret solution.

Furthermore, if somebody really has a need to not use the fastest HW 
implementation, the kernel crypto API allows him to do that. With the hard-
wired approach in the glue file, you are stuck.


Ciao
Stephan
