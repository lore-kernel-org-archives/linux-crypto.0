From: Dwayne Litzenberger <dlitz@dlitz.net>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Sun, 20 Jul 2014 17:25:40 -0700
Message-ID: <20140721002540.GA20595@rivest.lan>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140717170115.GO1491@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 17, 2014 at 01:01:16PM -0400, Theodore Ts'o wrote:
>The getrandom(2) system call is a superset of getentropy(2).  When we
>add the support for this into glibc, it won't be terribly difficult
>nor annoying to drop the following in alongside the standard support
>needed for any new system call:
>
>int getentropy(void *buf, size_t buflen)
>{
>	int	ret;
>
>	ret = getentropy(buf, buflen, 0);
>	return (ret > 0) ? 0 : ret;
>}
>
>The reason for the additional flags is that I'm trying to solve more
>problems than just getentropy()'s raison d'etre.  The discussion of
>this is in the commit description; let me know if there bits that I
>could make clearer.

This could still return predictable bytes during early boot, though, 
right?

-- 
Dwayne C. Litzenberger <dlitz@dlitz.net>
 OpenPGP: 19E1 1FE8 B3CF F273 ED17  4A24 928C EC13 39C2 5CF7
