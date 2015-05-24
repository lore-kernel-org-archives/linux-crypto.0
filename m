From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Sun, 24 May 2015 11:32:53 +0800
Message-ID: <20150524033253.GB20656@gondor.apana.org.au>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
 <1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
 <20150517104508.468b032f@bbrezillon>
 <55607CB7.8020505@gmail.com>
 <20150523163536.2d64ef8d@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
	joe@perches.com, tj@kernel.org, arnd@arndb.de,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150523163536.2d64ef8d@bbrezillon>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, May 23, 2015 at 04:35:36PM +0200, Boris Brezillon wrote:
>
> > Since all SG I get was always a multiple of 16 (AES BLOCK SIZE) it was a sort of confirmation.
> > 
> > Herbert ? does am I right or a chunking test is missing for cbc(aes) in testmgr.h
> 
> Okay, just sharing my vision of this thing (I'll let Herbert comment on
> this aspect): I'd say that theoretically nothing prevents one from
> splitting its sg list in chunks smaller than the block size, so I'd
> say you should use the same trick for AES. 

Indeed, you must be able to handle a block that straddles two SG
entries.  If the hardware is not capable then you have to linearise
it by copying or use a fallback.

I can't believe we don't have a generic test for this in testmgr.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
