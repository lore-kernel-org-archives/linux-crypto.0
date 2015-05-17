From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-sunxi] Re: [PATCH v9 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 17 May 2015 09:32:03 +0800
Message-ID: <20150517013203.GA5161@gondor.apana.org.au>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
 <1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
 <20150515065222.GA16808@gondor.apana.org.au>
 <555787D7.80708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
	joe@perches.com, tj@kernel.org, arnd@arndb.de,
	boris.brezillon@free-electrons.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <555787D7.80708@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, May 16, 2015 at 08:09:27PM +0200, Corentin LABBE wrote:
>
> Incidental question, I need to use the MD5 IV for export_md5 function, but they are not defined anywhere (unlike SHAxx ones), does this is voluntary or do you will accept a patch for adding them.

Please send a patch to add them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
