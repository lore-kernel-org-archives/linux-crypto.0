Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949866;
	b=5mING6F6X9jl9j2c6AEtEp62mCjCUiYPecoysDCnqURQe85CeDo5yO8GOxYHWLTUWPPG
	 5PWEAhhz/eNjM97oVsxI/K+vb5hxuQvi1kURjxFrFSD6JcWJnzmfVuFWNTkC7DjTnMgyK
	 x1W1II3GYDq5OCqz2Q2u3ZTV120bhF57sYTD7jZAHMdpnJBmEYex0BHNZpH9A4z7Al7Gn
	 QE91YAmp0P11wZKXcaRWZG5HwteZZTIPUUlYH/jpFPPkeDiUmtJXwNAw1vChUguyiu4NC
	 2nhLrMpf6MsHO7kMksAf8TGtE8ubNJ0TvLCqf6Sapx+H8xywDvuWy8+hjV6RkYe9CVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949866;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
	b=Ok28xz7gPXQ1Bw6IQzHiIKpQ2nQrROF5k9j+IhayYuC/0dr72iq+wDIROvTcRj4tst3f
	 m4Gybppm51K+9D+GvZ9pOPsd6Xvka+0pAmBuAfHEthgq29KWlPPLyLwV0DeBkdVdZ74bW
	 /Mxotb5LNLkx1R2+SSIzk+JXM76CkY91X9/pTwa40JmTZPtPaOLZgOhwBN/1LsZUjkydr
	 uOoijDMwzXgTGvXhlIGtjdT5nDijwyddVQCgCR/xbnEvMqioOR6cQWMiWpYJjKEaqUZx3
	 n7h8uWZ09R+YcnlB2V/w3eP2f6eD4ZR9lMDFOXYND9kW1Sng+OGgETP4d9QlltFbUqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="KsMB/lqK";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DD8606A339
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43DD8606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KsMB/lqK
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14394530ec6so544303c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949865; x=1794554665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=KsMB/lqKt9Gn+6Y8bnHkZGKoZ/HODHShk9DP3lCJCCbE1cTrm15u36FRbou+RsV9Lu
         u9yvkCX0dY2aWQJh/AuUclUVRq6Hk1CpPWWGe9erIQmM6XSN0/VWqQExgOPTgWb0vm7g
         DTTUgx6mMz5+wI3ekfjYikXExnd7jGS30Jeoryl2tdZETKjuxHz9fsHbv2HFrO/orpvb
         dfPAHsw9J6xbuGk8LdbTx/6IXcOxAX/L7Wi4ODTupdImF+dux3gv1ExbOA+VqDERK09Z
         n5yS2SttSGgz5S0OrolVOz/vHN6mDXeFDhI0WjfD1JZ6+dLJIm2HLY+VpuJcXfvtvwJd
         +bdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949865; x=1794554665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=F2a8xTkMKwrboHYVH1IHidwl8twf/K+nXofBhP/LDb4KDOb/1rEU34A2ZZdaXwq8nb
         RmliSGGXBuaYS46WxA8rBNLDSmt842OG6mEbmF6CZUR+NXK+M4AIsXovqVxMXdev60po
         OjK8K1CPd9zVWHJlchNV3LCp+Bji1bYLzpuldydGdYQdCOybeUVsA0Qt8k1CbJLeYGT2
         FKr9zLRfr2PIFTlfgiZkd3pL7BwPDGD/sdpYSdNcOjUkG/Ub6wnfSRyqhlftBAF3JYjD
         c4SPHXcTyUvjzlT9zJr9ytaF6oKd3YkAxClWynQrc35vJsUqYlJy5PNnfj/rWeejeRHI
         YPzg==
X-Forwarded-Encrypted: i=1; AKwUvBwoWUvbW7GRcegY1dw+EjTBzB4Bg9a1hzXF/cGrDMmoGe4kb3k1v+nKH1fJpTf8KgZeSlyQfxve8k6jrDE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Z0jXcoobtMaFPyFe7xCxLRKoJgSDvYypOrK5bBHAnSOQOtz0X
	VR/4wl/tGUCLcz8rDK4HpskHiqoDEvW5Vx9sKsr84hNtC/wBcnZTOaCd
X-Gm-Gg: AYBFou0xyGU6eZPnt5N2dknc237KvC9IQPg2MIOJHxIlBw9VjKYej1P1jbES9sRdKjT
	4kMbI7qqvlKByn4JOljA1Z/nlmjBMJpQjG4Tl+IN8mLVkbWP4CZ9NwQ8CqS6Owgc2V8NCat2pCw
	EojPVPDh0td6Bc5gjUttyRrjJuJ1PxOa76AuQwL8fCm+14+WpmHTjrdp5WtzBLdbo6sylpt/6lt
	hNDoL8qTCeSFsNbWsVagbUsiRfnVdqfx/mvGM/vCDk4zmhmqvm9hZ3svxmmMI2EdY9An812zWqc
	ts0VN106FiYoquCStaUt5jtICrhjfaB3/5lw4M73y9Vu7hKWW/519yEsB2JzSnoTucuZozsEP3o
	yzBAS32eKWfVPesXx4JQPCo1LeXILQJnuO0lQ7dIAs4ZGgZMsshiGE+fYNOnKprWsSdFBW6p4kz
	gMUxPo1C3i2T6EtEys9qO31tEBNpeWsjfMrgg7COZmNngpZzR6urP9d8g0/VL1H1zmjUwXfzuHL
	uA+RKIbqIzPqHIDJWwFF6c2f+0JdflGyqfnuqSFZzxpYiVzUR0vJGruMvElyniRmk/VOeAArfFu
	kuH7z+g8AwUXTGtPshAM/UGqqmgSamzCbroDhj1CEQ==
X-Received: by 2002:a05:701b:270d:b0:183:7d42:cfb5 with SMTP id a92af1059eb24-1b25d30e08emr2068315c88.19.1793949863734;
        Thu, 05 Nov 2026 23:24:23 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:23 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v3 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu,  5 Nov 2026 23:24:08 -0800
Message-Id: <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater
than 1, representing the maximum batch-size that the compressor
supports, so that kernel users of crypto_acomp, such as zswap, can
allocate resources for submitting multiple compress/decompress jobs that
can be batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

This enables zswap to compress/decompress multiple pages as a batch
to improve swapout/swapin performance and memory savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 14 ++++++++++++++
 include/crypto/acompress.h          | 12 ++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index ac4dc52668b8..df9e42f519c3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+	    (crypto_comp_alg_common(tfm)->base.cra_type == &crypto_acomp_type)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 93fa02ce818b..3ce4704dc879 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -593,6 +593,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 0c0d3fc8a9fc..2d4d302d1b3f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -47,6 +49,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.39.5

