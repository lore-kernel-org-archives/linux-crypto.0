From: David Miller <davem@davemloft.net>
Subject: Re: [sparc64] crc32c misbehave
Date: Wed, 31 May 2017 11:53:35 -0400 (EDT)
Message-ID: <20170531.115335.213691069712156732.davem@davemloft.net>
References: <CADxRZqzgaL4ew6PVek3WBsdwo6GcT0ORx=7h+6p0V3NAr8qF+w@mail.gmail.com>
        <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, sandeen@sandeen.net,
        linux-crypto@vger.kernel.org
To: matorola@gmail.com
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Anatoly Pugachev <matorola@gmail.com>
Date: Wed, 31 May 2017 14:56:52 +0300

> While debugging occasional crc32c checksum errors with xfs disk reads on
> sparc64 (T5 [sun4v] 3.6 GHz CPU ldom, debian unstable/sid), Eric have found
> that crc32c sometimes returns wrong checksum for data. Eric made a simple
> test kernel module (included), which produce the following results on my
> sparc64 machines:

I don't think that crc32c() is thread safe because of the way it is
implemented with a shared TFM crypto object allocated once at boot
time.

I think you are seeing the corruption any time an interrupt comes in
on the same cpu as your test module is running on and does a crc32c()
calculation, corrupting the context key value being used by your
invocation.

At least that's my guess, I could have misread how the key is stored
and managed around operations.

Can you try something like disabling cpu IRQs around the crc32c() function
in lib/libcrc32c.c?  Something like:

	u32 retval;

	local_irq_disable();

	shash->tfm = tfm;
	shash->flags = 0;
	*ctx = crc;

	err = crypto_shash_update(shash, address, length);
	BUG_ON(err);

	retval = *ctx;

	local_irq_enable();

	return retval;

Thanks.
