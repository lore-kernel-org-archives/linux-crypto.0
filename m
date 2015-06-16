From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 21:48:22 -0700
Message-ID: <557FAA96.2030008@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150616000519.GA16973@gondor.apana.org.au> <557F83DF.2090003@intel.com> <20150616022751.GA19040@gondor.apana.org.au> <557F8CCA.2080405@intel.com> <20150616032511.GA19977@gondor.apana.org.au> <557F99A6.3010904@intel.com> <20150616040605.GA20597@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbFPEs0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 00:48:26 -0400
In-Reply-To: <20150616040605.GA20597@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 09:06 PM, Herbert Xu wrote:
>> No, it will handle whatever it will find. So if a public key will be passed it will only set "n" and "e".
>> > If a private key will be passed it will set all three "n", "e", and "d".
>> > Then during operation I check if there is everything that's required.
> AFAICS the ASN1 parser will call all three functions and bomb out
> if any one of them fails.  If you did make them all optional then
> you'd need to check to ensure that at least n and e are present.
> 
> Also all your test vectors contain private keys.  Please add at
> least one that contains a public key only to test this.

I've just tested it and it works fine for both private and public keys.
I'll add one vector to test only public key case.
Thanks
