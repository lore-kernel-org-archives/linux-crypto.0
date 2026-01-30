Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9B327AC31
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769782237; cv=none; b=s0zL1iyMtdFGN1qiwCkCxfrdY1jdEfZmvGqwitg6uQBnwoMOvVYseSx++QuOr1Axotd+/tf9784PFz3Uy2KGDACOlCQ+QGRT2y6xIB+fL/dUhuO+p8GxHzDNUfYjExX30qbfr10CV3yPN6t+xuYG+RneXwqHHLbpEs7rmw/c+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769782237; c=relaxed/simple;
	bh=rmhZ5sOTwbtWVJbmT/uMxFq2nJwHusyhn+cZ3ChqXsU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=urwmx3T0mglNJioqG7P8U4w2opcpUhh1c837+vOoRDf+OXvMLRgUcLicuHNVIgCGvmIgCx4uKsMHrXUMD41h1V9PBBN3csRuls5aj8cJA8KSo1Mi1vGa/iYn7OdEdFfb23kkwDEElV0+meGXebMFLYfqO+A5tmo8OMrxqlOsXnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SkoWOFyB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SkoWOFyB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769782235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmhZ5sOTwbtWVJbmT/uMxFq2nJwHusyhn+cZ3ChqXsU=;
	b=SkoWOFyBExgSS1TdkVr+ASABVj+kmuzUel8bOPr6FpKtsMk49zlUPNnzYpwz88Ay2ZaoVr
	aX2qS0CgQo8PiypF1oe0vFdHgY7Dzgq3v19awphNWTzK/JiByt8d+Iq13vGJrBfM6+64W4
	4KneMdoM0La4ILriooB50+Gx3Z2aAMo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-g_mBxJh8MMqC7doZp1gvbg-1; Fri,
 30 Jan 2026 09:10:30 -0500
X-MC-Unique: g_mBxJh8MMqC7doZp1gvbg-1
X-Mimecast-MFC-AGG-ID: g_mBxJh8MMqC7doZp1gvbg_1769782228
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B5EC1956095;
	Fri, 30 Jan 2026 14:10:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CF3319560A2;
	Fri, 30 Jan 2026 14:10:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aXrKaTem9nnWNuGV@Rk>
References: <aXrKaTem9nnWNuGV@Rk> <1783975.1769190197@warthog.procyon.org.uk>
To: Coiby Xu <coxu@redhat.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.ibm.com>,
    Simo Sorce <simo@redhat.com>,
    Roberto Sassu <roberto.sassu@huawei.com>,
    Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
    Eric Snowberg <eric.snowberg@oracle.com>,
    Eric Biggers <ebiggers@kernel.org>, linux-integrity@vger.kernel.org,
    linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
    linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: IMA and PQC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2265996.1769782221.1@warthog.procyon.org.uk>
Date: Fri, 30 Jan 2026 14:10:21 +0000
Message-ID: <2265997.1769782221@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Coiby Xu <coxu@redhat.com> wrote:

> Take latest fresh CentOS Stream 10 x86_64 KVM guest as example, without any
> file system optimization, extra ~189MB disk space is needed if all files in
> /usr signed using by ML-DSA-65 where the disk size is 50G.

Is that storing raw signatures rather than PKCS#7 wrapped signatures?

David

