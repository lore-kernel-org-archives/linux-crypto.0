From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA
 usage for AHASH_REQUEST_ON_STACK
Date: Fri, 13 Jul 2018 11:44:06 +0800
Message-ID: <20180713034406.zwu2pkp3f2onybxs@gondor.apana.org.au>
References: <20180711203619.1020-1-keescook@chromium.org>
	<20180711203619.1020-12-keescook@chromium.org>
	<CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
	<20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
	<CAGXu5jLYmC7U=bucFZCLsSXNX=T4WhCccR6hx9dwROYF+ZMt0Q@mail.gmail.com>
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
In-Reply-To: <CAGXu5jLYmC7U=bucFZCLsSXNX=T4WhCccR6hx9dwROYF+ZMt0Q@mail.gmail.com>
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

On Thu, Jul 12, 2018 at 08:33:24PM -0700, Kees Cook wrote:
> On Thu, Jul 12, 2018 at 5:40 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Thu, Jul 12, 2018 at 06:02:26PM +0200, Arnd Bergmann wrote:
> >>
> >> Looking through some of the drivers, I found this interesting one:
> >
> > As I said before these patches are fundamentally broken.  Users
> > of AHASH_REQUEST_ON_STACK can only use sync algorithm providers
> > and therefore drivers are irrelevant.
> 
> I don't understand what this means. Can you give an example of what
> you want to see happen that will accomplish the VLA removals?

Any algorithm that is async must be ignored when you're calculating
the maximum on-stack size of the request.  For example, sha512-mb
is marked as async and therefore must not be used in conjunction
with AHASH_REQUEST_ON_STACK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
