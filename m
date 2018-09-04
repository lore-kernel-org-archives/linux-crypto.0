From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: xts - Drop use of auxiliary buffer
Date: Tue, 4 Sep 2018 11:38:16 +0800
Message-ID: <20180904033815.3titfipifya2zg7r@gondor.apana.org.au>
References: <20180903112942.18979-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-crypto@vger.kernel.org,
	omosnace@redhat.com
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180903112942.18979-1-omosnace@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Ondrej Mosnacek <omosnace@redhat.com> wrote:
> Hi Herbert, Mikulas,
> 
> I noticed the discussion about using kmalloc() inside crypto code and it
> made me wonder if the code in xts.c can actually be simplified to not
> require kmalloc() at all, while not badly affecting performace. I played
> around with it a little and it turns out we can drop the whole caching
> of tweak blocks, reducing code size by ~200 lines and not only preserve,
> but even improve the performance in some cases. See the full patch
> below.
> 
> Obviously, this doesn't solve the general issue of using kmalloc() in
> crypto API routines, but it does resolve the original reported problem
> and also makes the XTS code easier to maintain.

Nice work.  Unfortunately it doesn't apply against the latest
cryptodev tree.  Please rebase and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
