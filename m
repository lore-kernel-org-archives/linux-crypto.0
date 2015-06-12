From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Fri, 12 Jun 2015 14:56:56 +0800
Message-ID: <20150612065656.GA466@gondor.apana.org.au>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
 <20150611190543.31826.357.stgit@tstruk-mobl1>
 <20150612025940.GC30982@gondor.apana.org.au>
 <557A811E.7010208@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48013 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbFLG5b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 02:57:31 -0400
Content-Disposition: inline
In-Reply-To: <557A811E.7010208@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2015 at 11:50:06PM -0700, Tadeusz Struk wrote:
>
> Should I make it MPI[] rather than void *

It should be in encoded format since only the algorithms should
be decoding it.  Otherwise you have craziness where RSA-specific
knowledge is placed into x509_cert_parser.c to parse RSA keys.

It's probably easiest to go with the BER encoding that the only
current user is using.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
