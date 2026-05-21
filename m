Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18474379C2B
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779381033; cv=none; b=P7Ht0nskmVRMYwq1oVhHdaJhjcF1R1Up+UGuh+6AdXE+aRJkRIgrtbk9qCLVPRLTV/QDhD61LVU1QmH3WZ7JQMUE37fKUki2dK4cjAHV8kNJzRwMRhlSqfgLgv3oOqkOW2eobN42OMmGcQOYLvHIBEN/FCzBcPua7bwXFSjiuVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779381033; c=relaxed/simple;
	bh=xsFudY2ShHRnHzXTwA1/apj8bAL30/BHMx5NvtkvXGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4PyR/VyuDGWYS9FsBE+zloD55u1y++BsNTiwWwyhbMAY07bopB+LI6bHae3oj1QXFgRCF51f5xUVimwUZ9xaFTI2jLMJkplVVrtr0rsQ04jDK2MYL/GLfT81RA4Qo6cUNxichf2DwFHgekinjitPWBnCGyTZAbdv0uruXglYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ImZfL9kM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ImZfL9kM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779381031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C97nRy1hinTdJXTrPM4ee4OamiN4XZkMfci9rA8ZvWo=;
	b=ImZfL9kMcFt6qXGk+w/Wq5MNX/5eJrGcwFhwrkZlS5lt0fi7VtNw8TmUsP1N2npn8usURX
	eY962rbicAEzxamIPDIlRQxarfxelPsnbNOO+vKEzJpTNlcRvJqmeQyzD3O7VwSKzgHQu/
	bHDlUgqsqntDG5Q3WcxnBE8pMma4UhA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-hOzfOOEqMY6Uuj2zcwBX8w-1; Thu,
 21 May 2026 12:30:29 -0400
X-MC-Unique: hOzfOOEqMY6Uuj2zcwBX8w-1
X-Mimecast-MFC-AGG-ID: hOzfOOEqMY6Uuj2zcwBX8w_1779381026
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69A811800617;
	Thu, 21 May 2026 16:30:25 +0000 (UTC)
Received: from thinkpad (headnet01.pony-001.prod.iad2.dc.redhat.com [10.2.32.101])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84702180075D;
	Thu, 21 May 2026 16:30:19 +0000 (UTC)
Date: Thu, 21 May 2026 18:30:16 +0200
From: Felix Maurer <fmaurer@redhat.com>
To: Daniel Hodges <git@danielhodges.dev>
Cc: bpf@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
	vadim.fedorenko@linux.dev, song@kernel.org, yatsenko@meta.com,
	martin.lau@linux.dev, eddyz87@gmail.com, haoluo@google.com,
	jolsa@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
	sdf@fomichev.me, yonghong.song@linux.dev,
	herbert@gondor.apana.org.au, davem@davemloft.net
Subject: Re: [PATCH bpf-next v8 0/4] Add cryptographic hash and signature
 verification kfuncs to BPF
Message-ID: <ag8zGP5azt743BWc@thinkpad>
References: <20260225202935.31986-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225202935.31986-1-git@danielhodges.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Feb 25, 2026 at 03:29:31PM -0500, Daniel Hodges wrote:
> This patch series enhances BPF's cryptographic functionality by introducing
> kernel functions for SHA hashing and ECDSA signature verification. The changes
> enable BPF programs to verify data integrity and authenticity across
> networking, security, and observability use cases.
>
> The series addresses two gaps in BPF's cryptographic toolkit:
>
> 1. Cryptographic hashing - supports content verification and message digest
>    preparation
> 2. Asymmetric signature verification - allows validation of signed data
>    without requiring private keys in the datapath

Hi Daniel,

I found your series because I was about to implement something similar
like your hashing implementation. In other words, I'd be very happy to
see this patchset move forward.

Taking an initial look at your hashing patches, I'm wondering: the usual
interface to hash/digest algorithms is to have three functions: an
init() function to set up state, an update() function that can be called
multiple times to hash new bytes, and a finalize() function that creates
the actual hash. Depending on the algorithm, some of them (esp.
finalize) may be no-ops. Often, a fourth function, like hash(), is
provided as convenience, doing one init/update/finalize cycle when all
data to be hashed is already available.

I think we should provide the same init/update/finalize interface in bpf
as well to make the API more flexible. That would require splitting out
the shash_desc from the (mostly static) context. But doing so would also
address the review comment from bpf-ci bot to patch 1. WDYT?

Thanks,
   Felix

