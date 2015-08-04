From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 04 Aug 2015 06:50:07 -0700
Message-ID: <55C0C30F.6030000@intel.com>
References: <20150730094138.GA15941@gondor.apana.org.au> <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au> <55BBDD1F.4020208@intel.com> <20150802012354.GB10055@gondor.apana.org.au> <55BF9E4E.6020006@intel.com> <20150804095909.GA28167@gondor.apana.org.au> <55C0BDA2.2030302@intel.com> <20150804133218.GA30148@gondor.apana.org.au> <55C0C12C.2030207@intel.com> <20150804134449.GA30282@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144AbbHDNu7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:50:59 -0400
In-Reply-To: <20150804134449.GA30282@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/04/2015 06:44 AM, Herbert Xu wrote:
> On Tue, Aug 04, 2015 at 06:42:04AM -0700, Tadeusz Struk wrote:
>> > On 08/04/2015 06:32 AM, Herbert Xu wrote:
>>> > > What if someone calls adf_remove? For a software implementation
>>> > > you can prevent the algorithm from going away by holding module
>>> > > reference counts.  But a device can always be removed and you're
>>> > > not going to stop that no matter how many reference counts you
>>> > > hold :)
>> > 
>> > No way! It is defined as static ;)
> It's exported as a PCI device, no? PCI devices can be removed
> at any time through sysfs.

right.
