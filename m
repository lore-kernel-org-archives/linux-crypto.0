From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Date: Thu, 10 Aug 2017 10:36:51 -0700
Message-ID: <20170810173651.GB90916@gmail.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
 <671b5ffb-0a8b-4e70-e3ac-9754cea54829@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Terrell <terrelln@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <671b5ffb-0a8b-4e70-e3ac-9754cea54829@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 10, 2017 at 10:57:01AM -0400, Austin S. Hemmelgarn wrote:
> Also didn't think to mention this, but I could see the max level
> being very popular for use with SquashFS root filesystems used in
> LiveCD's. Currently, they have to decide between read performance
> and image size, while zstd would provide both.

The high compression levels of Zstandard are indeed a great fit for SquashFS,
but SquashFS images are created in userspace by squashfs-tools.  The kernel only
needs to be able to decompress them.

(Also, while Zstandard provides very good tradeoffs and will probably become the
preferred algorithm for SquashFS, it's misleading to imply that users won't have
to make decisions anymore.  It does not compress as well as XZ or decompress as
fast as LZ4, except maybe in very carefully crafted benchmarks.)

Eric
