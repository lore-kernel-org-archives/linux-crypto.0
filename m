Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DEF2417D1
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 12:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750682573; cv=none; b=U3sR9KhDSpKj57Fq5JzPrALwMSg0lO5VZcve17ZUf+UMzoJWXpdK/hn8lhyDJ4DChrKlXPRn0TVp1bOg1UTTK83+6VAs5gBWbFM5xSGt/OQOeCXT43+8uqCejftf+c7jk7qWQF3CBc034qR9qtPShfR8pl1mEmiMntdetRWcUyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750682573; c=relaxed/simple;
	bh=chF1uZFplXwQmgYOnogo76i3GdxrQkosEJzcq4dFzow=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kkvpAE5KUzj2K6LyPjJlEPjZZEzFEEAT+R1fg4OupnnAna96ZpgW6KAfYvGl9DO7z8O4q0e3Qo4VwWCNMRge1whQ/8UjZSmpUUYA3+DzDZHSJ0ddaCDBAar/Io6QSYR/RhaLAyRhT4Qx6Eyv5L62fWnodUrjWRVtOy3Zi/R7hzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WF7UE4MM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WF7UE4MM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750682570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i6wfaVASMTK3rRy1FpThH+NI3jGe1pbTtlZQ9RBaJaY=;
	b=WF7UE4MMqnYDN/KqqUq2zLow6ibPR1S8hHfhuE3M9XWPrDzozbFOTs7g7Izfe9GVcyMR/W
	J8K5Q6XUTuvkfiwTSdwslt8QQ+mhEa1DXFal3mjVf2xl8JYZvL4H3FrmMD2qcHCjXsm3ob
	C5TEAuavr4q/581uCIoaxZeuGUoGGaM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-TFBpu6m1Nc6cFG7LYEu4Rw-1; Mon,
 23 Jun 2025 08:42:48 -0400
X-MC-Unique: TFBpu6m1Nc6cFG7LYEu4Rw-1
X-Mimecast-MFC-AGG-ID: TFBpu6m1Nc6cFG7LYEu4Rw_1750682566
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5EFD1809C8C;
	Mon, 23 Jun 2025 12:42:46 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53320180035E;
	Mon, 23 Jun 2025 12:42:44 +0000 (UTC)
Date: Mon, 23 Jun 2025 14:42:40 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [v2 PATCH] dm-crypt: Extend state buffer size in
 crypt_iv_lmk_one
In-Reply-To: <27689dcc-3018-472f-9db1-efba8f9d52d1@gmail.com>
Message-ID: <23f34c41-0414-8e25-0d3f-bd6eea716732@redhat.com>
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com> <aFTe3kDZXCAzcwNq@gondor.apana.org.au> <afeb759d-0f6d-4868-8242-01157f144662@gmail.com> <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com> <aFk2diodY0QhmZS8@gondor.apana.org.au>
 <27689dcc-3018-472f-9db1-efba8f9d52d1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Mon, 23 Jun 2025, Milan Broz wrote:

> On 6/23/25 1:11 PM, Herbert Xu wrote:
> > On Mon, Jun 23, 2025 at 11:40:39AM +0200, Mikulas Patocka wrote:
> > > 
> > > 345 bytes on the stack - I think it's too much, given the fact that it
> > > already uses 345 bytes (from SHASH_DESC_ON_STACK) and it may be called in
> > > a tasklet context. I'd prefer a solution that allocates less bytes.
> > > 
> > > I don't see the beginning of this thread, so I'd like to ask what's the
> > > problem here, what algorithm other than md5 is used here that causes the
> > > buffer overflow?
> > 
> > The md5 export size has increased due to the partial block API
> > thus triggering the overflow.
> > 
> > How about this patch?

OK. I accepted the patch and committed it to the linux-dm git.

Mikulas

> For v2:
> 
> Tested-by: Milan Broz <gmazyland@gmail.com>
> 
> Just for the context, the patch fixes OOPS on 32bit (but 64bit should overflow
> struct too):
> 
> : Oops: Oops: 0000 [#1] SMP
> : CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.16.0-rc2+ #993
> PREEMPT(full)
> : Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference
> Platform, BIOS 6.00 11/12/2020
> : Workqueue: kcryptd-254:0-1 kcryptd_crypt [dm_crypt]
> : EIP: __crypto_shash_export+0xf/0x90
> : Code: 4a c1 c7 40 20 a0 b4 4a c1 81 cf 0e 00 04 08 89 78 50 e9 2b ff ff ff
> 8d 74 26 00 55 89 e5 57 56 53 89 c3 89 d6 8b 00 8b 40 14 <8b> 50 fc f6 40 13
> 01 74 04 4a 2b 50 14 85 c9 74 10 89 f2 89 d8 ff
> : EAX: 303a3435 EBX: c3007c90 ECX: 00000000 EDX: c3007c38
> : ESI: c3007c38 EDI: c3007c90 EBP: c3007bfc ESP: c3007bf0
> : DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010216
> : CR0: 80050033 CR2: 303a3431 CR3: 04fbe000 CR4: 00350e90
> : Call Trace:
> :  crypto_shash_export+0x65/0xc0
> :  crypt_iv_lmk_one+0x106/0x1a0 [dm_crypt]
> 
> ...
> 
> The bisect was
> 
> efd62c85525e212705368b24eb90ef10778190f5 is the first bad commit
> commit efd62c85525e212705368b24eb90ef10778190f5 (HEAD)
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Apr 18 10:59:04 2025 +0800
> 
>     crypto: md5-generic - Use API partial block handling
> 
>     Use the Crypto API partial block handling.
> 
> Milan
> 

