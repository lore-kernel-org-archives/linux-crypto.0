From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/5] KEYS: fixes for new keyctl_dh_compute() KDF extension
Date: Fri, 28 Apr 2017 16:53:00 +0100
Message-ID: <791.1493394780@warthog.procyon.org.uk>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Eric Biggers <ebiggers3@gmail.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939359AbdD1PxD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Apr 2017 11:53:03 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Content-ID: <790.1493394780.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan,

Eric Biggers <ebiggers3@gmail.com> wrote:

> This patch series fixes several bugs in the KDF extension to
> keyctl_dh_compute() currently sitting in keys-next: a way userspace could
> cause an infinite loop, two ways userspace could cause the use of
> uninitialized memory, a misalignment, and missing __user annotations.

Do you want to ack these or do they need fixing?

David
