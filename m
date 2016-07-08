From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 8 Jul 2016 09:28:03 -0700
Message-ID: <20160708162803.GA29111@linux.intel.com>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
 <20160701075559.GA11902@gmail.com>
 <20160701092806.GA13424@gondor.apana.org.au>
 <20160701101329.GA3833@gmail.com>
Reply-To: tim.c.chen@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9444 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbcGHQ2K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2016 12:28:10 -0400
Content-Disposition: inline
In-Reply-To: <20160701101329.GA3833@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 01, 2016 at 12:13:30PM +0200, Ingo Molnar wrote:
>=20
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
> > On Fri, Jul 01, 2016 at 09:55:59AM +0200, Ingo Molnar wrote:
> > >
> > > Plus:
> > >=20
> > > > > > =A0		/* Compute how many bytes to copy from user buffer int=
o
> > > > > > =A0		=A0* extra block
> > > > > > =A0		=A0*/
> > >=20
> > > please use the customary (multi-line) comment style:
> >=20
> > This is the customary comment style of the networking stack and
> > the crypto API.  So please don't change it.
>=20
> Guys, do you even read your own code??
>=20
> That 'standard' is not being enforced consistently at all. Even in th=
is very=20
> series there's an example of that weird comment not being followed:
>=20
> +++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
> @@ -304,7 +304,7 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(=
struct sha1_ctx_mgr *mgr,
>                 /*
>                  * Compute how many bytes to copy from user buffer in=
to
>                  * extra block
>=20
> See how this comment block uses the standard coding style, while the =
next patch=20
> has this weird coding style:
>=20
> -       if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_=
SIZE)) {
> +       if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK=
_SIZE)) {

Sorry I was on vacation and didn't get to respond earlier.
Let's switch the above from | to || so the code logic is
clearer.  Also clean up various multi-line comment style
inconsistencies in patch below.

Thanks.

Tim

---

=46rom: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] crypto: Cleanup sha multi-buffer code to use || instea=
d of |
 for condition comparison and cleanup multiline comment style

In sha*_ctx_mgr_submit, we currently use the | operator instead of ||
((ctx->partial_block_buffer_length) | (len < SHA1_BLOCK_SIZE))

Switching it to || and remove extraneous paranthesis to
adhere to coding style.

Also cleanup inconsistent multiline comment style.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha1-mb/sha1_mb.c     |  2 +-
 arch/x86/crypto/sha256-mb/sha256_mb.c | 11 +++++++----
 arch/x86/crypto/sha512-mb/sha512_mb.c | 11 +++++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-m=
b/sha1_mb.c
index 561b286..9e5b671 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -304,7 +304,7 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(st=
ruct sha1_ctx_mgr *mgr,
 	 * Or if the user's buffer contains less than a whole block,
 	 * append as much as possible to the extra block.
 	 */
-	if ((ctx->partial_block_buffer_length) | (len < SHA1_BLOCK_SIZE)) {
+	if (ctx->partial_block_buffer_length || len < SHA1_BLOCK_SIZE) {
 		/*
 		 * Compute how many bytes to copy from user buffer into
 		 * extra block
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sh=
a256-mb/sha256_mb.c
index c9d5dcc..89fa85e 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb.c
+++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
@@ -283,7 +283,8 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_submi=
t(struct sha256_ctx_mgr *mgr,
 	ctx->incoming_buffer =3D buffer;
 	ctx->incoming_buffer_length =3D len;
=20
-	/* Store the user's request flags and mark this ctx as currently
+	/*
+	 * Store the user's request flags and mark this ctx as currently
 	 * being processed.
 	 */
 	ctx->status =3D (flags & HASH_LAST) ?
@@ -299,8 +300,9 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_submi=
t(struct sha256_ctx_mgr *mgr,
 	 * Or if the user's buffer contains less than a whole block,
 	 * append as much as possible to the extra block.
 	 */
-	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SIZE)) {
-		/* Compute how many bytes to copy from user buffer into
+	if (ctx->partial_block_buffer_length || len < SHA256_BLOCK_SIZE) {
+		/*
+		 * Compute how many bytes to copy from user buffer into
 		 * extra block
 		 */
 		uint32_t copy_len =3D SHA256_BLOCK_SIZE -
@@ -323,7 +325,8 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_submi=
t(struct sha256_ctx_mgr *mgr,
 		/* The extra block should never contain more than 1 block */
 		assert(ctx->partial_block_buffer_length <=3D SHA256_BLOCK_SIZE);
=20
-		/* If the extra block buffer contains exactly 1 block,
+		/*
+		 * If the extra block buffer contains exactly 1 block,
 		 * it can be hashed.
 		 */
 		if (ctx->partial_block_buffer_length >=3D SHA256_BLOCK_SIZE) {
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sh=
a512-mb/sha512_mb.c
index 676f0f2..f4cf5b7 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -253,7 +253,8 @@ static struct sha512_hash_ctx
 					  int flags)
 {
 	if (flags & (~HASH_ENTIRE)) {
-		/* User should not pass anything other than FIRST, UPDATE, or
+		/*
+		 * User should not pass anything other than FIRST, UPDATE, or
 		 * LAST
 		 */
 		ctx->error =3D HASH_CTX_ERROR_INVALID_FLAGS;
@@ -284,7 +285,8 @@ static struct sha512_hash_ctx
 		ctx->partial_block_buffer_length =3D 0;
 	}
=20
-	/* If we made it here, there were no errors during this call to
+	/*
+	 * If we made it here, there were no errors during this call to
 	 * submit
 	 */
 	ctx->error =3D HASH_CTX_ERROR_NONE;
@@ -293,7 +295,8 @@ static struct sha512_hash_ctx
 	ctx->incoming_buffer =3D buffer;
 	ctx->incoming_buffer_length =3D len;
=20
-	/* Store the user's request flags and mark this ctx as currently bein=
g
+	/*
+	 * Store the user's request flags and mark this ctx as currently bein=
g
 	 * processed.
 	 */
 	ctx->status =3D (flags & HASH_LAST) ?
@@ -309,7 +312,7 @@ static struct sha512_hash_ctx
 	 * Or if the user's buffer contains less than a whole block,
 	 * append as much as possible to the extra block.
 	 */
-	if ((ctx->partial_block_buffer_length) | (len < SHA512_BLOCK_SIZE)) {
+	if (ctx->partial_block_buffer_length || len < SHA512_BLOCK_SIZE) {
 		/* Compute how many bytes to copy from user buffer into extra
 		 * block
 		 */
--=20
2.5.5
