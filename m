From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:29:45 -0700
Message-ID: <557F8A19.2020302@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150616000519.GA16973@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbbFPCaD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:30:03 -0400
In-Reply-To: <20150616000519.GA16973@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 05:05 PM, Herbert Xu wrote:
> Hmm, we could actually get rid of maxsize by just having each
> function check the dst_len and if it is insufficient write the
> required length in it and then return an error.

Actually I think it is useful. Without it the user will need to allocate
a buffer, and invoke an operation only to find out that the buffer need to be
bigger.
