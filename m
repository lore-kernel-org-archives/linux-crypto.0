From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Fri, 12 Jun 2015 07:24:10 -0700
Message-ID: <557AEB8A.2040708@intel.com>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1> <20150611190543.31826.357.stgit@tstruk-mobl1> <2901639.xlpED6EpBc@tauon.atsec.com> <20150612024246.GA30982@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbbFLOYK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 10:24:10 -0400
In-Reply-To: <20150612024246.GA30982@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/11/2015 07:42 PM, Herbert Xu wrote:
>> The testmgr code can mark an entire cipher implementation as fips_allowed=1 as 
>> > already done for RSA. However, unlike with the other ciphers, that flag must 
>> > go in conjunction with the used key sizes.
>> > 
>> > For FIPS mode, the following restrictions apply:
>> > 
>> > - RSA: 2048/3072
>> > 
>> > - DSA: L 2048 / N 224; L 2048 / N 256; L 3072 / N 256
>> > 
>> > - ECDSA: only the NIST curves
>> > 
>> > Any other key sizes for the given ciphers is not allowed in FIPS mode.
>> > 
>> > Should that constraint be considered here?
> Yes.  However it should be placed into a helper that everybody
> can call so that future hardware implementations can also make
> the same checks.

I will make the algorithm marked as fips allowed always and then fail in setkey if fips is enabled
and the given key doesn't meet the fips requirement.
Thanks
