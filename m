Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C271A9F90
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638186; cv=none; b=cQZPFKyowXzNYAcXzLsR41RxU8g77HSMxSXEuFcqVt78eEY+/VYLbj++xSupxLK9n4yBb6sjZ6mjX/U6npDDn+u8nnTBYc8wvFsI4zdDA/xeRESPeFtguBgE4ZOBvWIGxutYdhP0bjSbirpZYXIzCrxLKC4gTzt5jW9F9qPO2B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638186; c=relaxed/simple;
	bh=gl6YfourtYo8U6g1/qKaUB9KflQWRhHrp9HRUKZraj0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HBxNnWzyaFPjF3Pzdq+dLN06VKH1quAUMKtaKNZhjDaIKncwnxN511mIqCZnoPXzJPPGlJ2DOSDeO+zBIzJhhE4Da5o/VaOj0sM02TqW3S5Mb+d92yEkC8Zs+FlGTw4Xr8cwe4xGI8t2KR89R0m828UWLc6UY4aH1+smy0+LF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S490Ciq+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S490Ciq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758638183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7O96EOMeP3krqePOxAM+92m+BjepbymEMJJQVs9vpz8=;
	b=S490Ciq+UZ3ytEH9OCbZkN3TiJ/cF8NyGLF7MkzdoDQVHKfSZz35PMxapR5+aej9Q+x+iD
	uO8q2TysUaF4vbqg5FbS14wCO0nZc/Zjzg9jwI0IMiJITC11LiPCC7YVyUcE3xnrMmOhT9
	TgYXZ9YU4cGZHpITIxX0QSb1fLkolw8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-ucl1QUQoMJqokh5r6GZkDQ-1; Tue,
 23 Sep 2025 10:36:16 -0400
X-MC-Unique: ucl1QUQoMJqokh5r6GZkDQ-1
X-Mimecast-MFC-AGG-ID: ucl1QUQoMJqokh5r6GZkDQ_1758638175
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 883AF180057E;
	Tue, 23 Sep 2025 14:36:14 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AC7C1955F21;
	Tue, 23 Sep 2025 14:36:10 +0000 (UTC)
Date: Tue, 23 Sep 2025 16:36:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>, 
    Harald Freudenberger <freude@linux.ibm.com>, 
    Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com, 
    snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the
 hash request
In-Reply-To: <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
Message-ID: <1235adba-148c-c9ea-12d2-dd407a3ae28d@redhat.com>
References: <20250908131642.385445532@debian4.vm> <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com> <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com> <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com> <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com> <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com> <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com> <aNIYTm6neC3lC6dP@gondor.apana.org.au> <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Tue, 23 Sep 2025, Mikulas Patocka wrote:

> 
> 
> On Tue, 23 Sep 2025, Herbert Xu wrote:
> 
> > If authenc gets EBUSY from the ahash, then the ahash is responsible
> > for sending an EINPROGRESS notification.  I just checked the authenc
> > code and it does pass the notification back up to the caller (which
> > is dm-crypt).
> > 
> > So if EINPROGRESS is not being received, then it's a bug in the
> > ahash layer or the underlying ahash algorithm.
> 
> static void authenc_request_complete(struct aead_request *req, int err)
> {
>         if (err != -EINPROGRESS)
>                 aead_request_complete(req, err);
> }
> 
> This prevents -EINPROGRESS from reaching dm-crypt. If I remove the 
> condition "err != -EINPROGRESS", the deadlock goes away. Though, removing 
> it may break other things - we may send -EINPROGRESS twice, first for the 
> hash and then for the decryption.
> 
> > Which phmac implementation was this?
> 
> It was pseudo_phmac out-of-tree module sent by Harald Freudenberger. He 
> CC'd you, so you should have it as an attachment in your inbox.
> 
> The following scripts creates the buggy device mapper device:
> 
> #!/bin/sh -ex
> sync
> modprobe crypto_engine
> insmod ~/c/phmac/pseudo_phmac/phmac.ko
> modprobe brd rd_size=1048576
> dmsetup create cr_dif --table '0 2031880 integrity 1:0 32768 32 J 7 block_size:4096 interleave_sectors:32768 buffer_sectors:128 journal_sectors:16368 journal_watermark:50 commit_time:10000 fix_padding'
> dmsetup create cr --table '0 2031880 crypt capi:authenc(phmac(sha256),xts(aes))-plain64 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 0 252:0 0 2 integrity:32:aead sector_size:4096'
> dd if=/dev/zero of=/dev/mapper/cr bs=1M oflag=direct status=progress
> 
> > Cheers,
> 
> Mikulas

What do you think about this patch? Do you think that it is the right 
direction to fix it?

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The function authenc_request_complete ignores -EINPROGRESS. This causes
deadlock in dm-crypt when using it with authenticated encryption with an
asynchronous hash implementation.

This patch makes it pass -EINPROGRESS to the caller. Note that we don't
want to report -EINPROGRESS twice (one for the hash and the second one
for the cipher), so we set a flag and report -EINPROGRESS just once.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 crypto/authenc.c       |   11 +++++++++--
 include/linux/crypto.h |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/crypto/authenc.c
===================================================================
--- linux-2.6.orig/crypto/authenc.c	2025-09-23 16:15:42.000000000 +0200
+++ linux-2.6/crypto/authenc.c	2025-09-23 16:32:57.000000000 +0200
@@ -37,8 +37,15 @@ struct authenc_request_ctx {
 
 static void authenc_request_complete(struct aead_request *req, int err)
 {
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
+	if (unlikely(err == -EINPROGRESS)) {
+		req->base.flags |= CRYPTO_TFM_REQ_REPORT_EINPROGRESS;
+		return;
+	}
+	if (unlikely(req->base.flags & CRYPTO_TFM_REQ_REPORT_EINPROGRESS)) {
+		aead_request_complete(req, -EINPROGRESS);
+		req->base.flags &=~ CRYPTO_TFM_REQ_REPORT_EINPROGRESS;
+	}
+	aead_request_complete(req, err);
 }
 
 int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
Index: linux-2.6/include/linux/crypto.h
===================================================================
--- linux-2.6.orig/include/linux/crypto.h	2025-08-15 17:28:24.000000000 +0200
+++ linux-2.6/include/linux/crypto.h	2025-09-23 16:17:05.000000000 +0200
@@ -151,6 +151,7 @@
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
 #define CRYPTO_TFM_REQ_ON_STACK		0x00000800
+#define CRYPTO_TFM_REQ_REPORT_EINPROGRESS 0x00100000
 
 /*
  * Miscellaneous stuff.

