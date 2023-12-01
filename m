Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Jw8F8MW3"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335D5CC
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 02:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=fAPRMgCuD7LRyrAM3c4Hjh0YOMt2p9kLheGGBT4T6NE=; t=1701426118; x=1702635718; 
	b=Jw8F8MW3nnCUoTH59aENJ3SUHjSw08rIKACX/fG+gL5LhHpzhDUKaRkEeBDDhge8HCdwIIk1kGr
	opHZLv2JWXLB0WNPUQ2BgOqMWrcXVrKbSB5T+CJoPgBVVPMskmuYKyPGwiAHmaIK1DJBrtGQH4A+s
	OzLWMsHBR8b0j46vdRCxpBW5O/5rVF/XTpxH5XBCeT/eQFKPWPYf1ASYhZeEs/dDhouM93aIGf8XI
	yU8bWXJNsgffi4l3Ls5gu4OGFFpHaTNK/YkSX7SPURsaAC76suoFeU/hCNp5u8adikxkvnOn3/shC
	V+ej04VOmO3cS6VfZo05wDz58xsPiW7J9TUg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r90eg-0000000BAoz-2lO2;
	Fri, 01 Dec 2023 11:21:54 +0100
Message-ID: <e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
Subject: jitterentropy vs. simulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: linux-um@lists.infradead.org, linux-crypto@vger.kernel.org
Date: Fri, 01 Dec 2023 11:21:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

In ARCH=3Dum, we have a mode where we simulate clocks completely, and even
simulate that the CPU is infinitely fast. Thus, reading the clock will
return completely predictable values regardless of the work happening.

This is clearly incompatible with jitterentropy, but now jitterentropy
seems to be mandatory on pretty much every system that needs any crypto,
so we can't just seem to turn it off (any more?)

Now given that the (simulated) clock doesn't have jitter, it's derivates
are all constant/zero, and so jent_measure_jitter() - called via
jent_entropy_collector_alloc() - will always detect a stuck measurement,
and thus jent_gen_entropy() loops infinitely.

I wonder what you'd think about a patch like this?

--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -552,10 +552,13 @@ static int jent_measure_jitter(struct rand_data *ec, =
__u64 *ret_current_delta)
  * Function fills rand_data->hash_state
  *
  * @ec [in] Reference to entropy collector
+ *
+ * Return: 0 if entropy reading failed (was stuck), 1 otherwise
  */
-static void jent_gen_entropy(struct rand_data *ec)
+static int jent_gen_entropy(struct rand_data *ec)
 {
 	unsigned int k =3D 0, safety_factor =3D 0;
+	unsigned int stuck_counter =3D 0;
=20
 	if (fips_enabled)
 		safety_factor =3D JENT_ENTROPY_SAFETY_FACTOR;
@@ -565,8 +568,13 @@ static void jent_gen_entropy(struct rand_data *ec)
=20
 	while (!jent_health_failure(ec)) {
 		/* If a stuck measurement is received, repeat measurement */
-		if (jent_measure_jitter(ec, NULL))
+		if (jent_measure_jitter(ec, NULL)) {
+			if (stuck_counter++ > 100)
+				return 0;
 			continue;
+		}
+
+		stuck_counter =3D 0;
=20
 		/*
 		 * We multiply the loop value with ->osr to obtain the
@@ -575,6 +583,8 @@ static void jent_gen_entropy(struct rand_data *ec)
 		if (++k >=3D ((DATA_SIZE_BITS + safety_factor) * ec->osr))
 			break;
 	}
+
+	return 1;
 }
=20
 /*
@@ -611,7 +621,8 @@ int jent_read_entropy(struct rand_data *ec, unsigned ch=
ar *data,
 	while (len > 0) {
 		unsigned int tocopy, health_test_result;
=20
-		jent_gen_entropy(ec);
+		if (!jent_gen_entropy(ec))
+			return -3;
=20
 		health_test_result =3D jent_health_failure(ec);
 		if (health_test_result > JENT_PERMANENT_FAILURE_SHIFT) {


johannes
