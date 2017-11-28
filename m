From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] X.509: fix printing uninitialized stack memory when OID is empty
Date: Tue, 28 Nov 2017 11:03:54 +0000
Message-ID: <10620.1511867034@warthog.procyon.org.uk>
References: <20171127071817.25999-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Takashi Iwai <tiwai@suse.de>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754318AbdK1LD4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 06:03:56 -0500
In-Reply-To: <20171127071817.25999-1-ebiggers3@gmail.com>
Content-ID: <10619.1511867034.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I wonder if all -EBADMSG returns here should just print "(badoid)" into the
buffer.

David
