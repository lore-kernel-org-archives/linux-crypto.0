From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA
 usage for AHASH_REQUEST_ON_STACK
Date: Sun, 15 Jul 2018 10:44:30 +0800
Message-ID: <20180715024430.n6bcnb4k7cm3ugtj@gondor.apana.org.au>
References: <20180711203619.1020-1-keescook@chromium.org>
	<20180711203619.1020-12-keescook@chromium.org>
	<CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
	<20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
	<CAGXu5jJOZ3u1BTf8U20wErphfjKzaGK+m1sdhA89LqVP3MDYZA@mail.gmail.com>
	<20180713062204.2o7gz5xri374nii6@gondor.apana.org.au>
	<CAGXu5jJp3Y4RZD+ZUYsWqf+sTbGJwdN3M=KOiPBn9VecYE4OgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, qat-linux@intel.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>, dm-devel@redhat.com,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
	<linux-crypto@vger.kernel.org>, Lars Persson <larper@axis.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJp3Y4RZD+ZUYsWqf+sTbGJwdN3M=KOiPBn9VecYE4OgQ@mail.gmail.com>
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

On Fri, Jul 13, 2018 at 08:07:10PM -0700, Kees Cook wrote:
>
> On a plane today I started converting all these to shash. IIUC, it
> just looks like this (apologies for whitespace damage):

Yes if it doesn't actually make use of SGs then shash would be
the way to go.  However, for SG users ahash is the best interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
