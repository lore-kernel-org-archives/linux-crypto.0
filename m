From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 10 Apr 2015 13:50:56 +0000
Message-ID: <20150410135056.GB28873@io.lakedaemon.net>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Boris,

On Thu, Apr 09, 2015 at 04:58:41PM +0200, Boris Brezillon wrote:
> I know we usually try to adapt existing drivers instead of replacing them
> by new ones, but after trying to refactor the mv_cesa driver I realized it
> would take longer than writing an new one from scratch.

I'm sorry, but this makes me *very* uncomfortable.  Any organization
worth it's salt will do a very careful audit of code touching
cryptographic material and sensitive (decrypted) data.  From that point
on, small audits of the changes to the code allow the organization to
build a comfort level with kernel updates.  iow, following the git
history of the driver.

By apply this series, we are basically forcing those organizations to
either a) stop updating, or b) expend significant resources to do
another full audit.

In short, this series breaks the audit chain for the mv_cesa driver.

Maybe I'm the only person with this level of paranoia.  If so, I'm sure
others will override me.

>From my POV, it looks like the *only* reason we've chosen this route is
developer convenience.  I don't think that's sufficient reason to break
the change history of a driver handling sensitive data.

For an example of how I use the git history and binary differences to
audit a series of changes to cryptographic code, please take a look at
objdiff [1]. You can even duplicate my audit of my submission for the
skein/threefish driver currently in the staging tree, starting at [2]
and going up to [3].

thx,

Jason.

[1] scripts/objdiff [4]
[2] 449bb8125e3f "staging: crypto: skein: import code from Skein3Fish.git"
[3] 0264b7b7fb44 "staging: crypto: skein: rename macros"
[4] There are better tools out there for auditing actual code changes,
    radare (http://radare.org/r/) is one of them.  objdiff is good only
    at validating object code *hasn't* been changed by style commits.
