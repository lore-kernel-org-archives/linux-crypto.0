From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] X.509: fix comparisons of ->pkey_algo
Date: Tue, 28 Nov 2017 10:57:54 +0000
Message-ID: <10025.1511866674@warthog.procyon.org.uk>
References: <20171127071724.25874-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932660AbdK1K54 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 05:57:56 -0500
In-Reply-To: <20171127071724.25874-1-ebiggers3@gmail.com>
Content-ID: <10024.1511866674.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> if (strcmp(x509->pub->pkey_algo, sinfo->sig->pkey_algo))

Can you make this strcmp(...) != 0?  I know it may seem picky, but checking
strcmp() in this way kind of inverts the true/false thing.

Thanks,
David
