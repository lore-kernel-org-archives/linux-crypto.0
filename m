From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] splice: sendfile() at once fails for big files
Date: Tue, 5 May 2015 21:34:51 -0700
Message-ID: <20150506043451.GA9130@infradead.org>
References: <20150423150308.8782B1A2439@localhost.localdomain>
 <20150427070131.GA21190@gondor.apana.org.au>
 <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jens Axboe <axboe@kernel.dk>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbEFEe7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 00:34:59 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 05, 2015 at 08:41:05PM -0700, Linus Torvalds wrote:
> Jens, ping?
> 
> The test results should make this a no-brainer, but I hate how random
> these flag ops.

Not Jens here, but:

 (a) the patch looks correct, we do want to set the more flag if there
     is more data
 (b) I think  the AF_ALG model is totally broken if it relies on that
     for data integrity purposes.
