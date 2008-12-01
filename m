From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Re: next-20081125: crypto hard disk gets unaccessable
Date: Mon, 1 Dec 2008 12:57:49 +0800
Message-ID: <20081201045749.GA18292@gondor.apana.org.au>
References: <20081128063355.GA4700@denkbrett.schottelius.org>
	<20081129192939.925275f0.akpm@linux-foundation.org>
	<49332CC6.4080606@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christophe Saout <christophe@saout.de>,
	Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert@redhat.com
To: Milan Broz <mbroz@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49332CC6.4080606@redhat.com>
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

On Mon, Dec 01, 2008 at 01:16:06AM +0100, Milan Broz wrote:
>
> > [69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
> > [69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
> > [69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkcipher]
> > [69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
> > [69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
> > [69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]
> 
> I assume that crypto run here synchronously (not through asynchronous completion callback).
> 
> Herbert - is my guess ok? (The asynchronous handling in dm-crypt was the only part changed recently.)
> (And I think that except crypto hw nobody uses asynchronous mode yet by default.)

Yes that's definitely synchronous.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
