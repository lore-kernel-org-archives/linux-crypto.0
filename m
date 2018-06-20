From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Wed, 20 Jun 2018 11:10:51 -0700
Message-ID: <20180620181051.GC76265@gmail.com>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 07:57:14PM +0900, Juan Manuel Torres Palma wrote:
> Adds test vectors specified in skein v1.3
> specification. The main code is still in staging
> directory, but this is required to eventually be
> moved to the crypto directory.

Also, can you describe the users of Skein in the kernel?  If there are no users,
there's no need to move it out of staging, or even have it in the kernel at all
anymore.  I say that as someone who has had to volunteer to fix critical bugs
found by fuzzing in crypto algorithms for which it's unclear why they are in the
kernel at all, as there are no apparent users.

By the way, syzbot [1] doesn't have CONFIG_CRYPTO_SKEIN enabled, so the Skein
algorithms aren't being fuzzed currently.

[1] https://github.com/google/syzkaller/blob/master/docs/syzbot.md

- Eric
