From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC v2 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 3 Jun 2016 15:54:35 +0800
Message-ID: <20160603075435.GA30149@gondor.apana.org.au>
References: <cover.1464346333.git.baolin.wang@linaro.org>
 <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
 <20160602082606.GA15226@gondor.apana.org.au>
 <CAMz4kuJsR0OUJFq68B6znmoTfSeaT_Xhmq14Y4yGSWDJcNE6Hw@mail.gmail.com>
 <20160603065146.GA29953@gondor.apana.org.au>
 <CAMz4ku+C75VxiO41dBZDm9+PZ_BuUWqY_bmhRDbRwKPVCp+O-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
	David Miller <davem@davemloft.net>,
	Eric Biggers <ebiggers3@gmail.com>,
	Joonsoo Kim <js1304@gmail.com>, tadeusz.struk@intel.com,
	smueller@chronox.de, Masanari Iida <standby24x7@gmail.com>,
	Shaohua Li <shli@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sagi Grimberg <sagig@mellanox.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Keith Busch <keith.busch@intel.com>, Tejun Heo <tj@kernel.org>,
	Ming Lei <ming.lei@canonical.com>,
	Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	"open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
	<linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.ker
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36149 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbcFCHzb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jun 2016 03:55:31 -0400
Content-Disposition: inline
In-Reply-To: <CAMz4ku+C75VxiO41dBZDm9+PZ_BuUWqY_bmhRDbRwKPVCp+O-g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 03, 2016 at 03:10:31PM +0800, Baolin Wang wrote:
> On 3 June 2016 at 14:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Fri, Jun 03, 2016 at 02:48:34PM +0800, Baolin Wang wrote:
> >>
> >> If we move the IV generation into the crypto API, we also can not
> >> handle every algorithm with the bulk interface. Cause we also need to
> >> use different methods to map one whole bio or map one sector according
> >> to the algorithm whether can support bulk mode or not. Please correct
> >> me if I misunderstand your points. Thanks.
> >
> > Which ones can't be handled this way?
> 
> What I mean is bulk mode and sector mode's difference is not only the
> IV handling method, but also the method to map the data with
> scatterlists.
> Then we have two processes in dm-crypt ( crypt_convert_block() and
> crypt_convert_bulk_block() ) to handle the data, so we can not handle
> every algorithm with the bulk interface.

As I asked, which algorithm can't you handle through the bulk
interface, assuming it did all the requisite magic to generate
the correct IV?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
