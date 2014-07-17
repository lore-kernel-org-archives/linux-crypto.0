From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 13:01:16 -0400
Message-ID: <20140717170115.GO1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140717161215.GA14951@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 17, 2014 at 09:12:15AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
> > The getrandom(2) system call was requested by the LibreSSL Portable
> > developers.  It is analoguous to the getentropy(2) system call in
> > OpenBSD.
> 
> What's the reason to not implement exactly the same system call OpenBSD
> does?  Having slightly different names and semantics for the same
> functionality is highly annoying.

The getrandom(2) system call is a superset of getentropy(2).  When we
add the support for this into glibc, it won't be terribly difficult
nor annoying to drop the following in alongside the standard support
needed for any new system call:

int getentropy(void *buf, size_t buflen)
{
	int	ret;

	ret = getentropy(buf, buflen, 0);
	return (ret > 0) ? 0 : ret;
}

The reason for the additional flags is that I'm trying to solve more
problems than just getentropy()'s raison d'etre.  The discussion of
this is in the commit description; let me know if there bits that I
could make clearer.

Cheers,

					- Ted
