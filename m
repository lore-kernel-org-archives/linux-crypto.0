From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC v4 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Wed, 15 Jun 2016 14:27:04 +0800
Message-ID: <CAMz4kuKXJ5xUXj111VBb9hMH=kT3Y5P3_iVtgeS8kidbLZ+6TA@mail.gmail.com>
References: <cover.1465301616.git.baolin.wang@linaro.org> <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
 <20160607141613.GA2237@gondor.apana.org.au> <CAMz4kuLsAyo7pO3VhCV9QdyHJ8njc6dfvORf55Nc_JTDVR-inQ@mail.gmail.com>
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
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33978 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbcFOG1G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 02:27:06 -0400
Received: by mail-yw0-f181.google.com with SMTP id c72so11666261ywb.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jun 2016 23:27:05 -0700 (PDT)
In-Reply-To: <CAMz4kuLsAyo7pO3VhCV9QdyHJ8njc6dfvORf55Nc_JTDVR-inQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 8 June 2016 at 10:00, Baolin Wang <baolin.wang@linaro.org> wrote:
> Hi Herbert,
>
> On 7 June 2016 at 22:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Tue, Jun 07, 2016 at 08:17:05PM +0800, Baolin Wang wrote:
>>> Now some cipher hardware engines prefer to handle bulk block rather than one
>>> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
>>> the intermediate values (IV) by themselves in one bulk block. This means we
>>> can increase the size of the request by merging request rather than always 512
>>> bytes and thus increase the hardware engine processing speed.
>>>
>>> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
>>> mode.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
>>
>> Nack.  As I said before, please do it using explicit IV generators
>> like we do for IPsec.
>
> OK. I would like to try your suggestion. Thanks.

After some investigation, I still think we should divide the bulk
request from dm-crypt into small request (each one is 512bytes) if
this algorithm is not support bulk mode (like CBC). We have talked
with dm-crypt
maintainers why dm-crypt always use 512 bytes as one request size in
below thread, could you please check it?
http://www.kernelhub.org/?p=2&msg=907022

That means if we move the IV handling into crypto API, we still can
not use bulk interface for all algorithm, for example we still need to
read/write with 512 bytes for CBC, you can't use 4k or more block on
CBC (and most other encryption modes). If only a part of 4k block is
written (and then system crash happens), CBC would corrupt the block
completely. It means if we map one whole bio with bulk interface in
dm-crypt, we need to divide into every 512 bytes requests in crypto
layer. So I don't think we can handle every algorithm with bulk
interface just moving the IV handling into crypto API. Thanks.

>
>> --
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
>
> --
> Baolin.wang
> Best Regards



-- 
Baolin.wang
Best Regards
