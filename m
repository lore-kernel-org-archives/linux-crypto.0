From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Mon, 15 Jun 2015 19:41:14 -0700
Message-ID: <557F8CCA.2080405@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201842.15697.59701.stgit@tstruk-mobl1> <20150616000519.GA16973@gondor.apana.org.au> <557F83DF.2090003@intel.com> <20150616022751.GA19040@gondor.apana.org.au>
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
Received: from mga09.intel.com ([134.134.136.24]:50183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbbFPClS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:41:18 -0400
In-Reply-To: <20150616022751.GA19040@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 07:27 PM, Herbert Xu wrote:
>> The two functions will be almost identical. We can do it this way if we want to check
>> > if all the required elements of the key are provided. Currently I'm checking this in the
>> > actual operation.
> Right now your RSA setkey function only works if you supply both
> the public key and the private key.  If the user supplies only one
> key how are you going to tell whether it's public or private?

User can supply only public key and invoke encrypt() or verify() without any problem.
When the user invokes decrypt() or sign() then it will work only after the setkey was
given a private key. This is checked in the actual operation.
So the user is responsible for providing an appropriate key for given operation.
We can split it if you think this is the right thing to do, but currently it works fine.

 
