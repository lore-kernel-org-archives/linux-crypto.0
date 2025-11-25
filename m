Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516D02DEA78
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103311; cv=none; b=eAmW3xA/lSYLc/VlZtH/tYcag59ZuWPatJc6W0PX6fRcwwOHYmFCAuJpLmcaSqe1b9SE31RD3dvxRPV61INuhMSd0rcxRL26OVLVCopspeo+azbXF5XN/HYV1ONU0sxEMsdNBAC896aHpk+e3PQ8XUsFnnrXk4C3+DZyPvbs1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103311; c=relaxed/simple;
	bh=bsV8HPpAOwxQOfXTjgLW5hcUcjBvPscS6bLNYdNfGWI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BqgwHFeXEfvNcAGu96/8ycJvFomy9kOvA0dra2UkYV06dJk2YOEkexj2Z5CJhwKeu0V0oiSrtdowSEsbJgfa8iY84YIsGuYJLKXyAILWXpAsbMeQIzyC8BZ9E7dXq/RFas3Fc4NuwLh0mkA59SfWesWL3/I13ha4Lb+KTq/mHN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HERyRgv0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HERyRgv0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764103309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TKjf+Ylcemc6JjFX+iNpoi6jqfzHCRl2zMFeYIzmEtQ=;
	b=HERyRgv0HQKkql4ribhHkl53BOOzOxd0BOm1+3BHAgtCC0i2Kyd4nNY4dMj3asWOKiBJSG
	Ecis3ljpWdADIjfv9p8hB+OXtJE3T5vF2rPzENi11QlLJBTjbofInpQUPpmDRaNJUswvul
	y6Qsmahz+Z0nEnngjQiN2WQntTGyxgM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-xAoREdgaPOiZ0qpnh_Or3Q-1; Tue,
 25 Nov 2025 15:41:47 -0500
X-MC-Unique: xAoREdgaPOiZ0qpnh_Or3Q-1
X-Mimecast-MFC-AGG-ID: xAoREdgaPOiZ0qpnh_Or3Q_1764103306
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3E721954B1B;
	Tue, 25 Nov 2025 20:41:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75C27180047F;
	Tue, 25 Nov 2025 20:41:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251125190256.4034-3-James.Bottomley@HansenPartnership.com>
References: <20251125190256.4034-3-James.Bottomley@HansenPartnership.com> <20251125190256.4034-1-James.Bottomley@HansenPartnership.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH 2/2] crypto: pkcs7: add tests for pkcs7_get_authattr
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3954611.1764103304.1@warthog.procyon.org.uk>
Date: Tue, 25 Nov 2025 20:41:44 +0000
Message-ID: <3954612.1764103304@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Add example code to the test module pkcs7_key_type.c that verifies a
> message and then pulls out a known authenticated attribute.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Acked-by: David Howells <dhowells@redhat.com>

