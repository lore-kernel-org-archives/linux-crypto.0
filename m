Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637677;
	b=TZcCrVSuKXiuiJmde84LNX2rMJzsfUU5EbQnOb8z3uk1G4jwv3Oilw6EwvxpcAI/vCSU
	 u4PBRib9qyeD30FdyomTAdDg2RrsbFv8J5EM2gkRSwDH7ZVnX5KG1ZCUyNut4tdHgKmhr
	 2wcm0EesMP9ZdpG1g/RazViwZpqf3Q6Swrc0AsxLqMcXwVGBvdn06kxpCaLkdUTIGGHnZ
	 iu9Z4M+V9TLxVRfLruIr1eX4w7wqlqSjizeER+rfTJEujm2gYSSSHxl/xCc5t4wsz+z6C
	 /o7ncy7hEeKqpGmH5mfQW9GIlxKeKVLlgyjc0XjWswup8NQmZOF7kubfjea4NB3tT2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637677;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QmQfwt6Ao0oG0qFdwA911c4z+gOEP8sH0/exU2tcrOE=;
	b=csIGagLTeTiwKtOIkfbOKPOMU5z17+ZjqCj4C2Y6NjbtVS31vwxySQviYhk96yhl/RF5
	 Vq8T1fJSaYouRvmrL7cYveSenZBE9TcoNyWSCYaYFVWg8VT7FKVetbN8AhW3E1+UMQ161
	 ABGq3Y9pH73z+36Uyg2GKF64+hRwZwRI1knMc9QW6aZXNYo1u6Rx6CFsRQJI9nhRpKAR+
	 i18AJuZjzgKgekHm70fTjeoSH/xIVnJcRTQBRPooTBG+rpfKyMxmCh2oSPAhYgKj/Z/4f
	 5ZV5RLJYkvRyBXxNvclNE7IrubLkC5SdeVdv3dWdzYOAeEDz/gmBjBco9mT41NtKCgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FII90fcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EA79F606A31E;
	Wed, 25 Nov 2026 20:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FII90fcL
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4FDF1F000C6;
	Wed, 25 Nov 2026 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795637676;
	bh=QmQfwt6Ao0oG0qFdwA911c4z+gOEP8sH0/exU2tcrOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FII90fcLVF6+25/KHTpjKsEXg7XMRoWzVdYNoZjz7uXXy8m+fUEPO6mY4cUxCt8YD
	 Y/ua0rQf+PLUDD3/PuHRZGDOL7G+hkCSXN7YT+V77Gyf+4MWyKl/chIrrSbdOeiiSP
	 1+Y2LHu+YPB7DBOJtWctj9EJ4jh/CQzev3Bgw8o3/bSYgX7CfUijHyxSlTVWpFVIdL
	 tebRpkjzIDDxdZ7FygCi/EHK91196ZiPcu5yo+JpeZkuHvgQBGS+QUtLwSLaPQcLps
	 sRW8g+JBhQr59ZL4CR55XtZnBTeOHJngegBYKIeMnw9doaoppfAgh9h35IH/dL4VJw
	 KHuIhYLAZPKAg==
Date: Wed, 25 Nov 2026 22:14:32 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v3 8/9] KEYS: trusted: Factor out TPM2 blob loading
Message-ID: <awdBqM-gTfnsRKyL@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-9-jarkko@kernel.org>
 <sashiko-outbox-233944@kernel.org>
 <awcxDq7TrNmzFxjl@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h+DSvvEnG69Dw/wf"
Content-Disposition: inline
In-Reply-To: <awcxDq7TrNmzFxjl@kernel.org>


--h+DSvvEnG69Dw/wf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 25, 2026 at 09:03:46PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 25, 2026 at 06:16:23PM +0000, sashiko-bot@kernel.org wrote:
> > [Severity: Low]
> > This isn't a bug, but the commit message only mentions factoring out
> > tpm2_key_decode(), tpm2_load_blob(), and tpm2_buf_append_key_auth(),
> > without explaining why this refactoring is needed (to prepare for
> > asymmetric key support in the following patch).  It also omits adding
> > payload->private and trusted_payload_free() in the core trusted keys code,
> > as well as the new public_len < 8 bounds check before reading pub + 4 in
> > tpm2_load_cmd().
> 
> I agree with this and his has higher severity than "low" because patch
> needs to be split as a consequence.

I.e.,  this is the split change.

Br, Jarkko

--h+DSvvEnG69Dw/wf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KEYS-trusted-Add-private-backend-data-to-trusted_key.patch"

From 38d63947966fce0d3f6cc3274c4720b07fd5e791 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@kernel.org>
Date: Tue, 24 Nov 2026 13:03:29 +0200
Subject: [PATCH] KEYS: trusted: Add private backend data to
 trusted_key_payload

Add a backend-private pointer to struct trusted_key_payload and free it
sensitively via trusted_payload_free() on teardown and error paths. This
prepares for asymmetric TPM2 keys, which retain backend key metadata
across runtime pkey operations instead of unsealing a raw key at load
time.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/keys/trusted-type.h               |  1 +
 security/keys/trusted-keys/trusted_core.c | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 3db61b57cf73..790ffabb0d18 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -33,6 +33,7 @@ struct trusted_key_payload {
 	unsigned int blob_len;
 	unsigned char migratable;
 	unsigned char old_format;
+	void *private;
 	unsigned char key[MAX_KEY_SIZE + 1];
 	unsigned char blob[MAX_BLOB_SIZE];
 };
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 3721980ed83a..b8f980da606d 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -149,6 +149,14 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	return p;
 }
 
+static void trusted_payload_free(struct trusted_key_payload *p)
+{
+	if (!p)
+		return;
+	kfree_sensitive(p->private);
+	kfree_sensitive(p);
+}
+
 /*
  * trusted_instantiate - create a new trusted key
  *
@@ -223,7 +231,7 @@ static int trusted_instantiate(struct key *key,
 	if (!ret)
 		rcu_assign_keypointer(key, payload);
 	else
-		kfree_sensitive(payload);
+		trusted_payload_free(payload);
 	return ret;
 }
 
@@ -232,7 +240,7 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 	struct trusted_key_payload *p;
 
 	p = container_of(rcu, struct trusted_key_payload, rcu);
-	kfree_sensitive(p);
+	trusted_payload_free(p);
 }
 
 /*
@@ -269,7 +277,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = datablob_parse(&datablob, new_p);
 	if (ret != Opt_update) {
 		ret = -EINVAL;
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -283,7 +291,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = static_call(trusted_key_seal)(new_p, datablob);
 	if (ret < 0) {
 		pr_info("key_seal failed (%d)\n", ret);
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -322,7 +330,7 @@ static long trusted_read(const struct key *key, char *buffer,
  */
 static void trusted_destroy(struct key *key)
 {
-	kfree_sensitive(key->payload.data[0]);
+	trusted_payload_free(key->payload.data[0]);
 }
 
 struct key_type key_type_trusted = {
-- 
2.47.3


--h+DSvvEnG69Dw/wf--
