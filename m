From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] crypto: remove padding logic from rsa.c
Date: Fri, 26 Feb 2016 14:00:21 +0000
Message-ID: <21318.1456495221@warthog.procyon.org.uk>
References: <20160224171258.29272.1684.stgit@tstruk-mobl1> <20160224171237.29272.51126.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbcBZOAY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 09:00:24 -0500
In-Reply-To: <20160224171258.29272.1684.stgit@tstruk-mobl1>
Content-ID: <21317.1456495221.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +		if (memcmp(sig->digest, output, sig->digest_size) ||

I've added " != 0" after the memcmp().

> +		    req->dst_len != sig->digest_size)
> +			ret = -EBADMSG;

Btw, this has to be -EKEYREJECTED; -EBADMSG would indicate that the container
is unparseable.  I wonder if we should propose a -ESIGREJECTED error...

David
