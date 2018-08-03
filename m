From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v6 16/18] rxrpc: Reuse SKCIPHER_REQUEST_ON_STACK buffer
Date: Fri, 03 Aug 2018 10:14:28 +0100
Message-ID: <9082.1533287668@warthog.procyon.org.uk>
References: <CAGXu5jLVNnUXkyzGdee3zvLHw5zMaDhEGm4c4YLqU=L8q9TshA@mail.gmail.com> <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-17-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Kees Cook <keescook@chromium.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLVNnUXkyzGdee3zvLHw5zMaDhEGm4c4YLqU=L8q9TshA@mail.gmail.com>
Content-ID: <9081.1533287668.1@warthog.procyon.org.uk>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hmmm...  I'm wondering if the skcipher request should be allocated on call
initialisation and a pointer put in the rxrpc_call struct.  It's only used
serially for any particular call.

For the moment, I'll pass your patch onto DaveM.

David
