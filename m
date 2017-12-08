From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] KEYS: reject NULL restriction string when type is
 specified
Date: Fri, 8 Dec 2017 09:52:24 -0800 (PST)
Message-ID: <alpine.OSX.2.21.1712080859500.14297@mjmartin-mac01.sea.intel.com>
References: <alpine.OSX.2.21.1711301533110.40510@jsswain-mobl.amr.corp.intel.com> <089e082676ecdedb0b055f394f11@google.com> <20171130205159.97771-1-ebiggers3@gmail.com> <31869.1512744350@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Eric Biggers <ebiggers3@gmail.com>, keyrings@vger.kernel.org,
        syzbot
        <bot+25a1a3685abe943a89512250aece10bdd9aa4827@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <31869.1512744350@warthog.procyon.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 8 Dec 2017, David Howells wrote:

> Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
>
>> Since this fixes the bug for the asymmetric key type and ensures that other
>> key types won't make the same mistake, I agree this is the way to fix it. I
>> did not find any issues in the patch.
>
> Can I put that down as a Reviewed-by?

Yes. Looks like I missed the window for your pull request, though - I'll 
be sure to add Reviewed-by in future reviews.
