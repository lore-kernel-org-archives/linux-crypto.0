Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548B44F68C5;
	Mon, 28 Sep 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616029; cv=none; b=QWJHRMPJffgapVjeq0aJPDmDhDmT0KV9kYPw1ALYW89hqEODGQlUdWwCqG+dcngXvXHHR995VQNNesYg0HVNs0CGj7ViLs6uM1h0FM5iRIPKkqHjX7+X6uGKWwSyMFjg627XioARjD1F8QNwDJtAlkxdcMXqAyr4Nc1saenC77I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616029; c=relaxed/simple;
	bh=a+Iuuus1sgTBJhKjQnvMXW6ozErNdrWtW0/EXDUJEAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RsGUfgeEZWjBOw5yQGTY1YVsJ5k3FgLsaO67LFAn342NLl1fGiTiFT/BVmu88khdrvqNcr5d62LImmKfdKRqHxDLA/0Kur8znzchMk8uZQah3TzFvMNdMGXkmO4nbV1k5mLO1FGC6TP00F7VmOthCxgMJS6uczT2Nyd912a0Uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=arzilkyI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PiAcHMEn; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="arzilkyI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PiAcHMEn"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 1030F13804CE;
	Mon, 28 Sep 2026 13:20:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 28 Sep 2026 13:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616026;
	 x=1790623226; bh=uGRShz7/CEgnybR8rXKhuxR+uSCSKOTb4RA8UBLfDNI=; b=
	arzilkyIlW8ydVRfrZ7Z1ABeXWx8pvbGCpbldO7pfpRcEQqogVBIiQ4x0OC01K2A
	4/RKj96Cgn8FC50Cv875HSBU3LV1BlYs570QTRpbJn2p78bWyMBvnkQX45Tmwxxr
	qMjE8s3OibcIsx4LQHbUpsqlOfE1m8lUs2Z0BZhVi4/zacIhFdTJtcWneDH4v229
	tDwmr4EVMQvAAeQ92EzvrPo8HjOWzEiLKK4BI725+lYVATFJnOVuzopwaZVI8C1o
	eZc7D5jxpd+oSQgPGqeJotNekMM+5OOAWW/vr12boU7zBszoZw4TeHvuUd4b+1Jf
	traQzQw7Xr0CIA9Umiu88A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616026; x=
	1790623226; bh=uGRShz7/CEgnybR8rXKhuxR+uSCSKOTb4RA8UBLfDNI=; b=P
	iAcHMEn+/4usa1LG2ibAaKOKWn/fA+fxFMPOx+esfcVqmlLhkv0k+//JJGhDcyHT
	jrl7h/Wc/4dg+g36Fe37F9aWZWsUp3uV0njJ9fKSBDv0zkIgy77lvV7yloblOfd2
	YNyHgZrzC/pByOlZXOpPAS6vu5EqMsIwWVjWDmcgFnrFY035C5A3xDQjCSNnz49O
	R5l9pl2+pDERs60d4i22q57SDhPo6niP4U+ROCZHOa1J61jHtEgV3jAHlWSSeQRG
	bC0HOkUZ1GlnhOJM6W58WWuc9ed7ONsVn/N+oPTvc5hFvkdQ+hjzB1vreVvkQisX
	wThm12jHp8ufnIFx2Gqyw==
X-ME-Sender: <xms:2aG6ank5INbcEm76LgUiJa_7amBMFQJPpijJVBOsHuKegzlDwNDBSg>
    <xme:2aG6auSMyD23cRSMQMUeLT-oFOZidPgDmmlzJV8TKF44EQNlsExhTLiWs2U6SNuCq
    0s9ynw-R0Q1_MTg_pfwjzB7N4UuzSF5hT3DWsONomX18LXMtcqpJQ>
X-ME-Received: <xmr:2aG6ap6x-7SLa931p2AR7S_B4HfG3ohEGVgbIa5xnIChl50rGI-VV5siVd4U8nOn>
X-ME-Proxy-Cause: dmFkZTE3Dtw6IjhE/poi/CDPb5VXEYPNUPEe3rZRr1/3vnluvSNGZwYnc7Od0VEEqw6V8C
    kWRAMYAJAJV5aq+CNT4OFQyy1fVW8k3upxKlO9V7Rt5yUqYEIYE/wijeDPsE7H4gglp/5v
    F6D384IbY5FCBCgoXmGheBdMQQxOBU4ICiAnYejBlRLhJ/CKeqEcgPSAZh68CS/pdW/x+j
    oysMrjjAyGFH6oDZSV+ReHQBDpEH3XjCRs+r4WEsyv+LCLa1ZQRyjrSR6cKgS0Pi5Ve0FP
    CSaf3rI2+ul2/rPFwdCO88CC3NXOaOC07b4Jq2/gPXxONS3ydc229KCVcj4zNvzLHbXFmN
    tBNIm7Z2RGei8KhHv2/TVTjH/o3X6NcTdHfo/OnAnrCWFAdogiHhZv31ci62SFGn/MozHg
    ABFRFFqGcbYxwLJeBJe4thYz1QT/N2uIUUJISSciTjn0WOlAm66WEsgPEv1RiMJweOZJbb
    SfejPaQ8ew6C7iElvtdyY04hwiudB3AnHM/jMyQgRgIdd/3GiwlFd3CgNvt79rvJGPr5LL
    vUK49+VNc3WivjBgMS11aqb4NeGw7ZYL/+n9sZT1/Gd9crV6FI9XFlJC8rQJ8m5u45BSWu
    GYyBHKfGc6WsRSsPQcp69nDAt9SFXMQafmUXJ1d6aZbKipcG2AoGuQkbtxqQ
X-ME-Proxy: <xmx:2aG6aolDtNcrwXT8NDL02k8dwsWNBASyL3S2SiEoEH7HL-Ur3tBRgg>
    <xmx:2aG6av58REzBnqo_kdilb5gAYIPYXyV9spbMCjex0PgWyRk2Q4gesA>
    <xmx:2aG6arwh_MSV3vYAr5ruXFNT2JkekEX5e6BSRPlvoZCJB67IiAu2SQ>
    <xmx:2aG6agLXHzA0c74M-yXItjXap2gS0MNg8qnG83XifTwUIxfHS3vDFw>
    <xmx:2qG6apWQ6jTiBW-4_lAA-6X2as2dO4UXKo4yzSzVesqB_A0-IcHjOO3P>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:20:05 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:55 +0200
Subject: [PATCH v3 07/12] security/keys: Allocate key payloads from the
 secret pool
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-7-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2

Key payloads sit in memory in plain text for as long as the key exists,
and a kdump crash dump captures them along with everything else.

Allocate the payloads of the user-defined, trusted and encrypted key
types from the new secret pool, so that their backing pages are marked
by crash_memaction for the kdump kernel to wipe.

This commit covers the key types used by dm-crypt/cryptsetup. Additional
key types can be added if needed in future commits.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 security/keys/encrypted-keys/encrypted.c  | 5 +++--
 security/keys/trusted-keys/trusted_core.c | 3 ++-
 security/keys/user_defined.c              | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index e07092ea301a..633f31131867 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -27,6 +27,7 @@
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/scatterlist.h>
+#include <linux/secret_pool.h>
 #include <linux/ctype.h>
 #include <crypto/aes.h>
 #include <crypto/sha2.h>
@@ -648,8 +649,8 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	epayload = kzalloc_flex(*epayload, payload_data, payload_totallen,
-				GFP_KERNEL);
+	epayload = secret_pool_zalloc_flex(*epayload, payload_data,
+					   payload_totallen, GFP_KERNEL);
 	if (!epayload)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 0509d9955f2a..5f209c5f3f14 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -22,6 +22,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/secret_pool.h>
 #include <linux/slab.h>
 #include <linux/static_call.h>
 #include <linux/string.h>
@@ -140,7 +141,7 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	ret = key_payload_reserve(key, sizeof(*p));
 	if (ret < 0)
 		goto err;
-	p = kzalloc_obj(*p);
+	p = secret_pool_zalloc_obj(*p);
 	if (!p)
 		goto err;
 
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 6f88b507f927..dce2508587df 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -7,6 +7,7 @@
 
 #include <linux/export.h>
 #include <linux/init.h>
+#include <linux/secret_pool.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
@@ -64,7 +65,7 @@ int user_preparse(struct key_preparsed_payload *prep)
 	if (datalen == 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
-	upayload = kmalloc_flex(*upayload, data, datalen);
+	upayload = secret_pool_alloc_flex(*upayload, data, datalen);
 	if (!upayload)
 		return -ENOMEM;
 

-- 
2.55.0

