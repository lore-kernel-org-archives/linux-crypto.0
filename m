From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] KEYS: Use individual pages in big_key for crypto buffers
Date: Thu, 15 Feb 2018 21:36:01 +0000
Message-ID: <13335.1518730561@warthog.procyon.org.uk>
References: <20180215204528.GA49445@gmail.com> <151871006638.2759.15708879200455370908.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, Jason@zx2c4.com,
        herbert@gondor.apana.org.au, k.marinushkin@gmail.com,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162541AbeBOVgD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 16:36:03 -0500
In-Reply-To: <20180215204528.GA49445@gmail.com>
Content-ID: <13334.1518730561.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> If big_key_alloc_buffer() fails to allocate one of the pages then some of
> the pages may still be NULL here, causing __free_page() to crash.  You need
> to check for NULL first.

Ah, yes.  I incorrectly used free_page() first - and that does check for a
NULL pointer.  Applied your other changes also.

David
