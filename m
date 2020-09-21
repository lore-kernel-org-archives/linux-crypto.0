Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85CBC43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A675320874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgIUH7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:56892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgIUH71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59C6DB51C;
        Mon, 21 Sep 2020 08:00:01 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: [RFC PATCH 21/41] random: don't invoke arch_get_random_long() from add_interrupt_randomness()
Date:   Mon, 21 Sep 2020 09:58:37 +0200
Message-Id: <20200921075857.4424-22-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

x86's RDSEED/RDRAND insns have reportedly been slowed down significantly
on certain CPU families due to the ucode update required to mitigate
against the "Special Register Buffer Data Sampling" vulnerability
(CVE-2020-0543) and should not get invoked from the interrupt path anymore.

Currently, add_interrupt_randomness() obtains an arch_get_random_long()
sample for each bit of entropy awarded to the "interrupt source",
mixes it into the input_pool and awards that sample another bit of entropy.
This lock step between the interrupt source and arch_get_random_long()
ensures that the latter cannot dominate the former.

There are some more entropy sources all mixing into input_pool with a
non-zero entropy attribution:
- try_to_generate_entropy() at boot time
- add_input_randomness() and add_disk_randomness()
- add_hwgenerator_randomness().
I don't see what's so special about the interrupt randomness source that
entropy awarded to the architectural RNG should be limited to its output
rate only rather than to the joint rate from all these entropy sources as
a whole.

Follow this approach. Don't mix arch_get_random_long() entropy from
add_interrupt_randomness() into the input_pool. Instead, make crng_reseed()
invoke the architectural RNG to make up for any lack of entropy up to one
half of the minimum seed size. That is, if the input_pool contains less
than 128 bits of entropy, the architectural RNG will be invoked and
attributed an entropy value equal to the difference, but never more than
64 bits. Note that
- the architectural RNG won't be able to dominate the other randomness
  sources taken together in this scheme and
- in case the input_pool contains more entropy than required for the
  minimum seed level, it won't be attributed any entropy at all.
That is, the architectural RNG is effectively turned into an emergency
reserve in a sense.

A potentially adverse effect of this change is that entropy might get
depleted at a higher rate than before from the interrupt source, namely if
the input_pool contains more than half of the minimum seed size of entropy
at reseed. However, the entropy sources feeding into input_pool are assumed
to provide entropy at a steady rate when averaged over the time scale of a
reseed interval, which is several minutes in length. Thus, as the
primary_crng reseeds are the only consumers of input_pool entropy nowadays,
the input_pool's fill level can be assumed to be relatively constant at the
time of reseeds and an equilibrium between the rates at which the
input_pool receives and releases entropy will be reached.

OTOH, remember that the rate at which the pool entropy increases is
exponentially damped as the pool fills up. In case the interrupt source is
a major contributor to the pool, not having to account anymore for the
architectural RNG's noise formerly mixed in in lockstep will leave
considerably more pool capacity to the interrupt noise, which is a welcomed
side effect.

So, make min_crng_reseed_pool_entropy() return only half of the minimum
seed size required in case an architectural RNG will likely be able to
provide the other half, as indicated by
arch_has_random() || arch_has_random_seed(). This will effectively
- make dispatch_queued_entropy() to attempt an intitial seed of the
  primary_crng as soon as the amount of entropy available from the
  input_pool has first exceeded that threshold and also
- makes crng_reseed() to lower the minimum amount of entropy to be
  extracted from the input_pool by means of extract_entropy() to one half
  of the minimum seed size.

Introduce a new boolean variable "arch_randomness_required" to
crng_reseed() for tracking whether or not the seed must be amended by
additional output from the architectural RNG. Initialize it to false,
make crng_reseed() set it in case its extract_entropy() invocation could
obtain only less than the minimum seed size from input_pool.

crng_reseed() already attempts to xor output from the architectural RNG
over the full length of the crng state, i.e. over the full length of the
latter's 256 bit ChaCha20 key. Currently, failure in doing so is not
considered fatal. Make it so if arch_randomness_required has been set.

Note that assuming one bit of entropy per bit obtained from the
architectural RNG, it would actually suffice to successfully obtain
(16 - num + sizeof(u32) - 1) / sizeof(u32) u32's from
arch_get_random_long()/arch_get_random_seed_long(), where 16 is the
minimum seed size in bytes and num is the number of bytes which have
been previuously obtained from the input_pool. However, this assumption
might be overly optimistic and the total number of arch_get_random_long()
invocations per 64 bits of entropy attributed to it has already been
lowered from >= 64 to eight by this patch. Moreover, the
arch_get_random_long() loop in crng_reseed() would need to get reorganized
in order to make sure that there will actually be a sufficient number of
successful invocations when writing to the target buffer area following the
bytes obtained from the input_pool.

Thus, in case failing arch_get_random_long()s in combination with
arch_randomness_required set became a problem in the future, it would be
better to improve the error path and simply return the unused entropy
extracted from the input_pool back.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 49 +++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 424de1565927..7712b4464ef5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1190,6 +1190,14 @@ static int crng_slow_load(const char *cp, size_t len)
  */
 static int min_crng_reseed_pool_entropy(void)
 {
+	/*
+	 * If there's an architecture provided RNG, use it for
+	 * up to one half of the minimum entropy needed for
+	 * reseeding. That way it won't dominate the entropy
+	 * collected by other means at input_pool.
+	 */
+	if (arch_has_random() || arch_has_random_seed())
+		return 8;
 	return 16;
 }
 
@@ -1197,6 +1205,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 {
 	unsigned long	flags;
 	int		i, num;
+	bool		arch_randomness_required = false;
 	union {
 		__u8	block[CHACHA_BLOCK_SIZE];
 		__u32	key[8];
@@ -1205,8 +1214,16 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	if (r) {
 		num = extract_entropy(r, &buf, 32,
 				      min_crng_reseed_pool_entropy());
-		if (num == 0)
+		if (num == 0) {
 			return;
+		} else if (num < 16) {
+			/*
+			 * The input_pool did not provide sufficient
+			 * entropy for reseeding and the architecture
+			 * provided RNG will have to make up for it.
+			 */
+			arch_randomness_required = true;
+		}
 	} else {
 		_extract_crng(&primary_crng, buf.block);
 		_crng_backtrack_protect(&primary_crng, buf.block,
@@ -1216,8 +1233,17 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	for (i = 0; i < 8; i++) {
 		unsigned long	rv;
 		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
+		    !arch_get_random_long(&rv)) {
+			if (arch_randomness_required) {
+				/*
+				 * The input_pool failed to provide
+				 * sufficient entropy and the arch RNG
+				 * could not make up for that either.
+				 */
+				return;
+			}
 			rv = random_get_entropy();
+		}
 		buf.key[i] ^= rv;
 	}
 
@@ -1522,8 +1548,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	cycles_t		cycles = random_get_entropy();
 	__u32			c_high, j_high;
 	__u64			ip;
-	unsigned long		seed;
-	int			credit = 0;
 	bool			reseed;
 	struct queued_entropy	q = { 0 };
 
@@ -1560,26 +1584,11 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (!spin_trylock(&r->lock))
 		return;
 
-	/*
-	 * If we have architectural seed generator, produce a seed and
-	 * add it to the pool further below. For the sake of paranoia
-	 * don't let the architectural seed generator dominate the
-	 * input from the interrupt noise.
-	 */
-	credit = !!arch_get_random_long(&seed);
-
 	fast_pool->last = now;
 	fast_pool->count = 0;
 	/* award one bit for the contents of the fast pool */
-	__queue_entropy(r, &q, (credit + 1) << ENTROPY_SHIFT);
+	__queue_entropy(r, &q, 1 << ENTROPY_SHIFT);
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
-	if (credit) {
-		/*
-		 * A seed has been obtained from
-		 * arch_get_random_seed_long() above, mix it in.
-		 */
-		__mix_pool_bytes(r, &seed, sizeof(seed));
-	}
 	reseed = __dispatch_queued_entropy_fast(r, &q);
 	spin_unlock(&r->lock);
 	if (reseed)
-- 
2.26.2

