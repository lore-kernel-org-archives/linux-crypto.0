From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] crypto: remove padding logic from rsa.c
Date: Fri, 26 Feb 2016 15:02:00 +0000
Message-ID: <6299.1456498920@warthog.procyon.org.uk>
References: <20160224171258.29272.1684.stgit@tstruk-mobl1> <20160224171237.29272.51126.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbcBZPCD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 10:02:03 -0500
In-Reply-To: <20160224171258.29272.1684.stgit@tstruk-mobl1>
Content-ID: <6298.1456498920.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +		if (memcmp(sig->digest, output, sig->digest_size) ||
> +		    req->dst_len != sig->digest_size)

You must always do the size check first!

David
