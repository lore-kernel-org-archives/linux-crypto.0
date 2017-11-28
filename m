From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto: rsa - fix buffer overread when stripping leading zeroes
Date: Tue, 28 Nov 2017 10:54:32 +0000
Message-ID: <9913.1511866472@warthog.procyon.org.uk>
References: <20171127071649.25800-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932214AbdK1Kyf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 05:54:35 -0500
In-Reply-To: <20171127071649.25800-1-ebiggers3@gmail.com>
Content-ID: <9912.1511866472.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Are you going to take this?

David
