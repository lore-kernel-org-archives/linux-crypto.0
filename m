From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 04 Aug 2015 06:28:17 -0700
Message-ID: <55C0BDF1.4060108@intel.com>
References: <20150730094138.GA15941@gondor.apana.org.au> <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au> <55BBDD1F.4020208@intel.com> <20150802012354.GB10055@gondor.apana.org.au> <55BF9E4E.6020006@intel.com> <20150804095909.GA28167@gondor.apana.org.au> <20150804124726.GA29660@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbbHDN3J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:29:09 -0400
In-Reply-To: <20150804124726.GA29660@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/04/2015 05:47 AM, Herbert Xu wrote:
> In order to make progress I'm going to fold your patch into my
> series and push it into cryptodev.
> 
> I'll try to come up with a proper fix for this after I'm done
> with the AEAD stuff.

Thanks. Also thanks for converting this. It looks much cleaner now.
