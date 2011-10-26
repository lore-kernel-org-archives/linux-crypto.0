From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Tue, 25 Oct 2011 17:42:01 -0700
Message-ID: <4EA75759.3050900@xenotime.net>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/25/11 02:36, Stephen Rothwell wrote:
> Hi all,


When CONFIG_NET is not enabled:

ERROR: "nla_put" [crypto/rng.ko] undefined!
ERROR: "nla_put" [crypto/pcompress.ko] undefined!
ERROR: "netlink_kernel_release" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_kernel_create" [crypto/crypto_user.ko] undefined!
ERROR: "init_net" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_unicast" [crypto/crypto_user.ko] undefined!
ERROR: "__alloc_skb" [crypto/crypto_user.ko] undefined!
ERROR: "skb_trim" [crypto/crypto_user.ko] undefined!
ERROR: "skb_put" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_dump_start" [crypto/crypto_user.ko] undefined!
ERROR: "nla_put" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_rcv_skb" [crypto/crypto_user.ko] undefined!
ERROR: "nla_put" [crypto/crypto_hash.ko] undefined!
ERROR: "nla_put" [crypto/crypto_blkcipher.ko] undefined!
ERROR: "nla_put" [crypto/aead.ko] undefined!


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
