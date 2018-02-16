From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] KEYS: Use individual pages in big_key for crypto buffers [ver #2]
Date: Fri, 16 Feb 2018 09:05:52 +0000
Message-ID: <30807.1518771952@warthog.procyon.org.uk>
References: <20180216015629.GA136603@gmail.com> <151873522941.16065.2576464502758911341.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, Jason@zx2c4.com,
        herbert@gondor.apana.org.au, k.marinushkin@gmail.com,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757543AbeBPJFy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Feb 2018 04:05:54 -0500
In-Reply-To: <20180216015629.GA136603@gmail.com>
Content-ID: <30806.1518771952.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> memset() after vunmap(), and also when buf->virt can be NULL?  I had suggested:
> 
>         if (buf->virt) {
>                 memset(buf->virt, 0, buf->nr_pages * PAGE_SIZE);
>                 vunmap(buf->virt);
>         }

Sorry, yes.  I don't know why the change I made doesn't oops.

David
