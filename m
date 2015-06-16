From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 11:25:11 +0800
Message-ID: <20150616032511.GA19977@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
 <20150616000519.GA16973@gondor.apana.org.au>
 <557F83DF.2090003@intel.com>
 <20150616022751.GA19040@gondor.apana.org.au>
 <557F8CCA.2080405@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38691 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbFPDZ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 23:25:29 -0400
Content-Disposition: inline
In-Reply-To: <557F8CCA.2080405@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 07:41:14PM -0700, Tadeusz Struk wrote:
>
> User can supply only public key and invoke encrypt() or verify() without any problem.
> When the user invokes decrypt() or sign() then it will work only after the setkey was
> given a private key. This is checked in the actual operation.

The current parse_key function requires all three number to be
present, n, e, and d, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
