Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128C2FB965
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758126053; cv=none; b=avnFm0WgKpCpvuZ+AEthnGJxL1cEYYTlc9kAZSen7iDt/EhognNqOKL91P49rjl9p2Jx89Da/7yK+MkCOiHzkEDNHeTrDT5VSJ42DL3R1KdYiKZ4JFaX30IjDUeuzVmDKxlIDKik93vpxrKVxMhoo2oPh7c8UFdh9jCTmcRpvZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758126053; c=relaxed/simple;
	bh=gM3d1d3ut+EGUCOsM/y0UPLmE8bwv6Ynl/ykYBi/o54=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DWJF4jVRXeue+5ejUcsWy0a7t5ua/YsBv1TkV1A46G990ZLtxVd/A2LIPGHu9Rh8f1904P8pKzatd6hX0qhpzqIdw+IYxi79mkikcMCXobS7A6f/oB2QiGmtjDuTX5//j+9Wo6FAZJgTP8Mlr/4uxIAcUp8nn/gyU0nAWB4WLac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DL5ihcPt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DL5ihcPt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758126051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+tijCT54cokORiekHfcRtOnDwq19UO+MHke1EZZPPQ=;
	b=DL5ihcPtDVzRPG55KgPC4gzz9ISW9C97ByhIN1ReRk4HlK4vMlmS+jtfV5Rz8NbSiAS3Wy
	+E/hlAXp4jAaDWJmkJP/fwFPXgRBA8S46vmuzNOPBYuoZ5sA+16xPuT7hwm0NL2Z8RQR1l
	W/gFGY59WmUOSwsG5Kba611BbZpikKE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-dCifp9p1Nvay7S8L62QKGQ-1; Wed,
 17 Sep 2025 12:20:49 -0400
X-MC-Unique: dCifp9p1Nvay7S8L62QKGQ-1
X-Mimecast-MFC-AGG-ID: dCifp9p1Nvay7S8L62QKGQ_1758126048
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCBED1956086;
	Wed, 17 Sep 2025 16:20:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2AAF8180044F;
	Wed, 17 Sep 2025 16:20:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250915220727.GA286751@quark>
References: <20250915220727.GA286751@quark> <2767539.1757969506@warthog.procyon.org.uk> <2768235.1757970013@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3226360.1758126043.1@warthog.procyon.org.uk>
Date: Wed, 17 Sep 2025 17:20:43 +0100
Message-ID: <3226361.1758126043@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Okay, I have lib/crypto/sha3 working.  One question though: why are the hash
tests built as separate kunit modules rather than being built into the
algorithm module init function and marked __init/__initdata?  For FIPS
compliance, IIRC, you *have* to run tests on the algorithms, so wouldn't using
kunit just be a waste of resources?

David

