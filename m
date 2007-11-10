From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: geode: fix not inplace encryption
Date: Sat, 10 Nov 2007 21:58:19 +0100
Message-ID: <20071110205819.GB15150@Chamillionaire.breakpoint.cc>
References: <20071106200155.GA28183@Chamillionaire.breakpoint.cc> <20071106213040.GA30907@cosmic.amd.com> <20071110113914.GD5485@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jordan Crouse <jordan.crouse@amd.com>,
	linux-crypto@vger.kernel.org, stable@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50681 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbXKJU6W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 15:58:22 -0500
Content-Disposition: inline
In-Reply-To: <20071110113914.GD5485@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-10 19:39:14 [+0800]:

>On Tue, Nov 06, 2007 at 02:30:40PM -0700, Jordan Crouse wrote:
>> On 06/11/07 21:01 +0100, Sebastian Siewior wrote:
>> > Currently the Geode AES module fails to encrypt or decrypt if
>> > the coherent bits are not set what is currently the case if the
>> > encryption does not occur inplace. However, the encryption works 
>> > on my Geode machine _only_ if the coherent bits are always set.
>> > 
>> > Cc: Jordan Crouse <jordan.crouse@amd.com>
>> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>> 
>> Acked-by: Jordan Crouse <jordan.crouse@amd.com>
>> 
>> Anything in the cache is suspect - turning on coherency is the best plan
>> to be rock solid.
>
>Patch applied.  Thanks.
I haven't seen this patch in your crypto tree. Do you think about
pushing this into .24?

Sebastian
