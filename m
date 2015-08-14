From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Fri, 14 Aug 2015 14:26:36 +0800
Message-ID: <20150814062636.GA2799@gondor.apana.org.au>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
 <20150813035445.25108.76927.stgit@tstruk-mobl1>
 <20150814051410.GA2370@gondor.apana.org.au>
 <55CD8733.2000904@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48458 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbHNG0v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 02:26:51 -0400
Content-Disposition: inline
In-Reply-To: <55CD8733.2000904@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 11:14:11PM -0700, Tadeusz Struk wrote:
> 
> Right, but we don't need that anymore.

Why not? If you reduce the size without moving the buffer wouldn't
it begin with a bunch of zeroes and wouldn't you lose the real bytes
at the end?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
