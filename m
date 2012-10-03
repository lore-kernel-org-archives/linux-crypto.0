From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
Date: Wed, 03 Oct 2012 02:06:19 -0400 (EDT)
Message-ID: <20121003.020619.772556428995851933.davem@davemloft.net>
References: <20121003054542.GA2416@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au
To: jeff@garzik.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121003054542.GA2416@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 3 Oct 2012 01:45:42 -0400

> 1) tcrypt setup blatantly wrong.  What is the best setup here?  Define a
> separate entry for each digest length?  Is there some special string
> descriptor format that is desired, like "sha3-256" or "sha3(256)"?

Good question.  The base name should probably be something without
dashes.  Maybe "sha3_256", but yeah "sha3256" would look rediculous.
