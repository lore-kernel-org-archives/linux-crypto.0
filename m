From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/2] KEYS: Use pkcs1pad for padding in software_pkey
Date: Wed, 24 Feb 2016 17:28:23 +0000
Message-ID: <28905.1456334903@warthog.procyon.org.uk>
References: <20160224171237.29272.51126.stgit@tstruk-mobl1> <12559.1456224799@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbcBXR20 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 12:28:26 -0500
In-Reply-To: <20160224171237.29272.51126.stgit@tstruk-mobl1>
Content-ID: <28904.1456334903.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> I have converted the software_pkey to make use of the pkcs1pad
> template. The rsa.c is reverted back to what it was i.e. just
> math primitives and all padding is done in rsa-pkcs1padd.c
> software_pkey.c just allocates pksc1padd(alg,hash)

Okay, thanks - I'll take a look at that later.

One thought that just occurred to me: would it make sense to make a second
crypto template in rsa-pkcs1pad.c and call it "rsassa-pkcs1-v1_5" that does
this padding variant?  It can share most of its code with the generic pkcs1pad
algorithm.

We could then also add a third variant "rsassa-pss" at a later date.

David
