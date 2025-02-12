Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE10311CA9;
	Wed, 12 Feb 2025 06:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739340622; cv=none; b=FChcSjRCJ8E/RCfZy3ZZ2xzvYVpeeZgoXP7GlNlA7wwqbHJ7xUt04gmki6I8Ofy7AKChRrgMRK1OfuEcZ4tTEZMHFzmZOluokhFOpWaUvfzCouu3zM0vzUuLJKorHZfC3mP1Z5qBLyfPOKwwCjd7gY9ER+SJhkssEbeOCRktrYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739340622; c=relaxed/simple;
	bh=R3qNJM5/PD4yUcE7z/fFu4EBll49affaVVrEUATUk0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/RFnSdxrmt5WPGRU05ByQjucfhcjfDuqipCNb6ec36PiyT5ev/Dpq1Z/RQgCajp8IiN4n93Al+5JIFMuLtaUBVfHtPGNruA8hIuLhC4MOyHm/pdPeXFQ7VCz12RL+5qQX+DQMvAhkAZT9Hidei0sO81PjbwWkJ6cwf0raYnPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FVYB+/vZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FVYB+/vZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6Str7oYfWxLuaggMpptgbjOvLpW/PIrDwAfbw2hzR4U=; b=FVYB+/vZ7haImdT9Ge0ChwYHQa
	ldelcQbeWnBkjM1UWgAJZxIdhqaRDqnDvFt8smLLi6etUpKcdfVzJLGtHcbyvwDWEMN6t0Ue4dTDS
	fLSf/G9D2xRf7sSbknmU2xyZZcJzDXHoQQU+Jgmt4SRgexxRRyThT51kfdl0VT62RXZZCq7gbEi7v
	JtiZAwxfjjSytnSvqxPZoJRlx5e1p1HuReYaq+V0sFZ9kP0S/hrfloAjCywOlFkzulpzBJ4dTEUpZ
	kZ/nDd9UruHK6p5em1/ji690ITqPRZAuR94K+6DeaYoS4NI/Mv+5YuoVhDB4F1prf+o5abEWVFYQv
	ijgw0nug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti5jq-00HEde-2a;
	Wed, 12 Feb 2025 14:10:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 14:10:07 +0800
Date: Wed, 12 Feb 2025 14:10:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] crypto: null - Use spin lock instead of mutex
Message-ID: <Z6w7Pz8jBeqhijut@gondor.apana.org.au>
References: <6772f2f4.050a0220.2f3838.04cb.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6772f2f4.050a0220.2f3838.04cb.GAE@google.com>

On Mon, Dec 30, 2024 at 11:22:28AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a024e377efed net: llc: reset skb->transport_header
> git tree:       net
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c7f0b0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
> dashboard link: https://syzkaller.appspot.com/bug?extid=b3e02953598f447d4d2a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bce818580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bce818580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f2ea524d69fe/disk-a024e377.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b39d227b097d/vmlinux-a024e377.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8ee66636253f/bzImage-a024e377.xz

---8<---
As the null algorithm may be freed in softirq context through
af_alg, use spin locks instead of mutexes to protect the default
null algorithm.

Reported-by: syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 5b84b0f7cc17..337867028653 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -17,10 +17,10 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 
-static DEFINE_MUTEX(crypto_default_null_skcipher_lock);
+static DEFINE_SPINLOCK(crypto_default_null_skcipher_lock);
 static struct crypto_sync_skcipher *crypto_default_null_skcipher;
 static int crypto_default_null_skcipher_refcnt;
 
@@ -152,23 +152,32 @@ MODULE_ALIAS_CRYPTO("cipher_null");
 
 struct crypto_sync_skcipher *crypto_get_default_null_skcipher(void)
 {
+	struct crypto_sync_skcipher *ntfm = NULL;
 	struct crypto_sync_skcipher *tfm;
 
-	mutex_lock(&crypto_default_null_skcipher_lock);
+	spin_lock_bh(&crypto_default_null_skcipher_lock);
 	tfm = crypto_default_null_skcipher;
 
 	if (!tfm) {
-		tfm = crypto_alloc_sync_skcipher("ecb(cipher_null)", 0, 0);
-		if (IS_ERR(tfm))
-			goto unlock;
+		spin_unlock_bh(&crypto_default_null_skcipher_lock);
 
-		crypto_default_null_skcipher = tfm;
+		ntfm = crypto_alloc_sync_skcipher("ecb(cipher_null)", 0, 0);
+		if (IS_ERR(ntfm))
+			return ntfm;
+
+		spin_lock_bh(&crypto_default_null_skcipher_lock);
+		tfm = crypto_default_null_skcipher;
+		if (!tfm) {
+			tfm = ntfm;
+			ntfm = NULL;
+			crypto_default_null_skcipher = tfm;
+		}
 	}
 
 	crypto_default_null_skcipher_refcnt++;
+	spin_unlock_bh(&crypto_default_null_skcipher_lock);
 
-unlock:
-	mutex_unlock(&crypto_default_null_skcipher_lock);
+	crypto_free_sync_skcipher(ntfm);
 
 	return tfm;
 }
@@ -176,12 +185,16 @@ EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher);
 
 void crypto_put_default_null_skcipher(void)
 {
-	mutex_lock(&crypto_default_null_skcipher_lock);
+	struct crypto_sync_skcipher *tfm = NULL;
+
+	spin_lock_bh(&crypto_default_null_skcipher_lock);
 	if (!--crypto_default_null_skcipher_refcnt) {
-		crypto_free_sync_skcipher(crypto_default_null_skcipher);
+		tfm = crypto_default_null_skcipher;
 		crypto_default_null_skcipher = NULL;
 	}
-	mutex_unlock(&crypto_default_null_skcipher_lock);
+	spin_unlock_bh(&crypto_default_null_skcipher_lock);
+
+	crypto_free_sync_skcipher(tfm);
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
