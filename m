From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Tue, 13 May 2014 16:40:58 -0700
Message-ID: <1400024458.2970.247.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
	 <1400023182.2970.238.camel@schen9-DESK>
	 <20140513233410.GA28134@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaEMXlC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 19:41:02 -0400
In-Reply-To: <20140513233410.GA28134@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-14 at 07:34 +0800, Herbert Xu wrote:

> 
> Why do we need this patch since kmap_atomic is equivalent to
> page_address plus preempt_disable on x86-64?

For multi-buffers, you may still have some data lanes with jobs 
that are partially completed when you need to put the thread
to sleep.  With kmap_atomic, you cannot sleep before unmapping.

Thanks.

Tim
