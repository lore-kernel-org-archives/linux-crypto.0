From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Thu, 30 Apr 2015 16:04:41 -0700
Message-ID: <5542B509.9010703@intel.com>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1> <20150430223652.10157.86151.stgit@tstruk-mobl1> <20150430224312.GA30417@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: corbet@lwn.net, keescook@chromium.org, qat-linux@intel.com,
	jwboyer@redhat.com, richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42122 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbD3XHq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 19:07:46 -0400
In-Reply-To: <20150430224312.GA30417@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/30/2015 03:43 PM, Herbert Xu wrote:
> Please remodel it after pcompress or the newly converted rng type.
> 
> This union stuff has been obsolete since 2008 and it's time for
> it to die.

Ok, I didn't realize. Will send v2 shortly.
Thanks
