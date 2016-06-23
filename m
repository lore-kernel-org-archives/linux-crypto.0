From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Thu, 23 Jun 2016 09:27:20 +0800
Message-ID: <20160623012720.GA7143@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
 <20160622140225.GA315@gondor.apana.org.au>
 <576A9E64.2020209@gmail.com>
 <20160622142050.GA540@gondor.apana.org.au>
 <576AA0F4.2020605@gmail.com>
 <20160622143341.GA747@gondor.apana.org.au>
 <alpine.OSX.2.20.1606220813200.16013@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, Denis Kenzior <denkenz@gmail.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37609 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFWB1a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 21:27:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.20.1606220813200.16013@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 08:39:09AM -0700, Mat Martineau wrote:
>
> David Howells has a keyctl patch set in progress that makes use of
> pkcs1pad, with or without a hash:
> 
> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=keys-asym-keyctl&id=6fe3b4aa7df524f4867868b01d4cb4345b1bf2de

I'm sorry but I'm not going to allow arbitrary software algorithms
to be exported to userspace like this.

As I said, if we have a legitimate kernel user or a real hardware
implementation I'll reconsider this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
