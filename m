From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] KEYS: reject NULL restriction string when type is specified
Date: Fri, 08 Dec 2017 14:45:50 +0000
Message-ID: <31869.1512744350@warthog.procyon.org.uk>
References: <alpine.OSX.2.21.1711301533110.40510@jsswain-mobl.amr.corp.intel.com> <089e082676ecdedb0b055f394f11@google.com> <20171130205159.97771-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Eric Biggers <ebiggers3@gmail.com>,
        keyrings@vger.kernel.org,
        syzbot
        <bot+25a1a3685abe943a89512250aece10bdd9aa4827@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.21.1711301533110.40510@jsswain-mobl.amr.corp.intel.com>
Content-ID: <31868.1512744350.1@warthog.procyon.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> Since this fixes the bug for the asymmetric key type and ensures that other
> key types won't make the same mistake, I agree this is the way to fix it. I
> did not find any issues in the patch.

Can I put that down as a Reviewed-by?

David
