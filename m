From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:55:49 -0700
Message-ID: <557F9035.80500@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150615235954.GC16562@gondor.apana.org.au> <557F883C.5040207@intel.com> <20150616022947.GB19040@gondor.apana.org.au> <557F8E04.7000209@intel.com> <20150616025028.GA19474@gondor.apana.org.au>
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
Received: from mga11.intel.com ([192.55.52.93]:8573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbbFPCzx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:55:53 -0400
In-Reply-To: <20150616025028.GA19474@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 07:50 PM, Herbert Xu wrote:
> If you want to keep the helper generic what you can do is have
> it take struct rsa_key instead of struct crypto_ablkcipher.

Ok I'll do it that way.

> 
> It definitely should just be an optional helper as opposed to
> a required part of crypto_akcipher since you could have a piece
> of hardware that takes the encoded key directly in which case
> you wouldn't need the helper at all.

Oh yes, it is definitely optional.
Thanks
