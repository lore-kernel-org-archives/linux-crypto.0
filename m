From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: next-20081125: crypto hard disk gets unaccessable
Date: Mon, 01 Dec 2008 01:16:06 +0100
Message-ID: <49332CC6.4080606@redhat.com>
References: <20081128063355.GA4700@denkbrett.schottelius.org>
	<20081129192939.925275f0.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christophe Saout <christophe@saout.de>, LKML <linux-kernel@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert@redhat.com, Xu <herbert@gondor.apana.org.au>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081129192939.925275f0.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Andrew Morton wrote:
> (cc's added)
> 
>> After about four suspend & resume operations in the midst of editing
>> a file, the system beeped twice and issued this error:

Did this work before? If so, please can you provide version where
it works?

It is suspend to encrypted swap?

There should not be any recent change in dm-crypt related to this path,
so I expect it is some bug related to suspend/resume in combination with
running crypto - like corruption of some memory caused during suspend...


> [lots of snippage]
>> [69186.618357] RIP: 0010:[<ffffffff8031f246>]  [<ffffffff8031f246>] crypto_xor+0x7/0x48

> [69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
> [69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
> [69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkcipher]
> [69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
> [69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
> [69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]

I assume that crypto run here synchronously (not through asynchronous completion callback).

Herbert - is my guess ok? (The asynchronous handling in dm-crypt was the only part changed recently.)
(And I think that except crypto hw nobody uses asynchronous mode yet by default.)

Milan
--
mbroz@redhat.com
