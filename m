Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8636FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jun 2022 20:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiFPUQ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiFPUQ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jun 2022 16:16:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5895AA67
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jun 2022 13:16:26 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 25so3653454edw.8
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jun 2022 13:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPBG2nTUqkW0793jTPIkOVOiRQ8ElNjTOyYS1i3QeaQ=;
        b=qlHeb5AhXRYaPCFT2gAvvArTHDZTAhgmJPbyz6/l+Bz7HjGgYScC+wz2T3+iTQUH+n
         sqdshfaFNTZam3uTyiAr1VAI0baiCF4QzS/3OBt+HcvOZd9u9yNiF6JJxyQmqdd6yBDi
         GGFKk0uheKbjBapXZ3nfuFISjHICQ8xhfaCj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPBG2nTUqkW0793jTPIkOVOiRQ8ElNjTOyYS1i3QeaQ=;
        b=kHVCEKYsvUotaFJjnGEJXgtUQPS2O2cxMc3hukT81wFF9kze4KW6mcObWIEMQv8PTk
         fzbUqVFwJI2S5m1KWVJ4qBsCj5DcvOY+NmCh+1tnpiREPgEPy2zBThiGzb7CQnhzwapU
         ePchw9sKhZJTb6hGD/Pc7mOq+zXq0IbyKQ5WTedm/lG2NSBXvpJDB9E0O865nVJnOTd3
         oo4mz8RclMHjkvtbS7ixKSBfiZDPTa5IR1tEeHLDs1pvYG+Ci38ajvE7+VirXMnujeCS
         foFmwUGwdLRsqyv7Jl1q69BTXshTY9qZFEHaqPXzbwJxgB7VguzIrJVyHKhSm2Ts5E0M
         1rHQ==
X-Gm-Message-State: AJIora8QWB4TTUpVihLBTm4YY4w0t66ykJi2+f/jtN6VFlNPIB1DoITy
        0ekJ/TCTvsacyWNcpghfGnHVsA==
X-Google-Smtp-Source: AGRyM1uNCP1ltBL6EchQ/geW3Jcw3CWp5toA8kk7wsnN9raFTe6AjXY9vReITrEdsJgD6fj0OwP+lg==
X-Received: by 2002:a05:6402:ca5:b0:42d:dba5:b2a0 with SMTP id cn5-20020a0564020ca500b0042ddba5b2a0mr8781418edb.197.1655410585149;
        Thu, 16 Jun 2022 13:16:25 -0700 (PDT)
Received: from localhost.localdomain ([90.195.227.41])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090632cb00b00705cdfec71esm1176299ejk.7.2022.06.16.13.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 13:16:24 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH] crypto: rsa - implement Chinese Remainder Theorem for faster private key operations
Date:   Thu, 16 Jun 2022 21:15:50 +0100
Message-Id: <20220616201550.1827-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kernel RSA ASN.1 private key parser already supports only private keys with
additional values to be used with the Chinese Remainder Theorem [1], but these
values are currently not used.

This rudimentary CRT implementation speeds up RSA private key operations for the
following Go benchmark up to ~3x.

This implementation also tries to minimise the allocation of additional MPIs,
so existing MPIs are reused as much as possible (hence the variable names are a
bit weird).

The benchmark used:

```
package keyring_test

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"io"
	"syscall"
	"testing"
	"unsafe"
)

type KeySerial int32
type Keyring int32

const (
	KEY_SPEC_PROCESS_KEYRING Keyring = -2
	KEYCTL_PKEY_SIGN                 = 27
)

var (
	keyTypeAsym = []byte("asymmetric\x00")
	sha256pkcs1 = []byte("enc=pkcs1 hash=sha256\x00")
)

func (keyring Keyring) LoadAsym(desc string, payload []byte) (KeySerial, error) {
	cdesc := []byte(desc + "\x00")
	serial, _, errno := syscall.Syscall6(syscall.SYS_ADD_KEY, uintptr(unsafe.Pointer(&keyTypeAsym[0])), uintptr(unsafe.Pointer(&cdesc[0])), uintptr(unsafe.Pointer(&payload[0])), uintptr(len(payload)), uintptr(keyring), uintptr(0))
	if errno == 0 {
		return KeySerial(serial), nil
	}

	return KeySerial(serial), errno
}

type pkeyParams struct {
	key_id         KeySerial
	in_len         uint32
	out_or_in2_len uint32
	__spare        [7]uint32
}

// the output signature buffer is an input parameter here, because we want to
// avoid Go buffer allocation leaking into our benchmarks
func (key KeySerial) Sign(info, digest, out []byte) error {
	var params pkeyParams
	params.key_id = key
	params.in_len = uint32(len(digest))
	params.out_or_in2_len = uint32(len(out))

	_, _, errno := syscall.Syscall6(syscall.SYS_KEYCTL, KEYCTL_PKEY_SIGN, uintptr(unsafe.Pointer(&params)), uintptr(unsafe.Pointer(&info[0])), uintptr(unsafe.Pointer(&digest[0])), uintptr(unsafe.Pointer(&out[0])), uintptr(0))
	if errno == 0 {
		return nil
	}

	return errno
}

func BenchmarkSign(b *testing.B) {
	priv, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		b.Fatalf("failed to generate private key: %v", err)
	}

	pkcs8, err := x509.MarshalPKCS8PrivateKey(priv)
	if err != nil {
		b.Fatalf("failed to serialize the private key to PKCS8 blob: %v", err)
	}

	serial, err := KEY_SPEC_PROCESS_KEYRING.LoadAsym("test rsa key", pkcs8)
	if err != nil {
		b.Fatalf("failed to load the private key into the keyring: %v", err)
	}

	b.Logf("loaded test rsa key: %v", serial)

	digest := make([]byte, 32)
	_, err = io.ReadFull(rand.Reader, digest)
	if err != nil {
		b.Fatalf("failed to generate a random digest: %v", err)
	}

	sig := make([]byte, 256)
	for n := 0; n < b.N; n++ {
		err = serial.Sign(sha256pkcs1, digest, sig)
		if err != nil {
			b.Fatalf("failed to sign the digest: %v", err)
		}
	}

	err = rsa.VerifyPKCS1v15(&priv.PublicKey, crypto.SHA256, digest, sig)
	if err != nil {
		b.Fatalf("failed to verify the signature: %v", err)
	}
}
```

[1]: https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Using_the_Chinese_remainder_algorithm

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 crypto/rsa.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 5 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 39e04176b04b..0e555ee4addb 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -17,6 +17,11 @@ struct rsa_mpi_key {
 	MPI n;
 	MPI e;
 	MPI d;
+	MPI p;
+	MPI q;
+	MPI dp;
+	MPI dq;
+	MPI qinv;
 };

 /*
@@ -35,16 +40,49 @@ static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)

 /*
  * RSADP function [RFC3447 sec 5.1.2]
- * m = c^d mod n;
+ * m_1 = c^dP mod p;
+ * m_2 = c^dQ mod q;
+ * h = (m_1 - m_2) * qInv mod p;
+ * m = m_2 + q * h;
  */
-static int _rsa_dec(const struct rsa_mpi_key *key, MPI m, MPI c)
+static int _rsa_dec_crt(const struct rsa_mpi_key *key, MPI m_or_m1_or_h, MPI c)
 {
+	MPI m2, m12_or_qh;
+	int ret = -ENOMEM;
+
 	/* (1) Validate 0 <= c < n */
 	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
 		return -EINVAL;

-	/* (2) m = c^d mod n */
-	return mpi_powm(m, c, key->d, key->n);
+	m2 = mpi_alloc(0);
+	m12_or_qh = mpi_alloc(0);
+	if (!m2 || !m12_or_qh)
+		goto err_free_mpi;
+
+	/* (2i) m_1 = c^dP mod p */
+	ret = mpi_powm(m_or_m1_or_h, c, key->dp, key->p);
+	if (ret)
+		goto err_free_mpi;
+
+	/* (2i) m_2 = c^dQ mod q */
+	ret = mpi_powm(m2, c, key->dq, key->q);
+	if (ret)
+		goto err_free_mpi;
+
+	/* (2iii) h = (m_1 - m_2) * qInv mod p */
+	mpi_sub(m12_or_qh, m_or_m1_or_h, m2);
+	mpi_mulm(m_or_m1_or_h, m12_or_qh, key->qinv, key->p);
+
+	/* (2iv) m = m_2 + q * h */
+	mpi_mul(m12_or_qh, key->q, m_or_m1_or_h);
+	mpi_addm(m_or_m1_or_h, m2, m12_or_qh, key->n);
+
+	ret = 0;
+
+err_free_mpi:
+	mpi_free(m12_or_qh);
+	mpi_free(m2);
+	return ret;
 }

 static inline struct rsa_mpi_key *rsa_get_key(struct crypto_akcipher *tfm)
@@ -112,7 +150,7 @@ static int rsa_dec(struct akcipher_request *req)
 	if (!c)
 		goto err_free_m;

-	ret = _rsa_dec(pkey, m, c);
+	ret = _rsa_dec_crt(pkey, m, c);
 	if (ret)
 		goto err_free_c;

@@ -134,9 +172,19 @@ static void rsa_free_mpi_key(struct rsa_mpi_key *key)
 	mpi_free(key->d);
 	mpi_free(key->e);
 	mpi_free(key->n);
+	mpi_free(key->p);
+	mpi_free(key->q);
+	mpi_free(key->dp);
+	mpi_free(key->dq);
+	mpi_free(key->qinv);
 	key->d = NULL;
 	key->e = NULL;
 	key->n = NULL;
+	key->p = NULL;
+	key->q = NULL;
+	key->dp = NULL;
+	key->dq = NULL;
+	key->qinv = NULL;
 }

 static int rsa_check_key_length(unsigned int len)
@@ -217,6 +265,26 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	if (!mpi_key->n)
 		goto err;

+	mpi_key->p = mpi_read_raw_data(raw_key.p, raw_key.p_sz);
+	if (!mpi_key->p)
+		goto err;
+
+	mpi_key->q = mpi_read_raw_data(raw_key.q, raw_key.q_sz);
+	if (!mpi_key->q)
+		goto err;
+
+	mpi_key->dp = mpi_read_raw_data(raw_key.dp, raw_key.dp_sz);
+	if (!mpi_key->dp)
+		goto err;
+
+	mpi_key->dq = mpi_read_raw_data(raw_key.dq, raw_key.dq_sz);
+	if (!mpi_key->dq)
+		goto err;
+
+	mpi_key->qinv = mpi_read_raw_data(raw_key.qinv, raw_key.qinv_sz);
+	if (!mpi_key->qinv)
+		goto err;
+
 	if (rsa_check_key_length(mpi_get_size(mpi_key->n) << 3)) {
 		rsa_free_mpi_key(mpi_key);
 		return -EINVAL;
--
2.36.1
