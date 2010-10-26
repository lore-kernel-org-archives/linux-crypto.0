From: Huang Ying <ying.huang@intel.com>
Subject: Re: AES-NI for x86?
Date: Tue, 26 Oct 2010 09:28:05 +0800
Message-ID: <1288056485.2862.330.camel@yhuang-dev>
References: <20101025235003.GA6076@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0JZB2H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 21:28:07 -0400
In-Reply-To: <20101025235003.GA6076@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Mathias,

On Tue, 2010-10-26 at 07:50 +0800, Herbert Xu wrote:
> Mathias Krause <minipli@googlemail.com> wrote:
> > Hello list,
> > 
> > will there be a 32-bit version of the Intel AES-NI code? I've seen a 32-bit
> > version in openssl so it should be possible. Not?
> 
> It won't exist unless someone writes one.  Are you volunteering? :)
> 
> Ccing the author in case there is some reason why it won't work in
> 32-bit mode.

It can be done in 32-bit mode. We have not done that simply because we
still have no time to work on that.

You are welcome to do that. :)

Best Regards,
Huang Ying
