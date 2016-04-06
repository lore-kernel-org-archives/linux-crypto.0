From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 0/3] crypto: af_alg - add TLS type encryption
Date: Wed, 6 Apr 2016 10:56:12 -0700
Message-ID: <57054DBC.8010507@intel.com>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
 <20160405112940.GB11852@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbcDFSBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 14:01:20 -0400
In-Reply-To: <20160405112940.GB11852@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 04/05/2016 04:29 AM, Herbert Xu wrote:
> On Sat, Mar 05, 2016 at 05:20:44PM -0800, Tadeusz Struk wrote:
>> > Hi,
>> > The following series adds TLS type authentication. To do this a new
>> > template, encauth, is introduced. It is derived from the existing authenc
>> > template and modified to work in "first auth then encrypt" mode.
>> > The algif interface is also changed to work with the new authentication type.
> What is the point of this patch-set? Who is going to be the user?

The intend is to enable HW acceleration of the TLS protocol.
The way it will work is that the user space will send a packet of data
via AF_ALG and HW will authenticate and encrypt it in one go.

> 
> Also you're including padding into the algorithm.  That goes against
> the way we implemented IPsec.  What is the justification for doing
> it in the crypto layer instead of the protocol layer?

This is because of how the TLS protocol work. In IPSEC the stack does the job
of aligning the packet to block size and the crypto layer doesn't need to worry
about padding. In TLS we need to make sure that after auth the buff is still
block size align, and that is why we need padding.
Do you think we should make the user to provide the data in a big enough buffer
to accommodate the digest and padding and the padding itself?
Thanks,
-- 
TS
