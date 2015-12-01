From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 5/5] crypto: AES CBC multi-buffer glue code
Date: Tue, 01 Dec 2015 09:19:33 -0800
Message-ID: <1448990373.22260.0.camel@schen9-desk2.jf.intel.com>
References: <cover.1447977406.git.tim.c.chen@linux.intel.com>
	 <1447971340.4933.81.camel@schen9-desk2.jf.intel.com>
	 <20151124094710.GA32679@gondor.apana.org.au>
	 <1448389806.4933.112.camel@schen9-desk2.jf.intel.com>
	 <20151126084912.GA22103@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbbLARUM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Dec 2015 12:20:12 -0500
In-Reply-To: <20151126084912.GA22103@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-11-26 at 16:49 +0800, Herbert Xu wrote:
> On Tue, Nov 24, 2015 at 10:30:06AM -0800, Tim Chen wrote:
> >
> > On the decrypt path, we don't need to use multi-buffer algorithm
> > as aes-cbc decrypt can be parallelized inherently on a single
> > request.  So most of the time the outer layer algorithm
> > cbc_mb_async_ablk_decrypt can bypass mcryptd and
> > invoke mb_aes_cbc_decrypt synchronously
> > to do aes_cbc_dec when fpu is available.
> > This avoids the overhead of going through mcryptd.  Hence
> > the use of blkcipher on the inner layer.  For the mcryptd
> > path, we will complete a decrypt request in one shot so
> > blkcipher usage should be fine.
> 
> I think there is a misunderstanding here.  Just because you're
> using/exporting through the ablkcipher interface doesn't mean
> that you are asynchrounous.  For example, all blkcipher algorithms
> can be accessed through the ablkcipher interface and they of course
> remain synchrounous.
> 
> So I don't see how using an ablkcipher in the inner layer changes
> anything at all.  You can still return immediately and not bother
> with completion functions when you are synchrounous.
> 
> Cheers,

OK, I'll try to see if I can cast things back to the original ablkcipher
request and use that to walk the sg list.

Tim
