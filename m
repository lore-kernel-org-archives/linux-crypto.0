From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v3 1/3] crypto: add PKE API
Date: Thu, 04 Jun 2015 10:23:18 -0700
Message-ID: <55708986.5030506@intel.com>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1> <20150603224408.22310.45114.stgit@tstruk-mobl1> <20150604064929.GA22158@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbbFDRXH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 13:23:07 -0400
In-Reply-To: <20150604064929.GA22158@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 06/03/2015 11:49 PM, Herbert Xu wrote:
> Because the caller is going to be allocating memory for the output,
> we need to provide a way for them to know how much memory to
> allocate.
> 
> This presumably will depend on the key size.
> 
> So something like
> 
> 	int (*maxsize)(struct crypto_akcipher *tfm);
> 
> is needed.
> 
> You should also provide setkey here.  You can't just save a pointer
> to the key.  The transform must hold the key physically as the
> original may go away.  It should also ensure that the key is
> actually valid for the transform.
> 
> base already has ctx so you should get rid of ctx and move base
> to the end of the struct.

right, will do that.
Thanks for quick response.
