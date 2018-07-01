From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 11/11] crypto: skcipher: Remove VLA usage
 for SKCIPHER_REQUEST_ON_STACK
Date: Sun, 1 Jul 2018 14:24:19 +0800
Message-ID: <20180701062419.3opt7mnljf76hi4k@gondor.apana.org.au>
References: <20180625211026.15819-1-keescook@chromium.org>
	<20180625211026.15819-12-keescook@chromium.org>
	<20180626092041.mxfg4lxcvxfivzc2@gondor.apana.org.au>
	<CAGXu5jKYb-0NNvOcN79hzqU7O6vCFhMTBDGBL8Knuoc-YHamPg@mail.gmail.com>
	<20180627143622.ntksjxsymo4yw6dz@gondor.apana.org.au>
	<CAGXu5jJ2Z=YP+fNsvy+6a_BpC1ibZf6tOzZuPHk=Qx1qNVvOZw@mail.gmail.com>
	<20180627222749.xa5333caq5vaa7st@gondor.apana.org.au>
	<CAGXu5jKas=OyJPsrMthxjEykG=FkHDW84dO4bKGpj-50JjUYwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
	LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKas=OyJPsrMthxjEykG=FkHDW84dO4bKGpj-50JjUYwQ@mail.gmail.com>
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

On Wed, Jun 27, 2018 at 05:10:05PM -0700, Kees Cook wrote:
>
> In both cases here, what is "cipher"? i.e. what ciphers could lrw be
> wrapping, and what ciphers could cts be wrapping, so that I can
> examine the blocksizes, etc?

A cipher is a simple cipher like aes that operates on a single
block.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
