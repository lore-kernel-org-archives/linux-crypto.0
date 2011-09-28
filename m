From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] libcrc32c: Expose big-endian version of crc32c
Date: Wed, 28 Sep 2011 13:53:59 +1000
Message-ID: <20110928035356.GA6671@gondor.apana.org.au>
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com> <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 27, 2011 at 03:12:53PM -0700, Darrick J. Wong wrote:
> Provide a big-endian version of crc32c for modules that want it.

Who is going to use this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
