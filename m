From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v3 2/3] crypto: RSA: KEYS: convert rsa and public
 key to new PKE API
Date: Fri, 05 Jun 2015 09:42:39 -0700
Message-ID: <5571D17F.90502@intel.com>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>	 <20150603224414.22310.17260.stgit@tstruk-mobl1> <1433494212.3358.16.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:39728 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422987AbbFEQmz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 12:42:55 -0400
In-Reply-To: <1433494212.3358.16.camel@x220>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/05/2015 01:50 AM, Paul Bolle wrote:
> This builds two modules if PUBLIC_KEY_ALGO_RSA = 'm': rsa.ko and
> rsa_pkcs1_v1_5.ko. Is that what you want?

No, this not what I wanted.

> 
> public_key.c uses this, so it can end up in public_key.ko. But it's not
> exported. So a _quick and dirty_ build test generated:
>     WARNING: "rsa_pkcs1_v1_5_verify_signature" [[...]/crypto/asymmetric_keys/public_key.ko] undefined!
> 
> Also no MODULE_LICENSE() macro, so loading rsa_pkcs1_v1_5.ko should
> trigger a warning and taint the kernel.

Thank you Paul for taking the time to review the patches and for your feedback.
I'll have to change this again based on Herbert's feedback so this rsa_pkcs1_v1_5.c file
will go away anyway.
