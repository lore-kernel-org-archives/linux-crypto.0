Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC784D02
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758568139; cv=none; b=Z7yywuv9wNae+mnYEioqCHgZ3nCPYn+fk+kLYagxpTZgf4vt605dFRtZGyBtokS0QFm+vj0Zvlj0CJN9lQthbkF2vulxqtHIeCvJOMfAmkFFCSbiPULMd75SqEFz0Z9SpWCk8CPg5oUN95SPhlClL8hBGx7fRIILO1BIMN0HyFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758568139; c=relaxed/simple;
	bh=h29rtcSrOIMf5pAvLuUA6cibFcZeXhD1pDQIIJ4Wh4g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SPrHpw1csdrEoSPUDQRwe3j7PjDIrPT1wiMDkMhL+IFnmOWyAyb4q7qu4SNYgIb8OCheKoSUakfi87xDsNAURSIRvhrZfF2+dVlDaybkaa1fyK1QAMyol+LRURwW8QGllNUra/3ulb29kX1fzViHxZjwR9aL13T95drGBjKaBLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XglypIhM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XglypIhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758568136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HLVd4ns3Eb35/BddvOa6k7DbQr1MBKhOjsWznK+W9RQ=;
	b=XglypIhMUHKJA98k0KXNdLm3QJ6p1En+nsBRXm9w3/bw/fJXEbTDeVdiUyr+CUmBortf5u
	MF0FgqsmNfxWHlTl80YVl9Kp7jTR0PyG03CovwwQyYW8IGBtuRcFhK8KYWkbNWj4TlWuDm
	3WbddOhpEC0mghjc+JeoqxoIJr0scss=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-41O9Jm51Oy2sxKA0TofqmA-1; Mon,
 22 Sep 2025 15:08:55 -0400
X-MC-Unique: 41O9Jm51Oy2sxKA0TofqmA-1
X-Mimecast-MFC-AGG-ID: 41O9Jm51Oy2sxKA0TofqmA_1758568133
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BA271800297;
	Mon, 22 Sep 2025 19:08:53 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7305195608E;
	Mon, 22 Sep 2025 19:08:49 +0000 (UTC)
Date: Mon, 22 Sep 2025 21:08:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    Harald Freudenberger <freude@linux.ibm.com>
cc: Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com, 
    snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the hash
 request
In-Reply-To: <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
Message-ID: <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>
References: <20250908131642.385445532@debian4.vm> <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com> <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com> <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com> <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com> <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Thu, 18 Sep 2025, Harald Freudenberger wrote:

> On 2025-09-11 17:58, Mikulas Patocka wrote:
> > On Thu, 11 Sep 2025, Ingo Franzki wrote:
> > 
> > > >> So, it looks like a dm-crypt bug.
> > > >>
> > > >> Please, revert my patches and run the same test on a clean 6.17.0-rc5
> > > just
> > > >> to verify that the patches do not introduce the bug.
> > > >
> > > > With your patches reverted the combined mode fails the same way as with
> > > your patches.
> > > > So they did not introduce the bug.
> > > 
> > > Mikulas, do you have any idea what could be causing this errors?
> > > Is it that dm-crypt is not properly dealing with async-only HMAC ciphers?
> > > Async-only encryption ciphers seem to work fine in dm-crypt, since LUKS
> > > with PAES (but no integrity) works fine, and PAES is an async-onky cipher.
> > > LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, even in
> > > combination with PAES.
> > 
> > Yes, I think that it's a problem with async HMAC. The bug is probably
> > either in dm-crypt or in the crypto library.
> > 
> > Do you have some other (non-dm-crypt-related) workload that uses the
> > async authentication, so that we can determine whether the bug is in
> > dm-crypt or crypto?
> > 
> > Otherwise, would it be possible to give us a virtual machine on the
> > mainframe to debug this issue?
> > 
> > Mikulas
> 
> So here is now an out-of-tree kernel module build which offers a pseudo
> phmac-sha256
> for testing and debugging purpose. In the end this is just a asynch (ahash)
> wrapper
> around the hmac-sha256 shash crypto subsystem implementation. It should
> compile and
> be usable on all platforms (s390, x64, arm, ...).
> 
> I ran dm-integrity tests with this and all worked fine. Ingo ran dm-crypt
> tests
> where he combined aes-cbc encryption with phmac-sha256 integrity and saw hangs
> on cryptsetup open. He also reported that these issues are different to what
> he
> saw with the 'real' phmac in combination with aes encryption. A short glimpse
> gives
> me the impression that there is a job blocking the system's workqueue.
> However, I
> could not find any indication that the pseudo phmac is not working properly.
> 
> For instructions on how to build and use the module see the README in the tgz
> archive.
> 
> Thanks to all
> Harald Freudenberger

Hi

I analyzed the dm-crypt deadlock - in crypto_authenc_decrypt, there's 
        err = crypto_ahash_digest(ahreq);
        if (err)
                return err;
- here we get -EBUSY, that -EBUSY is propagated to dm-crypt. When dm-crypt 
gets -EBUSY, it waits in "wait_for_completion(&ctx->restart);" in 
crypt_convert.

dm-crypt wakes up when kcryptd_async_done gets -EINPROGRESS, but the 
crypto API never calls kcryptd_async_done with -EINPROGRESS, so dm-crypt 
deadlocks.

I've made this patch for the bug, it is tested only lightly, please review 
it.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

When we return -EBUSY from encryption routines, the caller is supposed to
sleep until it receives -EINPROGRESS in the callback method.

However when using authenc with asynchronous hash, the hash function may 
return -EBUSY. In this case, the crypto API never calls the caller with 
-EINPROGRESS and it causes deadlock in dm-crypt.

Fix this by turning -EBUSY into -EINPROGRESS.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 crypto/authenc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/crypto/authenc.c
===================================================================
--- linux-2.6.orig/crypto/authenc.c	2025-09-22 20:32:02.000000000 +0200
+++ linux-2.6/crypto/authenc.c	2025-09-22 20:35:38.000000000 +0200
@@ -146,8 +146,11 @@ static int crypto_authenc_genicv(struct
 				   authenc_geniv_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
-	if (err)
+	if (err) {
+		if (err == -EBUSY)
+			err = -EINPROGRESS;
 		return err;
+	}
 
 	scatterwalk_map_and_copy(hash, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(authenc), 1);
@@ -270,8 +273,11 @@ static int crypto_authenc_decrypt(struct
 				   authenc_verify_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
-	if (err)
+	if (err) {
+		if (err == -EBUSY)
+			err = -EINPROGRESS;
 		return err;
+	}
 
 	return crypto_authenc_decrypt_tail(req, aead_request_flags(req));
 }

