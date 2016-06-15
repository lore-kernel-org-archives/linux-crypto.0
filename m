From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v4 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Wed, 15 Jun 2016 16:48:19 +0800
Message-ID: <CAMz4kuLc4gdx2EJ=dy8OvBY3J_3OTHX0xi=Ps4YoaO3X-cE-zQ@mail.gmail.com>
References: <cover.1465301616.git.baolin.wang@linaro.org> <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
 <20160607141613.GA2237@gondor.apana.org.au> <CAMz4kuLsAyo7pO3VhCV9QdyHJ8njc6dfvORf55Nc_JTDVR-inQ@mail.gmail.com>
 <CAMz4kuKXJ5xUXj111VBb9hMH=kT3Y5P3_iVtgeS8kidbLZ+6TA@mail.gmail.com>
 <20160615064939.GA14227@gondor.apana.org.au> <CAMz4ku+s-6MQWHhnaau9fK9ssYJNpS9UFvgASoacP0e3vj-zzg@mail.gmail.com>
 <20160615073951.GA14986@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:32933 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbcFOIsV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 04:48:21 -0400
Received: by mail-yw0-f169.google.com with SMTP id g20so14183700ywb.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jun 2016 01:48:20 -0700 (PDT)
In-Reply-To: <20160615073951.GA14986@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 June 2016 at 15:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jun 15, 2016 at 03:38:02PM +0800, Baolin Wang wrote:
>>
>> But that means we should divide the bulk request into 512-byte size
>> requests and break up the mapped sg table for each request. Another
>> hand we should allocate memory for each request in crypto layer, which
>> dm-crypt have supplied one high efficiency way. I think these are
>> really top level how to use the crypro APIs, does that need to move
>> into crypto laryer? Thanks.
>
> I have already explained to you how you can piggy-back off dm-crypt's
> allocation, so what's the problem?

Because the request created in dm-crypt is connecting with dm-crypt
closely, I am worried if it can work or introduce other issues if we
move these top level things into crypto layer. Anyway I will try to do
that. Thanks.

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
