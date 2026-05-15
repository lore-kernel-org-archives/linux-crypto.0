Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AFC3EEAD3
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879714; cv=none; b=DbliQvEkojNbZB5+QXDTFDcJ4bQyFdE4KdxEP7EX9yT80aZ3etuoSpHaB+2GooW4W4R6vWgIHprR8JTtWo/PtV1oM2yXhibI/caXdIIQwUVnCZ5bFnmsoC8RxnYgy8narwg1M66ph3ul7RnBD9h61dE6c+UARu4/VHOGFm00AHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879714; c=relaxed/simple;
	bh=9qOiZjuMb85ewhTujam6wtmPKlWhsGUjRgHlaJ5hOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpLQO8WKtiGJ2Z87LqRnb+0oVeNXxaTVvPpmGDe58D7sN1so0DXJK/QCy8MmC0Hp7wXbd4ncRfFkBh04lik6ZjJ9oeBgrysIU1fp4NL5Qqer94SuzP59zN8ZJOJDrbdA7GAoCk+XQthJSlrVzZKvf3CcZ4NxB8Ru9zU/gtlhHRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbS/LYf2; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbS/LYf2"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3025d725a05so926267eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879712; x=1779484512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EseM1chjBypSoW0cp1ToXZvQ5KcO5EkTarmMMC63WUM=;
        b=hbS/LYf2dD1jw9aPBJqPXtrlyu6t+yl4dboWGs4zK1tvEQi2kZV761lDWhXi9oqxw0
         LNnhI6Sy7QZcjjWWYFWuIdyhAFkaA3nrxxjFNi7qNxEkKRTQ2ey/HdhWvQ4ibAQ+TECl
         82EVN3y6kfnl0qtvHMP1N92u42OmIb3325YRnwq4IiX45yedpdB//tKR8L1ZCZRE9o60
         AffvmAizY573rtdjdT/VDLfMPJAaG8NCM3KhKh7K18UD2Qv2f4pOJ59SI4OfkA3F64cK
         fxRnpyaanO93DB50OAou6rWfvNG5Y/qTtjqt51dmW5FsRtx4Yef0RtxYOT/qa24UJRdN
         0Ipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879712; x=1779484512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EseM1chjBypSoW0cp1ToXZvQ5KcO5EkTarmMMC63WUM=;
        b=fAXmgN0WpPJkNuvGIakdRMHfrQVaQ+sFzqpC03xPZOeht1voq/HvApU5HUYF0GsBnA
         cr6JOu+F6u0YFiF0G6JgLfD4+ZFp+Y/OnRSG9J9eZAk5Qt5YFJiYxKMZaVzHf3aA+omv
         1Fd1HjEjC44k8PfOkgSJCviE7wkYtgJU2QiVrsx+ZFD+pPwzX82XsHHXdtRYDhozq6wE
         D08qe7YgJHhpk5HxGizAlcuN/sF5sMRRoGPnxdK45BqTDDk4S6cepwCx9G904g3MvF99
         Zg5y/kaLK7F3mep10UXgVu2Bpu7lg+TBOa2DqhwGRaLefwK7+XK9DgNo+SH+4Dfzj3WG
         19Rw==
X-Forwarded-Encrypted: i=1; AFNElJ+E6Pc5FZcyfWRbjozpNjUoRVEn8YVFdrDopr62ra0/5VoTPBzl+gg9Nm3jzr09qO+cIfS9LHeUe9lsN0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ2iK7zXpYh6TXBb/Rf7RDUAgAvkE95k3D+BWMX+OkT8z4VKbF
	2BQgMVjewba6Pngx9AhHrxIAor0nt1gHL6I4sLfYy/lqfhp6eGaF9x9I
X-Gm-Gg: Acq92OH3yh4bNNIcb9UKyMSbOuxd0IpEDdZrT4jcr3tn5i/QL99LR7u7wMTrk4wPSbZ
	GFJB0BoY/hZ6YOaS4i46uBnIDwAdqP2lEwVHa1Esp4yijFbNRH/HRUag7hWwHQxCAL/6gcalE1c
	uOW+LjPdymUj6aBsxYVCY3DDa55qJWcBuLSvB0dyKSIxciYmtKlvwnDX32IDcE6S1wcPRj0ae1A
	RmgBlwQKKtkSXDzwrlc3LDKj059CNjyP1RqFq4fAIAYfWu6upnDNsMXemK0mqB5arRGXy/xfvFK
	7iloUc3IYL1da/ZOt5oFD4O6JOHd4d1opAROyX3O8kBywnOGGzygRrXOer8ugqXn5uAaj5SCFOP
	Xy9m4xwUHQuAtew6jckF/lPGpCddQ91m1D7NYhJ5l+LzrROfMjzxDusJl82NbRqzmBz6vVeGXPU
	Qm83olAZ7JdP8y6rYDBICusdhgKHs8OXc=
X-Received: by 2002:a05:7301:19a5:b0:2ed:e17:d50d with SMTP id 5a478bee46e88-3039868c8bcmr2807177eec.32.1778879712290;
        Fri, 15 May 2026 14:15:12 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978ad18asm8003129eec.26.2026.05.15.14.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:11 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 21/38] lib/crypto: Add SHA1 support for pre-boot environments
Date: Fri, 15 May 2026 14:13:53 -0700
Message-ID: <20260515211410.31440-22-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the SHA1 library code in lib/crypto/sha1.c to be used in
pre-boot environments. Use the __DISABLE_EXPORTS macro to disable
function exports and define the proper values for that environment
as was done earlier for SHA256.

Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 lib/crypto/sha1.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index daf18c862fdf..f30b5ff3b31e 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -125,7 +125,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
 	memzero_explicit(workspace, sizeof(workspace));
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
 #include "sha1.h" /* $(SRCARCH)/sha1.h */
 #else
 #define sha1_blocks sha1_blocks_generic
@@ -207,6 +207,12 @@ void sha1(const u8 *data, size_t len, u8 out[SHA1_DIGEST_SIZE])
 }
 EXPORT_SYMBOL_GPL(sha1);
 
+/*
+ * Pre-boot environments (as indicated by __DISABLE_EXPORTS being defined)
+ * don't need the SHA1 HMAC support code.
+ */
+#ifndef __DISABLE_EXPORTS
+
 static void __hmac_sha1_preparekey(struct sha1_block_state *istate,
 				   struct sha1_block_state *ostate,
 				   const u8 *raw_key, size_t raw_key_len)
@@ -302,6 +308,8 @@ void hmac_sha1_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 }
 EXPORT_SYMBOL_GPL(hmac_sha1_usingrawkey);
 
+#endif /* !__DISABLE_EXPORTS */
+
 #if defined(sha1_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha1_mod_init(void)
 {
-- 
2.47.3

