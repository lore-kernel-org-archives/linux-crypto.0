From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Mon, 17 Aug 2015 18:05:04 -0700
Message-ID: <55D284C0.5050201@intel.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1> <20150813035445.25108.76927.stgit@tstruk-mobl1> <20150814051410.GA2370@gondor.apana.org.au> <55CD8733.2000904@intel.com> <20150814062636.GA2799@gondor.apana.org.au> <55CDFA17.3090100@intel.com> <20150817085029.GB28441@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbbHRBGY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 21:06:24 -0400
In-Reply-To: <20150817085029.GB28441@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/17/2015 01:50 AM, Herbert Xu wrote:
>> If you don't like the first option then we still need this, as you pointed out.
> Yes this looks like the right fix for qat.  Please add a sign-off.
> You might be able to just do it by replying to this thread, and
> patchwork may be able to pick it up and attach it to the patch.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
